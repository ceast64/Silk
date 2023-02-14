using System.CommandLine;
using System.Security;
using System.Text;
using Google.Protobuf;
using Newtonsoft.Json;
using Serilog;
using Serilog.Sinks.SystemConsole.Themes;
using Yarn.Compiler;
using Silk;

ParallelOptions parallelOptions = new() { MaxDegreeOfParallelism = -1 };

// create CLI commands
var inputOption = new Option<DirectoryInfo>("--input", "Input file directory")
{
  AllowMultipleArgumentsPerToken = true,
  IsRequired                     = true
};
inputOption.AddAlias("-i");

var outputOption = new Option<DirectoryInfo>(
  "--output",
  description: "Output directory for processed files",
  getDefaultValue: () => new(Environment.CurrentDirectory));
outputOption.AddAlias("-o");

var pathOption = new Option<string>(
  "--runtimePath",
  "Path to the Silk runtime in your Rojo project\n example: \"game.ReplicatedStorage.Silk\"")
{
  IsRequired = true
};
pathOption.AddAlias("-r");

// setup Serilog
Log.Logger = new LoggerConfiguration()
             .MinimumLevel.Debug()
             .WriteTo.Console(theme: AnsiConsoleTheme.Code)
             .CreateLogger();

// create & execute RootCommand
var rootCommand = new RootCommand();
rootCommand.AddOption(inputOption);
rootCommand.AddOption(outputOption);
rootCommand.AddOption(pathOption);
rootCommand.SetHandler(CommandHandler, inputOption, outputOption, pathOption);

return await rootCommand.InvokeAsync(args);

// command handler
async Task CommandHandler(DirectoryInfo input, DirectoryInfo output, string yarnPath)
{
  // ensure directories exist
  if (!input.Exists)
  {
    Log.Logger.Fatal("Input directory {A} does not exist!", input.Name);
    return;
  }

  if (!output.Exists)
    output.Create();

  // compile the files in the directory
  await CompileDirectory(input, output, yarnPath);

  // cleanup Serilog
  await Log.CloseAndFlushAsync();
}

async Task CompileDirectory(DirectoryInfo sourcePath, DirectoryInfo outputPath, string silkPath)
{
  FileInfo[] files;

  // search for all yarn scripts, handle any errors
  try
  {
    files = sourcePath.GetFiles("*.yarn");
  }
  catch (SecurityException e)
  {
    Log.Logger.Fatal(e, "Missing necessary permissions to access files in directory {A}", sourcePath.Name);
    throw;
  }
  catch (DirectoryNotFoundException e)
  {
    Log.Logger.Fatal(e, "Source directory {A} not found", sourcePath.Name);
    throw;
  }

  // compile the files
  await Parallel.ForEachAsync(files, parallelOptions, async (file, token) =>
  {
    CompilationResult res;

    var job = CompilationJob.CreateFromString(file.Name, await File.ReadAllTextAsync(file.FullName, token));

    // attempt to compile
    try
    {
      res = Compiler.Compile(job);
    }
    catch (Exception e)
    {
      Log.Logger.Fatal(e, "Failed to compile script {A}", file.Name);
      throw;
    }

    // output diagnostics if there are any
    var diagnostics = res.Diagnostics.ToList();
    if (diagnostics.Count > 0)
      Log.Logger.Warning("Diagnostics for script {A}:", file.Name);

    foreach (var diagnostic in diagnostics)
      Log.Logger.Warning("lines {A}-{B}: {C}",
        diagnostic.Range.Start.Line,
        diagnostic.Range.End.Line,
        diagnostic.Message);

    // check for errors
    if (diagnostics.Any(d => d.Severity == Diagnostic.DiagnosticSeverity.Error) || res.Program is null)
    {
      Log.Logger.Error("Skipping file {A} due to errors being encountered.", file.Name);
      return;
    }

    var outputName = $"{Path.GetFileNameWithoutExtension(file.FullName)}.lua";

    // mirror the file's path in output directory    
    var outputFile = Path.Combine(outputPath.FullName, outputName);

    // encode the program
    var programEncoded = JsonFormatter.Default.Format(res.Program);
    programEncoded = Convert.ToBase64String(Encoding.UTF8.GetBytes(programEncoded));

    // serialize & encode the string table
    var stringJson     = JsonConvert.SerializeObject(res.StringTable);
    var stringsEncoded = Convert.ToBase64String(Encoding.UTF8.GetBytes(stringJson));

    // fill in template
    var output = Template.ScriptTemplate.Replace("%SILKPATH%", silkPath);
    output = output.Replace("%YARNPROGRAM%", programEncoded);
    output = output.Replace("%YARNSTRINGS%", stringsEncoded);

    // write final file
    await File.WriteAllTextAsync(outputFile, output, token);

    Log.Logger.Information("Wrote program data for {A}", file.Name);
  });

  var subDirs = sourcePath.GetDirectories();

  foreach (var sub in subDirs)
    await CompileDirectory(sub, outputPath.CreateSubdirectory(sub.Name), silkPath);
}
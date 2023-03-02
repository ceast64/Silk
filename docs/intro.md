---
sidebar_position: 1
---
# Getting started

## About
[Yarn Spinner](https://yarnspinner.dev) is a lightweight scripting language created by [Secret Lab](https://secretlab.com.au/) that makes
it easier to build branching narrative and dialogue in games.

Silk is a bridge between Yarn and Roblox that allows you to write dialogue
for your experience in Yarn.

## Installing
To use Silk, you will need to install two things:

* The CLI, which compiles and packs your Yarn scripts into ModuleScripts for use in Roblox
* The runtime, which executes those compiled ModuleScripts in your experience

### Aftman/Wally (Recommended)
:::info
Silk was created with an Aftman/Rojo workflow in mind.  
:::

You can install the latest version of the CLI with Aftman by running the following command:
```
aftman install ceast64/Silk
```

Then, you can install the runtime with the [Wally](https://github.com/UpliftGames/wally) package manager by adding it to your `wally.toml` file:
```
[dependencies]
Silk = "ceast64/silk@x.x.x" # replace x.x.x with latest version
```

### Manual
You can also manually download and install the runtime and CLI from the latest [release](https://github.com/ceast64/Silk/releases).

Download the correct build of the CLI and extract it somewhere within your PATH, and add the runtime to Studio or your local project.

### Unstable releases
Some features are unfinished or need more testing before they can be released.  
You can download unstable builds of the CLI and runtime from their respective GitHub workflows.

* [CLI builds](https://github.com/ceast64/Silk/actions/workflows/build-cli.yml)
* [Runtime builds](https://github.com/ceast64/Silk/actions/workflows/build-runtime.yml)

## Project setup
Different projects have different file structures, but this setup should be able to be
adapted to most project's needs.

### 1. Create a directory in your project for Yarn scripts
This directory will contain the Yarn scripts you'll use in your project.
:::info
Keep note of this directory's path in your project, as it will be used when we create the script to
compile all of the scripts.
:::

### 2. Create an output directory for compiled scripts
If you are using Git, add this directory to your `.gitignore` file.  
When you use the CLI to compile your Yarn scripts, they will be outputted
here as `.lua` files where they can be used with Rojo or any other tools.  

If you are using Rojo in your project, be sure to add this directory to your `.project.json` file(s)
so that your scripts sync properly.

### 3. Compiling Yarn programs
To start, running `silk --help` will output a description of each CLI option.

To compile your scripts, run the following:
```
silk -i <yarn script directory> -o <output directory> -r <path to runtime in Roblox>
```

See breakdown of the options in the CLI below.

| Option | Description |
| :--- | ---- |
| `-i`, `--input` | The directory containing Yarn scripts to compile. |
| `-o`, `--output` | The output directory for the processed ModuleScripts. |
| `-r`, `--runtimePath` | The path to the Silk runtime in your experience. Example: `"game.ReplicatedStorage.Silk"` |

:::info
If your project has a build script or CI workflow, be sure to
run the Silk CLI as a part of it so your dialogue works properly.
:::

### 4. Setting up your editor for writing Yarn scripts
You can install the [official Yarn Spinner extension](https://marketplace.visualstudio.com/items?itemName=SecretLab.yarn-spinner) for Visual Studio Code
to get highlighting and autocompletion in your Yarn scripts.

When using this extension, you can define your custom commands and functions in a JSON file ending with `.ysls.json` in the root of your project.

The schema is not fully documented, but an example configuration can be observed [here](https://github.com/YarnSpinnerTool/YarnSpinner/blob/main/YarnSpinner.LanguageServer/ImportExample.ysls.json).

You can learn more about the extension from [Yarn Spinner's official documentation](https://docs.yarnspinner.dev/getting-started/editing-with-vs-code).

## What's next?
Your project is now set up to use Yarn scripts!

To learn more about using Silk's dialogue runtime, read the [usage guide](guide/basics).

To learn more about writing in Yarn, visit [docs.yarnspinner.dev](https://docs.yarnspinner.dev/).

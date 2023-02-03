"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[684],{73571:e=>{e.exports=JSON.parse('{"functions":[{"name":"BindFunction","desc":"Binds a function to this Dialogue\'s [Library](Dialogue#Library).\\n:::caution\\nWill error if a function with the same name is already bound!\\n:::","params":[{"name":"self","desc":"","lua_type":"DialogueTypes.Dialogue"},{"name":"name","desc":"The name of the function to bind","lua_type":"string"},{"name":"argCount","desc":"The number of arguments the virtual machine should expect","lua_type":"number"},{"name":"argTypes","desc":"The types of each argument to the function","lua_type":"{ YarnType }"},{"name":"returnType","desc":"The type the function returns, or nil if it returns nothing","lua_type":"YarnType?"},{"name":"func","desc":"The Lua function to bind","lua_type":"YarnFunction"}],"returns":[],"function_type":"static","source":{"line":105,"path":"runtime/Dialogue.lua"}},{"name":"UnbindFunction","desc":"Unbinds a function from this Dialogue\'s [Library](Dialogue#Library).","params":[{"name":"self","desc":"","lua_type":"DialogueTypes.Dialogue"},{"name":"name","desc":"The name of the function to unbind","lua_type":"string"}],"returns":[],"function_type":"static","source":{"line":126,"path":"runtime/Dialogue.lua"}},{"name":"GetNodeNames","desc":"Returns a list of all loaded nodes in the program.","params":[{"name":"self","desc":"","lua_type":"DialogueTypes.Dialogue"}],"returns":[{"desc":"The names of all loaded nodes","lua_type":"{ string }"}],"function_type":"static","source":{"line":134,"path":"runtime/Dialogue.lua"}},{"name":"AddProgram","desc":"Loads the nodes from the specified Program, and adds them to the nodes already loaded.\\nIf [Dialogue.Program](Dialogue#Program) is nil, this method has the same effect as calling\\n[Dialogue:SetProgram](Dialogue#SetProgram).","params":[{"name":"self","desc":"","lua_type":"DialogueTypes.Dialogue"},{"name":"program","desc":"The additional Program to load.","lua_type":"YarnProgram"}],"returns":[],"function_type":"static","source":{"line":152,"path":"runtime/Dialogue.lua"}},{"name":"Continue","desc":"Starts or continues execution of the current Program.\\nThis method repeatedly executes instructions until one of the following conditions is encountered:\\n- The [LineHandler](Dialogue#LineHandler) or [CommandHandler](Dialogue#CommandHandler) is called.\\n  After calling either of these handlers, the Dialogue will wait until `Continue()` is called. `Continue()`\\n  may be called from inside the LineHandler or CommandHandler, or may be called at any future time.\\n- The [OptionsHandler](Dialogue#OptionsHandler) is called. When this occurs, the Dialogue is waiting for the user to specify\\n  which of the options has been selected, and `SetSelectedOption()` must be called before `Continue()` is called again.\\n- The Program reaches its end. When this occurs, `SetNode()` must be called before `Continue()` is called again.\\n- An error occurs while executing the Program.\\nThis method has no effect if it is called while the Dialogue is currently in the process of executing instructions.","params":[{"name":"self","desc":"","lua_type":"DialogueTypes.Dialogue"}],"returns":[],"function_type":"static","source":{"line":193,"path":"runtime/Dialogue.lua"}},{"name":"ExpandSubstitutions","desc":"Replaces all substitution markers in a text with the given substitution list.\\nThis method replaces substitution markers - for example, `{0}` - with the\\ncorresponding entry in `substitutions`.\\nIf `text` contains a substitution marker whose index is not present in `substitutions`,\\nit is ignored.","params":[{"name":"self","desc":"","lua_type":"DialogueTypes.Dialogue"},{"name":"text","desc":"The text containing substitution markers","lua_type":"string"},{"name":"substitutions","desc":"The list of substitutions","lua_type":"{ string }"}],"returns":[{"desc":"`text`, with the content from `substitutions` inserted.","lua_type":"string"}],"function_type":"static","source":{"line":209,"path":"runtime/Dialogue.lua"}},{"name":"GetTagsForNode","desc":"Returns the tags for the node `nodeName`.\\nThe tags for a node are defined by setting the `tags` header in\\nthe node\'s source code. This header must be a space-separated list.","params":[{"name":"self","desc":"","lua_type":"DialogueTypes.Dialogue"},{"name":"nodeName","desc":"The name of the node","lua_type":"string"}],"returns":[{"desc":"The node\'s tag, or `nil` if the node is not present in the Program","lua_type":"{ string }?"}],"function_type":"static","source":{"line":224,"path":"runtime/Dialogue.lua"}},{"name":"SetProgram","desc":"Loads all nodes from the provided Program.\\nThis method replaces any existing nodes that have been loaded.\\nIf you want to load nodes from an _additional_ Program, use the [AddProgram](Dialogue#AddProgram) method.","params":[{"name":"self","desc":"","lua_type":"DialogueTypes.Dialogue"},{"name":"program","desc":"The Program to use","lua_type":"YarnProgram"}],"returns":[],"function_type":"static","source":{"line":247,"path":"runtime/Dialogue.lua"}},{"name":"Stop","desc":"Immediately stops the `Dialogue`.\\nThe [DialogueCompleteHandler](Dialogue#OnDialogueComplete) will not\\nbe called if the dialogue is ended by calling [Stop](Dialogue#Stop).","params":[{"name":"self","desc":"","lua_type":"DialogueTypes.Dialogue"}],"returns":[],"function_type":"static","source":{"line":256,"path":"runtime/Dialogue.lua"}},{"name":"UnloadAll","desc":"Unloads all nodes from the `Dialogue`.","params":[{"name":"self","desc":"","lua_type":"DialogueTypes.Dialogue"}],"returns":[],"function_type":"static","source":{"line":263,"path":"runtime/Dialogue.lua"}},{"name":"new","desc":"Create a new Dialogue object with optional source program and starting node.","params":[{"name":"source","desc":"Source program","lua_type":"YarnProgram?"},{"name":"startNode","desc":"Starting node name","lua_type":"string?"}],"returns":[{"desc":"New dialogue object","lua_type":"Dialogue"}],"function_type":"static","tags":["constructor"],"source":{"line":274,"path":"runtime/Dialogue.lua"}}],"properties":[{"name":"DefaultStartNodeName","desc":"The node that execution will start from.","lua_type":"string","source":{"line":20,"path":"runtime/Dialogue.lua"}},{"name":"VariableStorage","desc":"The dictionary that provides access to the values of variables in use by this Dialogue.","lua_type":"{ [string]: Operand }","source":{"line":25,"path":"runtime/Dialogue.lua"}},{"name":"IsActive","desc":"A value indicating whether the Dialogue is currently executing Yarn instructions.","lua_type":"boolean","source":{"line":30,"path":"runtime/Dialogue.lua"}},{"name":"Library","desc":"The \\"library\\" of functions this Dialogue\'s Yarn code has access to.","lua_type":"{ [string]: LibraryFunction }","source":{"line":35,"path":"runtime/Dialogue.lua"}},{"name":"CurrentNode","desc":"The name of the current Node being executed.","lua_type":"string?","source":{"line":40,"path":"runtime/Dialogue.lua"}},{"name":"NodeNames","desc":"The names of all Nodes loaded in this Dialogue.","lua_type":"{ string }","source":{"line":45,"path":"runtime/Dialogue.lua"}},{"name":"Program","desc":"The program being executed by this Dialogue.","lua_type":"YarnProgram?","source":{"line":50,"path":"runtime/Dialogue.lua"}},{"name":"OnOptions","desc":"Called when the Dialogue has options to deliver to the user.","lua_type":"OptionsHandler?","tags":["callbacks"],"source":{"line":56,"path":"runtime/Dialogue.lua"}},{"name":"OnCommand","desc":"Called when the Dialogue has a command to execute.","lua_type":"CommandHandler?","tags":["callbacks"],"source":{"line":62,"path":"runtime/Dialogue.lua"}},{"name":"OnDialogueComplete","desc":"Called when the Dialogue has no more code left to execute.","lua_type":"DialogueCompleteHandler?","tags":["callbacks"],"source":{"line":68,"path":"runtime/Dialogue.lua"}},{"name":"OnLine","desc":"Called when the Dialogue delivers a line to the game.","lua_type":"LineHandler?","tags":["callbacks"],"source":{"line":74,"path":"runtime/Dialogue.lua"}},{"name":"OnNodeComplete","desc":"Called when the Dialogue has reached the end of a Node.","lua_type":"NodeCompleteHandler?","tags":["callbacks"],"source":{"line":80,"path":"runtime/Dialogue.lua"}},{"name":"OnNodeStart","desc":"Called when the Dialogue starts executing a Node.","lua_type":"NodeStartHandler?","tags":["callbacks"],"source":{"line":86,"path":"runtime/Dialogue.lua"}},{"name":"OnPrepareForLines","desc":"Called when the Dialogue anticipates that lines will be delivered soon.\\n[See for more info.](Dialogue#PrepareForLinesHandler)","lua_type":"PrepareForLinesHandler?","tags":["callbacks"],"source":{"line":93,"path":"runtime/Dialogue.lua"}}],"types":[{"name":"Line","desc":"Represents a line of Yarn dialogue.\\n:::caution\\nWhen the game receives a Line, it should do the following things to prepare the line for presentation to the user.\\n- Use the value in the ID property to look up the appropriate user-facing text in the string table.\\n- Use `ExpandSubstitutions()` to replace all substitutions in the user-facing text.\\n- Parse any markup in the line.\\n:::","lua_type":"{ id: string, substitutions: { string }? }","source":{"line":47,"path":"runtime/types/Dialogue.lua"}},{"name":"Option","desc":"Represents an option in a Yarn dialogue. The `destination` property is\\nthe node ID to run if the option is selected.","lua_type":"{ line: Line, destination: string, enabled: boolean }","source":{"line":57,"path":"runtime/types/Dialogue.lua"}},{"name":"LibraryFunction","desc":"Represents a function callable by Yarn.","lua_type":"{ argCount: number, argTypes: { YarnType }, returnType: YarnType?, func: YarnFunction }","source":{"line":68,"path":"runtime/types/Dialogue.lua"}},{"name":"YarnType","desc":"A type of argument to a bound Yarn function.","lua_type":"\\"string\\" | \\"boolean\\" | \\"number\\"","source":{"line":79,"path":"runtime/types/Dialogue.lua"}},{"name":"YarnFunction","desc":"A function that can be called by Yarn code.","lua_type":"(...Operand) -> ...Operand","source":{"line":85,"path":"runtime/types/Dialogue.lua"}},{"name":"OptionsHandler","desc":"","lua_type":"({ Option }) -> ()","tags":["handlers"],"source":{"line":90,"path":"runtime/types/Dialogue.lua"}},{"name":"CommandHandler","desc":"Called by the Dialogue whenever a command is executed.","lua_type":"(text: string) -> ()","tags":["handlers"],"source":{"line":97,"path":"runtime/types/Dialogue.lua"}},{"name":"DialogueCompleteHandler","desc":"Called by the Dialogue when the dialogue has reached its end and there is no more code to run.","lua_type":"() -> ()","tags":["handlers"],"source":{"line":104,"path":"runtime/types/Dialogue.lua"}},{"name":"LineHandler","desc":"Called by the Dialogue when it delivers a line to the game.","lua_type":"(line: Line) -> ()","tags":["handlers"],"source":{"line":111,"path":"runtime/types/Dialogue.lua"}},{"name":"NodeCompleteHandler","desc":"Called by the Dialogue when it reaches the end of a Node.","lua_type":"(name: string) -> ()","tags":["handlers"],"source":{"line":118,"path":"runtime/types/Dialogue.lua"}},{"name":"NodeStartHandler","desc":"Called by the Dialogue when it begins executing a Node.","lua_type":"(name: string) -> ()","tags":["handlers"],"source":{"line":125,"path":"runtime/types/Dialogue.lua"}},{"name":"PrepareForLinesHandler","desc":"Called by the Dialogue when it anticipates that it will deliver lines.\\nThis method should begin preparing to run the lines.  For example,\\nif a game delivers dialogue via voice-over, the appropriate audio files should be loaded.\\n:::caution\\nThis method serves to provide a hint to the game that a line _may_ be run. Not every line indicated in `lineIDs` may end up actually running.\\n:::\\nThis method may be called any number of times during a dialogue session.","lua_type":"(lineIDs: { string }) -> ()","tags":["handlers"],"source":{"line":138,"path":"runtime/types/Dialogue.lua"}}],"name":"Dialogue","desc":"Dialogue class used for executing a Yarn script.","source":{"line":6,"path":"runtime/Dialogue.lua"}}')}}]);
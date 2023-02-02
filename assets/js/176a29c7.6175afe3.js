"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[723],{77225:e=>{e.exports=JSON.parse('{"functions":[{"name":"getOperand","desc":"Turn a Protobuf operand into the union typed operand","params":[{"name":"operand","desc":"","lua_type":"RawProgram.Operand"}],"returns":[{"desc":"","lua_type":"YarnProgram.Operand\\n"}],"function_type":"static","private":true,"source":{"line":38,"path":"runtime/init.lua"}},{"name":"decodeInstructions","desc":"Decode a list of Protobuf instructions into a simpler form","params":[{"name":"code","desc":"","lua_type":"{ RawProgram.Instruction }"}],"returns":[{"desc":"","lua_type":"{ YarnProgram.Instruction }\\n"}],"function_type":"static","private":true,"source":{"line":49,"path":"runtime/init.lua"}},{"name":"decodeProgram","desc":"Decode a compiled Yarn program\\n:::note\\n  This method will usually only be used by generated YarnSpinnerRbx scripts.\\n:::","params":[{"name":"compiled","desc":"Compiled program data","lua_type":"RawProgram"}],"returns":[{"desc":"Program name if exists","lua_type":"string?"},{"desc":"Node lookup table","lua_type":"{ [string]: YarnProgram.Node }"},{"desc":"Initial values table","lua_type":"{ [string]: YarnProgram.Operand }"}],"function_type":"static","source":{"line":79,"path":"runtime/init.lua"}}],"properties":[{"name":"base64","desc":"Base64 library used by generated modules.","lua_type":"Base64","source":{"line":33,"path":"runtime/init.lua"}}],"types":[{"name":"RawProgram","desc":"[See full type here.](RawProgram)","lua_type":"RawProgram.RawProgram","source":{"line":21,"path":"runtime/init.lua"}},{"name":"Program","desc":"[See full type here.](YarnProgram)","lua_type":"YarnProgram.YarnProgram","source":{"line":27,"path":"runtime/init.lua"}}],"name":"Yarn","desc":"Main class for using files generated by YarnSpinnerRbx.","source":{"line":6,"path":"runtime/init.lua"}}')}}]);
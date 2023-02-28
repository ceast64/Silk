"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[957],{68852:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Create an empty Stack.","params":[],"returns":[{"desc":"The new Stack.","lua_type":"Stack"}],"function_type":"static","tags":["constructor"],"source":{"line":23,"path":"runtime/VirtualMachine/Stack.lua"}},{"name":"clear","desc":"Clear the Stack\'s values.","params":[],"returns":[],"function_type":"method","source":{"line":34,"path":"runtime/VirtualMachine/Stack.lua"}},{"name":"peek","desc":"Peek the value at the top of the Stack.","params":[],"returns":[{"desc":"The value at the top of the Stack.","lua_type":"Operand"}],"function_type":"method","source":{"line":43,"path":"runtime/VirtualMachine/Stack.lua"}},{"name":"pop","desc":"Pop a value off the top of the Stack.","params":[],"returns":[{"desc":"The value popped off the top of the Stack.","lua_type":"Operand"}],"function_type":"method","errors":[{"lua_type":"Stack underflow","desc":"The Stack is currently empty, so a value cannot be popped."}],"source":{"line":53,"path":"runtime/VirtualMachine/Stack.lua"}},{"name":"push","desc":"Push a value to the top of the Stack.","params":[{"name":"value","desc":"The value to push","lua_type":"Operand"}],"returns":[{"desc":"The new index of the top of the stack","lua_type":"number"}],"function_type":"method","source":{"line":66,"path":"runtime/VirtualMachine/Stack.lua"}}],"properties":[{"name":"items","desc":"The internal array containing all items on the Stack.","lua_type":"{ Operand }","source":{"line":17,"path":"runtime/VirtualMachine/Stack.lua"}}],"types":[],"name":"Stack","desc":"Simple stack structure implementation for the Virtual Machine.","source":{"line":10,"path":"runtime/VirtualMachine/Stack.lua"}}')}}]);
<img alt="Silk" width="256" height="256" src=".moonwave/static/img/silk-logo-light.png">
<!--moonwave-hide-before-this-line-->
Silk
===

# **NOT READY FOR SERIOUS USE!**

# Usage
Documentation is not yet complete, but classes have mostly complete [documentation](https://ceast64.github.io/Silk/api).

CLI requires .NET 7 to build, pre-built binaries coming soon:tm:.

# Goal
Allow developers to write [Yarn Spinner](https://yarnspinner.dev/) scripts and run them within Roblox experiences.  
A port of the entire compiler and protobuf structure to Luau would be too much work, so instead, we compile the scripts
in a C# CLI tool as part of a Rojo workflow.

## TODO (in no particular order):
- **WRITE A BETTER README**
- lots of testing
- ~~debug info callbacks~~
- ~~move Dialogue.Library to its own class~~
- ~~implement functions required for expressions (Number.Add, Number.EqualTo, etc.)~~
- implement default commands
- command parser
- ~~refactor code, namely typedefs, to improve ease of use~~
- ~~clean up API docs~~
- write beginner's guide and other docs
- test suite
- example projects with tutorials on docs site
- automate CLI build & release for tools like Aftman
- automate module build & release to Wally

[Yarn ball icon from Flaticon](https://www.flaticon.com/free-icons/yarn-ball)

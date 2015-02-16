# Console - Logary Target

**For LogLines | builtin**

Writes output messages to `System.Console.Out` and Error, and Fatal LogLines
to `System.Console.Error`.

``` powershell
Install-Package Logary
```

The console target is very simple to use and create:

``` fsharp
use logary =
  withLogary' "Console Example" (
    withTargets [
      Console.create (Console.ConsoleConf.Default) "console"
    ] >>
    withRules [
      Rule.forAny "console"
    ])
```

``` csharp
var x = LogaryFactory.New("Logary Specs", with => with.Target<Console.Builder>());
```

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
  withLogaryManager "Console Example" (
    withTargets [
      Console.create (Console.empty) (PointName.ofSingle "console")
    ] >>
    withRules [
      Rule.createForTarget (PointName.ofSingle "console")
    ])
```

``` csharp
var x = LogaryFactory.New("Logary Specs", with => with.Target<Console.Builder>());
```

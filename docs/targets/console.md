# Console - Logary Target

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

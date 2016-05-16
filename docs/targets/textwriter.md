# Logary.TextWriter

**For LogLines | builtin**

Write to any text writer - such as one from `System.IO.File.OpenWrite`.

``` powershell
Install-Package Logary
```

``` fsharp
open System
open System.IO

open NodaTime
open Logary
open Logary.Configuration
open Logary.Targets
open Logary.Metrics

#if INTERACTIVE
let path = __SOURCE_DIRECTORY__
#else
let path = System.Reflection.Assembly.GetExecutingAssembly().Location |> Path.GetDirectoryName
[<EntryPoint>]
#endif
let main argv =
  use logary =
    withLogaryManager "TextWriter.Example" (
      withTargets [
        Logary.Targets.TextWriter.create(
            let textConf = 
                TextWriter.TextWriterConf.create(
                    Path.Combine(path, DateTime.UtcNow.ToString("yyyy-MM") + "-happy.log") |> File.AppendText, 
                    Path.Combine(path, DateTime.UtcNow.ToString("yyyy-MM") + "-sad.log") |> File.AppendText)
            let newConf = { textConf with flush = true }
            newConf
        ) (PointName.ofSingle "filelogger")
      ] >>
      withRules [
        Rule.createForTarget (PointName.ofSingle "filelogger")
      ]
    ) |> Hopac.TopLevel.run

  Console.ReadKey true |> ignore
  0
``` 

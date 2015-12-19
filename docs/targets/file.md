# File - Logary Target

The file target is currently a planned target. If you really want to log to
file, in the mean while, use `System.IO.File.OpenWrite` and pass the
`TextWriter` you get back, to the `TextWriter` target.

Here is a simple example use case:

``` fsharp
open System
open System.IO
open Logary
open Logary.Configuration
open Logary.Targets
open Logary.Metrics

#if INTERACTIVE
#else
[<EntryPoint>]
#endif
let main args = 
    let logary = 
        withLogary "MyProject" (
            withTargets [
                Logary.Targets.TextWriter.create(
                    let conf = 
                        TextWriter.TextWriterConf.Create(
                            File.AppendText "happy.log",
                            File.AppendText "sad.log")
                    //conf.flush <- true
                    conf
                    ) "filelogger"
            ] >> withRules [
                Rule.createForTarget "filelogger"
            ]
        )
    let logger = Logging.getCurrentLogger ()
    LogLine.info "Hello World!" |> logger.Log
```

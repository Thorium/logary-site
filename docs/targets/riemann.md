# Riemann - Logary Target

**For Measures**

This target writes Measures to Riemann and is being used for sending metrics
from SQLServerHealth, for example. Sending them to riemann gives a platform to
start acting on what goes on in your system and can be a way to provide
auto-scaling to your deployments based off of application metrics.

Riemann is built in Clojure, and so is its config, so it gives you an
opportunity to try something new and learn a nice language.

> **Riemann monitors distributed systems.** Riemann aggregates events from your
> servers and applications with a powerful stream processing language.

``` powershell
Install-Package Intelliplan.Logary.Riemann 
```

![Riemann](https://raw.githubusercontent.com/logary/logary-assets/master/targets/riemann.png)

As a matter of fact, I have implemented a brand [new .Net
client](https://github.com/logary/logary/blob/feature/protobuf-riemann/src/Logary.Riemann/Client.fs#L56)
for Riemann, to make it stable and to make it fit well with Logary's
actor-based approach. More usage examples on this will follow.

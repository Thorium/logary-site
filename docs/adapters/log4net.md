# log4net Adapter

This adapter is a log4net Appender. It exists, because you might already have
libs and software that uses log4net to get things done, and you don't have time
to completely replace the logging infrastructure throughout your company.

Well, you're in luck! Now there's a log4net appender that you can use to get
access to all the niceties of Logary.

``` powershell
Install-Package Intelliplan.Logary.log4net -Pre
```

Now, add the adapter to your log4net configuration -- I recommend having the
message as the only message, instead of polluting the message with all sorts of
data-items that automatically get passed to the 'data' property of the LogLine,
anyhow.

Hence:

``` xml
<appender name="LogaryAppender" type="log4net.Appender.LogaryAppender">
    <layout type="log4net.Layout.PatternLayout">
        <conversionPattern value="%message" />
    </layout>
</appender>
```

Happy logging!

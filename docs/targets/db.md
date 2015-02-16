# DB - Logary Target

**For LogLines and Measures**

This target logs asynchronously to a database, using ADO.Net. You can configure
any connection factory through the target's configuration.

The target also comes with **Logary.DB.Migrations** that set up the database
state for both logs and metrics on boot, if not already existent.

``` powershell
Install-Package Logary.DB
Install-Package Logary.DB.Migrations
```


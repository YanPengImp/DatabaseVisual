# DatabaseVisual
Database Visualization
--------
This is a demo gif:

![image](https://github.com/YanPengImp/DatabaseVisual/blob/master/DatabaseDemo/DatabaseDemo/databasedemo.gif)

Use DatabaseVisual you can visualize database file on iPhone.
You can delete any row of data you don't want to keep,any also you can update any field except PRIMARY KEY.
The following is a simple code tutorial：

```
//you can specify the folder where the database resides
[DatabaseManager sharedInstance].dbDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
[[DatabaseManager sharedInstance] showTables];
```

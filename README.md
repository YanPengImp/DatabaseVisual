# DatabaseVisual
Features
======
DatabaseVisual is a simple visual data tool,solve the user export database view problem.<br>
Use DatabaseVisual you can visualize database file on iPhone.<br>
You can delete any row of data you don't want to keep,any also you can update any field except PRIMARY KEY.<br>
This is a demo gif:

![image](https://github.com/YanPengImp/DatabaseVisual/blob/master/DatabaseDemo/DatabaseDemo/databasedemo.gif)

Installation
======
CocoaPods
------

1.Update cocoapods to the latest version.<br>
2.Add pod 'DatabaseVisual' to your Podfile.<br>
3.Run pod install or pod update.<br>
4.Import <DatabaseVisual/DatabaseManager.h>.<br>

Manually
------

1.Download all the files in the DatabaseManager subdirectory.<br>
2.Add the source files to your Xcode project.<br>
3.Import "DatabaseManager.h"<br>

Usage：
=====

```
//you can specify the folder where the database resides
[DatabaseManager sharedInstance].dbDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
[[DatabaseManager sharedInstance] showTables];
```

>This is the first version,more features will be added later.<br>

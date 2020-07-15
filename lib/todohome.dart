import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:todo/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/new_todo.dart';
import 'package:todo/services/admob_services.dart';
import 'package:todo/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              primarySwatch: Colors.grey,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'ToDo',
            theme: theme,
            home: First(),
          );
        });
  }
}

class First extends StatefulWidget {
  @override
  FirstState createState() => FirstState();
}

class FirstState extends State<First> with SingleTickerProviderStateMixin {
  List<Todo> list = new List<Todo>();
  String newAppUrl;
  String newerVersion;
  SharedPreferences sharedPreferences;
  final ams = AdMobService();
  @override
  void initState() {
     try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    // list.add(Todo(title: 'Long Press to edit...'));
    // percenttodo = (doneto/(totalto+1));
    loadSharedPreferencesAndData();

    _loadSavedData();
    super.initState();
    Admob.initialize(ams.getAdMobAppId());
  }

versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      newerVersion = remoteConfig.getString('force_update_current_version');
      double newVersion = double.parse(remoteConfig
          .getString('force_update_current_version')
          .trim()
          .replaceAll(".", ""));
      newAppUrl = remoteConfig.getString('updateUrl');
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      } else {
        print("App is Updated!");
        print(newAppUrl);
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "update App ?";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return new CupertinoAlertDialog(
          insetAnimationCurve: Curves.easeInOut,
          insetAnimationDuration: Duration(seconds: 5),
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            Container(
              height: 40,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(128, 208, 199, 1),Color.fromRGBO(0, 147, 233, 1)
                  ],
                ),
                border: Border.all(width: 1, color: Colors.black),
              ),
              child: FlatButton(
                splashColor: Color.fromRGBO(0, 147, 233, 1),
                child: Text(
                  btnLabel,
                ),
                onPressed: () async {
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.storage,
                  ].request();
                  print(statuses[Permission.storage]);
                  Navigator.pop(context);
                  try {
                    OtaUpdate()
                        .execute(newAppUrl,
                            destinationFilename: 'ToDo'+newerVersion+'.apk')
                        .listen(
                      (OtaEvent event) {
                        print('EVENT: ${event.status} : ${event.value}');
                      },
                    );
                  } catch (e) {
                    print('Failed to make OTA update. Details: $e');
                  }
                },
              ),
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                // color: Colors.white,
                border: Border.all(width: 1, color: Colors.black),
              ),
              child: FlatButton(
                splashColor: Color.fromRGBO(0, 147, 233, 1),
                child: Text(
                  btnLabelCancel,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }
  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  List colors = [
    Colors.red,
    Colors.orange,
    Colors.lightGreen,
    Colors.tealAccent,
    Colors.blue,
    Colors.green,
    Colors.indigo,
    Colors.red,
    Colors.cyan,
    Colors.teal,
    Colors.amber.shade900,
    Colors.deepOrange,
    Colors.purple,
  ];

  int doneto = 0, totalto = 0, leftto;
  var key1 = 'doneto';
  var key2 = 'totalto';
  // var percent;

  Random random = new Random();
  int colorIndex = 0, writeindex = 0;
  int percent;
  void changeIndex() {
    setState(() => colorIndex = random.nextInt(10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        child: list.isEmpty ? emptyList() : buildListView(),
        color: Color.fromRGBO(236, 240, 243, 1),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        // notchMargin: 2,
        color: Color.fromRGBO(0, 147, 233, 1),

        child: Container(
          //    decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: [Color.fromRGBO(0, 147, 233, 1), Color.fromRGBO(128, 208, 199, 1)]
          //       ),
          // ),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new LinearPercentIndicator(
                padding: EdgeInsets.fromLTRB(0, 17.0, 0.0, 0.0),
                width: MediaQuery.of(context).size.width - 150,
                lineHeight: 12.0,
                percent: doneto / totalto,
                center: Text(
                  "%",
                ),
                animationDuration: 50000,
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: Colors.grey,
                progressColor: Color.fromRGBO(128, 208, 199, 1),
              ),
            ],
          ),
          height: 60.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: Color.fromRGBO(128, 208, 199, 1),
        child: Container(
          //   decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: [Color.fromRGBO(0, 147, 233, 1), Color.fromRGBO(128, 208, 199, 1)]
          //       ),
          // ),
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 40.0,
            ),
          ),
        ),
        onPressed: () => goToNewItemView(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  //scaffold end
  Widget emptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/bg.png', fit: BoxFit.fitHeight),
          Text(
            'Anything to add ?\n',
          ),
         
        ],
      ),
    );
  }

 Widget buildListView() {
    
    return Container(
      
      child: ListView.builder(
        
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            
            children: <Widget>[
              
              Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 5.0,
                  shadowColor: colors[index % 10],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // borderOnForeground: true,
                  child: Container(
                    child: buildItem(list[index], index),
                  )),
            
            ],
          );
        },
      ),
    );
  }

  Widget buildItem(Todo item, index) {
    return Dismissible(
      key: Key('${item.hashCode}'),
      background: Container(
        color: Colors.red[600],
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.delete_sweep),
            SizedBox(),
            Icon(Icons.delete_sweep),
          ],
        ),
      ),
      onDismissed: (direction) => {removeItem(item), removepercent(item)},
      direction: DismissDirection.startToEnd,
      child: buildListTile(item, index),
    );
  }

  Widget buildListTile(Todo item, int index) {
    return ListTile(
      
      onTap: () => {
        
        changeItemCompleteness(item),
        viewdoneto(item),
      },
      // child: Icon(Icons.stars),
      onLongPress: () => goToEditItemView(item),
      title: Text(
        item.title,
        key: Key('item-$index'),
        style: TextStyle(
            color: item.completed ? Colors.grey : Colors.black,
            decoration: item.completed ? TextDecoration.lineThrough : null),
      ),
      trailing: Icon(
        item.completed ? Icons.check_box : Icons.check_box_outline_blank,
        key: Key('completed-icon-$index'),
      ),
    );
  }

  _loadSavedData() async {
    // Get shared preference instance

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // percenttodo = totalto;
    setState(() {
      // Get value
      doneto = (prefs.getInt(key1) ?? 0);
      totalto = (prefs.getInt(key2) ?? 0);
      print(doneto);
      // percent = doneto~/(totalto);
      leftto = totalto - doneto;
    });
  }

  void removepercent(Todo item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (item.completed) {
        doneto--;
      }
      totalto--;
      prefs.setInt(key1, doneto);
      prefs.setInt(key2, totalto);
    });
  }

  void viewdoneto(Todo item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Get value
      item.completed ? doneto++ : doneto--;
      prefs.setInt(key1, doneto);
    });
  }

  void viewtotalto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Get value
      totalto++;
      prefs.setInt(key2, totalto);
    });
  }

  void statistics(doneto, totalto) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SimpleTab()));
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //   return Stats();
    // }));
  }

  void goToNewItemView() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoView();
    })).then((title) {
      if (title != null) {
        addItem(Todo(title: title));
        // totalto();
      }
    });
  }

  void addItem(Todo item) {
    viewtotalto();
    // Insert an item into the top of our list, on index zero
    list.insert(0, item);
    setState(() {});
    saveData();
  }

  void changeItemCompleteness(Todo item) {
   
    setState(() {
      item.completed = !item.completed;
    });

    setState(() {});
    saveData();
  }

  void goToEditItemView(item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoView(item: item);
    })).then((title) {
      if (title != null) {
        editItem(item, title);
      }
    });
  }

  void editItem(Todo item, String title) {
    item.title = title;
    saveData();
    setState(() {});
  }

  void removeItem(Todo item) {
    list.remove(item);

    saveData();
    setState(() {});
  }

  void loadData() {
    List<String> listString = sharedPreferences.getStringList('list');
    if (listString != null) {
      list = listString.map((item) => Todo.fromMap(json.decode(item))).toList();
      setState(() {});
    }
  }

  void saveData() {
    List<String> stringList =
        list.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('list', stringList);
  }
  
}

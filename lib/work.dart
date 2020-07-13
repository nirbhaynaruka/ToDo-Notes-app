import 'dart:convert';
import 'dart:math';
import 'package:To_Do/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:To_Do/new_todo.dart';
import 'package:To_Do/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:dynamic_theme/theme_switcher_widgets.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              primarySwatch: Colors.teal,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: theme,
            home: Work(),
          );
        });
  }
}

class Work extends StatefulWidget {
  @override
  WorkState createState() => WorkState();
}

class WorkState extends State<Work> with SingleTickerProviderStateMixin {
  List<Todo> list1 = new List<Todo>();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    int rem = worktotalto - workdoneto;
    // list1.add(Todo(title: 'Long Press to edit...'));
    // percenttodo = (workdoneto/(worktotalto+1));
    loadSharedPreferencesAndData();

    _loadSavedData();
    super.initState();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  List colors = [
    Colors.red[400],
    Colors.orange[300],
    Colors.lightGreen[400],
    Colors.blue[300],
    Colors.tealAccent[400],
    Colors.red[300],
    Colors.orange[400],
    Colors.lightGreen[300],
    Colors.blue[400],
    Colors.purple[300],
  ];
  bool isSwitched = false;

  int workdoneto = 0, worktotalto = 0;
  var key1 = 'workdoneto';
  var key2 = 'worktotalto';
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
      appBar: AppBar(
        title: Container(
          child: Container(
            child: Text(
              'To Do',
              key: Key('main-app-title'),
            ),
          ),
        ),
        actions: <Widget>[
          new CircularPercentIndicator(
            radius: 40.0,
            lineWidth: 4.0,
            percent: workdoneto / worktotalto,
            animation: true,
            center: new Text(
              '%',
            ),
            progressColor: Colors.orange,
          ),
        ],
        leading: IconButton(
            icon: Icon(Icons.data_usage),
            onPressed: () => statistics(workdoneto, worktotalto)),
        centerTitle: true,
      ),
      body: Container(
        child: list1.isEmpty ? emptyList() : buildListView(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.teal[200], Colors.red[200]]),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          child: Row(
            children: <Widget>[
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    changeBrightness();
                    isSwitched = value;
                  });
                },
                inactiveTrackColor: Colors.grey,
                // inactiveColor: Colors.grey,
                activeTrackColor: Colors.white,
                activeColor: Colors.black,
              ),

            ],
          ),
          color: Colors.red[300],
          height: 60.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 40.0,
          ),
        ),
        onPressed: () => goToNewItemView(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget emptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        Image.asset('assets/bg.png',fit: BoxFit.fitHeight),
          Text(
            'Lack of Work ?🧐\n',
          ),
          Text('Think of something.'),
        ],
      ),
    );
  }

  Widget buildListView() {
    return Container(
      child: ListView.builder(
        itemCount: list1.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              // child: Icons(Icons.stars),
              Card(
              elevation: 30.0,
              shadowColor: colors[index % 10],
              // borderOnForeground: true,
              child: Container(
                child: buildItem(list1[index], index),
                color: colors[index % 10],
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
      background:
          // child: Icon(Icons.delete, color: Colors.white,),
          // alignment: Alignment.centerLeft,
          Container(
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
      // direction: DismissDirection.startToEnd,
      child: buildListTile(item, index),
    );
  }

  Widget buildListTile(Todo item, int index) {
    return ListTile(
      onTap: () => {
        changeItemCompleteness(item),
        viewworkdoneto(item),
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
    int percent;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // percenttodo = worktotalto;
    setState(() {
      // Get value
      workdoneto = (prefs.getInt(key1) ?? 0);
      worktotalto = (prefs.getInt(key2) ?? 0);
      // print(workdoneto/worktotalto);
      // percent = workdoneto~/(worktotalto);
    });
  }

  void removepercent(Todo item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (item.completed) {
        workdoneto--;
      }
      worktotalto--;
      prefs.setInt(key1, workdoneto);
      prefs.setInt(key2, worktotalto);
    });
  }

  void viewworkdoneto(Todo item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Get value
      item.completed ? workdoneto++ : workdoneto--;
      prefs.setInt(key1, workdoneto);
    });
  }

  void viewworktotalto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Get value
      worktotalto++;
      prefs.setInt(key2, worktotalto);
    });
  }

  void statistics(workdoneto, worktotalto) {
    int rem = worktotalto - workdoneto;
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => Stats(rem)));
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
        // worktotalto();
      }
    });
  }

  void addItem(Todo item) {
    viewworktotalto();
    // Insert an item into the top of our list1, on index zero
    list1.insert(0, item);

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
    list1.remove(item);

    saveData();
    setState(() {});
  }

  void loadData() {
    List<String> list1String = sharedPreferences.getStringList('list1');
    if (list1String != null) {
      list1 = list1String.map((item) => Todo.fromMap(json.decode(item))).toList();
      setState(() {});
    }
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  void saveData() {
    List<String> stringList =
        list1.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('list1', stringList);
  }
}

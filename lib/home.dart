import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/mail.dart';
import 'package:todo/todohome.dart';
import 'package:todo/notes.dart';

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
            debugShowCheckedModeBanner: false,
            title: 'To Do',
            theme: theme,
            home: SimpleTab(),
          );
        });
  }
}

class SimpleTab extends StatefulWidget {
  @override
  _SimpleTabState createState() => _SimpleTabState();
}

class _SimpleTabState extends State<SimpleTab> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    // textStyle() {
    //   return new TextStyle(color: Colors.white, fontSize: 30.0);
    // }

    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        drawer: SafeArea(
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child:
                      Image.asset('assets/drawer.png', fit: BoxFit.fitHeight),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(0, 147, 233, 1),
                          Color.fromRGBO(128, 208, 199, 1)
                        ]),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Welcome ! \n ',
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0, 120, 0),
                      child: Text(
                        'Dark Theme',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(),
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
                Divider(),
                ListTile(
                  title: Text(
                      'Now you can schedule your tasks, Notes, wishes, orders or anything that you want to remind, share or track.'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                Container(
                  child: ExpansionTile(
                    title: const Text('How to use this App?'),
                    children: <Widget>[
                      ListTile(
                          title: Text(
                              '1.Add tasks or notes through + sign below.')),
                      ListTile(title: Text('2.Share your notes.')),
                      ListTile(title: Text('3.Mark Important notes.')),
                      ListTile(
                          title: Text(
                              '4.Edit tasks pressing long to your previous input.')),
                      ListTile(
                          title: Text(
                              '5.Remove tasks on sliding to block from left to right.')),
                      ListTile(
                          title: Text('6.Differentiate your tasks by colors.')),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                      'Give Feedback.'),
                  onTap: () {
                    Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new Mail();
            }));
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: new AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(128, 208, 199, 1),
                    Color.fromRGBO(0, 147, 233, 1)
                  ]),
            ),
          ),
          title: Text("To Do"),
          centerTitle: true,
          actions: <Widget>[
            CircleAvatar(
              child: Image.asset(
                'assets/icon.png',
                fit: BoxFit.cover,
              ),
            )
          ],
          bottom: new TabBar(
            tabs: <Widget>[
              new Tab(
                text: "Tasks",
              ),
              new Tab(
                text: "Notes",
              ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new Container(
              child: First(),
            ),
            new Container(
              child: new Center(
                child: Notes(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }
}

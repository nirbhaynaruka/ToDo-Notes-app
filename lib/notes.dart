import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
          return MaterialApp(
            title: 'Notes',
          
            home: Notes(),
          );
        }
}

class Notes extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  void initState() {
    super.initState();
  }

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
            title: 'Notes',
            theme: theme,
            home: MyHomePage(),
          );
        });
  }

}

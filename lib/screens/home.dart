import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:todo/components/faderoute.dart';
import 'package:todo/data/models.dart';
import 'package:todo/screens/edit.dart';
import 'package:todo/screens/view.dart';
import 'package:todo/services/admob_services.dart';
import 'package:todo/services/database.dart';
import '../components/cards.dart';
import 'package:firebase_admob/firebase_admob.dart';


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
            title: 'Notes',
            theme: theme,
            home: MyHomePage(),
          );
        });
  }
}


class MyHomePage extends StatefulWidget {
  

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  
  bool isstarOn = false;
  bool headerShouldHide = false;
  final ams = AdMobService();

  List<NotesModel> notesList = [];
  TextEditingController searchController = TextEditingController();

  bool isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
    Admob.initialize(ams.getAdMobAppId());
    NotesDatabaseService.db.init();
    setNotesFromDB();
  }

  setNotesFromDB() async {
    print("Entered setNotes");
    var fetchedNotes = await NotesDatabaseService.db.getNotesFromDB();
    setState(() {
      notesList = fetchedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
     resizeToAvoidBottomPadding: false,
       bottomNavigationBar: BottomAppBar(
         color: Color.fromRGBO(0, 147, 233, 1),
        shape: const CircularNotchedRectangle(),
        child: Container(
          // color: Colors.transparent,
          height: 60.0,
        ),

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:  Color.fromRGBO(128, 208, 199, 1),
        heroTag: null,
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 40.0,
          ),
        ),
        onPressed: () => gotoEditNote(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: Container(
        color: Color.fromRGBO(236, 240, 243, 1),
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,
        //       colors: [Colors.teal[200], Colors.red[200]]),
        // ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                buildButtonRow(),
                buildImportantIndicatorText(),
                // Container(height: 32),
                ...buildNoteComponentsList(),
             
                 // AD Here
          AdmobBanner(
            adUnitId: ams.getBannerAdId(),
            adSize: AdmobBannerSize.FULL_BANNER,
          ),
                Container(height: 100)
              ],
            ),
            margin: EdgeInsets.only(top: 2),
            padding: EdgeInsets.only(left: 10, right: 10),
          ),
        ),
      ),
    );
  }

  Widget buildButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                isstarOn = !isstarOn;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 160),
              height: 50,
              width: 50,
              curve: Curves.slowMiddle,
              child: Icon(
                isstarOn ? Icons.star : Icons.star,
                color: isstarOn ? Color.fromRGBO(0, 147, 233, 1) : Colors.black45,
              ),
              decoration: BoxDecoration(
                  // color: isstarOn ? Colors.green : Colors.transparent,
                  border: Border.all(
                    width: isstarOn ? 2 : 1,
                  
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
          ),
          
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.only(left: 16),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      maxLines: 1,
                      onChanged: (value) {
                        handleSearch(value);
                      },
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(isSearchEmpty ? Icons.search : Icons.cancel,
                        ),
                    onPressed: cancelSearch,
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget testListItem(Color color) {
    return new NoteCardComponent(
      noteData: NotesModel.random(),
    );
  }

  Widget buildImportantIndicatorText() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      firstChild: Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 010.0, 0, 0),
        child: Text(
          'Here are the notes marked important by you'.toUpperCase(),
          style: TextStyle(
              fontSize: 12, color:  Color.fromRGBO(128, 208, 199, 1), fontWeight: FontWeight.w500),
        ),
      ),
      secondChild: Container(
        height: 2,
      ),
      crossFadeState:
          isstarOn ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  List<Widget> buildNoteComponentsList() {
    List<Widget> noteComponentsList = [];
    notesList.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    if (searchController.text.isNotEmpty) {
      notesList.forEach((note) {
        if (note.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            note.content
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
          noteComponentsList.add(NoteCardComponent(
            noteData: note,
            onTapAction: openNoteToRead,
          ));
      });
      return noteComponentsList;
    }
    if (isstarOn) {
      notesList.forEach((note) {
        if (note.isImportant)
          noteComponentsList.add(NoteCardComponent(
            noteData: note,
            onTapAction: openNoteToRead,
          ));
      });
    } else {
      notesList.forEach((note) {
        noteComponentsList.add(NoteCardComponent(
          noteData: note,
          onTapAction: openNoteToRead,
        ));
      });
    }
    return noteComponentsList;
  }

  void handleSearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isSearchEmpty = false;
      });
    } else {
      setState(() {
        isSearchEmpty = true;
      });
    }
  }

  void gotoEditNote() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                EditNotePage(triggerRefetch: refetchNotesFromDB)));
  }

  void refetchNotesFromDB() async {
    await setNotesFromDB();
    print("Refetched notes");
  }

  openNoteToRead(NotesModel noteData) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
        context,
        FadeRoute(
            page: ViewNotePage(
                triggerRefetch: refetchNotesFromDB, currentNote: noteData)));
    await Future.delayed(Duration(milliseconds: 300), () {});

    setState(() {
      headerShouldHide = false;
    });
  }

  void cancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      searchController.clear();
      isSearchEmpty = true;
    });
  }
}

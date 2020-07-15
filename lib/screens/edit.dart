import 'dart:ui';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/painting.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:todo/data/models.dart';
import 'package:todo/services/database.dart';


class EditNotePage extends StatefulWidget {
  Function() triggerRefetch;
  NotesModel existingNote;
  EditNotePage({Key key, Function() triggerRefetch, NotesModel existingNote})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.existingNote = existingNote;
  }
  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {

  
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices:<String>[],
    
  );

InterstitialAd _interstitialAd;
InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: "ca-app-pub-3856528239276675/9165413818",
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }
  
  bool isDirty = false;
  bool isNoteNew = true;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();

  NotesModel currentNote;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
        FirebaseAdMob.instance.initialize(appId: "ca-app-pub-3856528239276675~6899624383");
    _interstitialAd = createInterstitialAd()..load();
    if (widget.existingNote == null) {
      currentNote = NotesModel(
          content: '', title: '', date: DateTime.now(), isImportant: false);
      isNoteNew = true;
    } else {
      currentNote = widget.existingNote;
      isNoteNew = false;
    }
    titleController.text = currentNote.title;
    contentController.text = currentNote.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
resizeToAvoidBottomPadding: false,
        body: Container(
        color: Color.fromRGBO(236, 240, 243, 1),
        //   decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //       colors: [Color.fromRGBO(0, 147, 233, 1), Color.fromRGBO(128, 208, 199, 1)]
        //       ),
        // ),
          child: Stack(
      children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  focusNode: titleFocus,
                  autofocus: true,
                  controller: titleController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSubmitted: (text) {
                    titleFocus.unfocus();
                    FocusScope.of(context).requestFocus(contentFocus);
                  },
                  onChanged: (value) {
                    markTitleAsDirty(value);
                  },
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: 32,
                      fontWeight: FontWeight.w700),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter a title',
                    hintStyle: TextStyle(
                        // color: Colors.grey.shade400,
                        fontSize: 32,
                        fontFamily: 'ZillaSlab',
                        fontWeight: FontWeight.w700),
                    // border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  
                  focusNode: contentFocus,
                  controller: contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    markContentAsDirty(value);
                  },
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  decoration: InputDecoration.collapsed(
                   
                    hintText: 'Start writing...',
                    hintStyle: TextStyle(
                        // color: Colors.grey.shade400,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
          ClipRect(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: handleSave,
                        ),
                        Spacer(),
                        IconButton(
                          tooltip: 'Mark note as important',
                          icon: Icon(currentNote.isImportant
                              ? Icons.star
                              : Icons.star_border),
                          onPressed: titleController.text.trim().isNotEmpty &&
                                  contentController.text.trim().isNotEmpty
                              ? markImportantAsDirty
                              : null,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline),
                          onPressed: () {
                            handleDelete1();
                          },
                        ),
                        AnimatedContainer(
                          margin: EdgeInsets.only(left: 10),
                          duration: Duration(milliseconds: 200),
                          width: isDirty ? 100 : 0,
                          height: 42,
                          curve: Curves.decelerate,
                            // color: Theme.of(context).accentColor,
                          child:RaisedButton(
                           onPressed: () {
                             handleSave();
                            createInterstitialAd();
                             },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color.fromRGBO(0, 147, 233, 1), Color.fromRGBO(128, 208, 199, 1)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 95.0, minHeight: 40.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Save",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                  ),
                ),
              ),
                        )
                      ],
                    ),
                  ),
                
          
      ]
          ),
        ),
    );
  }
void handleDelete1() async {
   await NotesDatabaseService.db
                      .deleteNoteInDB(currentNote);
                  widget.triggerRefetch();
                  Navigator.pop(context);
                  // Navigator.pop(context);
}
  void handleSave() async {
    setState(() {
      currentNote.title = titleController.text;
      currentNote.content = contentController.text;
      Navigator.of(context).pop(titleController.text);
      print('Hey there ${currentNote.content}');
    });
    if (isNoteNew) {
      var latestNote = await NotesDatabaseService.db.addNoteInDB(currentNote);
      setState(() {
        currentNote = latestNote;
      });
    } else {
      await NotesDatabaseService.db.updateNoteInDB(currentNote);
    }
    setState(() {
      isNoteNew = false;
      isDirty = false;
    });
    widget.triggerRefetch();
    titleFocus.unfocus();
    contentFocus.unfocus();
  }

  void markTitleAsDirty(String title) {
    setState(() {
      isDirty = true;
    });
  }

  void markContentAsDirty(String content) {
    setState(() {
      isDirty = true;
    });
  }

  void markImportantAsDirty() {
    setState(() {
      currentNote.isImportant = !currentNote.isImportant;
    });
    handleSave();
  }

  void handleDelete() async {
    if (isNoteNew) {
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text('Delete It'),
              content: Text('You sure about it ?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Yes',
                      style: prefix0.TextStyle(
                          color: Colors.red.shade300,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () async {
                    await NotesDatabaseService.db.deleteNoteInDB(currentNote);
                    widget.triggerRefetch();
                    Navigator.pop(context);
                    Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                  },
                ),
                FlatButton(
                  child: Text('Nah',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  void handleBack() {

    Navigator.pop(context);
  }
}

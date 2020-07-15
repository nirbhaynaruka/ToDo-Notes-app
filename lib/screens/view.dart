import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:todo/data/models.dart';
import 'package:todo/screens/edit.dart';
import 'package:todo/services/database.dart';

class ViewNotePage extends StatefulWidget {
  Function() triggerRefetch;
  NotesModel currentNote;
  ViewNotePage({Key key, Function() triggerRefetch, NotesModel currentNote})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.currentNote = currentNote;
  }
  @override
  _ViewNotePageState createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {




  @override
  void initState() {
    super.initState();

    showHeader();
  }

  void showHeader() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        headerShouldShow = true;
      });
    });
  }

  bool headerShouldShow = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        color: Color.fromRGBO(236, 240, 243, 1),
        //   decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,
        //       colors: [Colors.teal[200], Colors.red[200]]
        //       ),
        // ),
          child: Stack(
      children: <Widget>[
          ListView(
            // physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24.0, top: 10, bottom: 16),
                child: AnimatedOpacity(
                  opacity: headerShouldShow ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  child: Text(
                    widget.currentNote.title,
                    style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: headerShouldShow ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    DateFormat.yMd().add_jm().format(widget.currentNote.date),
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, top: 36, bottom: 24, right: 24),
                child: Text(
                  widget.currentNote.content,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          ClipRect( 
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: handleBack,
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: handleEdit,
                        ),
                        IconButton(
                          icon: Icon(widget.currentNote.isImportant
                              ? Icons.star
                              : Icons.star_border),
                          onPressed: () {
                            markImportantAsDirty();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline),
                          onPressed: handleDelete1,
                        ),
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: handleShare,
                        ),
                      ],
                    ),
                  
                
                ),
          
      ],
    ),
        ));
  }

  void handleSave() async {
    await NotesDatabaseService.db.updateNoteInDB(widget.currentNote);
    widget.triggerRefetch();
  }

  void markImportantAsDirty() {
    setState(() {
      widget.currentNote.isImportant = !widget.currentNote.isImportant;
    });
    // Navigator.pop(context);
    handleSave();
  }

  void handleEdit() {
    Navigator.pop(context);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => EditNotePage(
                  existingNote: widget.currentNote,
                  triggerRefetch: widget.triggerRefetch,
                )));
  }

  void handleShare() {
    Share.share(
        '${widget.currentNote.title.trim()}\n(On: ${widget.currentNote.date.toIso8601String().substring(0, 10)})\n\n${widget.currentNote.content}');
  }

  void handleBack() {
    Navigator.pop(context);
  }
void handleDelete1() async {
   await NotesDatabaseService.db
                      .deleteNoteInDB(widget.currentNote);
                  widget.triggerRefetch();
                  Navigator.pop(context);
                  // Navigator.pop(context);
}
  // void handleDelete() async {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //           title: Text('Delete It'),
  //           content: Text('You sure about it ?'),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('Yes',
  //                   style: TextStyle(
  //                       color: Colors.red.shade300,
  //                       fontWeight: FontWeight.w500,
  //                       letterSpacing: 1)),
  //               onPressed: () async {
  //                 await NotesDatabaseService.db
  //                     .deleteNoteInDB(widget.currentNote);
  //                 widget.triggerRefetch();
  //                 Navigator.pop(context);
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             FlatButton(
  //               child: Text('Nah',
  //                   style: TextStyle(
  //                       color: Theme.of(context).primaryColor,
  //                       fontWeight: FontWeight.w500,
  //                       letterSpacing: 1)),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }
}

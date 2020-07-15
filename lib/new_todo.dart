import 'package:flutter/material.dart';
import 'package:todo/todo.dart';
import 'dart:math';
import 'package:firebase_admob/firebase_admob.dart';

// const String testDevice = 'ca-app-pub-3856528239276675/6380749637';

class NewTodoView extends StatefulWidget {
  final Todo item;

  NewTodoView({this.item});

  @override
  _NewTodoViewState createState() => _NewTodoViewState();
}

class _NewTodoViewState extends State<NewTodoView> {
  TextEditingController titleController;

 static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices:<String>[],
    
  );

InterstitialAd _interstitialAd;
InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: "ca-app-pub-3856528239276675/6380749637",
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }


  List write = [
    'You got this.😉',
    'you can do it.😎',
    'Good luck today! I know you’ll do great.🥰',
    'Keep on keeping on!🤩',
    'Things are going to start looking up soon.',
    'Hey Unicorn.🤩',
    'Stop doubting yourself.😊',
    'Be encouraged today!🤗',
    'you are capable.😜',
    'go for it.',
    'keep on trying.😁',
    'tell me about it.😮',
  ];
  Random random = new Random();
  int writeindex = 0;
  void changeIndex() {
    setState(() => writeindex = random.nextInt(10));
  }

  @override
  void initState() {
    changeIndex();
    super.initState();
     FirebaseAdMob.instance.initialize(appId: "ca-app-pub-3856528239276675~6899624383");
    _interstitialAd = createInterstitialAd()..load();
    titleController = new TextEditingController(
        text: widget.item != null ? widget.item.title : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          // color: Colors.white,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color.fromRGBO(128, 208, 199, 1),Color.fromRGBO(0, 147, 233, 1)]),
          ),
        ),
        title: Text(
          widget.item != null ? 'Edit todo' : 'New todo',
          key: Key('new-item-title'),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromRGBO(236, 240, 243, 1),
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,
        //      colors: [Color.fromRGBO(128, 208, 199, 1),Color.fromRGBO(0, 147, 233, 1)]

        //       ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: titleController,
                autofocus: true,
                onSubmitted: (value) => submit(),
                decoration: InputDecoration(
                    labelText: 'To-Do',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    hintText: write[writeindex],
                    hintStyle: TextStyle(
                      color: Colors.black,
                    )
                    ,
                    prefixIcon: Icon(Icons.edit),
                    border: OutlineInputBorder(
                        borderSide: new BorderSide(color:Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        )
                        ),
                
              ),
              SizedBox(
                height: 14.0,
              ),
              RaisedButton(
                onPressed: () {submit();
                _interstitialAd?.show();},
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
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    if (titleController.text.isNotEmpty)
      Navigator.of(context).pop(titleController.text);
  }
}

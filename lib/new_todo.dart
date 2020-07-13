import 'package:flutter/material.dart';
import 'package:To_Do/todo.dart';
import 'dart:math';


class NewTodoView extends StatefulWidget {
  final Todo item;

  NewTodoView({ this.item });
  
  @override
  _NewTodoViewState createState() => _NewTodoViewState();
}

class _NewTodoViewState extends State<NewTodoView> {
  TextEditingController titleController;

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
    titleController = new TextEditingController(
      text: widget.item != null ? widget.item.title : null
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item != null ? 'Edit todo' : 'New todo',
          key: Key('new-item-title'),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.teal[200], Colors.red[200]]),
              ),
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
                    
                    hintText: write[writeindex],
                    prefixIcon: Icon(Icons.edit),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))
                        )
                 ),
              ),
              SizedBox(height: 14.0,),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color
                  ),
                ),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                  )
                ),
                onPressed: () => submit(),
              )
            ],
          ),
        ),
      ),
    );
       
  }

  void submit(){
     if(titleController.text.isNotEmpty)
    Navigator.of(context).pop(titleController.text);
  }
}

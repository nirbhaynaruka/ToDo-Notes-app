import 'package:To_Do/main.dart';
import 'package:To_Do/work.dart';
// import 'package:To_Do/work.dart';
// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart';
// import 'package:percent_indicator/percent_indicator.dart';



// class Stats extends StatefulWidget {
 
//    final int rem;//if you have multiple values add here
//    Stats(this.rem, {Key key}): super(key: key);//add also..example this.abc,this...

//   @override
//   _StatsState createState() => _StatsState();
// }

// class _StatsState extends State<Stats> {
//   int task;
//   @override
//   void initState() {
//     task = widget.rem;
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome !'),
      
//       ),
//       body: Center(
//         child: Image.asset('assets/statsbg.png',fit: BoxFit.fitHeight),
//     ),
//         floatingActionButton: FloatingActionButton(
//         child: Center(
//           child: Icon(
//             Icons.add,
//             color: Colors.white,
//             size: 40.0,
//           ),
//         ),
//         onPressed: () => work(),
//       ),
//     );
//   }

  
//   void work() {
    
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => Work()));
//     // Navigator.of(context).pop(Home());
//   }
// }
import 'package:flutter/material.dart';

class SimpleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    textStyle() {
      return new TextStyle(color: Colors.white, fontSize: 30.0);
    }

    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Smiple Tab Demo"),
          bottom: new TabBar(
            tabs: <Widget>[
              new Tab(
                text: "First",
              ),
              new Tab(
                text: "Second",
              ),
              new Tab(
                text: "Third",
              ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new Container(
              color: Colors.deepOrangeAccent,
              child: Home(),
            ),
            new Container(
              color: Colors.blueGrey,
              child: Work(),
            ),
            new Container(
              color: Colors.teal,
              child: new Center(
                child: new Text(
                  "Third",
                  style: textStyle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
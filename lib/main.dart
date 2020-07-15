import 'dart:async';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/home.dart';
import 'package:introduction_screen/introduction_screen.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
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
            home: new Splash(),
        
          );
        });
  }
}

class Splash extends StatefulWidget {
    @override
    SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
    Future checkFirstSeen() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool _seen = (prefs.getBool('seen') ?? false);
        if (_seen) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new SimpleTab()));
        } else {
        await prefs.setBool('seen', true);
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new OnBoardingPage()));
        }
}

    @override
    void initState() {
        super.initState();
        new Timer(new Duration(milliseconds: 200), () {
        checkFirstSeen();
        });
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
        body: new Center(
        ),
        );
    }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SimpleTab()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.png', width: 200.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0,color: Colors.white);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      boxDecoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromRGBO(0, 147, 233, 1),Color.fromRGBO(128, 208, 199, 1)]
              ),
        ),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Welcome on To-Do"
          ,
          body:
              "Have a look at how this app is the best choice for you :)",
          image: _buildImage('icon'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Task scheduling",
          body:
              "Add, edit or delete tasks, check on tasks by completion bar & checkbox",
          image: _buildImage('task'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Create your notes list",
          body:
              "Write notes, dictations, differentiate your notes by an amazing title.",
          image: _buildImage('notes'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Mark important & favourites ",
          body: "Mark so called important & upcoming tasks \n Filter all at once when required.",
          image: _buildImage('star'),
          
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Share notes or tasks",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              
              Text(" Share your notes to anyone anywhere.", style: bodyStyle),
            ],
          ),
          image: _buildImage('share'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Here you go.', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color:Color.fromRGBO(0, 147, 233, 1),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.white,
        activeShape: RoundedRectangleBorder(
          
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
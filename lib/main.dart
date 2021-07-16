// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:first_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'map.dart';

void main(){
  return runApp(ChangeNotifierProvider(
      child : MyApp(),
      create: (BuildContext context) => ThemeProvider(false)
  ));
}
/*
child: MaterialApp(
          title: 'Main Screen',
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => HomePage(),
            // When navigating to the "/second" route, build the SecondScreen widget.

          },
          debugShowCheckedModeBanner: false,

        )
 */
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder : (context , ThemeProvider, child){
          return MaterialApp(
            title: 'Main Screen',
            theme : ThemeProvider.getTheme,
            initialRoute: '/',
            routes: {
              // When navigating to the "/" route, build the FirstScreen widget.
              '/': (context) => HomePage(),
              // When navigating to the "/second" route, build the SecondScreen widget.

            },
            debugShowCheckedModeBanner: false,

          );
        },
       //we can add child so that incase its rebuilt, child doesnt undergo rebuild. optimization.
    );
  }
}
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget{

  String titleString;
  CommonAppBar(this.titleString);

  @override
  Size get preferredSize => const Size.fromHeight(50);



  @override
  Widget build(BuildContext context){
    return AppBar(
    title : Text(titleString),
    actions : <Widget>[
    Container(
    margin : EdgeInsets.only(right : 10),
    child : IconButton(
    icon :  Icon(Icons.brightness_6),
    onPressed: () {
    ThemeProvider themeProvider= Provider.of<ThemeProvider>(context , listen : false);
    //export the ThemeProvider 's provider context & set listen to be false. so that
    //when build change is triggered in provider, it doesnt remodify this section as well.
    themeProvider.swapTheme();
    },
    )
    )

    ]
    );
  }
}

class HomePage extends StatelessWidget {


  String title = "Home page";
  Color _iconColor = Colors.black; //Colors.white
  @override
  Widget build(BuildContext context) {

    return Scaffold(
          appBar : CommonAppBar(title),
          body :ListView(
              children : [
                Image.asset(
                  'images/lake.jpg',
                  width: 600,
                  height: 240,
                  fit: BoxFit.cover,
                ),
                titleSection,
                buttonSection(),
                textSection
              ]
          )

      );
  }
}



  Widget titleSection = Container(
    padding : const EdgeInsets.all(32),
    child : Row(
      children : [
        Expanded(
          child : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding : const EdgeInsets.only(bottom : 8),
                child : Text('This is a location',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
              Text(
                'primary location add.',
                style : TextStyle(
                  color : Colors.grey[500]
                ),
              ),
            ],
          ),
        ),
        FavouriteWidget(),
      ],
    ),
  );
/* creating a stateful widget for creating a button interactivity for adding favourites */
class FavouriteWidget extends StatefulWidget {
  @override
  _FavouriteWidgetState createState() => _FavouriteWidgetState();
}
class _FavouriteWidgetState extends State<FavouriteWidget>{
  bool _isStarClicked = false;
  int _favouriteNumber = 41;

  void handleStarClick(){

    setState(() {
      if(_isStarClicked) {
        _favouriteNumber--;
        _isStarClicked = false;
      }
      else{
        _favouriteNumber++;
        _isStarClicked = true;
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children : [
       IconButton(
           onPressed: handleStarClick,
           icon: _isStarClicked ? Icon(Icons.star) : Icon(Icons.star_border),
           color : Colors.red[500]
       ),
        Text('$_favouriteNumber')

      ]
    );
  }
}

/*since we know that, next section is made up of row with 3 columns,
each column is identical (re-usable component) thus, we can create a function for it
and call those column functions in our second function which will create row for us as its children
 which we will render.
*/


/*button section stateful widget. */
Color _buttonColor = Colors.blue;

class buttonSection extends StatefulWidget {
  @override
  _buttonSectionState createState() => _buttonSectionState();
}

//a utility function to be triggered on pressed event of call.

class _buttonSectionState extends State<buttonSection>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child : Row(
        mainAxisAlignment : MainAxisAlignment.spaceEvenly,
        children : [
        Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: TextButton.icon(           //fontSize : 12 . fontWeight 400 color " color
              label:Text(''),
              icon : Icon(Icons.call),
              onPressed: () => launch("tel://111111"),
            ),
          ),
        ],
      ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: TextButton.icon(           //fontSize : 12 . fontWeight 400 color " color
                label:Text(''),
                icon : Icon(Icons.near_me),
                onPressed: () => myMap.openMaps(19.078505, 72.907166),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: TextButton.icon(           //fontSize : 12 . fontWeight 400 color " color
                label:Text(''),
                icon : Icon(Icons.share),
                onPressed: () => Share.share('https://www.google.com/maps/search/?api=1&query=19.078505, 72.907166', subject: 'Location Map'),
              ),
            ),
          ],
        )
        ]
      )
    );
  }
}

/* map screen for route */
class MapScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    String title = 'Map Screen!';

    return Scaffold(
          appBar: CommonAppBar(title),
          body :Center(
            child: ElevatedButton(
              // Within the SecondScreen widget
              onPressed: () {
                // Navigate back to the first screen by popping the current route
                // off the stack.
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),

          )

      );
  }
}



Widget textSection = Container(
  padding: const EdgeInsets.all(32),
  child: Text(
    "Lorem ipsum dolor sit amet,consectetur adipiscing elit, sed do eiusmod tempor "
        "incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco "
        "laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in "
        "voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat "
        "non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    softWrap: true,
  ),
);
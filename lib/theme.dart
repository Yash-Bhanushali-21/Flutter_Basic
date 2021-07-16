import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
 ThemeData _selectedTheme = ThemeData.light(); //to know the already selected theme.

 ThemeData light = ThemeData.light(); //for a light theme.
 ThemeData dark = ThemeData.dark(); //for a dark theme.


 ThemeProvider (bool isDarkMode){
   this._selectedTheme = isDarkMode ? dark : light;
 }
 void swapTheme() {
  this._selectedTheme = this._selectedTheme == dark ? light : dark;
  notifyListeners(); //goes to consumer of provider, rebuilds the entire child wrapped in provider.
 }
 ThemeData get getTheme => this._selectedTheme;


}
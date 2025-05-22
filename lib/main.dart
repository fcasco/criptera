import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'tabs.dart';
import 'settings_page.dart';

const double appBarHeight = 48.0;
const double appBarElevation = 1.0;

bool shortenOn = false;

List<Map<String, dynamic>> marketListData = [];
Map<String, dynamic> portfolioMap = {};
List<Map<String, dynamic>> portfolioDisplay = [];
Map<String, dynamic> totalPortfolioStats = {};

bool isIOS = false;
String upArrow = "⬆";
String downArrow = "⬇";

int lastUpdate = 0;
Future<void> getMarketData() async {
  int pages = 5;
  List<Map<String, dynamic>> tempMarketListData = [];

  Future<void> _pullData(int page) async {
    var response = await http.get(
        Uri.parse(
          "https://min-api.cryptocompare.com/data/top/mktcapfull?tsym=USD&limit=100" +
            "&page=" +
            page.toString()),
        headers: {"Accept": "application/json"});

    List<Map<String, dynamic>> rawMarketListData = (json.decode(response.body)["Data"] as List).cast<Map<String, dynamic>>();
    tempMarketListData.addAll(rawMarketListData);
  }

  List<Future<void>> futures = [];
  for (int i = 0; i < pages; i++) {
    futures.add(_pullData(i));
  }
  await Future.wait(futures);

  marketListData = [];
  // Filter out lack of financial data
  for (Map<String, dynamic> coin in tempMarketListData) {
    if (coin.containsKey("RAW") && coin.containsKey("CoinInfo")) {
      marketListData.add(coin);
    }
  }

  final Directory directory = await getApplicationDocumentsDirectory();
  File jsonFile = File(directory.path + "/marketData.json");
  jsonFile.writeAsStringSync(json.encode(marketListData));
  print("Got market data.");

  lastUpdate = DateTime.now().millisecondsSinceEpoch;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Directory directory = await getApplicationDocumentsDirectory();
  File jsonFile = File(directory.path + "/portfolio.json");
  if (jsonFile.existsSync()) {
    portfolioMap = json.decode(jsonFile.readAsStringSync()) as Map<String, dynamic>;
  } else {
    jsonFile.createSync();
    jsonFile.writeAsStringSync("{}");
    portfolioMap = {};
  }
  jsonFile = File(directory.path + "/marketData.json");
  if (jsonFile.existsSync()) {
    marketListData = (json.decode(jsonFile.readAsStringSync()) as List).cast<Map<String, dynamic>>();
  } else {
    jsonFile.createSync();
    jsonFile.writeAsStringSync("[]");
    marketListData = [];
    // getMarketData(); ?does this work?
  }

  String themeMode = "Automatic";
  bool darkOLED = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Load preferences with fallback values
  shortenOn = prefs.getBool("shortenOn") ?? false;
  themeMode = prefs.getString("themeMode") ?? "Automatic";
  darkOLED = prefs.getBool("darkOLED") ?? false;

  runApp(CripteraApp(themeMode, darkOLED));
}

String numCommaParse(String? numString) {
  if (shortenOn) {
    String str = num.parse(numString ?? "0").round().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]!},");
    List<String> strList = str.split(",");

    if (strList.length > 3) {
      return strList[0] +
          "." +
          strList[1].substring(0, 4 - strList[0].length) +
          "B";
    } else if (strList.length > 2) {
      return strList[0] +
          "." +
          strList[1].substring(0, 4 - strList[0].length) +
          "M";
    } else {
      return num.parse(numString ?? "0").toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]!},");
    }
  }

  return num.parse(numString ?? "0").toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]!},");
}

String normalizeNum(num input) {
  if (input >= 100000) {
    return numCommaParse(input.round().toString());
  } else if (input >= 1000) {
    return numCommaParse(input.toStringAsFixed(2));
  } else {
    return input.toStringAsFixed(6 - input.round().toString().length);
  }
}

String normalizeNumNoCommas(num input) {
  if (input >= 1000) {
    return input.toStringAsFixed(2);
  } else {
    return input.toStringAsFixed(6 - input.round().toString().length);
  }
}

class CripteraApp extends StatefulWidget {
  const CripteraApp(this.themeMode, this.darkOLED);
  final String themeMode;
  final bool darkOLED;

  @override
  CripteraAppState createState() => CripteraAppState();
}

class CripteraAppState extends State<CripteraApp> {
  bool darkEnabled = true;
  late String themeMode;
  late bool darkOLED;

  Future<void> savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("themeMode", themeMode);
    prefs.setBool("shortenOn", shortenOn);
    prefs.setBool("darkOLED", darkOLED);
  }

  void toggleTheme() {
    switch (themeMode) {
      case "Automatic":
        themeMode = "Dark";
        break;
      case "Dark":
        themeMode = "Light";
        break;
      case "Light":
        themeMode = "Automatic";
        break;
    }
    handleUpdate();
    savePreferences();
  }

  void setDarkEnabled() {
    switch (themeMode) {
      case "Automatic":
        int nowHour = DateTime.now().hour;
        if (nowHour > 6 && nowHour < 20) {
          darkEnabled = false;
        } else {
          darkEnabled = true;
        }
        break;
      case "Dark":
        darkEnabled = true;
        break;
      case "Light":
        darkEnabled = false;
        break;
    }
    setNavBarColor();
  }

  void handleUpdate() {
    setState(() {
      setDarkEnabled();
    });
  }

  void switchOLED({bool? state}) {
    setState(() {
      darkOLED = state ?? !darkOLED;
    });
    setNavBarColor();
    savePreferences();
  }

  Future<void> setNavBarColor() async {
    if (darkEnabled) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor:
              darkOLED ? darkThemeOLED.primaryColor : darkTheme.primaryColor));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: lightTheme.primaryColor));
    }
  }

  final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.purple,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      secondary: Colors.purpleAccent[100]!,
      primary: Colors.purple,
    ),
    primaryColor: Colors.white,
    primaryColorLight: Colors.purple[700],
    dividerColor: Colors.grey[200],
    bottomAppBarColor: Colors.grey[200],
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.purple[700],
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    primaryIconTheme: IconThemeData(color: Colors.black),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: Colors.purple[700],
      ),
    ),
    disabledColor: Colors.grey[500],
  );

  final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.purple,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      secondary: Colors.deepPurpleAccent[100]!,
      primary: Colors.purple,
    ),
    primaryColor: Color.fromRGBO(50, 50, 57, 1.0),
    primaryColorLight: Colors.deepPurpleAccent[100],
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.deepPurpleAccent[100],
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: Colors.deepPurpleAccent[100],
      ),
    ),
    cardColor: Color.fromRGBO(55, 55, 55, 1.0),
    dividerColor: Color.fromRGBO(60, 60, 60, 1.0),
    bottomAppBarColor: Colors.black26,
  );

  final ThemeData darkThemeOLED = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      secondary: Colors.deepPurpleAccent[100]!,
      primary: Colors.deepPurple,
      background: Colors.black,
      surface: Colors.black,
    ),
    primaryColor: Color.fromRGBO(5, 5, 5, 1.0),
    scaffoldBackgroundColor: Colors.black,
    canvasColor: Colors.black,
    primaryColorLight: Colors.deepPurple[300],
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.deepPurpleAccent[100],
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: Colors.deepPurple[300],
      ),
    ),
    cardColor: Color.fromRGBO(16, 16, 16, 1.0),
    dividerColor: Color.fromRGBO(20, 20, 20, 1.0),
    bottomAppBarColor: Color.fromRGBO(19, 19, 19, 1.0),
    dialogBackgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
  );

  @override
  void initState() {
    super.initState();
    themeMode = widget.themeMode;
    darkOLED = widget.darkOLED;
    setDarkEnabled();
  }

  @override
  Widget build(BuildContext context) {
    isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    if (isIOS) {
      upArrow = "↑";
      downArrow = "↓";
    }

    return MaterialApp(
      color: darkEnabled
          ? darkOLED ? darkThemeOLED.primaryColor : darkTheme.primaryColor
          : lightTheme.primaryColor,
      title: "Criptera",
      home: Tabs(
        savePreferences: savePreferences,
        toggleTheme: toggleTheme,
        handleUpdate: handleUpdate,
        darkEnabled: darkEnabled,
        themeMode: themeMode,
        switchOLED: switchOLED,
        darkOLED: darkOLED,
      ),
      theme: darkEnabled ? darkOLED ? darkThemeOLED : darkTheme : lightTheme,
      routes: <String, WidgetBuilder>{
        "/settings": (BuildContext context) => SettingsPage(
              savePreferences: savePreferences,
              toggleTheme: toggleTheme,
              darkEnabled: darkEnabled,
              themeMode: themeMode,
              switchOLED: switchOLED,
              darkOLED: darkOLED,
            ),
      },
    );
  }
}

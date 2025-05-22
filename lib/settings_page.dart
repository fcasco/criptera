import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage(
      {required this.savePreferences,
      required this.toggleTheme,
      required this.darkEnabled,
      required this.themeMode,
      required this.switchOLED,
      required this.darkOLED});
  final Function savePreferences;
  final Function toggleTheme;
  final bool darkEnabled;
  final String themeMode;
  final Function switchOLED;
  final bool darkOLED;

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  _confirmDeletePortfolio() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Clear Portfolio?"),
            content: Text("This will permanently delete all transactions."),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    await _deletePortfolio();
                    Navigator.of(context).pop();
                  },
                  child: Text("Delete")),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel"))
            ],
          );
        });
  }

  Future<Null> _deletePortfolio() async {
    getApplicationDocumentsDirectory().then((Directory directory) {
      File jsonFile = File(directory.path + "/portfolio.json");
      jsonFile.delete();
      portfolioMap = {};
    });
  }

  _exportPortfolio() {
    String text = json.encode(portfolioMap);
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(appBarHeight),
            child: AppBar(
              titleSpacing: 0.0,
              elevation: appBarElevation,
              title: Text("Export Portfolio"),
            ),
          ),
          body: SingleChildScrollView(
              child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).indicatorColor,
                    content: Text("Copied to Clipboard!")));
            },
            child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.apply(fontSizeFactor: 1.1))),
          )));
    }));
  }

  _showImportPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ImportPage()));
  }

  _launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String version = "";
  String buildNumber = "";
  _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber; 
    });
  }

  void initState() { 
    super.initState();
    _getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          titleSpacing: 0.0,
          elevation: appBarElevation,
          title: Text("Settings", style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text("Preferences",
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Container(
              color: Theme.of(context).cardColor,
              child: ListTile(
                onTap: () => widget.toggleTheme(),
                leading: Icon(widget.darkEnabled
                    ? Icons.brightness_3
                    : Icons.brightness_7),
                subtitle: Text(widget.themeMode),
                title: Text("Theme"),
              )),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(Icons.opacity),
              title: Text("OLED Dark Mode"),
              trailing: Switch(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: widget.darkOLED,
                onChanged: (onOff) {
                  widget.switchOLED(state: onOff);
                },
              ),
              onTap: () => widget.switchOLED(),
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(Icons.short_text),
              title: Text("Abbreviate Numbers"),
              trailing: Switch(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: shortenOn,
                  onChanged: (onOff) {
                    setState(() {
                      shortenOn = onOff;
                    });
                    widget.savePreferences();
                  }),
              onTap: () {
                setState(() {
                  shortenOn = !shortenOn;
                });
                widget.savePreferences();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text("Data", style: Theme.of(context).textTheme.bodyMedium),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text("Export Portfolio"),
              leading: Icon(Icons.file_upload),
              onTap: _exportPortfolio,
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text("Import Portfolio"),
              leading: Icon(Icons.file_download),
              onTap: _showImportPage,
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text("Clear Portfolio"),
              leading: Icon(Icons.delete),
              onTap: _confirmDeletePortfolio,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text("About", style: Theme.of(context).textTheme.bodyMedium),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text("Version $version ($buildNumber)"),
              subtitle: Text("github.com/trentpiercy/trace"),
              leading: Icon(Icons.info_outline),
              onTap: () => _launchUrl("https://github.com/"),
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text("Issues & Feature Requests"),
              leading: Icon(Icons.bug_report),
              onTap: () =>
                  _launchUrl("https://github.com/"),
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: RichText(
                text: TextSpan(
                  text: "Forked and updated by ",
                  style: Theme.of(context).textTheme.titleMedium,
                  children: <TextSpan>[
                    TextSpan(text: "fcasco", style: Theme.of(context).textTheme.titleMedium
                      ?.apply(color: Theme.of(context).colorScheme.secondary, fontWeightDelta: 2))
                  ]
                )
              ),
              subtitle: Text("github.com/fcasco"),
              leading: Icon(Icons.build),
              onTap: () => _launchUrl("https://github.com/fcasco"),
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: RichText(
                text: TextSpan(
                  text: "Originally created with love by ",
                  style: Theme.of(context).textTheme.titleMedium,
                  children: <TextSpan>[
                    TextSpan(text: "@TrentPiercy", style: Theme.of(context).textTheme.titleMedium
                      ?.apply(color: Theme.of(context).colorScheme.secondary, fontWeightDelta: 2))
                  ]
                )
              ),
              subtitle: Text("twitter.com/trentpiercy"),
              leading: Icon(Icons.favorite),
              onTap: () => _launchUrl("https://twitter.com/trentpiercy"),
            ),
          ),
        ],
      ),
    );
  }
}

class ImportPage extends StatefulWidget {
  @override
  ImportPageState createState() => ImportPageState();
}

class ImportPageState extends State<ImportPage> {
  TextEditingController _importController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> newPortfolioMap = {};
  Color textColor = Colors.red;
  List validSymbols = [];

  _checkImport(text) {
    try {
      Map<String, dynamic> checkMap = json.decode(text);
      if (checkMap.isEmpty) {
        throw "failed at empty map";
      }
      for (String symbol in checkMap.keys) {
        if (!validSymbols.contains(symbol)) {
          throw "symbol not valid";
        }
      }
      for (List transactions in checkMap.values) {
        if (transactions.isEmpty) {
          throw "failed at emtpy transaction list";
        }
        for (Map transaction in transactions) {
          if ((transaction.keys.toList()..sort()).toString() !=
              ["exchange", "notes", "price_usd", "quantity", "time_epoch"]
                  .toString()) {
            throw "failed formatting check at transaction keys";
          }
          for (String K in transaction.keys) {
            if (K == "quantity" || K == "time_epoch" || K == "price_usd") {
              num.parse(transaction[K].toString());
            }
          }
        }
      }

      newPortfolioMap = checkMap;
      setState(() {
        textColor = (Theme.of(context).textTheme.bodyLarge?.color ?? Colors.green);
      });
    } catch (e) {
      print("Invalid JSON: $e");
      newPortfolioMap = {};
      setState(() {
        textColor = Colors.red;
      });
    }
  }

  _importPortfolio() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Import Portfolio?"),
            content: Text(
                "This will permanently overwrite current portfolio and transactions."),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    portfolioMap = newPortfolioMap;
                    await getApplicationDocumentsDirectory()
                        .then((Directory directory) {
                      File jsonFile =
                          File(directory.path + "/portfolio.json");
                      jsonFile.writeAsStringSync(json.encode(portfolioMap));
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Success!")));
                  },
                  child: Text("Import")),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel"))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    marketListData.forEach((coin) {
      validSymbols.add(coin["CoinInfo"]["Name"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(appBarHeight),
          child: AppBar(
            titleSpacing: 0.0,
            elevation: appBarElevation,
            title: Text("Import Portfolio"),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                    padding: EdgeInsets.only(top: 6.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      String? clipText = (await Clipboard.getData('text/plain'))?.text;
                      _importController.text = (clipText ?? "");
                      _checkImport(clipText);
                    },
                    child: Text("Paste",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.apply(color: Theme.of(context).iconTheme.color)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0),
                  ),
                  ElevatedButton(
                    onPressed: textColor != Colors.red ? _importPortfolio : null,
                    child: Text("Import",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.apply(color: Theme.of(context).iconTheme.color)),
                    // color: Colors.green,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _importController,
                  maxLines: null,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.apply(color: textColor, fontSizeFactor: 1.1),
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2.0)),
                      border: OutlineInputBorder(),
                      hintText: "Enter Portfolio JSON"),
                  onChanged: _checkImport,
                ),
              ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import '../flutter_candlesticks.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'change_bar.dart';

class CoinMarketStats extends StatefulWidget {
  CoinMarketStats({
    Key? key,
    this.exchangeData,
    this.e,
  }) : super(key: key);

  final exchangeData;
  final e;

  @override
  CoinMarketStatsState createState() => CoinMarketStatsState(
        exchangeData: exchangeData,
        e: e,
      );
}

class CoinMarketStatsState extends State<CoinMarketStats> {
  CoinMarketStatsState({
    required this.exchangeData,
    required this.e,
  });

  Map exchangeData;
  String? price;

  String e;
  List? historyOHLCV;

  int currentOHLCVWidthSetting = 0;
  String historyAmt = "720";
  String historyType = "minute";
  String historyTotal = "24h";
  String historyAgg = "2";

  String _high = "0";
  String _low = "0";
  String _change = "0";

  String toSym = "USD";

  normalizeNum(num input) {
    if (input < 1) {
      return input.toStringAsFixed(4);
    } else {
      return input.toStringAsFixed(2);
    }
  }

  Future<Null> getPrice() async {
    var response = await http.get(
        Uri.parse(Uri.encodeFull("https://min-api.cryptocompare.com/data/price?fsym=" +
            exchangeData["FROMSYMBOL"] +
            "&tsyms=" +
            toSym +
            "&e=" +
            e)),
        headers: {"Accept": "application/json"});
    setState(() {
      price = JsonDecoder().convert(response.body)[toSym].toString();
    });
  }

  Future<Null> getHistoryOHLCV() async {
    var response = await http.get(
        Uri.parse(Uri.encodeFull("https://min-api.cryptocompare.com/data/histo" +
            ohlcvWidthOptions[historyTotal][currentOHLCVWidthSetting][3] +
            "?fsym=" +
            exchangeData["FROMSYMBOL"] +
            "&tsym=USD&limit=" +
            (ohlcvWidthOptions[historyTotal][currentOHLCVWidthSetting][1] - 1)
                .toString() +
            "&aggregate=" +
            ohlcvWidthOptions[historyTotal][currentOHLCVWidthSetting][2]
                .toString() +
            "&e=" +
            e)),
        headers: {"Accept": "application/json"});
    setState(() {
      historyOHLCV = JsonDecoder().convert(response.body)["Data"];
    });
  }

  Future<Null> changeOHLCVWidth(int currentSetting) async {
    currentOHLCVWidthSetting = currentSetting;
    historyOHLCV = [];
    getHistoryOHLCV();
  }

  void _getHL() {
    num highReturn = -double.infinity;
    num lowReturn = double.infinity;

    for (var i in (historyOHLCV ?? [])) {
      if (i["high"] > highReturn) {
        highReturn = i["high"].toDouble();
      }
      if (i["low"] < lowReturn) {
        lowReturn = i["low"].toDouble();
      }
    }

    _high = normalizeNum(highReturn);
    _low = normalizeNum(lowReturn);

    var start = historyOHLCV?[0]["open"] == 0 ? 1 : historyOHLCV?[0]["open"];
    var end = historyOHLCV?.last["close"];
    var changePercent = (end - start) / start * 100;
    _change = changePercent.toString().substring(0, changePercent > 0 ? 5 : 6);
  }

  Future<Null> changeHistory(
      String type, String amt, String total, String agg) async {
    setState(() {
      _high = "0";
      _low = "0";
      _change = "0";

      historyAmt = amt;
      historyType = type;
      historyTotal = total;
      historyAgg = agg;

      historyOHLCV = [];
    });
    getPrice();
    await getHistoryOHLCV();
    _getHL();
  }

  void initState() {
    super.initState();
    // Initialize history data if not already loaded
    if (historyOHLCV == null || (historyOHLCV is List && (historyOHLCV as List).isEmpty)) {
      changeHistory(historyType, historyAmt, historyTotal, historyAgg);
      price = exchangeData["PRICE"].toString();
      getPrice();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          titleSpacing: 0.0,
          elevation: appBarElevation,
          title: Text(
              exchangeData["FROMSYMBOL"] + " on " + exchangeData["MARKET"]),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0, bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("\$" + price.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.apply(fontSizeFactor: 2.2)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text("24h Volume",
                                  style: Theme.of(context).textTheme.bodySmall),
                              Text(
                                  "\$" + numCommaParse(exchangeData["VOLUME24HOURTO"].toStringAsFixed(0)),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.apply(
                                          fontSizeFactor: 1.1,
                                          fontWeightDelta: 2)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Container(
                                color: Theme.of(context).cardColor,
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text("Period",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.apply(
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor)),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 3.0)),
                                                Text(historyTotal,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.apply(
                                                            fontWeightDelta:
                                                                2)),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 4.0)),
                                                Text(
                                                    num.parse(_change) > 0
                                                        ? "+" + _change + "%"
                                                        : _change + "%",
                                                    style: Theme.of(context)
                                                        .primaryTextTheme
                                                        .bodyLarge
                                                        ?.apply(
                                                            fontWeightDelta: 1,
                                                            color: num.parse(
                                                                        _change) >=
                                                                    0
                                                                ? Colors.green
                                                                : Colors.red))
                                              ],
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 1.5)),
                                            Row(
                                              children: <Widget>[
                                                Text("Candle Width",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.apply(
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor)),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 3.0)),
                                                Text(
                                                    ohlcvWidthOptions[
                                                                historyTotal][
                                                            currentOHLCVWidthSetting]
                                                        [0],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.apply(
                                                            fontWeightDelta: 2))
                                              ],
                                            ),
                                          ],
                                        ),
                                        (historyOHLCV != null && historyOHLCV is List && (historyOHLCV as List).isNotEmpty)
                                            ? Row(
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("High",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyLarge
                                                              ?.apply(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor)),
                                                      Text("Low",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyLarge
                                                              ?.apply(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor)),
                                                    ],
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 1.5)),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text("\$" + _high,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium),
                                                      Text("\$" + _low,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium)
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                              child: PopupMenuButton(
                            tooltip: "Select Width",
                            icon: Icon(Icons.swap_horiz,
                                color: Theme.of(context).buttonColor),
                            itemBuilder: (BuildContext context) {
                              List<PopupMenuEntry<dynamic>> options = [];
                              for (int i = 0;
                                  i < ohlcvWidthOptions[historyTotal].length;
                                  i++) {
                                options.add(PopupMenuItem(
                                    child: Text(
                                        ohlcvWidthOptions[historyTotal][i][0]),
                                    value: i));
                              }
                              return options;
                            },
                            onSelected: (result) {
                              changeOHLCVWidth(result);
                            },
                          )),
                          Container(
                              child: PopupMenuButton(
                            tooltip: "Select Period",
                            icon: Icon(Icons.access_time,
                                color: Theme.of(context).buttonColor),
                            itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                      child: Text("1h"),
                                      value: ["minute", "60", "1h", "1"]),
                                  PopupMenuItem(
                                      child: Text("6h"),
                                      value: ["minute", "360", "6h", "1"]),
                                  PopupMenuItem(
                                      child: Text("12h"),
                                      value: ["minute", "720", "12h", "1"]),
                                  PopupMenuItem(
                                      child: Text("24h"),
                                      value: ["minute", "720", "24h", "2"]),
                                  PopupMenuItem(
                                      child: Text("3D"),
                                      value: ["hour", "72", "3D", "1"]),
                                  PopupMenuItem(
                                      child: Text("7D"),
                                      value: ["hour", "168", "7D", "1"]),
                                  PopupMenuItem(
                                      child: Text("1M"),
                                      value: ["hour", "720", "1M", "1"]),
                                  PopupMenuItem(
                                      child: Text("3M"),
                                      value: ["day", "90", "3M", "1"]),
                                  PopupMenuItem(
                                      child: Text("6M"),
                                      value: ["day", "180", "6M", "1"]),
                                  PopupMenuItem(
                                      child: Text("1Y"),
                                      value: ["day", "365", "1Y", "1"]),
                                ],
                            onSelected: (result) {
                              changeHistory(
                                  result[0], result[1], result[2], result[3]);
                            },
                          )),
                        ],
                      ),
                    ),
                    Flexible(
                      child: (historyOHLCV != null && historyOHLCV is List && (historyOHLCV as List).isNotEmpty)
                          ? Container(
                              padding: const EdgeInsets.only(
                                  left: 2.0, right: 1.0, top: 10.0),
                              child: OHLCVGraph(
                                data: (historyOHLCV ?? []),
                                enableGridLines: true,
                                gridLineColor: Theme.of(context).dividerColor,
                                gridLineLabelColor: Theme.of(context).hintColor,
                                gridLineAmount: 4,
                                volumeProp: 0.2,
                              ),
                            )
                          : Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                    )
                  ],
                ),
          )
    );
  }
}

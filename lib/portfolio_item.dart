import 'package:flutter/material.dart';

import 'main.dart';
import 'market/coin_tabs.dart';
import 'market_coin_item.dart';

class PortfolioListItem extends StatelessWidget {
  PortfolioListItem(this.snapshot, this.columnProps);
  final columnProps;
  final Map snapshot;

  _getImage() {
    if (assetImages.contains(snapshot["symbol"].toLowerCase())) {
      return Image.asset(
          "assets/images/" + snapshot["symbol"].toLowerCase() + ".png",
          height: 28.0);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => CoinDetails(
                  snapshot: snapshot, enableTransactions: true)));
        },
        child: Container(
          decoration: BoxDecoration(),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * columnProps[0],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _getImage(),
                    Padding(padding: const EdgeInsets.only(right: 8.0)),
                    Text(snapshot["symbol"],
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * columnProps[1],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                          "\$" +
                              numCommaParse((snapshot["total_quantity"] *
                                      snapshot["price_usd"])
                                  .toStringAsFixed(2)),
                          style: Theme.of(context).textTheme.bodyMedium),
                      Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                      Text(
                          num.parse(snapshot["total_quantity"]
                                  .toStringAsPrecision(9))
                              .toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.apply(color: Theme.of(context).hintColor))
                    ],
                  )),
              Container(
                width: MediaQuery.of(context).size.width * columnProps[2],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                        "\$" + normalizeNumNoCommas(snapshot["price_usd"])),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text(
                        (snapshot["percent_change_24h"] ?? 0) >= 0
                            ? "+" + (snapshot["percent_change_24h"] ?? 0)
                                    .toStringAsFixed(2) + "%"
                            : (snapshot["percent_change_24h"] ?? 0)
                                    .toStringAsFixed(2) + "%",
                        style: Theme.of(context).primaryTextTheme.bodyLarge?.apply(
                            color: (snapshot["percent_change_24h"] ?? 0) >= 0
                                ? Colors.green
                                : Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

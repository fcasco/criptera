import 'package:flutter/material.dart';

import 'coin_exchange_stats.dart';
import '../main.dart';

class ExchangeListItem extends StatelessWidget {
  ExchangeListItem(this.exchangeDataSnapshot, this.columnProps);
  final columnProps;
  final exchangeDataSnapshot;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => CoinMarketStats(
                    exchangeData: exchangeDataSnapshot,
                    e: exchangeDataSnapshot["MARKET"],
                  )));
        },
        child: Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * columnProps[0],
                child: Text(exchangeDataSnapshot["MARKET"],
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width * columnProps[1],
                child: Text(
                    "\$" + normalizeNum(exchangeDataSnapshot["VOLUME24HOURTO"]),
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Container(
                width: MediaQuery.of(context).size.width * columnProps[2],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text("\$" +
                        normalizeNumNoCommas(exchangeDataSnapshot["PRICE"])),
                    exchangeDataSnapshot["CHANGEPCT24HOUR"] > 0
                        ? Text(
                            "+" +
                                exchangeDataSnapshot["CHANGEPCT24HOUR"]
                                    .toStringAsFixed(2) +
                                "%",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.apply(color: Colors.green))
                        : Text(
                            exchangeDataSnapshot["CHANGEPCT24HOUR"]
                                    .toStringAsFixed(2) +
                                "%",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.apply(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

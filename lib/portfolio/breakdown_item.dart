import 'package:flutter/material.dart';

import '../main.dart';
import '../market_coin_item.dart';
import '../market/coin_tabs.dart';

class PortfolioBreakdownItem extends StatelessWidget {
  PortfolioBreakdownItem({required this.snapshot, required this.totalValue, required this.color});
  final snapshot;
  final num totalValue;
  final Color color;
  final columnProps = [.2, .3, .3];

  _getImage() {
    if (assetImages.contains(snapshot["symbol"].toLowerCase())) {
      return Image.asset(
          "assets/images/" + snapshot["symbol"].toLowerCase() + ".png",
          height: 24.0);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                CoinDetails(snapshot: snapshot, enableTransactions: true)));
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
              width: MediaQuery.of(context).size.width * columnProps[2],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                      "\$" +
                          numCommaParse((snapshot["total_quantity"] *
                                  snapshot["price_usd"])
                              .toStringAsFixed(2)),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.apply(fontSizeFactor: 1.05)),
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
                        ((snapshot["total_quantity"] * snapshot["price_usd"])
                                        .abs() /
                                    totalValue.abs() *
                                    100)
                                .toStringAsFixed(2) +
                            "%",
                        style: Theme.of(context).textTheme.bodyMedium?.apply(
                            color: color,
                            fontSizeFactor: 1.3,
                            fontWeightDelta: 2)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

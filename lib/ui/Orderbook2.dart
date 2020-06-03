import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderBookMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderBookPage(),
    );
  }
}

class OrderBookPage extends StatefulWidget{
  @override
  _OrderBookPageState createState() => _OrderBookPageState();
}

class _OrderBookPageState extends State<OrderBookPage> {
  int _count = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
        child: FutureBuilder(
          future: fetchOrderBooks(http.Client()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? OrderBookList(
                      orders: snapshot.data,
                  )
                : Center(child: CircularProgressIndicator());
          },
        ),
      )
    );
  }

  Future<Null> _refreshHandle() async {
    setState(() {
      _count++;
    });
    return null;
  }
}

Future <List<List<OrderBooks>>> fetchOrderBooks(http.Client client) async {
  final orderBookData = await client.get('https://aidosmarket.com/api/order-book');
  final statsData = await client.get('https://aidosmarket.com/api/stats');
  final bbb =  compute(parseOrderBooks, orderBookData.body);
  final ccc =  compute(parseStats, statsData.body);
  print(bbb);
  print('-----------------');
  print(ccc);
  return bbb;
}

// A function that will convert a response body into a List<OrderBooks>
List<List<OrderBooks>> parseOrderBooks(String responseBody) {
  final Map<String, dynamic> data = json.decode(responseBody);
  String askJson = json.encode(data["order-book"]['ask']);
  String bidJson = json.encode(data["order-book"]['bid']);
  List askBooks = json.decode(askJson);
  List bidBooks = json.decode(bidJson);
  final sell = askBooks.map<OrderBooks>((json) => OrderBooks.fromJson(json)).toList();
  final buy =  bidBooks.map<OrderBooks>((json) => OrderBooks.fromJson(json)).toList();
  var array = [sell, buy];
  return array;
}

class OrderBooks {
  final String price;
  final String orderAmount;
  final String orderValue;

  OrderBooks({this.price, this.orderAmount, this.orderValue});
  factory OrderBooks.fromJson(Map<String, dynamic> json) {
    return OrderBooks(
      price: json['price'].toString(),
      orderAmount: json['order_amount'].toString(),
      orderValue: ((json['order_value'] * 100000).floor() / 100000).toString(),
    );
  }
}

List<Stats> parseStats(String responseBody) {
  final Map<String, dynamic> data = json.decode(responseBody);
  String statsJson = json.encode(data["stats"]);
  List stats = [json.decode(statsJson)];
  return stats.map<Stats>((json) => Stats.fromJson(json)).toList();
}


class Stats {
  final String ask;
  final String bid;
  final String lastPrice;
  final String lastTransactionType;
  final String lastTransactionCurrency;
  final String h24Volume;
  final String h24VolumeBuy;
  final String h24VolumeSell;
  final String h1Volume;
  final String h1VolumeBuy;
  final String h1VolumeSell;

  Stats({this.ask, this.bid, this.lastPrice, this.lastTransactionType, this.lastTransactionCurrency, this.h24Volume, this.h24VolumeBuy, this.h24VolumeSell, this.h1Volume, this.h1VolumeBuy, this.h1VolumeSell});

  factory Stats.fromJson(Map<String, Object> json) {
    return Stats(
      ask: json['ask'].toString(),
      bid: json['bid'].toString(),
      lastPrice: json['last_price'].toString(),
      lastTransactionType: json['last_transaction_type'].toString(),
      lastTransactionCurrency: json['last_transaction_currency'].toString(),
      h24Volume: json['24h_volume'].toString(),
      h24VolumeBuy: json['24h_volume_buy'].toString(),
      h24VolumeSell: json['24h_volume_sell'].toString(),
      h1Volume: json['1h_volume'].toString(),
      h1VolumeBuy: json['1h_volume_buy'].toString(),
      h1VolumeSell: json['1h_volume_sell'].toString(),
    );
  }
}

class OrderBookList extends StatelessWidget {
  final List<List<OrderBooks>> orders;

  OrderBookList({Key key, this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderBookList = ListView.separated(
      padding: EdgeInsets.fromLTRB(1.0, 6.0, 1.0, 6.0),
      itemCount: 100,
      reverse: true,
      itemBuilder: (context, index) {
        return Container(
          child: Row(
            children: <Widget>[
              Divider(color: Colors.black),
              Center(
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                    child: Text(
                      orders[0][index].price,
                    ),
                  )),
              Center(
                  child: Container(
                      width: 100,
                      margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                      child: Text(orders[0][index].orderAmount))),
              Center(
                  child: Container(
                    width: 160,
                    margin: EdgeInsets.fromLTRB(0, 2, 5, 0),
                    child: Text(orders[0][index].orderValue),
                  )),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );

    final OrderBookList2 = ListView.separated(
      padding: EdgeInsets.fromLTRB(1.0, 6.0, 1.0, 6.0),
      itemCount: 100,
      itemBuilder: (context, index) {
        return Container(
          child: Row(
            children: <Widget>[
              Divider(color: Colors.black),
              Center(
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                    child: Text(
                      orders[1][index].price,
                    ),
                  )),
              Center(
                  child: Container(
                      width: 100,
                      margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                      child: Text(orders[1][index].orderAmount))),
              Center(
                  child: Container(
                    width: 160,
                    margin: EdgeInsets.fromLTRB(0, 2, 5, 0),
                    child: Text(orders[1][index].orderValue),
                  )),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );

    final topTitle = Container(
        color: Colors.black,
        child: Row(
          children: <Widget>[
            Divider(color: Colors.black),
            Container(
                child: Container(
                    width: 100,
                    margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                    child: Text(
                      'Type',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))),
            Container(
                child: Container(
                    width: 100,
                    margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                    child: Text(
                      'Date',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))),
            Container(
                child: Container(
                  width: 160,
                  margin: EdgeInsets.fromLTRB(0, 2, 5, 0),
                  child: Text(
                    'Price',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        ));

    final aaa = Container(
        decoration: new BoxDecoration(
          border: Border(
            bottom: BorderSide( //                   <--- left side
              color: Colors.black,
              width: 1.0,
            ),
            top: BorderSide( //                    <--- top side
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        padding: EdgeInsets.fromLTRB(1.0, 3.0, 1.0, 3.0),
        child: Row(
          children: <Widget>[
            Divider(color: Colors.black),
            Container(
                child: Container(
                    width: 100,
                    margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))),
            Container(
                child: Container(
                    width: 100,
                    margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))),
            Container(
                child: Container(
                  width: 160,
                  margin: EdgeInsets.fromLTRB(0, 2, 5, 0),
                  child: Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        ));


    //MainContainer
    return Container(
      child: Column(
        children: <Widget>[
          topTitle,
          Flexible(child: OrderBookList),
          aaa,
          Flexible(child: OrderBookList2),
        ],
      ),
    );
  }
}
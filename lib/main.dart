import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Transactios>> fetchTransactios(http.Client client) async {
  final aaa = await client.get('https://aidosmarket.com/api/transactions?limit=100');
  // Use the compute function to run parseTransactios in a separate isolate
  return compute(parseTransactios, aaa.body);
}

Future<List<OrderBooks>> fetchOrderBook(http.Client client) async {
  final bbb = await client.get('https://aidosmarket.com/api/order-book');
  print(compute(parseOrderBook, bbb.body));
  return compute(parseOrderBook, bbb.body);
}


List<OrderBooks> parseOrderBook(String responseBody) {
  final Map<String,dynamic> data = json.decode(responseBody);
  String askJson = json.encode(data["order-book"]["ask"]);
  String bidJson = json.encode(data["order-book"]["bid"]);
  List ask = json.decode(askJson);
  List bid = json.decode(bidJson);
  ask.map<OrderBooks>((json) => OrderBooks.fromJson(json)).toList();
  return bid.map<OrderBooks>((json) => OrderBooks.fromJson(json)).toList();
}

class OrderBooks {
  final String date;
  final String orderAmount;
  final String price;

  OrderBooks({this.date,this.orderAmount,this.price});

  factory OrderBooks.fromJson(Map<String, dynamic> json) {
    return OrderBooks(
      date: json['date'],
      orderAmount: json['order_amount'].toString(),
      price: json['price'].toString(),
    );
  }
}

// A function that will convert a response body into a List<Transactios>
List<Transactios> parseTransactios(String responseBody) {
  final Map<String,dynamic> data = json.decode(responseBody);
  String transactionsJson = json.encode(data["transactions"]["data"]);
  print(transactionsJson);
  List transactions = json.decode(transactionsJson);
  return transactions.map<Transactios>((json) => Transactios.fromJson(json)).toList();
}

class Transactios {
  final String date;
  final String id;
  final String price;
  final String amount;

  Transactios({this.date,this.id,this.price,this.amount});
  factory Transactios.fromJson(Map<String, dynamic> json) {
    return Transactios(
      date: json['date'],
      id: json['id'].toString(),
      price: json['price'].toString(),
      amount: json['amount'].toString(),
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ADK Watcher'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _count = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        child: FutureBuilder<List<Transactios>>(
          future: fetchTransactios(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData ?
            RefreshIndicator(
              child: TransactiosList(photos: snapshot.data, count: _count),
              onRefresh: _refreshhandle,
            )
            : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
      ),
    );
  }

  Future<Null> _refreshhandle() async {
    setState(() {
      _count;
    });
    return null;
  }
}

class TransactiosList extends StatelessWidget {
  final List<Transactios> photos;
  final int count;
  TransactiosList({Key key, this.photos, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Row(
          children: <Widget>[
             Divider(
                color: Colors.black
            ),
            Center(
                child:Text(photos[index].date)
            ),
            Center(
                 child:Text(photos[index].price)
            ),
            Center(
                child:Text(photos[index].amount),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}

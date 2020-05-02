import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Aaa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map> _askData;
  List<Map> _bidData;
  List<Map> _transactionData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, int index) {
          return Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(_askData[index]['price'].toString(),),
                  Text(_bidData[index]['price'].toString(),),
                  Text(_transactionData[index]['price'].toString(),),
                ],
              ),
          );
        },
      ),
    );
  }

  void fetchOrders() async {
    const orderUrl = 'https://aidosmarket.com/api/order-book';
    http.get(orderUrl)
        .then((response) {
      print("Response status: ${response.statusCode}");
      final Map<String,dynamic> data = json.decode(response.body);
      String askJson = json.encode(data["order-book"]["ask"]);
      String bidJson = json.encode(data["order-book"]["bid"]);
      setState(() {
        List ask = json.decode(askJson);
        List bid = json.decode(bidJson);
        //買いのデータ
        _askData = ask.map<Map>((value) {
          return value;
        }).toList();
        //売りのデータ
        _bidData = bid.map<Map>((value) {
          return value;
        }).toList();
      });
    });
  }

  void fetchTransactions() async {
    const transactionUrl = 'https://aidosmarket.com/api/transactions';
    http.get(transactionUrl)
        .then((response) {
      print("Response status: ${response.statusCode}");
      final  data = json.decode(response.body);
      String transactionsJson = json.encode(data["transactions"]["data"]);
      setState(() {
        List transactions = json.decode(transactionsJson);
        //トランザクションデータ
        _transactionData = transactions.map<Map>((value) {
          return value;
        }).toList();
      });
    });
  }


  @override
  void initState() {
    print('initState2');
    _bidData = [];
    _transactionData = [];
    fetchOrders();
    fetchTransactions();
    super.initState();
  }
}
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

class TransactionsMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _count = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        child: FutureBuilder<List<Transactions>>(
          future: fetchTransactions(http.Client()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? RefreshIndicator(child: TransactionsList(photos: snapshot.data, count: _count),
                  onRefresh: _refreshHandle,
                )
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
      ),
    );
  }

  Future<Null> _refreshHandle() async {
    setState(() {
      _count;
    });
    return null;
  }
}


class TransactionsList extends StatelessWidget {
  final List<Transactions> photos;
  final int count;

  TransactionsList({Key key, this.photos, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TransactionsList = ListView.separated(
      padding: EdgeInsets.fromLTRB(1.0, 6.0, 1.0, 1.0),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Container(
          child: Row(
            children: <Widget>[
              Divider(color: Colors.black),
              Center(
                  child: Container(
                    width: 30,
                    margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                    child: Text(
                      photos[index].type,
                      style: TextStyle(
                        color: photos[index].type == 'Buy' ? Colors.green : Colors.red,
                      ),
                    ),
                  )),
              Center(
                  child: Container(
                      width: 150,
                      margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                      child: Text(photos[index].date))),
              Center(
                  child: Container(
                    width: 90,
                    margin: EdgeInsets.fromLTRB(0, 2, 5, 0),
                    child: Text(photos[index].price),
                  )),
              Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 2, 10, 0),
                    child: Text(photos[index].amount),
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
                    width: 32,
                    margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                    child: Text(
                      'Type',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))),
            Container(
                child: Container(
                    width: 150,
                    margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                    child: Text(
                      'Date',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))),
            Container(
                child: Container(
                  width: 90,
                  margin: EdgeInsets.fromLTRB(0, 2, 5, 0),
                  child: Text(
                    'Price',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )),
            Container(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 2, 10, 0),
                  child: Text(
                    'Amount',
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
          Flexible(child: TransactionsList),
        ],
      ),
    );
  }
}

Future<List<Transactions>> fetchTransactions(http.Client client) async {
  final transactionData = await client.get('https://aidosmarket.com/api/transactions?limit=100');
  return compute(parseTransactions, transactionData.body);
}

// A function that will convert a response body into a List<Transactions>
List<Transactions> parseTransactions(String responseBody) {
  final Map<String, dynamic> data = json.decode(responseBody);
  String transactionsJson = json.encode(data["transactions"]["data"]);
  List transactions = json.decode(transactionsJson);
  return transactions.map<Transactions>((json) => Transactions.fromJson(json)).toList();
}

class Transactions {
  final String date;
  final String id;
  final String price;
  final String amount;
  final String type;

  Transactions({this.date, this.id, this.price, this.amount, this.type});

  factory Transactions.fromJson(Map<String, dynamic> json) {
    initializeDateFormatting("ja_JP");
    DateTime datetime = DateTime.parse(json['date']); // StringからDate
    var _9hourssAfter = datetime.add(new Duration(hours: 9));
    var formatter = new DateFormat('yyyy/MM/dd HH:mm');
    var formattedDate = formatter.format(_9hourssAfter); // DateからString

    return Transactions(
      date: formattedDate,
      id: json['id'].toString(),
      price: json['price'].toString(),
      amount: json['amount'].round().toString(),
      type: json['type'],
    );
  }

}

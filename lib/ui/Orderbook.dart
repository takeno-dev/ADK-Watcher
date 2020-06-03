import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'test.dart';


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
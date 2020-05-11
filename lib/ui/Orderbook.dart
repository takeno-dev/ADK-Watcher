import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "package:intl/intl.dart";


class OrderBookMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
    //return Container(child:Text('aaa'));
    return Scaffold(
      body:Padding(
        child: FutureBuilder<List<OrderBooks>>(
          future: fetchOrderBooks(http.Client()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? RefreshIndicator(
                  child: OrderBookList(
                      photos: snapshot.data,
                      count: _count
                  ),
              onRefresh: _refreshHandle,
            )
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
      )
    );
  }

  Future<Null> _refreshHandle() async {
    setState(() {
      _count;
    });
    return null;
  }
}

Future<List<OrderBooks>> fetchOrderBooks(http.Client client) async {
  final orderBookData = await client.get('https://aidosmarket.com/api/order-book');
  return compute(parseOrderBooks, orderBookData.body);
}

// A function that will convert a response body into a List<OrderBooks>
List<OrderBooks> parseOrderBooks(String responseBody) {
  final List<dynamic> data = json.decode(responseBody);
  //String orderBooksJson = json.encode(data["order-book"]['ask']);
  //List orderBooks = json.decode(orderBooksJson);
  return data.map<OrderBooks>((json) => OrderBooks.fromJson(json)).toList();
}

class OrderBooks {
  final String price;
  final String orderAmount;
  final String orderValue;

  OrderBooks({this.price, this.orderAmount, this.orderValue});

  factory OrderBooks.fromJson(List<dynamic> json) {
    print(json);

    return OrderBooks(
      //price: json['price'].toString(),
      //orderAmount: json['order_amount'].toString(),
      //orderValue: json['order_value'].toString(),
    );
  }
}

class OrderBookList extends StatelessWidget {
  final List<OrderBooks> photos;
  final int count;

  OrderBookList({Key key, this.photos, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderBookList = ListView.separated(
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
                      photos[index].price,
                    ),
                  )),
              Center(
                  child: Container(
                      width: 150,
                      margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                      child: Text(photos[index].orderAmount))),
              Center(
                  child: Container(
                    width: 90,
                    margin: EdgeInsets.fromLTRB(0, 2, 5, 0),
                    child: Text(photos[index].orderValue),
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
          ],
        ));

    //MainContainer
    return Container(
      child: Column(
        children: <Widget>[
          topTitle,
          Flexible(child: OrderBookList),
        ],
      ),
    );
  }
}
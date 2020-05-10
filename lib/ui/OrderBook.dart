import 'package:flutter/material.dart';

class OrderBookMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: OrderBookPage(),
    );
  }
}

class OrderBookPage extends StatefulWidget {
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
                ? RefreshIndicator(child: TransactionsList(photos: snapshot.data, count: _count),
              onRefresh: _refreshHandle,
            )
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
      )
    );
  }
}

Future<List<OrderBooks>> fetchOrderBooks(http.Client client) async {
  final orderBookData = await client.get('https://aidosmarket.com/api/order-book');
  return compute(parseTransactions, orderBookData.body);
}

// A function that will convert a response body into a List<Transactions>
List<OrderBooks> parseOrderBooks(String responseBody) {
  final Map<String, dynamic> data = json.decode(responseBody);
  String orderBooksJson = json.encode(data["order-book"]["data"]);
  List orderBooks = json.decode(orderBooksJson);
  return orderBooks.map<Transactions>((json) => OrderBooks.fromJson(json)).toList();
}

class OrderBooks {
  final String price;
  final String order_amount;
  final String order_value;

  OrderBooks(this.price, this.order_amount, this.order_value);

  factory OrderBooks.fromJson(Map<String, dynamic> json) {
    initializeDateFormatting("ja_JP");
    DateTime datetime = DateTime.parse(json['date']); // StringからDate
    var _9hourssAfter = datetime.add(new Duration(hours: 9));
    var formatter = new DateFormat('yyyy/MM/dd HH:mm');
    var formattedDate = formatter.format(_9hourssAfter); // DateからString

    return OrderBooks(
      date: formattedDate,
      id: json['id'].toString(),
      price: json['price'].toString(),
      amount: json['amount'].round().toString(),
      type: json['type'],
    );
  }
}





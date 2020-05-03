
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MaterialIconsViewer());
  }
}

Future fetchPhotos(http.Client client) async {
  final response = await client.get('https://aidosmarket.com/api/transactions?limit=100');
  final response2 = await client.get('https://aidosmarket.com/api/order-book');
  //print([response,response]);
  print(response);
  return([response,response2]);
  return(response);
  //return compute(parsePhotos, response.body);
}

class MaterialIconsViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADK Watcher"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: fetchPhotos(http.Client()),
          builder: (context, future) {
            if (!future.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final Map<String,dynamic> data = json.decode(future.data[1].body);
            String askJson = json.encode(data["order-book"]["ask"]);
            String bidJson = json.encode(data["order-book"]["bid"]);
            List ask = json.decode(askJson);
            List bid = json.decode(bidJson);
            double aaa = 0;
            return Container(
              height: 600,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      child: SizedBox(
                        width: 320,
                        height: 300,
                        child: ListView.builder(
                          itemCount: bid.length,
                          itemBuilder: (context, int index) {
                            aaa = aaa + bid[index]['order_value'];
                            return Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      ((aaa * 100.0).round() / 100.0).toString(),
                                      style: TextStyle(
                                        fontSize: 8,
                                      ),
                                    ),height: 10, width: 30,
                                  ),
                                  Container(
                                    child: Text(
                                      bid[index]['order_amount'].toString(),
                                      style: TextStyle(
                                        fontSize: 8,
                                      ),
                                    ),height: 10, width: 60,
                                  ),
                                  Container( child: Text(
                                    bid[index]['price'].toString(),
                                    style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.green
                                    ),
                                  ), height: 10, width: 90,
                                  ),
                                  Container(
                                    child: Text(
                                      ask[index]['price'].toString(),
                                      style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.red
                                      ),
                                    ),height: 10, width: 60,
                                  ),
                                  Container(
                                      child: Text(
                                        ask[index]['order_amount'].toString(),
                                        style: TextStyle(
                                          fontSize: 8,
                                        ),
                                      ),height: 10, width: 60
                                  ),
                                  Container(
                                      child: Text(
                                        ask[index]['order_value'].toString(),
                                        style: TextStyle(
                                          fontSize: 8,
                                        ),
                                      ),height: 10, width: 60
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

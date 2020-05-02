
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
        child: Row(
          children: <Widget>[
            Expanded(
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

                  return Container(
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: SizedBox(
                              width: 170,
                              height: 200,
                              child: ListView.builder(
                                itemCount: bid.length,
                                itemBuilder: (context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 0),
                                    child: Row(
                                      children: <Widget>[
                                        Container( child: Text(
                                          bid[index]['price'].toString(),
                                          style: TextStyle(
                                              fontSize: 8
                                          ),
                                        ),height: 10, width: 80,),
                                        Container( child: Text(
                                          bid[index]['order_amount'].toString(),
                                          style: TextStyle(
                                              fontSize: 8
                                          ),
                                        )),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                        ),
                        Container(
                            child: SizedBox(
                              width: 170,
                              height: 200,
                              child: ListView.builder(
                                itemCount: ask.length,
                                itemBuilder: (context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 0),
                                    child: Row(
                                      children: <Widget>[
                                        Container( child: Text(
                                          ask[index]['price'].toString(),
                                          style: TextStyle(
                                              fontSize: 8
                                          ),
                                        ),height: 10, width: 80,),
                                        Container( child: Text(
                                          ask[index]['order_amount'].toString(),
                                          style: TextStyle(
                                              fontSize: 8
                                          ),
                                        )),
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

          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MaterialIconsViewer());
  }
}

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client.get('https://jsonplaceholder.typicode.com/photos');
  // Use the compute function to run parsePhotos in a separate isolate.

  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
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
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, int index) {
                      return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'aaaa',
                          ));
                    },
                  );
                },
              ),
            ),
            Expanded(
              child:  FutureBuilder(
                future: http.get("https://aidosmarket.com/api/transactions?limit=50"),
                builder: (context, future) {
                  if (!future.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final Map<String,dynamic> data = json.decode(future.data.body);
                  String transactionsJson = json.encode(data["transactions"]["data"]);
                  List transactions = json.decode(transactionsJson);
                  print(transactions.length);

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, int index) {
                      return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            transactions[index]['price'].toString(),
                          ));
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: http.get("https://aidosmarket.com/api/transactions?limit=50"),
                builder: (context, future) {
                  if (!future.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final Map<String,dynamic> data = json.decode(future.data.body);
                  String transactionsJson = json.encode(data["transactions"]["data"]);
                  List transactions = json.decode(transactionsJson);
                  print(transactions.length);

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, int index) {
                      return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            transactions[index]['price'].toString(),
                          ));
                    },
                  );
                },
              ),
            ),
          ],
        ),

        /*
        FutureBuilder(
          future: http.get("https://aidosmarket.com/api/transactions?limit=50"),
          builder: (context, future) {
            if (!future.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final Map<String,dynamic> data = json.decode(future.data.body);
            String transactionsJson = json.encode(data["transactions"]["data"]);
            List transactions = json.decode(transactionsJson);
            print(transactions.length);

            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, int index) {
                return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      transactions[index]['price'].toString(),
                    ));
              },
            );
          },
        ),
        */
      ),
    );
  }
}

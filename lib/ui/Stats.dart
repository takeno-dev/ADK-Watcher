import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

class StatsMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        child: FutureBuilder<List<Stats>>(
          future: fetchStats(http.Client()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? RefreshIndicator(child: StatsList(photos: snapshot.data, count: _count),
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


class StatsList extends StatelessWidget {
  final List<Stats> photos;
  final int count;

  StatsList({Key key, this.photos, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StatsList = ListView.separated(
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
                      photos[index].currency,
                      style: TextStyle(
                        color: photos[index].currency == 'Buy' ? Colors.green : Colors.red,
                      ),
                    ),
                  )),
              Center(
                  child: Container(
                      width: 150,
                      margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                      child: Text(photos[index].currency))),
              Center(
                  child: Container(
                    width: 90,
                    margin: EdgeInsets.fromLTRB(0, 2, 5, 0),
                    child: Text(photos[index].currency),
                  )),
              Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 2, 10, 0),
                    child: Text(photos[index].currency),
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
          Flexible(child: StatsList),
        ],
      ),
    );
  }
}

Future<List<Stats>> fetchStats(http.Client client) async {
  final statsData = await client.get('https://aidosmarket.com/api/stats');
  return compute(parseStats, statsData.body);
}

// A function that will convert a response body into a List<Stats>
List<Stats> parseStats(String responseBody) {
  final Map<String, dynamic> data = json.decode(responseBody);
  String statsJson = json.encode(data["stats"]);
  List stats = [json.decode(statsJson)];
  print(stats.map<Stats>((json) => Stats.fromJson(json)));
  return stats.map<Stats>((json) => Stats.fromJson(json)).toList();
}

class Stats {
  final String currency;
  Stats({this.currency});
  factory Stats.fromJson(Map<String, Object> json) {
    return Stats(
      currency: json['currency'],
    );
  }
}

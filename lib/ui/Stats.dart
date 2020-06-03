import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatsMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _refreshHandle();
        },
      ),
    );
  }

  Future<Null> _refreshHandle() async {
    setState(() {
      _count;
    });
  }
}


class StatsList extends StatelessWidget {
  final List<Stats> photos;
  final int count;

  StatsList({Key key, this.photos, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final last = Container(
      child:Column(
        children: [

        ],
      )
    );

    //MainContainer
    return Container(
      child: Column(
        children: <Widget>[
          last,
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
  return stats.map<Stats>((json) => Stats.fromJson(json)).toList();
}

class Stats {
  final String ask;
  final String bid;
  final String lastPrice;
  final String lastTransactionType;
  final String lastTransactionCurrency;
  final String h24Volume;
  final String h24VolumeBuy;
  final String h24VolumeSell;
  final String h1Volume;
  final String h1VolumeBuy;
  final String h1VolumeSell;

  Stats({this.ask, this.bid, this.lastPrice, this.lastTransactionType, this.lastTransactionCurrency, this.h24Volume, this.h24VolumeBuy, this.h24VolumeSell, this.h1Volume, this.h1VolumeBuy, this.h1VolumeSell});

  factory Stats.fromJson(Map<String, Object> json) {
    return Stats(
      ask: json['ask'].toString(),
      bid: json['bid'].toString(),
      lastPrice: json['last_price'].toString(),
      lastTransactionType: json['last_transaction_type'].toString(),
      lastTransactionCurrency: json['last_transaction_currency'].toString(),
      h24Volume: json['24h_volume'].toString(),
      h24VolumeBuy: json['24h_volume_buy'].toString(),
      h24VolumeSell: json['24h_volume_sell'].toString(),
      h1Volume: json['1h_volume'].toString(),
      h1VolumeBuy: json['1h_volume_buy'].toString(),
      h1VolumeSell: json['1h_volume_sell'].toString(),
    );
  }
}

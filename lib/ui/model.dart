import 'dart:convert';

// A function that will convert a response body into a List<OrderBooks>
List<List<OrderBooks>> parseOrderBooks(String responseBody) {
  final Map<String, dynamic> data = json.decode(responseBody);
  String askJson = json.encode(data["order-book"]['ask']);
  String bidJson = json.encode(data["order-book"]['bid']);
  List askBooks = json.decode(askJson);
  List bidBooks = json.decode(bidJson);
  final sell = askBooks.map<OrderBooks>((json) => OrderBooks.fromJson(json)).toList();
  final buy =  bidBooks.map<OrderBooks>((json) => OrderBooks.fromJson(json)).toList();
  var array = [sell, buy];
  return array;
}

class OrderBooks {
  final String price;
  final String orderAmount;
  final String orderValue;

  OrderBooks({this.price, this.orderAmount, this.orderValue});
  factory OrderBooks.fromJson(Map<String, dynamic> json) {
    return OrderBooks(
      price: json['price'].toString(),
      orderAmount: json['order_amount'].toString(),
      orderValue: ((json['order_value'] * 100000).floor() / 100000).toString(),
    );
  }
}

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
import 'dart:async';
import 'package:flutter/material.dart';
import 'model.dart';


Future<String> _calculation = Future<String>.delayed(
  Duration(seconds: 2),
      () => 'Data Loaded',
);


final aaa = Container(
    decoration: new BoxDecoration(
      border: Border(
        bottom: BorderSide( //                 <--- left side
          color: Colors.black,
          width: 1.0,
        ),
        top: BorderSide( //                    <--- top side
          color: Colors.black,
          width: 1.0,
        ),
      ),
    ),
    padding: EdgeInsets.fromLTRB(1.0, 3.0, 1.0, 3.0),
    child: Row(
      children: <Widget>[
        Divider(color: Colors.black),
        Container(
            child: Container(
                width: 100,
                margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                child: Text(
                  'aa',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ))),
        Container(
            child: Container(
                width: 100,
                margin: EdgeInsets.fromLTRB(5, 2, 10, 0),
                child: Text(
                  'aa',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ))),
        Container(
            child: Container(
              width: 160,
              margin: EdgeInsets.fromLTRB(0, 2, 5, 0),
              child: Text(
                'aa',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )),
      ],
    ));


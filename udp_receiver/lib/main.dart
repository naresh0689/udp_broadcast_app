import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:udp/udp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.

        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //var text_message = '';

  @override
  void initState() {
    print('In initState');
    var DESTINATION_ADDRESS = InternetAddress('255.255.255.255');

    RawDatagramSocket.bind(InternetAddress.anyIPv4, 8889)
        .then((RawDatagramSocket udpSocket) async {
      print('In bind DESTINATION_ADDRESS : $DESTINATION_ADDRESS');
      print(await NetworkInterface.list());
      udpSocket.broadcastEnabled = true;
      udpSocket.readEventsEnabled = true;
      udpSocket.writeEventsEnabled = true;

      udpSocket.listen((e) {
        print('In listen');
        Datagram dg = udpSocket.receive();
        if (dg != null) {
          print("received ${utf8.decode(dg.data)}");
        }
      });
      print('receiver');

      var msg =
          'RECEIVER APP TEST MESSAGE AT ${DateTime.now().toIso8601String()}';
      print('sending ${msg}');
      List<int> data = utf8.encode(msg);
      udpSocket.send(data, DESTINATION_ADDRESS, 8889);
    });

    super.initState();
  }

  var _message = 'Default';

  Future<void> _changeMessage(String msg) async {
    _message = msg;
    setState(() {
      print('In set state _message ; $_message, msg : $msg');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Sending Message to Network',
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              '$_message',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

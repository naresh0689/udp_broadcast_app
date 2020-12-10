import 'dart:io';
import 'dart:convert';

main() {
  var DESTINATION_ADDRESS = InternetAddress('255.255.255.255');

  RawDatagramSocket.bind(InternetAddress.anyIPv4, 8889)
      .then((RawDatagramSocket udpSocket) {
    udpSocket.broadcastEnabled = true;
    udpSocket.writeEventsEnabled = true;
    udpSocket.readEventsEnabled = true;
    // uncomment below lines if you want this program to listen as well
//    udpSocket.listen((e) {
//      Datagram dg = udpSocket.receive();
//      if (dg != null) {
//        print("received ${utf8.decode(dg.data)}");
//      }
//    });
//    List<int> data =utf8.encode('TEST');
    while (true) {
      var message = 'message at ' + DateTime.now().toIso8601String();
      print('sending message : $message');
      List<int> data = utf8.encode(message);
      udpSocket.send(data, DESTINATION_ADDRESS, 8889);
      sleep(const Duration(seconds: 5));
    }
  });
}

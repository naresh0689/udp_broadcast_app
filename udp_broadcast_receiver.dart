import 'dart:io';
import 'dart:convert';

main() {
  var DESTINATION_ADDRESS = InternetAddress('255.255.255.255');

  RawDatagramSocket.bind(InternetAddress.anyIPv4, 8889)
      .then((RawDatagramSocket udpSocket) {
    udpSocket.broadcastEnabled = true;
    udpSocket.writeEventsEnabled = true;
    udpSocket.readEventsEnabled = true;
    udpSocket.listen((e) {
      Datagram dg = udpSocket.receive();
      if (dg != null) {
        print("received ${utf8.decode(dg.data)}");
      }
    });
    //List<int> data =utf8.encode('TEST');
//while(true) {
//  List<int> data =utf8.encode('message at ' + DateTime.now().toIso8601String());
//    udpSocket.send(data, DESTINATION_ADDRESS, 8889);
//	sleep(const Duration(seconds:5));
//}
  });
}

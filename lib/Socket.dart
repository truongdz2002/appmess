import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Socket extends StatefulWidget {
  const Socket({Key? key}) : super(key: key);

  @override
  State<Socket> createState() => _SocketState();
}

class _SocketState extends State<Socket> {
  var channel = WebSocketChannel.connect(Uri.parse('Connected - wss://ws.postman-echo.com/raw'));
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('WebSocket Example'),
        ),
        body: Column(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: channel.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.toString());
                    } else {
                      return Text('No data received');
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (String message) {
                  channel.sink.add(message);
                },
                decoration: InputDecoration(
                  labelText: 'Enter a message',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

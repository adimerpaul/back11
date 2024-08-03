import 'package:back11/pages/MyHomePage.dart';
import 'package:back11/services/notificationServices.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../globals.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeService();
  await Permission.notification.request();
  // await Permission.camera.request();
  await initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    socketInit();
  }
  socketInit() {
    print('socketInit');
    globals.socket = io('http://192.168.1.3:3000',
        OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({'foo': 'bar'})
            .build());
    globals.socket.onConnect((data) {
      print('connect');
    });
    globals.socket.on('chat message', (data) {
      print(data);
      showNotification(data, 0);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}


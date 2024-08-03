import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'notificationServices.dart';
import '../globals.dart' as globals;
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      // autoStartOnBoot: false,
      // notificationChannelId: NotificationHelper.channelId1,
    ),
  );
}
@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  // Timer.periodic(const Duration(seconds: 3), (timer) async {
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {
  //       print('Awesome ${DateTime.now()}');
  //       showNotification('AAAAA', 0);
  //     }
  //   }
  // });
  // globals.socket = io('http://localhost:3000',
  //     OptionBuilder()
  //         .setTransports(['websocket']) // for Flutter or Dart VM
  //         .disableAutoConnect()  // disable auto-connection
  //         .setExtraHeaders({'foo': 'bar'}) // optional
  //         .build()
  // );
  // globals.socket.on('connect', (_) {
  //   print('connect');
  // });
  // globals.socket.on('message', (data){
  //   print(data);
  //   // showNotification(data, 0);
  // });
  socketInit();
}
socketInit() {
  globals.socket = io('http://192.168.1.3:3000',
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
      // .setExtraHeaders({'foo': 'bar'}) // optional
          .build());
  globals.socket.onConnect((data) {
    print('connect');
  });
  globals.socket.on('chat message', (data) {
    print(data);
    showNotification(data, 0);
  });
}
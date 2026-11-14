import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../core/constants/api_constants.dart';
import 'api_service.dart';

/// PDF §4.7 — socket.on('order:status', { orderId, status })
class SocketService {
  IO.Socket? _socket;
  final _ctrl = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get orderStatusStream => _ctrl.stream;

  void connect(String orderId) {
    if (ApiService.mockMode) return; // demo me tracking screen timer use karta hai
    _socket = IO.io(ApiConstants.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'query': {'orderId': orderId},
    });
    _socket!.on('order:status', (data) => _ctrl.add(Map<String, dynamic>.from(data)));
    _socket!.onConnectError((e) => debugPrint('Socket error: $e'));
  }

  void disconnect() => _socket?.disconnect();
  void dispose() { _socket?.dispose(); _ctrl.close(); }
}
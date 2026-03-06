import 'dart:async';
import 'dart:convert';

import 'package:boxmon/chatting/models/chat_message_model.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

typedef ChatMessageListener = void Function(ChatMessageModel message);

class ChatSocketService extends GetxService {
  final dio.Dio _dio = Get.find<dio.Dio>();
  final TokenService _tokenService = Get.find<TokenService>();

  StompClient? _client;
  Completer<void>? _connectCompleter;
  final Map<int, StompUnsubscribe> _roomSubscriptions = {};
  bool _connected = false;

  Future<void> connect() async {
    if (_connected && _client != null) return;

    final int? userId = _tokenService.userId;
    final String? role = _tokenService.userType;
    final String? token = _tokenService.accessToken;
    if (userId == null || role == null) {
      throw Exception('채팅 소켓 연결에 필요한 사용자 정보가 없습니다.');
    }

    final normalizedRole = role.toUpperCase().trim();

    _connectCompleter = Completer<void>();

    _client = StompClient(
      config: StompConfig.sockJS(
        url: _resolveSockJsUrl(),
        webSocketConnectHeaders: {
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
          'X-USER-ID': '$userId',
          'X-USER-ROLE': normalizedRole,
        },
        stompConnectHeaders: {
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
          'X-USER-ID': '$userId',
          'X-USER-ROLE': normalizedRole,
        },
        onConnect: (_) {
          _connected = true;
          if (!(_connectCompleter?.isCompleted ?? true)) {
            _connectCompleter?.complete();
          }
        },
        onWebSocketError: (dynamic error) {
          _connected = false;
          if (!(_connectCompleter?.isCompleted ?? true)) {
            _connectCompleter?.completeError(error ?? Exception('웹소켓 연결 실패'));
          }
        },
        onStompError: (frame) {
          _connected = false;
          if (!(_connectCompleter?.isCompleted ?? true)) {
            _connectCompleter?.completeError(
              Exception(frame.body ?? 'STOMP 에러'),
            );
          }
        },
        onDisconnect: (_) {
          _connected = false;
        },
      ),
    );

    _client!.activate();
    await _connectCompleter!.future.timeout(const Duration(seconds: 5));
  }

  void subscribeRoom({
    required int shipmentId,
    required ChatMessageListener onMessage,
  }) {
    if (!_connected || _client == null) return;
    if (_roomSubscriptions.containsKey(shipmentId)) return;

    final unsubscribe = _client!.subscribe(
      destination: '/sub/chat.room.$shipmentId',
      callback: (frame) {
        final String? body = frame.body;
        if (body == null || body.isEmpty) return;

        final dynamic decoded = jsonDecode(body);
        if (decoded is! Map) return;
        onMessage(ChatMessageModel.fromJson(Map<String, dynamic>.from(decoded)));
      },
    );

    _roomSubscriptions[shipmentId] = unsubscribe;
  }

  void unsubscribeRoom(int shipmentId) {
    final unsubscribe = _roomSubscriptions.remove(shipmentId);
    unsubscribe?.call();
  }

  void sendText({
    required int shipmentId,
    required String content,
  }) {
    if (!_connected || _client == null) return;
    _client!.send(
      destination: '/pub/chat.send.$shipmentId',
      body: jsonEncode({'contentType': 'TEXT', 'content': content}),
    );
  }

  void disconnect() {
    for (final unsubscribe in _roomSubscriptions.values) {
      unsubscribe.call();
    }
    _roomSubscriptions.clear();
    _client?.deactivate();
    _client = null;
    _connected = false;
  }

  String _resolveSockJsUrl() {
    final uri = Uri.parse(_dio.options.baseUrl);
    return uri.replace(path: '/ws-chat', query: null, fragment: null).toString();
  }
}

import 'package:boxmon/chatting/models/chat_message_model.dart';
import 'package:boxmon/chatting/models/chat_room_item_model.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class ChatService extends GetxService {
  final dio.Dio _dio = Get.find<dio.Dio>();
  final TokenService _tokenService = Get.find<TokenService>();

  Future<List<ChatRoomItemModel>> fetchChatRooms() async {
    final String? role = _tokenService.userType;
    final String? token = _tokenService.accessToken;
    if (token == null) return const [];

    final String normalizedRole = (role ?? '').toUpperCase().trim();
    final List<String> candidatePaths = normalizedRole.contains('DRIVER')
        ? <String>[
            'shipment/my/inventory/driver',
            'shipment/my/inventory/shipper',
          ]
        : <String>[
            'shipment/my/inventory/shipper',
            'shipment/my/inventory/driver',
          ];

    final List<ChatRoomItemModel> merged = <ChatRoomItemModel>[];

    for (final path in candidatePaths) {
      try {
        final response = await _dio.get(
          path,
          options: dio.Options(headers: {'Authorization': 'Bearer $token'}),
        );
        if (response.statusCode != 200 || response.data is! List) {
          continue;
        }
        final List<dynamic> rows = response.data as List<dynamic>;
        final parsed = rows
            .whereType<Map>()
            .map((row) => Map<String, dynamic>.from(row))
            .map(_toRoomItem)
            .where((room) => _isChatAvailableStatus(room.shipmentStatus))
            .toList();
        merged.addAll(parsed);
      } catch (_) {
        // 역할 불일치로 한쪽 엔드포인트가 실패해도 다른 후보를 계속 시도한다.
      }
    }

    if (merged.isEmpty) return const [];

    final Map<int, ChatRoomItemModel> dedupedByShipmentId = {
      for (final room in merged) room.shipmentId: room,
    };
    final rooms = dedupedByShipmentId.values.toList();

    rooms.sort((a, b) => b.shipmentId.compareTo(a.shipmentId));
    return rooms;
  }

  Future<List<ChatMessageModel>> fetchMessages(int shipmentId) async {
    final headers = _buildChatHeaders();
    final response = await _dio.get(
      'chat/$shipmentId/messages',
      options: dio.Options(headers: headers),
    );

    final dynamic body = response.data;
    final List<dynamic> rawMessages = body is Map<String, dynamic>
        ? (body['messages'] as List<dynamic>? ?? const [])
        : const [];

    return rawMessages
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .map(ChatMessageModel.fromJson)
        .toList();
  }

  Map<String, String> _buildChatHeaders() {
    final int? userId = _tokenService.userId;
    final String? role = _tokenService.userType;
    final String? token = _tokenService.accessToken;
    if (userId == null || role == null || token == null) {
      throw Exception('채팅 사용자 정보가 없습니다.');
    }

    return {
      'Authorization': 'Bearer $token',
      'X-USER-ID': '$userId',
      'X-USER-ROLE': role,
    };
  }

  ChatRoomItemModel _toRoomItem(Map<String, dynamic> json) {
    final int shipmentId = _toInt(json['shipmentId']) ?? 0;
    final String pickup = '${json['pickupAddress'] ?? ''}'.trim();
    final String dropoff = '${json['dropoffAddress'] ?? ''}'.trim();

    return ChatRoomItemModel(
      shipmentId: shipmentId,
      title: '운송 #$shipmentId',
      subtitle: '$pickup -> $dropoff',
      shipmentStatus: '${json['shipmentStatus'] ?? ''}',
    );
  }

  bool _isChatAvailableStatus(String status) {
    final String normalized = status.toUpperCase().trim();
    if (normalized.isEmpty) return true;

    const denied = {
      'REQUESTED',
      'CANCELLED',
      'CANCELED',
      'CANCEL_REQUESTED',
      'CANCELLED_BY_SHIPPER',
      'CANCELLED_BY_DRIVER',
    };
    return !denied.contains(normalized);
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }
}

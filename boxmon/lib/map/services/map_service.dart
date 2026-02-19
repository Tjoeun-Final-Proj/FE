import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapService {
  final Dio _dio;

  // 생성자에서 Dio를 직접 세팅하거나 외부에서 받을 수 있게 함
  MapService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc',
    headers: {
      'X-NCP-APIGW-API-KEY-ID': dotenv.env['X-NCP-APIGW-API-KEY-ID'],
      'X-NCP-APIGW-API-KEY': dotenv.env['X-NCP-APIGW-API-KEY'],
    },
  ));

  // 실제 호출 메소드
  Future<Map<String, dynamic>> fetchReverseGeocode(double lat, double lng) async {
    try {
      final response = await _dio.get('', queryParameters: {
        'coords': '$lng,$lat',
        'sourcecrs': 'epsg:4326',
        'output': 'json',
        'orders': 'admcode,legalcode,addr,roadaddr',
        'resulttype' : 'aroundbase'
      });
      return response.data;
    } catch (e) {
      rethrow; // 에러는 위로 던져서 처리하게 함
    }
  }
}
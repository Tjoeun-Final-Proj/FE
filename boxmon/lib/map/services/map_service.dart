import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapService {
  final Dio _dio;

  // 생성자에서 Dio를 직접 세팅하거나 외부에서 받을 수 있게 함
  MapService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://maps.apigw.ntruss.com',
    headers: {
      'X-NCP-APIGW-API-KEY-ID': dotenv.env['X-NCP-APIGW-API-KEY-ID'],
      'X-NCP-APIGW-API-KEY': dotenv.env['X-NCP-APIGW-API-KEY'],
    },
  ));

  // 실제 호출 메소드
  Future<Map<String, dynamic>> fetchReverseGeocode(double lat, double lng) async {
    try {
      final response = await _dio.get('/map-reversegeocode/v2/gc', queryParameters: {
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

  // 네이버 장소 검색 하는 메서드
  // MapService 내부
Future<Map<String, dynamic>> fetchPlaceSearch(String query) async {
  try {
    print("--- API 요청 상세 ---");
    print("URL: ${_dio.options.baseUrl}/map-geocode/v2/geocode");
    print("Headers: ${_dio.options.headers}"); // 여기서 .env 값이 잘 들어갔는지 확인!
    print("QueryParams: {'query': $query}");

    final response = await _dio.get('/map-geocode/v2/geocode', queryParameters: {
      'query': query,
    });
    return response.data;
  } on DioException catch (e) {
    print("❌ 에러 상세 내용: ${e.response?.data}"); // 서버가 보내준 구체적인 에러 메시지 확인
    rethrow;
  }
}
}
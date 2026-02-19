import 'package:boxmon/map/model/geocoding_repository.dart';
import 'package:boxmon/map/model/naver_address_model.dart';
import 'package:dio/dio.dart' as dio_lib; // 중복 방지를 위해 별칭 변경 추천


class NaverGeocodingRepository implements GeocodingRepository {
  // 1. 타입을 임포트 별칭에 맞게 dio_lib.Dio로 수정
  final dio_lib.Dio _dio; 

  NaverGeocodingRepository(this._dio);

  @override
  Future<NaverAddressModel> fetchAddressWithKeys({
    required double lat,
    required double lng,
    required String id,
    required String secret,
  }) async {
    // 2. 메서드 호출 시 dio_lib.Options 사용
    final response = await _dio.get(
      'https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc',
      queryParameters: {
        'coords': '$lng,$lat',
        'sourcecrs': 'epsg:4326',
        'output': 'json',
        'orders': 'admcode,legalcode,addr,roadaddr',
        'resulttype' : 'aroundbase'
      },
      options: dio_lib.Options(
        headers: {
          'X-NCP-APIGW-API-KEY-ID': id,
          'X-NCP-APIGW-API-KEY': secret,
        },
      ),
    );

    return NaverAddressModel.fromJson(response.data);
  }

  @override
  Future<NaverAddressModel> fetchAddress(double lat, double lng) async {
    final response = await _dio.get(
      'https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc',
      queryParameters: {
        'coords': '$lng,$lat',
        'sourcecrs': 'epsg:4326',
        'output': 'json',
        'orders': 'admcode,legalcode,addr,roadaddr',
        'resulttype' : 'aroundbase'
      },
    );
    return NaverAddressModel.fromJson(response.data);
  }
}
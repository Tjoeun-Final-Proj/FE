import 'package:boxmon/map/model/location_point.dart';
import 'package:boxmon/map/model/location_route_response.dart';
import 'package:boxmon/map/services/location_service.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

class ShipmentRouteMapController extends GetxController {
  final LocationService _locationService = LocationService();

  final isLoading = true.obs;
  final errorMessage = RxnString();
  final routePoints = <LocationPoint>[].obs;

  int shipmentId = 0;
  double? driverPointX;
  double? driverPointY;
  double? dropoffPointX;
  double? dropoffPointY;

  @override
  void onInit() {
    super.onInit();
    _bindArguments();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    isLoading.value = true;
    errorMessage.value = null;

    if (shipmentId <= 0) {
      errorMessage.value = "유효하지 않은 운송 ID입니다.";
      isLoading.value = false;
      return;
    }

    final LocationRouteResponse? response = await _locationService
        .getShipmentRoute(shipmentId);

    if (response == null) {
      errorMessage.value = "경로 데이터를 불러오지 못했습니다.";
      isLoading.value = false;
      return;
    }

    final points = List<LocationPoint>.from(response.points);
    points.sort((a, b) {
      final ta = DateTime.tryParse(a.at);
      final tb = DateTime.tryParse(b.at);
      if (ta == null || tb == null) return 0;
      return ta.compareTo(tb);
    });

    routePoints.assignAll(points);
    isLoading.value = false;
  }

  void _bindArguments() {
    final args = Get.arguments;
    if (args is! Map) return;

    shipmentId = _toInt(args['shipmentId']) ?? 0;
    driverPointX = _toDouble(args['driverPointX']);
    driverPointY = _toDouble(args['driverPointY']);
    dropoffPointX = _toDouble(args['dropoffPointX']);
    dropoffPointY = _toDouble(args['dropoffPointY']);
  }

  NLatLng? get startLatLng =>
      routePoints.isEmpty ? null : NLatLng(routePoints.first.lat, routePoints.first.lng);

  NLatLng? get endLatLng =>
      routePoints.isEmpty ? null : NLatLng(routePoints.last.lat, routePoints.last.lng);

  NLatLng? get currentDriverLatLng {
    if (driverPointX != null && driverPointY != null) {
      return NLatLng(driverPointY!, driverPointX!);
    }
    return endLatLng;
  }

  NLatLng get initialTarget {
    return currentDriverLatLng ??
        endLatLng ??
        (dropoffPointX != null && dropoffPointY != null
            ? NLatLng(dropoffPointY!, dropoffPointX!)
            : const NLatLng(37.5665, 126.9780));
  }

  List<NLatLng> get polylineCoords =>
      routePoints.map((e) => NLatLng(e.lat, e.lng)).toList();

  Future<void> retry() => _loadRoute();

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  double? _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}


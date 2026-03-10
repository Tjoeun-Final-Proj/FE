import 'package:boxmon/common/controller/shipment_route_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

class ShipmentRouteMapView extends StatelessWidget {
  ShipmentRouteMapView({super.key});

  final ShipmentRouteMapController controller = Get.put(
    ShipmentRouteMapController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "운송 경로 지도",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null) {
          return _ErrorView(
            message: controller.errorMessage.value!,
            onRetry: controller.retry,
          );
        }

        return _RouteMapBody(controller: controller);
      }),
    );
  }
}

class _RouteMapBody extends StatefulWidget {
  const _RouteMapBody({required this.controller});

  final ShipmentRouteMapController controller;

  @override
  State<_RouteMapBody> createState() => _RouteMapBodyState();
}

class _RouteMapBodyState extends State<_RouteMapBody> {
  NaverMapController? _mapController;

  ShipmentRouteMapController get controller => widget.controller;

  @override
  void didUpdateWidget(covariant _RouteMapBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncMap();
  }

  Future<void> _syncMap() async {
    final map = _mapController;
    if (map == null) return;

    final coords = controller.polylineCoords;
    if (coords.length >= 2) {
      final path = NPathOverlay(
        id: 'shipment_route_${controller.shipmentId}',
        coords: coords,
      );
      await map.addOverlay(path);
    }

    final start = controller.startLatLng;
    final end = controller.endLatLng;
    final current = controller.currentDriverLatLng;

    if (start != null) {
      await map.addOverlay(
        NMarker(
          id: 'route_start_${controller.shipmentId}',
          position: start,
          caption: const NOverlayCaption(text: '시작'),
        ),
      );
    }
    if (end != null) {
      await map.addOverlay(
        NMarker(
          id: 'route_end_${controller.shipmentId}',
          position: end,
          caption: const NOverlayCaption(text: '종료'),
        ),
      );
    }
    if (current != null) {
      await map.addOverlay(
        NMarker(
          id: 'route_current_${controller.shipmentId}',
          position: current,
          caption: const NOverlayCaption(text: '기사 현재 위치'),
        ),
      );
    }

    final target = end ?? current ?? start ?? controller.initialTarget;
    await map.updateCamera(
      NCameraUpdate.withParams(
        target: target,
        zoom: coords.length >= 2 ? 13 : 15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasRoute = controller.routePoints.isNotEmpty;

    return Stack(
      children: [
        NaverMap(
          options: NaverMapViewOptions(
            locationButtonEnable: false,
            indoorEnable: false,
            initialCameraPosition: NCameraPosition(
              target: controller.initialTarget,
              zoom: hasRoute ? 13 : 15,
            ),
          ),
          onMapReady: (mapController) {
            _mapController = mapController;
            _syncMap();
          },
        ),
        if (!hasRoute)
          Positioned(
            top: 14,
            left: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xCCFFFFFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "조회된 운송 경로가 없습니다.",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 15, color: Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text("다시 시도"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_states.dart';
import '../../logic/map/map_controller.dart';
import '../../widgets/map/map_widgets.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  final LatLng _initialPosition = const LatLng(1.2136, -77.2811);

  final List<Map<String, dynamic>> _riskZones = [
    {
      'lat': 1.2150,
      'lng': -77.2820,
      'level': 'high',
      'name': 'Parqueadero Norte'
    },
    {'lat': 1.2120, 'lng': -77.2800, 'level': 'medium', 'name': 'Edificio C'},
    {
      'lat': 1.2140,
      'lng': -77.2830,
      'level': 'critical',
      'name': 'Entrada Principal'
    },
    {'lat': 1.2160, 'lng': -77.2790, 'level': 'low', 'name': 'Biblioteca'},
    {'lat': 1.2130, 'lng': -77.2840, 'level': 'high', 'name': 'Cafetería'},
  ];

  final List<Map<String, dynamic>> _nearbyReports = [
    {
      'type': AppStrings.theft,
      'description': 'Robo de celular reportado cerca al Parqueadero Norte.',
      'time': 'hace 20 min',
      'level': 'high',
      'icon': Icons.phone_android_rounded,
    },
    {
      'type': AppStrings.suspicious,
      'description': 'Persona sospechosa merodeando el Edificio C sin carnet.',
      'time': 'hace 45 min',
      'level': 'medium',
      'icon': Icons.person_off_rounded,
    },
    {
      'type': AppStrings.lighting,
      'description': 'Falta de iluminación en la zona de la cafetería.',
      'time': 'hace 1 hora',
      'level': 'low',
      'icon': Icons.light_mode_rounded,
    },
    {
      'type': AppStrings.harassment,
      'description': 'Acoso verbal reportado en la entrada principal.',
      'time': 'hace 2 horas',
      'level': 'high',
      'icon': Icons.warning_rounded,
    },
  ];

  Color _colorForLevel(String level) {
    switch (level) {
      case 'critical':
        return AppColors.riskCritic;
      case 'high':
        return AppColors.riskHigh;
      case 'medium':
        return AppColors.riskMedium;
      case 'low':
      default:
        return AppColors.riskLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapControllerProvider);
    final mapActions = ref.read(mapControllerProvider.notifier);

    const filters = <MapFilterOption>[
      MapFilterOption(
        value: AppStrings.all,
        label: AppStrings.all,
        icon: Icons.layers_rounded,
      ),
      MapFilterOption(
        value: AppStrings.theft,
        label: AppStrings.theft,
        icon: Icons.phone_android_rounded,
      ),
      MapFilterOption(
        value: AppStrings.harassment,
        label: AppStrings.harassment,
        icon: Icons.warning_rounded,
      ),
      MapFilterOption(
        value: AppStrings.lighting,
        label: AppStrings.lighting,
        icon: Icons.light_mode_rounded,
      ),
      MapFilterOption(
        value: AppStrings.suspicious,
        label: AppStrings.suspicious,
        icon: Icons.person_off_rounded,
      ),
    ];

    final filteredReports = mapState.activeFilter == AppStrings.all
        ? _nearbyReports
        : _nearbyReports
            .where((r) => r['type'] == mapState.activeFilter)
            .toList();

    final riskLabel = _riskLabel(mapState.currentRiskLevel);
    final riskColor = _riskColor(mapState.currentRiskLevel);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialPosition,
              initialZoom: 16,
              minZoom: 12,
              maxZoom: 20,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.safecampus.safecampus_ai',
              ),
              CircleLayer(
                circles: _riskZones.map((zone) {
                  final color = _colorForLevel(zone['level']);
                  return CircleMarker(
                    point: LatLng(zone['lat'], zone['lng']),
                    radius: 80,
                    color: color.withValues(alpha: 0.2),
                    borderColor: color.withValues(alpha: 0.5),
                    borderStrokeWidth: 2,
                  );
                }).toList(),
              ),
              MarkerLayer(
                markers: _riskZones.map((zone) {
                  final color = _colorForLevel(zone['level']);
                  return Marker(
                    point: LatLng(zone['lat'], zone['lng']),
                    width: 36,
                    height: 36,
                    child: GestureDetector(
                      onTap: () => _showZoneDetails(zone),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          SafeArea(
            child: Column(
              children: [
                MapTopBar(
                  onSearchTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Buscador en desarrollo')),
                    );
                  },
                  onNotificationsTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notificaciones en desarrollo')),
                    );
                  },
                  activeFilter: mapState.activeFilter,
                  filters: filters,
                  onFilterSelected: mapActions.setFilter,
                ),
                const SizedBox(height: 8),
                CurrentRiskChip(
                  color: riskColor,
                  label: riskLabel,
                ),
                const Spacer(),
                NearbyReportsSheet(
                  sheetController: _sheetController,
                  reports: filteredReports,
                  levelColor: _colorForLevel,
                  onViewOnMap: () => _mapController.move(_initialPosition, 16),
                ),
              ],
            ),
          ),
          MapFloatingButtons(
            bottomOffset: MediaQuery.of(context).size.height * 0.24,
            onCenter: () => _mapController.move(_initialPosition, 16),
            isSosEnabled: mapState.isSosEnabled,
            onToggleSos: () {
              final wasEnabled = mapState.isSosEnabled;
              mapActions.toggleSos();
              if (!wasEnabled) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.crisis_alert_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Expanded(child: Text(AppStrings.sosActivated)),
                      ],
                    ),
                    backgroundColor: AppColors.sosRed,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
  
  void _showZoneDetails(Map<String, dynamic> zone) {
    final color = _colorForLevel(zone['level']);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Icon(Icons.location_on_rounded, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(zone['name'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text('Nivel: ${(zone['level'] as String).toUpperCase()}',
                        style: TextStyle(color: color, fontSize: 13)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: const Text(
                AppStrings.aiZoneWarning,
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Trazando ruta segura...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.route_rounded, size: 20),
                label: const Text(AppStrings.viewSafeRoute,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _riskLabel(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return AppStrings.riskLow;
      case RiskLevel.medium:
        return AppStrings.riskMedium;
      case RiskLevel.high:
        return AppStrings.riskHigh;
      case RiskLevel.critical:
        return AppStrings.riskCritical;
    }
  }

  Color _riskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return AppColors.riskLow;
      case RiskLevel.medium:
        return AppColors.riskMedium;
      case RiskLevel.high:
        return AppColors.riskHigh;
      case RiskLevel.critical:
        return AppColors.riskCritic;
    }
  }
}

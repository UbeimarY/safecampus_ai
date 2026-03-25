import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final MapController _mapController = MapController();
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  // 🔑 Token se carga desde variable de entorno — no hardcodear aquí
  static const String _mapboxToken = String.fromEnvironment(
    'MAPBOX_TOKEN',
    defaultValue: 'TOKEN_NO_CONFIGURADO',
  );
  static const String _mapboxStyle = 'mapbox/dark-v11';

  final LatLng _initialPosition = const LatLng(1.2136, -77.2811);

  final List<Map<String, dynamic>> _zonasRiesgo = [
    {
      'lat': 1.2150,
      'lng': -77.2820,
      'nivel': 'alto',
      'nombre': 'Parqueadero Norte'
    },
    {'lat': 1.2120, 'lng': -77.2800, 'nivel': 'medio', 'nombre': 'Bloque C'},
    {
      'lat': 1.2140,
      'lng': -77.2830,
      'nivel': 'critico',
      'nombre': 'Entrada Principal'
    },
    {'lat': 1.2160, 'lng': -77.2790, 'nivel': 'bajo', 'nombre': 'Biblioteca'},
    {'lat': 1.2130, 'lng': -77.2840, 'nivel': 'alto', 'nombre': 'Cafetería'},
  ];

  final List<Map<String, dynamic>> _reportesCercanos = [
    {
      'tipo': 'Robo',
      'descripcion': 'Robo de celular cerca del parqueadero norte',
      'tiempo': 'Hace 20 min',
      'nivel': 'alto',
      'icon': Icons.phone_android_rounded,
    },
    {
      'tipo': 'Persona sospechosa',
      'descripcion': 'Hombre merodeando el bloque C sin identificación',
      'tiempo': 'Hace 45 min',
      'nivel': 'medio',
      'icon': Icons.person_off_rounded,
    },
    {
      'tipo': 'Iluminación',
      'descripcion': 'Zona sin luz cerca de la cafetería principal',
      'tiempo': 'Hace 1 hora',
      'nivel': 'bajo',
      'icon': Icons.light_mode_rounded,
    },
    {
      'tipo': 'Acoso',
      'descripcion': 'Acoso verbal reportado en la entrada principal',
      'tiempo': 'Hace 2 horas',
      'nivel': 'alto',
      'icon': Icons.warning_rounded,
    },
  ];

  String _nivelRiesgoActual = 'MEDIO';
  bool _sosActivo = false;
  String _filtroActivo = 'Todo';

  Color _colorNivel(String nivel) {
    switch (nivel) {
      case 'critico':
        return AppColors.riskCritic;
      case 'alto':
        return AppColors.riskHigh;
      case 'medio':
        return AppColors.riskMedium;
      default:
        return AppColors.riskLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Mapa principal ──────────────────────────────────────────────
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
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/{style}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                additionalOptions: const {
                  'style': _mapboxStyle,
                  'accessToken': _mapboxToken,
                },
                tileSize: 512,
                zoomOffset: -1,
              ),
              CircleLayer(
                circles: _zonasRiesgo.map((zona) {
                  final color = _colorNivel(zona['nivel']);
                  return CircleMarker(
                    point: LatLng(zona['lat'], zona['lng']),
                    radius: 80,
                    color: color.withValues(alpha: 0.2),
                    borderColor: color.withValues(alpha: 0.5),
                    borderStrokeWidth: 2,
                  );
                }).toList(),
              ),
              MarkerLayer(
                markers: _zonasRiesgo.map((zona) {
                  final color = _colorNivel(zona['nivel']);
                  return Marker(
                    point: LatLng(zona['lat'], zona['lng']),
                    width: 36,
                    height: 36,
                    child: GestureDetector(
                      onTap: () => _mostrarDetalleZona(zona),
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

          // ── UI sobre el mapa ────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 8),
                _buildRiskChip(),
                const Spacer(),
                _buildBottomSheet(),
              ],
            ),
          ),

          // ── Botón SOS + Ubicación ───────────────────────────────────────
          _buildSOSButton(),
        ],
      ),
    );
  }

  // ── Barra superior ────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return FadeInDown(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.97),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.search_rounded,
                              color: AppColors.accent,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¿A dónde vas?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Buscar ruta segura',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 24,
                            color: Colors.white12,
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.tune_rounded,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _buildIconButton(
                  icon: Icons.notifications_rounded,
                  badge: true,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Todo', Icons.layers_rounded),
                  _buildFilterChip('Robos', Icons.phone_android_rounded),
                  _buildFilterChip('Acoso', Icons.warning_rounded),
                  _buildFilterChip('Iluminación', Icons.light_mode_rounded),
                  _buildFilterChip('Sospechosos', Icons.person_off_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    bool badge = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            if (badge)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.riskHigh,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = _filtroActivo == label;
    return GestureDetector(
      onTap: () => setState(() => _filtroActivo = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.2)
              : AppColors.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.accent.withValues(alpha: 0.6)
                : Colors.white12,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.accent : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Chip de riesgo actual ─────────────────────────────────────────────────

  Widget _buildRiskChip() {
    final color = _colorNivel(_nivelRiesgoActual.toLowerCase());
    return FadeInDown(
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.6),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Zona actual: Riesgo $_nivelRiesgoActual',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Panel inferior deslizable ─────────────────────────────────────────────

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.22,
      minChildSize: 0.10,
      maxChildSize: 0.78,
      snap: true,
      snapSizes: const [0.10, 0.22, 0.78],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 24,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 6),
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.riskHigh.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.riskHigh,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reportes Cercanos',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Últimas 24 horas',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.riskHigh.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    AppColors.riskHigh.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              '${_reportesCercanos.length} activos',
                              style: const TextStyle(
                                color: AppColors.riskHigh,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildReporteCard(_reportesCercanos[index]),
                  childCount: _reportesCercanos.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }

  // ── Card de reporte ───────────────────────────────────────────────────────

  Widget _buildReporteCard(Map<String, dynamic> reporte) {
    final color = _colorNivel(reporte['nivel']);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(reporte['icon'], color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reporte['tipo'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: color.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        reporte['nivel'].toUpperCase(),
                        style: TextStyle(
                          color: color,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  reporte['descripcion'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 11,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      reporte['tiempo'],
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Ver en mapa →',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Botón SOS + ubicación ─────────────────────────────────────────────────

  Widget _buildSOSButton() {
    return Positioned(
      right: 16,
      bottom: MediaQuery.of(context).size.height * 0.24,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _mapController.move(_initialPosition, 16),
            child: Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.97),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.my_location_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          GestureDetector(
            onTap: _activarSOS,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _sosActivo ? 68 : 60,
              height: _sosActivo ? 68 : 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sosRed,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sosRed
                        .withValues(alpha: _sosActivo ? 0.8 : 0.5),
                    blurRadius: _sosActivo ? 28 : 16,
                    spreadRadius: _sosActivo ? 8 : 3,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _sosActivo ? Icons.crisis_alert_rounded : Icons.sos_rounded,
                    color: Colors.white,
                    size: _sosActivo ? 28 : 24,
                  ),
                  if (!_sosActivo)
                    const Text(
                      'SOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Métodos ───────────────────────────────────────────────────────────────

  void _activarSOS() {
    setState(() => _sosActivo = !_sosActivo);
    if (_sosActivo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.crisis_alert_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('¡SOS Activado! Compartiendo ubicación...'),
            ],
          ),
          backgroundColor: AppColors.sosRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _mostrarDetalleZona(Map<String, dynamic> zona) {
    final color = _colorNivel(zona['nivel']);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(
                      zona['nombre'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Nivel: ${zona['nivel'].toUpperCase()}',
                      style: TextStyle(color: color, fontSize: 13),
                    ),
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
                'La IA detectó actividad inusual en esta zona. '
                'Se recomienda precaución especialmente en horario nocturno.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.route_rounded, size: 20),
                label: const Text(
                  'Ver ruta segura',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

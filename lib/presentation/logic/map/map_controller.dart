import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_states.dart';

final mapControllerProvider =
    StateNotifierProvider<MapStateController, MapState>((ref) {
  return MapStateController();
});

class MapStateController extends StateNotifier<MapState> {
  MapStateController() : super(const MapState());

  void setFilter(String filter) {
    state = state.copyWith(activeFilter: filter);
  }

  void toggleSos() {
    state = state.copyWith(isSosEnabled: !state.isSosEnabled);
  }

  void setRiskLevel(RiskLevel level) {
    state = state.copyWith(currentRiskLevel: level);
  }
}

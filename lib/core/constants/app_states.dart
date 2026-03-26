enum AsyncStatus {
  idle,
  loading,
  success,
  error,
}

class AuthUiState {
  final AsyncStatus status;
  final String? errorMessage;

  const AuthUiState({
    this.status = AsyncStatus.idle,
    this.errorMessage,
  });

  AuthUiState copyWith({
    AsyncStatus? status,
    String? errorMessage,
  }) {
    return AuthUiState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class OnboardingState {
  final int pageIndex;

  const OnboardingState({
    this.pageIndex = 0,
  });

  OnboardingState copyWith({
    int? pageIndex,
  }) {
    return OnboardingState(
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }
}

enum RiskLevel {
  low,
  medium,
  high,
  critical,
}

class MapState {
  final RiskLevel currentRiskLevel;
  final bool isSosEnabled;
  final String activeFilter;

  const MapState({
    this.currentRiskLevel = RiskLevel.medium,
    this.isSosEnabled = false,
    this.activeFilter = 'All',
  });

  MapState copyWith({
    RiskLevel? currentRiskLevel,
    bool? isSosEnabled,
    String? activeFilter,
  }) {
    return MapState(
      currentRiskLevel: currentRiskLevel ?? this.currentRiskLevel,
      isSosEnabled: isSosEnabled ?? this.isSosEnabled,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

class RegisterState {
  final int stepIndex;
  final bool hasAcceptedTerms;
  final AsyncStatus status;
  final String? errorMessage;

  const RegisterState({
    this.stepIndex = 0,
    this.hasAcceptedTerms = false,
    this.status = AsyncStatus.idle,
    this.errorMessage,
  });

  RegisterState copyWith({
    int? stepIndex,
    bool? hasAcceptedTerms,
    AsyncStatus? status,
    String? errorMessage,
  }) {
    return RegisterState(
      stepIndex: stepIndex ?? this.stepIndex,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

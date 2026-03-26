import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/registro_screen.dart';
import '../../presentation/screens/main_screen.dart';
import '../../presentation/screens/reportes/crear_reporte_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash',         builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/onboarding',     builder: (c, s) => const OnboardingScreen()),
      GoRoute(path: '/login',          builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/registro',       builder: (c, s) => const RegisterScreen()),
      GoRoute(path: '/mapa',           builder: (c, s) => const MainScreen()),
      GoRoute(path: '/crear-reporte',  builder: (c, s) => const CrearReporteScreen()),
    ],
  );
}

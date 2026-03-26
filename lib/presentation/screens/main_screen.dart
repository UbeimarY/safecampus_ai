import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import 'mapa/mapa_screen.dart';
import 'reportes/lista_reportes_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'perfil/perfil_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
{
  int _currentIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.map_rounded, label: AppStrings.navMap),
    _NavItem(icon: Icons.report_rounded, label: AppStrings.navReports),
    _NavItem(icon: Icons.add, label: ''),
    _NavItem(icon: Icons.dashboard_rounded, label: AppStrings.navDashboard),
    _NavItem(icon: Icons.person_rounded, label: AppStrings.navProfile),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      _showReportMenu();
      return;
    }
    setState(() => _currentIndex = index);
  }

  void _showReportMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              AppStrings.whatDoYouWantToDo,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _buildMenuOption(
              icon: Icons.add_alert_rounded,
              label: AppStrings.createReport,
              sublabel: AppStrings.reportIncidentNow,
              color: AppColors.riskHigh,
              onTap: () {
                Navigator.pop(context);
                context.push('/crear-reporte');
              },
            ),
            const SizedBox(height: 12),

            _buildMenuOption(
              icon: Icons.sos_rounded,
              label: AppStrings.sosEmergency,
              sublabel: AppStrings.activateEmergencyAlert,
              color: AppColors.sosRed,
              onTap: () {
                Navigator.pop(context);
                context.push('/sos');
              },
            ),
            const SizedBox(height: 12),

            _buildMenuOption(
              icon: Icons.psychology_rounded,
              label: AppStrings.consultAi,
              sublabel: AppStrings.askAboutSafeZones,
              color: AppColors.accent,
              onTap: () {
                Navigator.pop(context);
                context.push('/chat-ia');
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  sublabel,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded,
                color: color, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex > 2 ? _currentIndex - 1 : _currentIndex,
        children: const [
          MapScreen(),
          ListaReportesScreen(),
          DashboardScreen(),
          PerfilScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(
            top: BorderSide(color: Colors.white12, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                if (index == 2) {
                  // Botón central FAB
                  return _buildFABButton();
                }
                return _buildNavItem(index);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _currentIndex == index;
    final item = _navItems[index];

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                item.icon,
                key: ValueKey(isSelected),
                color: isSelected ? AppColors.accent : AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color: isSelected ? AppColors.accent : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFABButton() {
    return GestureDetector(
      onTap: () => _onTabTapped(2),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.accent, AppColors.primary],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.5),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

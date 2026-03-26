import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class MapFilterOption {
  final String value;
  final String label;
  final IconData icon;

  const MapFilterOption({
    required this.value,
    required this.label,
    required this.icon,
  });
}

class MapTopBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onNotificationsTap;
  final String activeFilter;
  final List<MapFilterOption> filters;
  final ValueChanged<String> onFilterSelected;

  const MapTopBar({
    super.key,
    required this.onSearchTap,
    required this.onNotificationsTap,
    required this.activeFilter,
    required this.filters,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onSearchTap,
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
                                  AppStrings.whereTo,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  AppStrings.searchSafeRoute,
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
                MapIconButton(
                  icon: Icons.notifications_rounded,
                  showBadge: true,
                  onTap: onNotificationsTap,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters
                    .map(
                      (f) => MapFilterChip(
                        label: f.label,
                        icon: f.icon,
                        isSelected: activeFilter == f.value,
                        onTap: () => onFilterSelected(f.value),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapIconButton extends StatelessWidget {
  final IconData icon;
  final bool showBadge;
  final VoidCallback onTap;

  const MapIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
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
            if (showBadge)
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
}

class MapFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const MapFilterChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
}

class CurrentRiskChip extends StatelessWidget {
  final Color color;
  final String label;

  const CurrentRiskChip({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withValues(alpha: 0.5)),
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
              '${AppStrings.currentZoneRisk} $label',
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
}

class NearbyReportsSheet extends StatelessWidget {
  final DraggableScrollableController sheetController;
  final List<Map<String, dynamic>> reports;
  final Color Function(String level) levelColor;
  final VoidCallback onViewOnMap;

  const NearbyReportsSheet({
    super.key,
    required this.sheetController,
    required this.reports,
    required this.levelColor,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: sheetController,
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
                                AppStrings.nearbyReports,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                AppStrings.last24Hours,
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
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.riskHigh.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.riskHigh.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              '${reports.length} ${AppStrings.active}',
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
                  (context, index) => ReportCard(
                    report: reports[index],
                    levelColor: levelColor,
                    onViewOnMap: onViewOnMap,
                  ),
                  childCount: reports.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }
}

class ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  final Color Function(String level) levelColor;
  final VoidCallback onViewOnMap;

  const ReportCard({
    super.key,
    required this.report,
    required this.levelColor,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    final color = levelColor(report['level']);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
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
            child: Icon(report['icon'], color: color, size: 22),
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
                      report['type'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        (report['level'] as String).toUpperCase(),
                        style: TextStyle(
                          color: color,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  report['description'],
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
                      report['time'],
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onViewOnMap,
                      child: const Text(
                        AppStrings.viewOnMap,
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
}

class MapFloatingButtons extends StatelessWidget {
  final double bottomOffset;
  final VoidCallback onCenter;
  final VoidCallback onToggleSos;
  final bool isSosEnabled;

  const MapFloatingButtons({
    super.key,
    required this.bottomOffset,
    required this.onCenter,
    required this.onToggleSos,
    required this.isSosEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: bottomOffset,
      child: Column(
        children: [
          GestureDetector(
            onTap: onCenter,
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
            onTap: onToggleSos,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSosEnabled ? 68 : 60,
              height: isSosEnabled ? 68 : 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sosRed,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sosRed.withValues(
                      alpha: isSosEnabled ? 0.8 : 0.5,
                    ),
                    blurRadius: isSosEnabled ? 28 : 16,
                    spreadRadius: isSosEnabled ? 8 : 3,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSosEnabled
                        ? Icons.crisis_alert_rounded
                        : Icons.sos_rounded,
                    color: Colors.white,
                    size: isSosEnabled ? 28 : 24,
                  ),
                  if (!isSosEnabled)
                    const Text(
                      AppStrings.sos,
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
}

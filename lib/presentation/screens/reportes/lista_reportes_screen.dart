import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ListaReportesScreen extends StatelessWidget {
  const ListaReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Reportes', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.report_rounded, size: 80, color: Colors.white24),
            SizedBox(height: 16),
            Text(
              'Lista de Reportes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
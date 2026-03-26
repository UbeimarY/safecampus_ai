import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class CommunityPlaceholder extends StatelessWidget {
  const CommunityPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.people_alt_rounded,
            size: 80,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.community,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'El feed de la comunidad estará disponible pronto.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Actualizando feed...')),
              );
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Actualizar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white12,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}


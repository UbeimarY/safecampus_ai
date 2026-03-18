import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Hive (BD local)
  await Hive.initFlutter();

  runApp(
    const ProviderScope(
      child: SafeCampusApp(),
    ),
  );
}

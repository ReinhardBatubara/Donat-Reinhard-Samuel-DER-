import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale Bahasa Indonesia untuk format tanggal
  await initializeDateFormatting('id_ID', null);

  runApp(
    // ProviderScope diperlukan untuk Riverpod
    const ProviderScope(
      child: DRSApp(),
    ),
  );
}

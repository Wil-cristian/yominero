import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  SupabaseService._privateConstructor();
  static final SupabaseService instance = SupabaseService._privateConstructor();

  late final SupabaseClient client;

  Future<void> init() async {
    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (url == null || anonKey == null || anonKey.contains('<your')) {
      throw Exception('SUPABASE_URL and SUPABASE_ANON_KEY must be set in .env');
    }

    // Initialize with a built-in timeout to avoid long blocking during app start.
    try {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
      ).timeout(const Duration(seconds: 8));
    } on Exception {
      // rethrow so callers can decide how to proceed
      rethrow;
    }

    client = Supabase.instance.client;
  }
}

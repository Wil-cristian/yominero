import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yominero/core/auth/supabase_service.dart';

Future<void> main() async {
  // Load .env from project root
  await dotenv.load();

  try {
    await SupabaseService.instance.init();
    print('Supabase initialized successfully.');
  } catch (e) {
    print('Supabase init failed: $e');
  }
}

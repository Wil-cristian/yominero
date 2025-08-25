import 'dart:io';
import 'dart:convert';

Map<String, String> _loadEnv(File file) {
  final map = <String, String>{};
  final lines = file.readAsLinesSync();
  for (var line in lines) {
    line = line.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final idx = line.indexOf('=');
    if (idx <= 0) continue;
    final key = line.substring(0, idx).trim();
    final value = line.substring(idx + 1).trim();
    map[key] = value;
  }
  return map;
}

Future<void> main(List<String> args) async {
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    print('.env not found in project root');
    return;
  }

  final env = _loadEnv(envFile);
  final url = env['SUPABASE_URL'];

  // Resolve anon key: CLI arg > TEST_ANON env var > .env
  final anonFromArg = args.isNotEmpty ? args[0] : null;
  final tableFromArg = args.length > 1 ? args[1] : null;
  final anon = anonFromArg ??
      Platform.environment['TEST_ANON'] ??
      env['SUPABASE_ANON_KEY'];

  if (url == null) {
    print('SUPABASE_URL missing in .env');
    return;
  }

  if (anon == null || anon.contains('<your')) {
    print(
        'SUPABASE_ANON_KEY missing. Provide it as the first CLI argument, or set TEST_ANON env var, or put it in .env.');
    print('Usage examples:');
    print('  dart tool/test_supabase_dart.dart <ANON_KEY> [table]');
    print(
        "  # or set env vars: $env:TEST_ANON='your_key' ; dart tool/test_supabase_dart.dart [table]");
    return;
  }

  final table =
      tableFromArg ?? Platform.environment['TEST_TABLE'] ?? 'products';
  final base = url.endsWith('/') ? '${url}rest/v1' : '$url/rest/v1';
  final uri = Uri.parse('$base/$table');
  final client = HttpClient();
  try {
    final request = await client.getUrl(uri);
    request.headers.set('apikey', anon);
    request.headers.set('Authorization', 'Bearer $anon');
    final response = await request.close();
    print('HTTP ${response.statusCode} ${response.reasonPhrase}');
    final body = await response.transform(utf8.decoder).join();
    print(
        'Response body (first 400 chars): ${body.length > 400 ? body.substring(0, 400) : body}');
  } catch (e) {
    print('HTTP request failed: $e');
  } finally {
    client.close(force: true);
  }
}

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  getApiHost(String key) {
    return dotenv.env['API_HOST'] ?? '';
  }
}

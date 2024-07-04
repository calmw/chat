import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  key(String key) {
    return dotenv.env[key] ?? '';
  }
}

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  get(String key) {
    return dotenv.env[key] ?? '';
  }
}

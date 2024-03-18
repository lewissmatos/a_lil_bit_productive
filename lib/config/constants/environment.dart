import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String pexelsApiKey = dotenv.env['PEXELS_API_KEY'] ?? '';
}

import 'dart:developer';
import 'package:flutter/foundation.dart';

import 'package:appwrite/appwrite.dart';

import '../helper/global.dart';

class AppWrite {
  static final _client = Client();
  static final _database = Databases(_client);
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;

    try {
      _client
          .setEndpoint('https://cloud.appwrite.io/v1')
          .setProject('658813fd62bd45e744cd')
          .setSelfSigned(status: true);

      _initialized = true;

      // Don't attempt to fetch API key on web during initialization
      // as it may cause initialization errors
      if (!kIsWeb) {
        getApiKey();
      }
    } catch (e) {
      log('AppWrite init error: $e');
      // Set a fallback API key for testing
      if (apiKey.isEmpty) {
        // You should replace this with your own API key for production
        apiKey = '';
      }
    }
  }

  static Future<String> getApiKey() async {
    if (apiKey.isNotEmpty) return apiKey;

    try {
      final d = await _database.getDocument(
          databaseId: 'MyDatabase',
          collectionId: 'ApiKey',
          documentId: 'chatGptKey');

      apiKey = d.data['apiKey'];
      log('API Key retrieved: ${apiKey.isNotEmpty}');
      return apiKey;
    } catch (e) {
      log('AppWrite getApiKey error: $e');

      // Set a fallback API key for testing
      // For security, don't hardcode a real API key here
      apiKey = '';
      return apiKey;
    }
  }
}

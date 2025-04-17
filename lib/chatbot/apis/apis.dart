import 'dart:convert';
import 'dart:developer';
// import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart';
import 'package:translator_plus/translator_plus.dart';

import '../helper/global.dart';

class APIs {
  //get answer from google gemini ai
  static Future<String> getAnswer(String question) async {
    try {
      log('Using API key: ${apiKey.isEmpty ? "No API key found" : "API key available"}');

      if (apiKey.isEmpty) {
        return "Please add your Gemini API key in the lib/helper/global.dart file to use the AI chat feature. Get your API key from https://aistudio.google.com/app/apikey";
      }

      final model = GenerativeModel(
        // Use a more stable model version
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );

      final content = [Content.text(question)];
      final res = await model.generateContent(content, safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      ]);

      if (res.text == null || res.text!.isEmpty) {
        return "No response received from Gemini. Please try again.";
      }

      log('res: ${res.text}');
      return res.text!;
    } catch (e) {
      log('getAnswerGeminiE: $e');
      if (e.toString().contains('API key')) {
        return 'Invalid API key. Please add a valid Gemini API key in lib/helper/global.dart.';
      }
      return 'Something went wrong with Gemini AI. Error: $e';
    }
  }

  //get answer from chat gpt
  // static Future<String> getAnswer(String question) async {
  //   try {
  //     log('api key: $apiKey');

  //     //
  //     final res =
  //         await post(Uri.parse('https://api.openai.com/v1/chat/completions'),

  //             //headers
  //             headers: {
  //               HttpHeaders.contentTypeHeader: 'application/json',
  //               HttpHeaders.authorizationHeader: 'Bearer $apiKey'
  //             },

  //             //body
  //             body: jsonEncode({
  //               "model": "gpt-3.5-turbo",
  //               "max_tokens": 2000,
  //               "temperature": 0,
  //               "messages": [
  //                 {"role": "user", "content": question},
  //               ]
  //             }));

  //     final data = jsonDecode(res.body);

  //     log('res: $data');
  //     return data['choices'][0]['message']['content'];
  //   } catch (e) {
  //     log('getAnswerGptE: $e');
  //     return 'Something went wrong (Try again in sometime)';
  //   }
  // }

  static Future<List<String>> searchAiImages(String prompt) async {
    try {
      if (prompt.isEmpty) {
        return [];
      }

      // Use a different, more reliable API
      final encodedPrompt = Uri.encodeComponent(prompt);

      // Pexels API is reliable and provides direct image URLs
      final res = await get(
          Uri.parse(
              'https://api.pexels.com/v1/search?query=$encodedPrompt&per_page=10'),
          headers: {
            'Authorization':
                'MWlIJxmpe9UQprXbipQx07KpCcvHnqzGYOoGSXiWzMqcjVuOR8AXtCll' // Demo key for testing
          });

      log('Image API response status: ${res.statusCode}');

      if (res.statusCode != 200) {
        log('Image search error: ${res.statusCode} - ${res.body}');

        // Fallback to placeholder images if API doesn't work
        return [
          'https://picsum.photos/seed/${prompt.hashCode}/500/500',
          'https://picsum.photos/seed/${prompt.hashCode + 1}/500/500',
          'https://picsum.photos/seed/${prompt.hashCode + 2}/500/500',
          'https://picsum.photos/seed/${prompt.hashCode + 3}/500/500',
          'https://picsum.photos/seed/${prompt.hashCode + 4}/500/500',
        ];
      }

      final data = jsonDecode(res.body);

      if (data == null ||
          !data.containsKey('photos') ||
          data['photos'] == null ||
          data['photos'].isEmpty) {
        log('Invalid response format or no images found');

        // Fallback to placeholder images
        return [
          'https://picsum.photos/seed/${prompt.hashCode}/500/500',
          'https://picsum.photos/seed/${prompt.hashCode + 1}/500/500',
          'https://picsum.photos/seed/${prompt.hashCode + 2}/500/500',
          'https://picsum.photos/seed/${prompt.hashCode + 3}/500/500',
          'https://picsum.photos/seed/${prompt.hashCode + 4}/500/500',
        ];
      }

      // Extract image URLs
      final List<String> imageUrls = [];
      for (var photo in data['photos']) {
        if (photo['src'] != null && photo['src']['medium'] != null) {
          imageUrls.add(photo['src']['medium']);
        }
      }

      log('Found ${imageUrls.length} images from API');

      // If no images found, return placeholder images
      if (imageUrls.isEmpty) {
        return [
          'https://picsum.photos/seed/${prompt.hashCode}/500/500',
          'https://picsum.photos/seed/${prompt.hashCode + 1}/500/500',
          'https://picsum.photos/seed/${prompt.hashCode + 2}/500/500',
          'https://picsum.photos/seed/${prompt.hashCode + 3}/500/500',
          'https://picsum.photos/seed/${prompt.hashCode + 4}/500/500',
        ];
      }

      return imageUrls;
    } catch (e) {
      log('searchAiImagesE: $e');

      // Fallback to picsum.photos as a last resort
      return [
        'https://picsum.photos/seed/${prompt.hashCode}/500/500',
        'https://picsum.photos/seed/${prompt.hashCode + 1}/500/500',
        'https://picsum.photos/seed/${prompt.hashCode + 2}/500/500',
        'https://picsum.photos/seed/${prompt.hashCode + 3}/500/500',
        'https://picsum.photos/seed/${prompt.hashCode + 4}/500/500',
      ];
    }
  }

  static Future<String> googleTranslate(
      {required String from, required String to, required String text}) async {
    try {
      if (text.isEmpty) {
        return '';
      }

      final res = await GoogleTranslator().translate(text, from: from, to: to);
      return res.text;
    } catch (e) {
      log('googleTranslateE: $e ');
      return 'Translation error: $e';
    }
  }
}

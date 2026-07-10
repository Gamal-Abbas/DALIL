import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/guide_place_model.dart';

abstract class GuideRemoteDataSource {
  Future<List<GuidePlaceModel>> getAllPlaces();
  Future<String> generateGuide(String prompt);
}

class GuideRemoteDataSourceImpl implements GuideRemoteDataSource {
  final FirebaseFirestore firestore;

  GuideRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<GuidePlaceModel>> getAllPlaces() async {
    try {
      final snapshot = await firestore.collection('places').get();
      final places = snapshot.docs
          .map((doc) => GuidePlaceModel.fromFirestore(doc))
          .toList();
      return places;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch places: $e');
    }
  }

  @override
  Future<String> generateGuide(String prompt) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      
      if (apiKey == null || apiKey.trim().isEmpty) {
        throw Exception('Gemini API Key not found.');
      }

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      final content = [Content.text(prompt)];
      
      // Use timeout for the Gemini request
      final response = await model.generateContent(content).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw Exception('Gemini API request timed out after 20 seconds.');
        },
      );

      final generatedText = response.text;
      
      if (generatedText == null || generatedText.trim().isEmpty) {
        throw Exception('Received empty response from Gemini.');
      }

      return generatedText.trim();
    } catch (e) {
      throw Exception('Failed to generate guide: $e');
    }
  }
}

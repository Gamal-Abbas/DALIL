// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/place_model.dart';

// class BookingsService {
//   static const String key = "bookings";

//   Future<void> addBooking(PlaceModel place) async {
//     final prefs = await SharedPreferences.getInstance();

//     final list = prefs.getStringList(key) ?? [];

//     list.add(jsonEncode({
//       "id": place.id,
//       "name": place.name,
//       "description": place.description,
//       "image": place.image,
//     }));

//     await prefs.setStringList(key, list);
//   }

//   Future<List<PlaceModel>> getBookings() async {
//     final prefs = await SharedPreferences.getInstance();
//     final list = prefs.getStringList(key) ?? [];

//     return list.map((e) {
//       final data = jsonDecode(e);
//       return PlaceModel(
//         id: data["id"],
//         name: Map<String, dynamic>.from(data["name"]),
//         description: Map<String, dynamic>.from(data["description"]),
//         image: data["image"],
//       );
//     }).toList();
//   }
// }
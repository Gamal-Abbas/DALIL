// import 'package:flutter/material.dart';
// import '../../core/services/bookings_service.dart';
// import '../../core/widget/place_card.dart';
// import '../../core/models/place_model.dart';

// class BookingsScreen extends StatefulWidget {
//   const BookingsScreen({super.key});

//   @override
//   State<BookingsScreen> createState() => _BookingsScreenState();
// }

// class _BookingsScreenState extends State<BookingsScreen> {
//   final service = BookingsService();
//   List<PlaceModel> bookings = [];

//   @override
//   void initState() {
//     super.initState();
//     loadBookings();
//   }

//   void loadBookings() async {
//     final data = await service.getBookings();
//     setState(() {
//       bookings = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final lang = Localizations.localeOf(context).languageCode;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Bookings"),
//       ),
//       body: bookings.isEmpty
//           ? const Center(child: Text("No bookings yet"))
//           : ListView.builder(
//               itemCount: bookings.length,
//               itemBuilder: (context, index) {
//                 final item = bookings[index];

//                 return Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: PlaceCard(
//                     title: item.getName(lang),
//                     subtitle: item.getDescription(lang),
//                     image: item.image,
//                     onTap: () {},
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
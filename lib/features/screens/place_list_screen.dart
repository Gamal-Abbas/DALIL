import 'package:flutter/material.dart';
import 'package:dalil/core/models/place_model.dart';
import 'package:dalil/core/widget/place_card.dart';
import 'package:dalil/core/services/firestore_service.dart';

class PlaceListScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String collection;
  final String lang;
  final FirestoreService service = FirestoreService();

  PlaceListScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.collection,
    required this.lang,
  });

  int _crossAxisCount(double width) {
    if (width >= 1100) return 4;
    if (width >= 800) return 3;
    if (width >= 550) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = _crossAxisCount(width);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E2D),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFE5C158)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFE5C158)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFE5C158),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pyram.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.6),
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: StreamBuilder<List<PlaceModel>>(
              stream: service.getPlaces(collection),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, color: Colors.white70),
                        SizedBox(height: 10),
                        Text(
                          "No Internet or weak connection",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(
                    child: Text(
                      "لا توجد نتائج",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                    vertical: width * 0.04,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: width * 0.03,
                    mainAxisSpacing: width * 0.03,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return PlaceCard(
                      title: item.getName(lang),
                      subtitle: item.getDescription(lang),
                      image: item.image,
                      onTap: () {},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:dalil/generated/l10n.dart';
import 'package:dalil/core/models/place_model.dart';
import 'package:dalil/core/widget/place_card.dart';

import '../../features/screens/place_list_screen.dart';

class HomeSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String collection;
  final Stream<List<PlaceModel>> stream;
  final String lang;
  final String searchQuery;

  const HomeSection({
    super.key,
    required this.title,
    required this.icon,
    required this.collection,
    required this.stream,
    required this.lang,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final loc = S.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFFE5C158)),
                SizedBox(width: width * 0.02),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFFE5C158),
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceListScreen(
                          title: title,
                          icon: icon,
                          collection: collection,
                          lang: lang,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        loc.seeMore,
                        style: TextStyle(color: Colors.white70, fontSize: width * 0.035),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white70),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: width * 0.04),
          SizedBox(
            height: width * 0.6,
            child: StreamBuilder<List<PlaceModel>>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, color: Colors.white70),
                      SizedBox(height: 10),
                      Text(
                        "No Internet or weak connection",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  );
                }

                var data = snapshot.data ?? [];

                if (searchQuery.isNotEmpty) {
                  data = data
                      .where((item) =>
                          item.getName(lang).toLowerCase().contains(searchQuery.toLowerCase()))
                      .toList();
                }

                if (data.isEmpty) {
                  return const Center(
                    child: Text("لا توجد نتائج", style: TextStyle(color: Colors.white54)),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
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
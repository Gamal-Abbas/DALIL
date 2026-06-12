import 'package:dalil/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:dalil/core/services/firestore_service.dart';
import 'package:dalil/core/models/place_model.dart';
import '../../core/widget/place_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final service = FirestoreService();
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E2D),
        elevation: 0,
        title: Text(
          loc.dalil,
          style: const TextStyle(
            color: Color(0xFFE5C158),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: RefreshIndicator(
              color: const Color(0xFFE5C158),
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 800));
              },
              child: ListView(
                children: [
                  SizedBox(height: width * 0.05),
                  _buildHeader(context),

                  _buildSection(
                    context: context,
                    title: loc.attractions,
                    icon: Icons.account_balance,
                    collection: "attractions",
                    stream: service.getPlaces("attractions"),
                    lang: lang,
                  ),

                  _buildSection(
                    context: context,
                    title: loc.kings,
                    icon: Icons.workspace_premium,
                    collection: "kings",
                    stream: service.getPlaces("kings"),
                    lang: lang,
                  ),

                  _buildSection(
                    context: context,
                    title: loc.eras,
                    icon: Icons.history,
                    collection: "eras",
                    stream: service.getPlaces("eras"),
                    lang: lang,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final loc = S.of(context);
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        children: [
          Text(
            loc.welcome,
            style: TextStyle(
              color: Colors.white70,
              fontSize: width * 0.04,
            ),
          ),
          SizedBox(height: width * 0.02),
          Text(
            loc.historyAwaits,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFE5C158),
              fontSize: width * 0.07,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: width * 0.03),
          Text(
            loc.homeDesc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: width * 0.035,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String collection,
    required Stream<List<PlaceModel>> stream,
    required String lang,
  }) {
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
                Row(
                  children: [
                    Text(
                      loc.seeMore,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: width * 0.035,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.white70,
                    ),
                  ],
                )
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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

                final data = snapshot.data ?? [];

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
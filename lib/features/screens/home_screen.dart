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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E2D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          loc.dalil,
          style: TextStyle(
            color: Color(0xFFE5C158),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
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
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(context),
                  _buildSection(
                    title: loc.attractions,
                    stream: service.getPlaces("attractions"),
                    lang: lang,
                  ),
                  _buildSection(
                    title: loc.kings,
                    stream: service.getPlaces("kings"),
                    lang: lang,
                  ),
                  _buildSection(
                    title: loc.eras,
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Text(
              loc.welcome,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 5),
            Text(
              loc.historyAwaits,
              style: const TextStyle(
                color: Color(0xFFE5C158),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              loc.homeDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Stream<List<PlaceModel>> stream,
    required String lang,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFE5C158),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 250,
            child: StreamBuilder<List<PlaceModel>>(
              stream: stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data = snapshot.data!;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    return PlaceCard(
                      title: item.getName(lang),
                      subtitle: item.getDescription(lang),
                      image: item.image,
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => DetailsScreen(
                        //       id: item.id,
                        //     ),
                        //   ),
                        // );
                      },
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
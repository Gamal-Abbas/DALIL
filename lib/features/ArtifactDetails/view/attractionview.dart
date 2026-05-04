import 'package:dalil/core/utils/size.dart';
import 'package:dalil/features/ArtifactDetails/data/model/attrctionModel.dart';
import 'package:dalil/features/ArtifactDetails/data/model/eraModel.dart';
import 'package:dalil/features/ArtifactDetails/view/baseLayout.dart';
import 'package:dalil/features/ArtifactDetails/widgets/buildStateBar.dart';
import 'package:dalil/features/ArtifactDetails/widgets/mainContentCard.dart';
import 'package:dalil/features/ArtifactDetails/widgets/sectionTitle.dart';
import 'package:dalil/notifications/notifications2/firebaseManager.dart';
import 'package:flutter/material.dart';

class AttractionUI extends StatefulWidget {
  final AttractionModel data;

  const AttractionUI({super.key, required this.data});

  @override
  State<AttractionUI> createState() => _AttractionUIState();
}

class _AttractionUIState extends State<AttractionUI> {
  late Future<Map<String, dynamic>?> _dataFuture;

  @override
  void initState() {
    super.initState();

    _dataFuture = FireBaseManager.getSpecificData(
      id: widget.data.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _dataFuture,
      builder: (context, snapshot) {
        print('future build================');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Color(0xFFFFD700))),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return _buildBaseLayout(null, []);
        }

        final rawData = snapshot.data!;

        Map<String, dynamic> rawEraData = rawData.containsKey('IraInfos') && rawData['IraInfos'] != null
            ? rawData['IraInfos']
            : rawData;

        final eraModel = EraModel.fromJson(rawEraData);
        final List<String> relatedNames = List<String>.from(rawData['relatedItems'] ?? []);

        return _buildBaseLayout(eraModel, relatedNames);
      },
    );
  }

  Widget _buildBaseLayout(EraModel? eraInfo, List<String> relatedNames) {
    if (eraInfo == null) {
      return const Scaffold(body: Center(child: Text("Error loading data", style: TextStyle(color: Colors.white))));
    }

    const Color pharaohGold = Color(0xFFFFD700);
print('build============');
    // final size = MediaQuery.of(context).size;
    // final height = size.height;
    // final width = size.width;
    return BaseLayout(
      title: widget.data.name,
      image: widget.data.image,
      child: Column(
        spacing: (context.screenHeight/50).clamp(15, 20),    //15
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(eraInfo.name),
          // const SizedBox(height: 12),
          Text(
            widget.data.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: (context.screenHeight/20).clamp(40, 46),   //40
              height: (context.screenHeight/700).clamp(1.1, 1.3), //1.1
              fontWeight: FontWeight.w900,
            ),
          ),
          // const SizedBox(height: 20),
          BuildStateBar(eraInfo: eraInfo, gold: pharaohGold),
          // const Gap(15),
          MainContentCard(
            description: widget.data.description,
            eraInfo: eraInfo,
            related: relatedNames,
            gold: pharaohGold,
          ),
        ],
      ),
    );
  }
}
import 'package:dalil/features/ArtifactDetails/data/model/eraModel.dart';
import 'package:dalil/features/ArtifactDetails/data/model/kingModel.dart';
import 'package:dalil/features/ArtifactDetails/view/baseLayout.dart';
import 'package:dalil/features/ArtifactDetails/widgets/buildStateBar.dart';
import 'package:dalil/features/ArtifactDetails/widgets/mainContentCard.dart';
import 'package:dalil/features/ArtifactDetails/widgets/sectionTitle.dart';
import 'package:dalil/notifications/notifications2/firebaseManager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class KingUI extends StatefulWidget {
  final KingModel data;

  const KingUI({super.key, required this.data});

  @override
  State<KingUI> createState() => _KingUIState();
}

class _KingUIState extends State<KingUI> {
  // 1. تخزين الـ Future لضمان تنفيذ الطلب مرة واحدة فقط عند فتح الشاشة
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFFD700)),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return _buildBaseLayout(null, []);
        }

        final rawData = snapshot.data!;

        Map<String, dynamic> rawEraData =
            rawData.containsKey('IraInfos') && rawData['IraInfos'] != null
            ? rawData['IraInfos']
            : rawData;

        final eraModel = EraModel.fromJson(rawEraData);

        List<String> relatedNames = List<String>.from(
          rawData['relatedItems'] ?? [],
        );

        return _buildBaseLayout(eraModel, relatedNames);
      },
    );
  }

  Widget _buildBaseLayout(EraModel? eraInfo, List<String> relatedNames) {
    if (eraInfo == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Error loading data",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    const Color pharaohGold = Color(0xFFFFD700);
    final size=MediaQuery.of(context).size;
    final height=size.height;
    final width=size.width;
    return BaseLayout(
      title: widget.data.name,
      image: widget.data.image,
      child: Column(
        spacing: (height/36).clamp(15, 22), //15
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(eraInfo.name),

          Text(
            widget.data.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: (height/20).clamp(40, 46),   //40
              height: (height/700).clamp(1.1, 1.3), //1.1
              fontWeight: FontWeight.w900,
            ),
          ),

          BuildStateBar(eraInfo: eraInfo, gold: pharaohGold),

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

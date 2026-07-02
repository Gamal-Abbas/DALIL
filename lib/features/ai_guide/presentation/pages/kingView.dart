
import 'package:depi_dalil/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/utils/size.dart';
import '../../../notifications/data/datasources/firebase_service.dart';
import '../../data/models/eraModel.dart';
import '../../data/models/kingModel.dart';
import '../widgets/buildStateBar.dart';
import '../widgets/mainContentCard.dart';
import '../widgets/sectionTitle.dart';
import 'baseLayout.dart';

class KingUI extends StatefulWidget {
  final KingModel data;

  const KingUI({super.key, required this.data});

  @override
  State<KingUI> createState() => _KingUIState();
}

class _KingUIState extends State<KingUI> {
  late Future<Map<String, dynamic>?> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = FirebaseService.getDataFromFirebase_By_Id(id: widget.data.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Scaffold(
            backgroundColor: context.scaffoldBg,
            body: Center(
              child: CircularProgressIndicator(color: context.primary),
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
      return  Scaffold(
        backgroundColor: context.scaffoldBg,
        body: Center(
          child: Text(
            "Error loading data",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final height = context.screenHeight;

    return BaseLayout(
      title: widget.data.name,
      image: widget.data.image,
      child: Column(
        spacing: (height / 36).clamp(15, 22), //15
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(eraInfo.name),

          Text(
            widget.data.name,
            style: TextStyle(
              color: context.primary,
              fontSize: (height / 20).clamp(40, 46), //40
              height: (height / 700).clamp(1.1, 1.3), //1.1
              fontWeight: FontWeight.w900,
            ),
          ),

          BuildStateBar(eraInfo: eraInfo, gold: context.primary),

          MainContentCard(
            description: widget.data.description,
            eraInfo: eraInfo,
            related: relatedNames,
            gold: context.primary,
          ),
        ],
      ),
    );
  }
}

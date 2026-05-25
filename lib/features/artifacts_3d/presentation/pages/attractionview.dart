
import 'package:depi_dalil/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/utils/size.dart';
import '../../../notifications/domain/usecases/firebase_service.dart';
import '../../data/models/attrctionModel.dart';
import '../../data/models/eraModel.dart';
import '../widgets/buildStateBar.dart';
import '../widgets/mainContentCard.dart';
import '../widgets/sectionTitle.dart';
import 'baseLayout.dart';

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

    _dataFuture = FirebaseService.getDataFromFirebase_By_Id(id: widget.data.id);
  }

  late double screenHeight_divise_50;
  late double screenHeight_divise_20;
  late double screenHeight_divise_700;

  @override
  void didChangeDependencies() {
    screenHeight_divise_50 = (context.screenHeight / 50).clamp(15, 20);
    screenHeight_divise_20 = (context.screenHeight / 20).clamp(40, 46);
    screenHeight_divise_700 = (context.screenHeight / 700).clamp(1.1, 1.3);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
        final List<String> relatedNames = List<String>.from(
          rawData['relatedItems'] ?? [],
        );

        return _buildBaseLayout(eraModel, relatedNames);
      },
    );
  }

  Widget _buildBaseLayout(EraModel? eraInfo, List<String> relatedNames) {
    if (eraInfo == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Error loading data",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    print('build============');

    return BaseLayout(
      title: widget.data.name,
      image: widget.data.image,
      child: Column(
        spacing: screenHeight_divise_50, //15
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(eraInfo.name),
          // const SizedBox(height: 12),
          Text(
            widget.data.name,
            style: TextStyle(
              color:context.secondary,
              fontSize: screenHeight_divise_20, //40
              height: screenHeight_divise_700, //1.1
              fontWeight: FontWeight.w900,
            ),
          ),
          // const SizedBox(height: 20),
          BuildStateBar(eraInfo: eraInfo, gold: context.primary),
          // const Gap(15),
          MainContentCard(
            description: widget.data.description,
            eraInfo: eraInfo,
            related: relatedNames,
            gold: context.secondary,
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';


import 'package:flutter/material.dart';

import '../../../../core/utils/size.dart';
import '../../data/models/attrctionModel.dart';
import '../../data/models/baseModel.dart';
import '../../data/models/eraModel.dart';
import '../../data/models/kingModel.dart';
import 'attractionview.dart';
import 'eraView.dart';
import 'kingView.dart';

class ArtifactDetailsScreen extends StatelessWidget {
  final BaseModel data;

  const ArtifactDetailsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    try {
      final String name = data.collectionType.toLowerCase();

      if (name.contains('era')) {
        // final model = EraModel.fromJson(data.toJson());
        // print('Success! Years are: ${(model as EraModel).startYear}');
        return EraUI(
          data: data as EraModel,
          height: context.screenHeight,
          width: context.screenWidth,
        );
      } else if (name.contains("king")) {
        final model = KingModel.fromJson(data.toJson());

        return KingUI(data: model);
      } else if (name.contains("attraction")) {
        final model = AttractionModel.fromJson(data.toJson());
        print('Dispatcher============');
        print(model.relatedKings);
        print(model.name);
        return AttractionUI(data: model);
      } else {
        return const Scaffold(body: Center(child: Text("نوع غير معروف")));
      }
    } catch (e) {
      print(e.toString());
      return Text('Errror');
    }
  }
}

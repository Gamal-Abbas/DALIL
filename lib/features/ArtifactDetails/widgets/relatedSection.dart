import 'package:dalil/features/ArtifactDetails/data/class/replaceIdwithName.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RelatedSection extends StatelessWidget {
  final List ids;

  const RelatedSection(this.ids);

  @override
  Widget build(BuildContext context) {

    final height=MediaQuery.of(context).size.height;
    return FutureBuilder<List<String>>(
      future: ReplaceIdWithName.loadNames(ids),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return  Text("Loading...".tr(), style: TextStyle(color: Colors.white54));
        }

        return Wrap(
          spacing: (height/100).clamp(8, 9.5),//8
          children: snapshot.data!
              .map((e) => Chip(
            label: Text(e),
            backgroundColor: Colors.amber,
          ))
              .toList(),
        );
      },
    );
  }
}
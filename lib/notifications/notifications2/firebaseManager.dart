import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalil/core/constants/cash.dart';
import 'package:dalil/notifications/notifications2/notificationManager.dart';
import 'package:easy_localization/easy_localization.dart';

class FireBaseManager {
  static Future<void> retrieveDataFromFirebase() async {
    try {
      String lang = cash.getLang();

      List<String> collections = ['kings', 'attractions', 'eras'];
      String randomCollection =
          collections[Random().nextInt(collections.length)];

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(randomCollection)
          .get();

      if (snapshot.docs.isEmpty) return;

      var randomDoc = snapshot.docs[Random().nextInt(snapshot.docs.length)];

      String docId = randomDoc.id;
      Map<String, dynamic> data = randomDoc.data() as Map<String, dynamic>;

      String name = data['name'][lang] ?? data['name']['en'];

      String title = "dalil".tr();
      String body = name;

      print('Id in daily Notifi==============');
      print(docId);
      print(randomCollection);
      print('type in daily Notifi==============');

      final String simplePayload = "$docId|$randomCollection";
      final payload = {"id": docId, "type": randomCollection};
      print(payload);

      await NotificationManager.startDailyscheduled(
        title: title,
        body: body,
        payload: simplePayload,
        lang: lang,
      );
    } catch (e) {
      print('Error in retrieveDataFromFirebase ================');
      print(e.toString());
    }
  }

  static String getCurrentLang() {
    try {
      return Intl.getCurrentLocale().split('_')[0];
    } catch (e) {
      return 'ar';
    }
  }

  static Future<Map<String, dynamic>?> getSpecificData({
    required String id,
  }) async {
    try {
      String lang = cash.getLang();

      print('Final Lang from Cash: $lang');

      if (lang != 'ar' && lang != 'en') lang = 'ar';
      // print('get Sepcific data start ==============');
      // print(id);

      String collection;
      if (id.startsWith('attraction')) {
        collection = 'attractions';
      } else if (id.startsWith('king')) {
        collection = 'kings';
      } else {
        collection = 'eras';
      }
      // print('Collection=$collection');

      var doc = await FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .get();
      // print(doc);
      // print(doc.data());
      if (!doc.exists) return null;

      var data = doc.data()!;
      // print('Secific Data   data variable===========');
      // print(data);
      // print(doc.id);

      if (collection == 'eras') {
        return {
          "collectionType": "eras",
          "id": doc.id,
          "name": data['name']?[lang] ?? data['name']?['ar'],
          "image": data['image'],
          "description":
              data['description']?[lang] ?? data['description']?['ar'],
          "startYear": data['startYear'],
          "endYear": data['endYear'],
        };
      }

      String relatedKey = collection == 'kings'
          ? 'relatedAttractions'
          : 'relatedKings';

      String? eraId = data['eraId'];
      // print('ira Id in get specific data is ==================');
      // print(eraId);
      Map<String, dynamic>? eraData;

      if (eraId != null) {
        var eraDoc = await FirebaseFirestore.instance
            .collection('eras')
            .doc(eraId)
            .get();

        eraData = eraDoc.data();
        // print('ira Id in get specific data is ==================');
        // print(eraId);
        // print(eraData);
      }
      // print('Secific Data   data variable===========');
      // print(eraData);

      List<String> relatedNames = [];

      if (data.containsKey(relatedKey) && data[relatedKey] != null) {
        // print('before fetch name from key =======');
        // print(data[relatedKey]);
        relatedNames = await fetchRelatedNames(data[relatedKey]);
      }
      // print(data[relatedKey]);

      return {
        "collectionType": collection,
        "id": doc.id,
        "name": data['name']?[lang] ?? data['name']?['ar'],
        "image": data['image'],
        "eraId": eraId,
        "description": data['description']?[lang] ?? data['description']?['ar'],
        "IraInfos": {
          "name": eraData?['name']?[lang] ?? eraData?['name']?['ar'],
          "description":
              eraData?['description']?[lang] ?? eraData?['description']?['ar'],
          "startYear": eraData?['startYear'],
          "endYear": eraData?['endYear'],
        },
        "relatedItems": relatedNames,
      };
    } catch (e) {
      print("Error in getSpecificData: $e==========================");
      return null;
    }
  }

  // =====================================================

  static Future<String> getSpecificName({required String id}) async {
    String collection;

    if (id.startsWith('attraction')) {
      collection = 'attractions';
    } else if (id.startsWith('king')) {
      collection = 'kings';
    } else {
      collection = 'eras';
    }

    try {
      var doc = await FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .get();
      // print('Doc in getSpecificName ==============');
      // print(doc);
      // print(doc.data());
      if (doc.exists && doc.data() != null) {
        // String lang = getCurrentLang();
        String lang = cash.getLang();

        print('Final Lang from Cash: $lang');
        if (lang != 'ar' && lang != 'en') lang = 'ar';

        return doc.data()!['name']?[lang] ?? doc.data()!['name']?['ar'] ?? id;
      }
    } catch (e) {
      // print('Error in getSpecificName=-======================');
      // print(e);
    }

    return id;
  }

  static Future<List<String>> fetchRelatedNames(List ids) async {
    return await Future.wait(
      ids.map((id) => getSpecificName(id: id.toString())),
    );
  }
}

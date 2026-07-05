import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/cash.dart';
import '../../data/repositories/firebase_repo.dart';
import 'notification_service.dart';

class FirebaseService {
  // FirebaseRepo firebaseRepo =FirebaseRepo();
  static Future<void> retrieveRandom_Id_FromFirebase() async
  {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print('🔕 No user logged in - skipping');
      return;
    }

    final enabled = cash.pref.getBool('notifications_enabled') ?? true;
    if (!enabled) {
      print('🔕 Notifications disabled - skipping');
      return;
    }
    try {
      String lang = cash.getLang();

      List<String> collections = ['kings', 'attractions', 'eras'];
      String randomCollection =
      collections[Random().nextInt(collections.length)];

      final snapshot = await FirebaseRepo.getCollectionData(
        collection: randomCollection,
      );

      if (snapshot.docs.isEmpty) return;

      var randomDoc = snapshot.docs[Random().nextInt(snapshot.docs.length)];
      Map<String, dynamic> data = await FirebaseRepo.getDocData(doc: randomDoc);

      String docId = randomDoc.id;
      String name = data['name'][lang] ?? data['name']['en'];

      String title = "dalil".tr();
      String body = name;

      print(docId);
      print(randomCollection);
      print('==============================================');
      print('LANG: $lang'); // ✅ شايفه في الـ logs بالفعل
      print('==============================================');
      final String simplePayload = "$docId|$randomCollection";
      // final payload = {"id": docId, "type": randomCollection};
      print(simplePayload);

      await NotificationService.startDailyscheduled(
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

  static Future<Map<String, dynamic>?>
  getDataFromFirebase_By_Id({
    required String id,
  })
  async {
    try {
      String lang = cash.getLang();
      // if (lang != 'ar' && lang != 'en') lang = 'ar';
      // print('Final Lang from Cash: $lang');

      String collection;
      if (id.startsWith('attraction')) {
        collection = 'attractions';
      } else if (id.startsWith('king')) {
        collection = 'kings';
      } else {
        collection = 'eras';
      }

      final doc = await FirebaseRepo.getDoc(id: id, collection: collection);

      if (!doc.exists) return null;

      final data = FirebaseRepo.getDocData(doc: doc);

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

      Map<String, dynamic>? eraData;

      if (eraId != null) {
        var eraDoc = await FirebaseRepo.getDoc(id: eraId, collection: 'eras');
        eraData = eraDoc.data() as Map<String, dynamic>;
      }

      List<String> relatedNames = [];

      if (data.containsKey(relatedKey) && data[relatedKey] != null) {
        relatedNames = await get_ListOf_SpecificNamesFromIds(data[relatedKey]);
      }

      return {
        "price": collection == 'attractions'
            ? (data['price'] ?? 0).toDouble() : null,
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

  static Future<String> get_One_SpecificNamefromId
      ({required String id}) async {
    String collection;

    if (id.startsWith('attraction')) {
      collection = 'attractions';
    } else if (id.startsWith('king')) {
      collection = 'kings';
    } else {
      collection = 'eras';
    }

    try {
      var doc = await FirebaseRepo.getDoc(id: id, collection: collection);
      if (doc.exists && doc.data() != null) {
        String lang = cash.getLang();
        // if (lang != 'ar' && lang != 'en') lang = 'ar';
        // print('Final Lang from Cash: $lang');

        return doc.data()!['name']?[lang] ?? doc.data()!['name']?['ar'] ?? id;
      }
    } catch (e) {}

    return id;
  }

  static Future<List<String>> get_ListOf_SpecificNamesFromIds(List ids) async {
    return await Future.wait(
      ids.map((id) =>
          get_One_SpecificNamefromId(id: id.toString())),
    );
  }
}
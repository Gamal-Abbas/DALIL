


import '../../features/notifications/data/datasources/firebase_service.dart';

class ReplaceIdWithName {
  // final List ids;
  // ReplaceIdWithName({
  //   required
  // this.ids
  // });
  static Future<List<String>> loadNames(List ids) async {
    try {
      final futures = ids.map(
        (id) => FirebaseService.get_One_SpecificNamefromId(id: id.toString()),
      );
      return await Future.wait(futures);
    } catch (e) {
      return ids.map((e) => e.toString()).toList();
    }
  }
}

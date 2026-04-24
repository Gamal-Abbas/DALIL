import 'package:dalil/notifications/notifications2/firebaseManager.dart';

class ReplaceIdWithName {

// final List ids;
// ReplaceIdWithName({
//   required
// this.ids
// });
  static Future<List<String>> loadNames(List ids) async {
    try {
      final futures = ids.map(
            (id) =>
            FireBaseManager.getSpecificName(id: id.toString()),
      );
      return await Future.wait(futures);
    } catch (e) {
      return ids.map((e) => e.toString()).toList();
    }
  }


}
import 'package:flutter_compass/flutter_compass.dart';

class CompassDataSource {
  Stream<double> getHeadingStream() {
    return FlutterCompass.events!.map((event) => event.heading ?? 0.0);
  }
}

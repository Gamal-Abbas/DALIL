import 'package:flutter_bloc/flutter_bloc.dart';
import 'object_detection_state.dart';

class ObjectDetectionCubit extends Cubit<ObjectDetectionState> {
  ObjectDetectionCubit() : super(ObjectDetectionInitial());
}

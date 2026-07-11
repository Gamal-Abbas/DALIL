abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ModelLoadingFailure extends Failure {
  const ModelLoadingFailure({required super.message});
}

class InferenceFailure extends Failure {
  const InferenceFailure({required super.message});
}

class ImagePickerFailure extends Failure {
  const ImagePickerFailure({required super.message});
}

class JsonDataFailure extends Failure {
  const JsonDataFailure({required super.message});
}

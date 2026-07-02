class QrState {}

class QrInit extends QrState {}

class QrSucces extends QrState {
  final Map<String, dynamic> data;

  QrSucces({required this.data});
}

class QrError extends QrState {}

class QrLoading extends QrState {}

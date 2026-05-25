class qrState {}

class qrInit extends qrState {}

class qrSucces extends qrState {
  final Map<String, dynamic> data;

  qrSucces({required this.data});
}

class qrError extends qrState {}

class qrLoading extends qrState {}

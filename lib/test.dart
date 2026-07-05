// class Service {
//   Future<dynamic> fetchData(String endPoint) async {
//     return Future.value([]);  }}
//
// class Repository {
//   final Service service;
//   Repository({required this.service});
//
//   Future<dynamic> getProducts() async {
//     return Future.value([]);  }}
//
// class UseCase {
//   final Repository repository;
//   UseCase({required this.repository});
//
//   void getProduct() {
//     repository.getProducts(); }}
//
// void main() {
//   UseCase useCase = UseCase(
//       repository: Repository(
//           service: Service()
//       )
//   );
// }

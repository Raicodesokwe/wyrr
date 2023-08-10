import '../api/api_repository.dart';

class BaseBloc extends Object {
  final repository = ApiRepository();

  void dispose() {
    print('------------------- ${this} Dispose ------------------- ');
  }
}

import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/services/user_service.dart';

class UserRepository {
  final UserService service;

  const UserRepository({required this.service});

  Future<List<User>> getUsers() {
    return service.getUsers();
  }
}

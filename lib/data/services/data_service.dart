import 'package:dd_study2022_ui/data/services/database.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';

class DataService {
  Future cuUser(User user) async {
    await DB.instance.createUpdate(user);
  }
}
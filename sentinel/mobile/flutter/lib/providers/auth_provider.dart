import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  // Simulate login (no API call)
  void login(String email, String code) {
    _user = User(
      id: 'user1',
      firstName: 'Rami',
      lastName: 'Troudi',
      vehicle: 'Kia Rio 2013',
      insuranceCompany: 'Lloyd (démo)',
    );
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}

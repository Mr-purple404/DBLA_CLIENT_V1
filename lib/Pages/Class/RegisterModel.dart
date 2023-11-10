import 'package:flutter/foundation.dart';

class GlobalRegisterModel extends ChangeNotifier {
  String _nomCustommer = '';
  String _prenomCustommer = '';
  String _dateNaissance = '';
  String _emailCustommer = '';

  String get nomCustommer => _nomCustommer;
  String get prenomCustommer => _prenomCustommer;
  String get dateNaissance => _dateNaissance;
  String get emailCustommer => _emailCustommer;

  void setNameCustommer(String newnName) {
    _nomCustommer = newnName;
    notifyListeners(); // Notifie les écouteurs du changement
  }

  void setFirstNameCustommer(String newFirstName) {
    _prenomCustommer = newFirstName;
    notifyListeners(); // Notifie les écouteurs du changement
  }

  void setDateNaissance(String newDate) {
    _dateNaissance = newDate;
    notifyListeners(); // Notifie les écouteurs du changement
  }

  void setEmailCustommmer(String newEmail) {
    _emailCustommer = newEmail;
    notifyListeners(); // Notifie les écouteurs du changement
  }
}

import 'package:flutter/foundation.dart';

class GlobalVariableModel extends ChangeNotifier {
  int _idRace = 0;
  int _idRacing = 0;
  String _price = '';
  int get idRace => _idRace;
  int get idRacing => _idRacing;
  String get price => _price;

  void setIdRace(int newIdRace) {
    _idRace = newIdRace;
    notifyListeners(); // Notifie les écouteurs du changement
  }

  void setIdRacing(int newIdRacing) {
    _idRacing = newIdRacing;
    notifyListeners(); // Notifie les écouteurs du changement
  }

  void setPrice(String newPrice) {
    _price = newPrice;
    notifyListeners(); // Notifie les écouteurs du changement
  }
}

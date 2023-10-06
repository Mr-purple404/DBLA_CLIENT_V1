import 'package:flutter/foundation.dart';

class GlobalVariableModel extends ChangeNotifier {
  int _idRace = 0;

  int get idRace => _idRace;

  void setIdRace(int newIdRace) {
    _idRace = newIdRace;
    notifyListeners(); // Notifie les écouteurs du changement
  }
}

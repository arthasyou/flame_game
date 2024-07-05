import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SlotMachineProvider extends ChangeNotifier {
  bool _isSpinning = false;
  bool get isSpinning => _isSpinning;

  int _coin = 0;
  int get coin => _coin;

  void setIsSpinning(bool isSpinning) {
    _isSpinning = isSpinning;
    notifyListeners();
  }

  void setCoin(int coin) {
    _coin = coin;
    notifyListeners();
  }
}

final slotMachineProvider = ChangeNotifierProvider<SlotMachineProvider>((ref) {
  return SlotMachineProvider();
});

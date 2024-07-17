import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../protos/message.pb.dart';

class SlotMachineProvider extends ChangeNotifier {
  // 私有构造函数
  SlotMachineProvider._internal();

  // 单例实例
  static final SlotMachineProvider _instance = SlotMachineProvider._internal();

  // 工厂构造函数
  factory SlotMachineProvider() {
    return _instance;
  }

  bool _isSpinning = false;
  bool get isSpinning => _isSpinning;
  bool shouldStartSpinning = false;

  int _coin = 0;
  int get coin => _coin;

  int _bigOrSmallBet = 0;
  int get bigOrSmallBet => _bigOrSmallBet;

  List<Bet> _bets = List.generate(8, (index) => Bet(index: index, amount: 0));
  List<Bet> get bets => _bets;

  List<int> _lights = [];
  List<int> get lights => _lights;

  void setIsSpinning(bool isSpinning) {
    _isSpinning = isSpinning;
    notifyListeners();
  }

  void setShouldStartSpinning(bool value) {
    shouldStartSpinning = value;
    notifyListeners();
  }

  void setCoin(int coin) {
    _coin = coin;
    notifyListeners();
  }

  void _setBigOrSmallBet(int value) {
    _bigOrSmallBet = value;
    notifyListeners();
  }

  void addBoSBet() {
    int t = _bigOrSmallBet;
    _setBigOrSmallBet(t + 1);
  }

  void setBets(List<Bet> bets) {
    _bets = bets;
    notifyListeners();
  }

  int getBet(int index) {
    // Find the Bet with the given index
    int betIndex = _bets.indexWhere((bet) => bet.index == index);
    return _bets[betIndex].amount;
  }

  void increaseBet(int index, int amount) {
    if (_coin > amount) {
      int betIndex = _bets.indexWhere((bet) => bet.index == index);
      if (betIndex != -1) {
        // Increase the amount of the existing Bet
        _bets[betIndex].amount += amount;
        _coin -= amount;
        notifyListeners();
      }
    }
  }

  void setLights(List<int> lights) {
    _lights = lights;
    // notifyListeners();
  }
}

final slotMachineProvider = ChangeNotifierProvider<SlotMachineProvider>((ref) {
  return SlotMachineProvider();
});

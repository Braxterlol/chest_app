import 'package:flutter/material.dart';
import 'dart:math';
import '../models/chest_model.dart';
import '../models/loot_item.dart';

class ChestViewModel extends ChangeNotifier {
  List<ChestModel> _chests = [];
  bool _isOpening = false;
  LootItem? _lastOpenedItem;

  List<ChestModel> get chests => _chests;
  bool get isOpening => _isOpening;
  LootItem? get lastOpenedItem => _lastOpenedItem;

  ChestViewModel() {
    _loadChests();
  }

  void _loadChests() {
    _chests = ChestModel.getAvailableChests();
    notifyListeners();
  }

  Future<LootItem?> openChest(ChestModel chest) async {
    if (_isOpening) return null;

    _isOpening = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));

    LootItem selectedItem = _selectRandomItem(chest.possibleItems);
    
    _lastOpenedItem = selectedItem;
    _isOpening = false;
    
    notifyListeners();
    return selectedItem;
  }

  LootItem _selectRandomItem(List<LootItem> items) {
    final random = Random();
    
    int randomValue = random.nextInt(100);
    
    List<LootItem> legendaryItems = items.where((item) => item.rarity == ItemRarity.legendary).toList();
    List<LootItem> epicItems = items.where((item) => item.rarity == ItemRarity.epic).toList();
    List<LootItem> rareItems = items.where((item) => item.rarity == ItemRarity.rare).toList();
    List<LootItem> commonItems = items.where((item) => item.rarity == ItemRarity.common).toList();

    if (randomValue < 5 && legendaryItems.isNotEmpty) {
      return legendaryItems[random.nextInt(legendaryItems.length)];
    } else if (randomValue < 20 && epicItems.isNotEmpty) {
      return epicItems[random.nextInt(epicItems.length)];
    } else if (randomValue < 50 && rareItems.isNotEmpty) {
      return rareItems[random.nextInt(rareItems.length)];
    } else if (commonItems.isNotEmpty) {
      return commonItems[random.nextInt(commonItems.length)];
    }
    
    return items[random.nextInt(items.length)];
  }

  void resetLastOpenedItem() {
    _lastOpenedItem = null;
    notifyListeners();
  }
}
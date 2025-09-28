import 'package:flutter/material.dart';

enum ItemRarity { common, rare, epic, legendary }

class LootItem {
  final String name;
  final String icon;
  final ItemRarity rarity;
  final int value;

  LootItem({
    required this.name,
    required this.icon,
    required this.rarity,
    required this.value,
  });

  Color get rarityColor {
    switch (rarity) {
      case ItemRarity.common:
        return Colors.grey;
      case ItemRarity.rare:
        return Colors.blue;
      case ItemRarity.epic:
        return Colors.purple;
      case ItemRarity.legendary:
        return Colors.orange;
    }
  }

  String get rarityName {
    return rarity.toString().split('.').last.toUpperCase();
  }
}
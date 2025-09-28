import 'loot_item.dart';

class ChestModel {
  final String name;
  final String image;
  final List<LootItem> possibleItems;
  final int cost;
  bool isOpened;

  ChestModel({
    required this.name,
    required this.image,
    required this.possibleItems,
    required this.cost,
    this.isOpened = false,
  });

  static List<ChestModel> getAvailableChests() {
    return [
      ChestModel(
        name: "Bronze Chest",
        image: "🥉",
        cost: 100,
        possibleItems: [
          LootItem(name: "Iron Sword", icon: "⚔️", rarity: ItemRarity.common, value: 50),
          LootItem(name: "Health Potion", icon: "🧪", rarity: ItemRarity.common, value: 25),
          LootItem(name: "Magic Ring", icon: "💍", rarity: ItemRarity.rare, value: 150),
        ],
      ),
      ChestModel(
        name: "Silver Chest",
        image: "🥈",
        cost: 250,
        possibleItems: [
          LootItem(name: "Steel Armor", icon: "🛡️", rarity: ItemRarity.rare, value: 200),
          LootItem(name: "Fire Gem", icon: "💎", rarity: ItemRarity.epic, value: 400),
          LootItem(name: "Dragon Scale", icon: "🐉", rarity: ItemRarity.legendary, value: 1000),
        ],
      ),
      ChestModel(
        name: "Gold Chest",
        image: "🥇",
        cost: 500,
        possibleItems: [
          LootItem(name: "Legendary Sword", icon: "🗡️", rarity: ItemRarity.legendary, value: 1500),
          LootItem(name: "Phoenix Feather", icon: "🪶", rarity: ItemRarity.legendary, value: 2000),
          LootItem(name: "Crown of Kings", icon: "👑", rarity: ItemRarity.legendary, value: 3000),
        ],
      ),
    ];
  }
}
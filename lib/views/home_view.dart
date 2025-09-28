import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/chest_viewmodel.dart';
import '../widgets/chest_grid.dart';
import '../widgets/loot_reveal.dart';
import '../models/loot_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(Colors.deepPurple[900], Colors.indigo[900], 
                            _backgroundAnimation.value)!,
                  Color.lerp(Colors.indigo[900], Colors.purple[900], 
                            _backgroundAnimation.value)!,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: Consumer<ChestViewModel>(
                      builder: (context, viewModel, child) {
                        if (viewModel.lastOpenedItem != null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _showLootReveal(context, viewModel.lastOpenedItem!);
                            viewModel.resetLastOpenedItem();
                          });
                        }
                        return ChestGrid();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          'Loot Chest Adventure',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showLootReveal(BuildContext context, LootItem item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LootRevealDialog(item: item),
    );
  }
}
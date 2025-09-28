import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/chest_viewmodel.dart';
import 'chest_card.dart';

class ChestGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChestViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: viewModel.chests.length,
            itemBuilder: (context, index) {
              return ChestCard(chest: viewModel.chests[index]);
            },
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chest_model.dart';
import '../../viewmodels/chest_viewmodel.dart';

class ChestCard extends StatefulWidget {
  final ChestModel chest;

  ChestCard({required this.chest});

  @override
  _ChestCardState createState() => _ChestCardState();
}

class _ChestCardState extends State<ChestCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _openingController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _openingController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05)
        .animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut));
    
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _openingController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _openingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChestViewModel>(
      builder: (context, viewModel, child) {
        return AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value * 0.1,
                child: GestureDetector(
                  onTapDown: (_) => _hoverController.forward(),
                  onTapUp: (_) => _hoverController.reverse(),
                  onTapCancel: () => _hoverController.reverse(),
                  onTap: !viewModel.isOpening ? _openChest : null,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.amber[300]!, Colors.amber[600]!],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Background pattern
                          CustomPaint(
                            painter: ChestBackgroundPainter(),
                            size: Size.infinite,
                          ),
                          // Content
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Hero(
                                  tag: 'chest_${widget.chest.name}',
                                  child: Text(
                                    widget.chest.image,
                                    style: TextStyle(fontSize: 80),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  widget.chest.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                if (viewModel.isOpening)
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Shimmer effect
                          if (!viewModel.isOpening)
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.5, 1.0],
                                  transform: GradientRotation(_rotationAnimation.value * 6.28),
                                ).createShader(bounds);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Colors.white],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openChest() async {
    _openingController.forward();
    final viewModel = Provider.of<ChestViewModel>(context, listen: false);
    await viewModel.openChest(widget.chest);
    _openingController.reset();
  }
}

class ChestBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (double i = -size.height; i < size.width + size.height; i += 30) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

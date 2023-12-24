import 'package:flutter/material.dart';

class CustomLoadingScreen extends StatelessWidget {
  const CustomLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BouncingBallLoadingIndicator(),
            SizedBox(height: 16.0),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.blue, // Set the color of the loading text
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BouncingBallLoadingIndicator extends StatefulWidget {
  const BouncingBallLoadingIndicator({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  BouncingBallLoadingIndicatorState createState() =>
      BouncingBallLoadingIndicatorState();
}

class BouncingBallLoadingIndicatorState
    extends State<BouncingBallLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.0,
      height: 50.0,
      child: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue, // Set the color of the bouncing ball
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

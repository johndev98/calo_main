import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 65,
                width: double.infinity,
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.amber),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton.filled(
                              padding: EdgeInsets.all(15),
                              onPressed: () {},
                              icon: Icon(Icons.home),
                            ),
                            IconButton.filled(
                              onPressed: () {},
                              icon: Icon(Icons.home),
                            ),
                            IconButton.filled(
                              onPressed: () {},
                              icon: Icon(Icons.home),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(22),
                        backgroundColor: Colors.deepOrangeAccent,
                      ),
                      onPressed: () {},
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

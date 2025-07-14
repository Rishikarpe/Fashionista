import 'package:flutter/material.dart';

  class OutfitScreen extends StatelessWidget {
    const OutfitScreen({super.key}); // Added key parameter
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Outfit Recommendations')),
        body: const Center(
          child: Text('Outfit recommendations coming soon!'),
        ),
      );
    }
  }
import 'package:flutter/material.dart';
import 'package:foodmood/widgets/custom_header.dart';

class BlacklistScreen extends StatelessWidget {
  const BlacklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              headerTxt: 'Blacklisted Foods',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text('Blacklist Foods'),
          ],
        ),
      ),
    );
  }
}

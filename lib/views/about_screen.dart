import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/widgets/app_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'About Us',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome to Sandwich Shop!', style: heading2),
              const SizedBox(height: 20),
              Text(
                'We are a family-owned business dedicated to serving the best sandwiches in town. ',
                style: normalText,
              ),
              const SizedBox(height: 20),
              Text(
                'Our Story',
                style: heading2,
              ),
              const SizedBox(height: 10),
              Text(
                'Founded in 2024, Sandwich Shop has been committed to quality ingredients, '
                'exceptional service, and delicious sandwiches made fresh to order.',
                style: normalText,
              ),
              const SizedBox(height: 20),
              Text(
                'Our Values',
                style: heading2,
              ),
              const SizedBox(height: 10),
              Text(
                '• Fresh ingredients daily\n'
                '• Made-to-order sandwiches\n'
                '• Fast and friendly service\n'
                '• Community focused',
                style: normalText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

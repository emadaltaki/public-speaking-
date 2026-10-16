import 'package:flutter/widgets.dart';

/// Non-web fallback: scheduling pages can only be embedded in the browser.
class BookingEmbed extends StatelessWidget {
  const BookingEmbed({super.key, required this.url, this.height = 720});

  final String url;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

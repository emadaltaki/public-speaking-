import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

/// Shows an online scheduling page (Cal.com, Calendly, ...) inside the site.
class BookingEmbed extends StatelessWidget {
  const BookingEmbed({super.key, required this.url, this.height = 720});

  final String url;
  final double height;

  static final Set<String> _registered = {};

  @override
  Widget build(BuildContext context) {
    final viewType = 'booking-embed-$url';
    if (_registered.add(viewType)) {
      ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) {
        final frame = web.HTMLIFrameElement()
          ..src = url
          ..title = 'Book a time'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        return frame;
      });
    }
    return SizedBox(
      height: height,
      child: HtmlElementView(viewType: viewType),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';

void main() {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // Build the accessibility tree up front so screen readers (and crawlers)
  // can read the page without the user enabling it first.
  SemanticsBinding.instance.ensureSemantics();
  runApp(const SpeakUpFearlessApp());
}

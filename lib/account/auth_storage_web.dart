import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

String? readStoredUser(String key) => readLocal(key);

void writeStoredUser(String key, String value) => writeLocal(key, value);

void clearStoredUser(String key) {
  try {
    web.window.localStorage.removeItem(key);
  } catch (_) {}
}

String? readLocal(String key) {
  try {
    return web.window.localStorage.getItem(key);
  } catch (_) {
    return null;
  }
}

void writeLocal(String key, String value) {
  try {
    web.window.localStorage.setItem(key, value);
  } catch (_) {}
}

/// Opens a page of this site outside the Flutter app (the sign-in page).
void openSitePage(String path) {
  web.window.location.assign(path);
}

/// Lets the visitor pick a photo, crops it to a centred square and shrinks it
/// to [size] pixels, and returns it as a small JPEG data URL (or null if they
/// cancel). Done in the browser so only a few KB are uploaded.
Future<String?> pickSquarePhoto({int size = 256}) {
  final done = Completer<String?>();
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = 'image/*';
  input.onchange = (web.Event _) {
    final file = input.files?.item(0);
    if (file == null) {
      done.complete(null);
      return;
    }
    final url = web.URL.createObjectURL(file);
    final img = web.HTMLImageElement();
    img.onload = (web.Event _) {
      final w = img.naturalWidth, h = img.naturalHeight;
      final side = w < h ? w : h;
      final canvas = web.HTMLCanvasElement()
        ..width = size
        ..height = size;
      final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D;
      ctx.drawImage(
        img,
        (w - side) / 2,
        (h - side) / 2,
        side,
        side,
        0,
        0,
        size,
        size,
      );
      web.URL.revokeObjectURL(url);
      done.complete(canvas.toDataURL('image/jpeg', 0.85.toJS));
    }.toJS;
    img.onerror = (web.Event _) {
      web.URL.revokeObjectURL(url);
      done.complete(null);
    }.toJS;
    img.src = url;
  }.toJS;
  input.click();
  return done.future;
}

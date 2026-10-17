{{flutter_js}}
{{flutter_build_config}}

// CanvasKit comes from this site instead of gstatic.com, so the home page can
// fetch it ahead of time and opening the games or account page is quicker.
_flutter.loader.load({
  config: { canvasKitBaseUrl: '/canvaskit/' },
});

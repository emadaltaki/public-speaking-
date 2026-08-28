// Replaces Flutter's generated offline-first service worker, which served
// flutter_bootstrap.js and main.dart.js cache-first and left returning visitors
// on a previous deployment. The site is built with --pwa-strategy=none, so no
// new worker is ever registered; this file only exists to tear down workers
// that older visitors still have installed.
self.addEventListener('install', () => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys.map((key) => caches.delete(key)));
    await self.registration.unregister();

    const clients = await self.clients.matchAll({ type: 'window' });
    for (const client of clients) {
      try {
        await client.navigate(client.url);
      } catch (err) {
        // A client that refuses to navigate still picks up the new build on
        // its next load, since this worker no longer answers fetches.
      }
    }
  })());
});

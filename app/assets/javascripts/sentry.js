//= require_self

(function () {
  if (!window.SENTRY_DSN) return;

  // load @sentry/browser as a UMD module
  var script = document.createElement('script');
  script.src = 'https://browser.sentry-cdn.com/7.93.0/bundle.tracing.min.js'; // last stable as of March 2025.
  script.crossOrigin = 'anonymous';

  script.onload = function () {
    Sentry.init({
      dsn: window.SENTRY_DSN,
      integrations: [new Sentry.BrowserTracing()],
      tracesSampleRate: 1.0,
    });
  };

  document.head.appendChild(script);
})();

// sentry.js
// if (window.SENTRY_DSN && typeof Sentry !== 'undefined') {
//   Sentry.init({ dsn: window.SENTRY_DSN });
// }
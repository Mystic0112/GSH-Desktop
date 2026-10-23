// Ponte dos arquivos `.panel` (plano 67). Injetada pelo app no início do
// documento; a página só vê `window.gsh`.
//
//   const r = await gsh("exec git status --short");
//   r.ok, r.code, r.stdout, r.stderr, r.json (stdout parseado quando é JSON)
//   gsh.on("theme", vars => ...)   // troca de tema do app
//   gsh.theme                       // as CSS variables --ckp-* atuais
//   gsh.route / gsh.on("route") // hash routing (multi-página)
// Libs embarcadas (sem rede): /__gsh__/{gsh.css,petite-vue.js,
// chart.js,marked.js,tailwind.js} — servidas dos assets do app.
(function () {
  if (window.gsh) return;
  var listeners = {};

  function ready() {
    if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
      return Promise.resolve();
    }
    return new Promise(function (resolve) {
      window.addEventListener('flutterInAppWebViewPlatformReady', function () {
        resolve();
      }, { once: true });
    });
  }

  function gsh(line) {
    return ready().then(function () {
      return window.flutter_inappwebview.callHandler('gsh', String(line));
    });
  }

  gsh.on = function (event, fn) {
    (listeners[event] = listeners[event] || []).push(fn);
    return function () {
      listeners[event] = (listeners[event] || []).filter(function (f) {
        return f !== fn;
      });
    };
  };

  gsh.theme = {};


  gsh.__emit = function (event, data) {
    (listeners[event] || []).forEach(function (fn) {
      try {
        fn(data);
      } catch (e) {
        console.error(e);
      }
    });
  };

  gsh.__setTheme = function (vars) {
    gsh.theme = vars;
    var root = document.documentElement;
    for (var k in vars) root.style.setProperty(k, vars[k]);
    gsh.__emit('theme', vars);
  };

  // Roteamento por hash para painéis com mais de uma "página" num arquivo só.
  //   gsh.route.path            // "/" | "/detail/3" (location.hash sem "#")
  //   gsh.route.params          // { id: "3" } quando casou com um pattern
  //   gsh.route.go("/detail/3") // navega (muda o hash)
  //   gsh.route.match("/detail/:id")  // params ou null
  //   gsh.on("route", route => ...)   // dispara a cada mudança
  var route = {
    path: '/',
    params: {},
    go: function (path) {
      location.hash = path.charAt(0) === '/' ? path : '/' + path;
    },
    match: function (pattern) {
      var p = pattern.split('/').filter(Boolean);
      var c = route.path.split('/').filter(Boolean);
      if (p.length !== c.length) return null;
      var params = {};
      for (var i = 0; i < p.length; i++) {
        if (p[i].charAt(0) === ':') params[p[i].slice(1)] = decodeURIComponent(c[i]);
        else if (p[i] !== c[i]) return null;
      }
      return params;
    },
  };
  function readHash() {
    var h = location.hash.replace(/^#/, '');
    route.path = h.charAt(0) === '/' ? h : '/' + h;
    route.params = {};
    gsh.__emit('route', route);
  }
  window.addEventListener('hashchange', readHash);
  readHash();
  gsh.route = route;

  window.gsh = gsh;
})();

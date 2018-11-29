extensions_sources = [
  'jsapi.vala',
  'jsutils.vala'
]

extensions_deps = [
  dependency('webkit2gtk-web-extension-4.0'),
  dependency('javascriptcoregtk-4.0'),
  dependency('json-glib-1.0')
]

shared_library('webkit2gtk-boilerplate-extension', extensions_sources,
  vala_args: ['--vapi=libwebkit2gtk-boilerplate.vapi'],
  dependencies: extensions_deps,
  install: true,
  install_dir: '/opt/webkit2gtk-boilerplate/extensions'
)

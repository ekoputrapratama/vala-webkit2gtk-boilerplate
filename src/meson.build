
webkit2gtk_boilerplate_sources = [
  'widgets/Window.vala',
  'widgets/WebView.vala',
  'constants/WindowType.vala',
  'main.vala'
]

gnome = import('gnome')

webkit2gtk_boilerplate_sources += gnome.compile_resources('webkit2gtk-boilerplate-resources',
  'webkit2gtk-boilerplate.gresource.xml'
)
webkit2gtk_boilerplate_deps = [
  dependency('gdk-3.0', version: '>= 3.22'),
  dependency('gtk+-3.0', version: '>= 3.22'),
  dependency('libsoup-2.4'),
  dependency('libwnck-3.0'),
  dependency('webkit2gtk-4.0'),
  dependency('javascriptcoregtk-4.0'),
  dependency('gee-0.8'),
  dependency('gdk-pixbuf-2.0'),
  dependency('json-glib-1.0')
]



executable('webkit2gtk-boilerplate', webkit2gtk_boilerplate_sources,
  vala_args: ['--target-glib=2.2.5 --rdynamic'],
  dependencies: webkit2gtk_boilerplate_deps,
  install: true,
  install_dir: '/opt/webkit2gtk-boilerplate'
)

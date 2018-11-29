cmd = run_command('sh', '-c', 'echo $HOME')
HOME_DIR = cmd.stdout().strip()
desktop_file = i18n.merge_file(
  input: 'webkit2gtk-boilerplate.desktop.in',
  output: 'webkit2gtk-boilerplate.desktop',
  type: 'desktop',
  po_dir: '../po',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'applications')
)

desktop_utils = find_program('desktop-file-validate', required: false)
if desktop_utils.found()
  test('Validate desktop file', desktop_utils,
    args: [desktop_file]
  )
endif

appstream_file = i18n.merge_file(
  input: 'webkit2gtk-boilerplate.appdata.xml.in',
  output: 'webkit2gtk-boilerplate.appdata.xml',
  po_dir: '../po',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'appdata')
)


appstream_util = find_program('appstream-util', required: false)
if appstream_util.found()
  test('Validate appstream file', appstream_util,
    args: ['validate', appstream_file]
  )
endif

install_data('io.github.webkit2gtk-boilerplate.gschema.xml',
  install_dir: join_paths(get_option('datadir'), 'glib-2.0/schemas')
)
install_subdir('static', install_dir : join_paths('/opt','webkit2gtk-boilerplate'))
compile_schemas = find_program('glib-compile-schemas', required: false)
if compile_schemas.found()
  test('Validate schema file', compile_schemas,
    args: ['--strict', '--dry-run', meson.current_source_dir()]
  )
endif


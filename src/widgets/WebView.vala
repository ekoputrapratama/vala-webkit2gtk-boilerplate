using Gee;
using GLib;

namespace Webkit2gtkBoilerplate {

	[DBus(name = "io.github.webkit2gtk-boilerplate.JSApi")]
	interface JSApi : Object {
		public signal void on_string_callback();
	}

	public class WebView : WebKit.WebView {
		private JSApi messenger = null;
		private int count = 0;
		public File launchers_folder { get; private set; }
		public File config_folder { get; construct; }
		public WebKit.WebContext context {get; set;}
		public signal void on_string_callback();

		public WebView.with_context(WebKit.WebContext ctx) {
			GLib.Object(context: ctx);
			this.init();
		}
		public WebView() {
			this.init();
		}
		~WebView() {
			Bus.watch_name(BusType.SESSION, "io.github.webkit2gtk-boilerplate.JSApi", BusNameWatcherFlags.NONE,
			               (connection, name, owner) => { on_extension_appeared(connection, name, owner); }, null);
		}
		construct
		{
      
		}
		public void init() {

			WebKit.Settings settings = this.get_settings();
			settings.enable_plugins = true;
			settings.enable_javascript = true;
			settings.allow_file_access_from_file_urls = true;
			settings.allow_universal_access_from_file_urls = true;
			settings.enable_developer_extras = true;
			settings.enable_webgl = true;
		}
		private void on_extension_appeared(DBusConnection connection, string name, string owner) {
			try {
				messenger = connection.get_proxy_sync("io.github.webkit2gtk-boilerplate.JSApi", "/io/github/webkit2gtk-boilerplate/jsapi",
				                                      DBusProxyFlags.NONE, null);
				messenger.on_string_callback.connect(() => {
					message("on_string_callback");
					on_string_callback();
				});
			} catch(IOError error) {
				warning("Problem connecting to extension: %s", error.message);
			}
		}

	}
}

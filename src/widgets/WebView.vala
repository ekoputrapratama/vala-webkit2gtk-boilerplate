using Gee;
using GLib;

namespace Webkit2gtkBoilerplate {

	[DBus(name = "io.github.webkit2gtk-boilerplate.JSApi")]
	interface JSApi : Object {
		public signal void on_void_callback();
	}

	public class WebView : WebKit.WebView {
		private JSApi messenger = null;
		private int count = 0;
		public File launchers_folder { get; private set; }
		public File config_folder { get; construct; }
		public WebKit.WebContext context {get; set;}
		public signal void on_void_callback();

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
			//  config_folder = Paths.AppConfigFolder.get_child("dock1");
			//  launchers_folder = config_folder.get_child("launchers");
		}
		public void init() {
			Gdk.RGBA transparent = {red:0, green:0, blue:0, alpha: 0};
			//  this.set_background_color(transparent);

			WebKit.Settings settings = this.get_settings();
			settings.enable_plugins = true;
			settings.enable_javascript = true;
			settings.allow_file_access_from_file_urls = true;
			settings.allow_universal_access_from_file_urls = true;
			settings.enable_developer_extras = true;
			settings.enable_webgl = true;
		}
		public void init_launcher_icons(string dock_icons) {
			message("init_launcher_icons: %s", dock_icons);
			//  run_javascript(INIT_LAUNCHER_SCRIPT.printf(dock_icons), null);
			//  if (messenger != null) {
			//    try {
			//        messenger.init_launcher_icon(color);
			//    } catch (Error error) {
			//        warning("Error adding div: %s", error.message);
			//    }
			//  }
		}
		private void on_extension_appeared(DBusConnection connection, string name, string owner) {
			try {
				messenger = connection.get_proxy_sync("io.github.webkit2gtk-boilerplate.JSApi", "/io/github/webkit2gtk-boilerplate/jsapi",
				                                      DBusProxyFlags.NONE, null);
				//  messenger.div_clicked.connect((num) => { div_clicked(num); });
				messenger.on_void_callback.connect(() => {
					message("on_void_callback");
					on_void_callback();
				});
			} catch(IOError error) {
				warning("Problem connecting to extension: %s", error.message);
			}
		}

	}
}

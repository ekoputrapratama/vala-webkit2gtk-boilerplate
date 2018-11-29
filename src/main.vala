

namespace Webkit2gtkBoilerplate {

	class Webkit2gtkBoilerplateApp : Gtk.Application {
		Webkit2gtkBoilerplate.Window window;
		public override void activate() {
			this.init();
			window = new Webkit2gtkBoilerplate.Window();
      add_window(window);
      var url = "file:///opt/webkit2gtk-boilerplate/static/index.html";
      window.load(url, true);
		}
		public void init() {
			unowned Wnck.Screen screen = Wnck.Screen.get_default();
			//  Wnck.set_client_type(Wnck.ClientType.PAGER);
			// Make sure internal window-list of Wnck is most up to date
			Gdk.error_trap_push();
			screen.force_update();

			if(Gdk.error_trap_pop() != 0)
				critical("Wnck.Screen.force_update() caused a XError");

			unowned GLib.List<Wnck.Window> window_list = screen.get_windows();
			screen.window_manager_changed.connect_after(window_manager_changed);
      screen.window_closed.connect_after(handle_window_closed);
      
      message("Window-manager: %s", screen.get_window_manager_name());
      
		}
		public void window_manager_changed(Wnck.Screen screen) {
			message("window_manager_changed");
		}
		public void handle_window_closed(Wnck.Window window) {
			message("window_closed");
		}
		public static string ? get_window_icon(Wnck.Window window)
		{
			unowned Wnck.Window w = window;
			unowned Gdk.Pixbuf ? pbuf = null;
			string ? image = "";

			warn_if_fail(w != null);

			if(w == null)
				return null;

			Gdk.error_trap_push();

			pbuf = w.get_icon();
			if(w.get_icon_is_fallback())
				pbuf = null;

			if(Gdk.error_trap_pop() != 0)
				critical("get_window_icon() for '%s' caused a XError", window.get_name());

			if(pbuf != null) {
				uint8[] buffer;
				var saved = pbuf.save_to_buffer(out buffer, "png");
				if(saved) {
					image = GLib.Base64.encode(buffer);
				} else {
					image = null;
				}
			}
			return image;
		}
	}

	static int main(string[] args) {
		return new Webkit2gtkBoilerplateApp().run(args);
	}
}

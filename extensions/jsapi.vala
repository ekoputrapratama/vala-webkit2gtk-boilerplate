using WebKit;
using JS;
using GLib;
using Webkit2gtkBoilerplate.JSUtils;

namespace Webkit2gtkBoilerplate {
	JSApi jsapi = null;
	[DBus(name = "io.github.libwebkit2gtk-boilerplate.JSApi")]
	public class JSApi : GLib.Object {
		private int count = 0;
		private WebKit.WebPage page;
		public signal void on_void_callback();

		//  public void add_div(string color) {
		//      int x = Random.int_range(0, 300),
		//          y = Random.int_range(0, 300);
		//      count += 1;
		//      WebKit.DOM.Document document = page.get_dom_document();
		//      try {
		//              WebKit.DOM.Element el = document.create_element("div");
		//              el.append_child(document.create_text_node(@"$count"));
		//              el.set_attribute("style", @"background: $color; left: $x; top: $y;");
		//              el.set_attribute("id", @"$count");
		//              ((WebKit.DOM.EventTarget)el).add_event_listener_with_closure("click", on_div_clicked,
		//                                                                           false);
		//              document.body.insert_before(el, null);
		//      } catch(Error error) {
		//              warning("Oh noes: %s", error.message);
		//      }
		//  }
		[DBus(visible = false)]
		public void on_bus_aquired(DBusConnection connection) {
			try {
				connection.register_object("/io/github/webkit2gtk-boilerplate/jsapi", this);
			} catch(IOError error) {
				warning("Could not register service: %s", error.message);
			}
		}

		[DBus(visible = false)]
		public void on_page_created(WebKit.WebExtension extension, WebKit.WebPage page) {
			this.page = page;
			//  on_void_callback();
		}

		[DBus(visible = false)]
		public void on_window_object_cleared(ScriptWorld world, WebPage page, Frame frame) {
			message("window object cleared");
			unowned JS.Context context = (JS.GlobalContext)frame.get_javascript_context_for_script_world(world);;
			unowned JS.Object global = context.get_global_object();

			JS.String name = new JS.String.with_utf8_c_string("sayHello");
      JS.Value ex;
      JS.Value str;
      JS.Value objo;

      unowned JS.Object cb = context.make_function(name, void_callback);
      unowned JS.Object obj = context.make_object(null, null);
      obj.set_property(context,name,JS.Value.string(context, new JS.String("Hello From Native Code")), JS.PropertyAttribute.None);
			global.set_property(context,
			                    name,
			                    cb,
			                    JS.PropertyAttribute.ReadOnly);
      global.set_property(context,
      new JS.String.with_utf8_c_string("Webkit2GtkBoilerplate"),
			                    obj,
			                    JS.PropertyAttribute.ReadOnly);
		}
		public static unowned JS.Value exit(JS.Context ctx,
		                                    JS.Object function,
		                                    JS.Object thisObject,
		                                    JS.Value[] arguments,
		                                    out unowned JS.Object exception)
		{
			exception = null;
			message("exit got called");
			JS.String string = new JS.String.with_utf8_c_string("Hello From Native Code");
			return JS.Value.undefined(ctx);
		}

		public static unowned JS.Value void_callback(JS.Context ctx,
		                                             JS.Object function,
		                                             JS.Object thisObject,
		                                             JS.Value[] args,
		                                             out unowned JS.Value exception) {
			exception = null;
			unowned JS.Value undefined = JS.Value.undefined(ctx);

			
			Variant[] ? data = null;

			//  if(args.length > 0) {
			try {

				for(var i = 0; i < args.length; i++) {
					data[i] = variant_from_value(ctx, args[i]);
				}
				if(jsapi != null) {
					jsapi.on_void_callback();
					message("void_callback got called");
        }
        unowned JS.Value str = JS.Value.string(ctx, new JS.String("Hello From Native Code"));
        return str;
			} catch(JSApiError e) {
				message(e.message);
				exception = create_exception(ctx, "Argument %d: %s".printf(1, e.message));
				return undefined;
			}
			//  }
			return undefined;
		}
	}
	[DBus(name = "io.github.webkit2gtk-boilerplate.JSApi")]
	public errordomain JSApiError {
		ERROR,
		/**
		 * An object has not been found
		 */
		NOT_FOUND,
		/**
		 * A value has wrong type
		 */
		WRONG_TYPE,
		/**
		 * Call of a JavaScript function failed.
		 */
		FUNC_FAILED,
		/**
		 * Unable to load script from file
		 */
		READ_ERROR,
		/**
		 * JavaScript API does not have any context yet.
		 */
		NO_CONTEXT,
		/**
		 * Execution of a script caused an exception.
		 */
		EXCEPTION,

		INITIALIZATION_FAILED;
	}

	[CCode(cname = "G_MODULE_EXPORT webkit_web_extension_initialize", instance_pos = -1)]
	void webkit_web_extension_initialize(WebKit.WebExtension extension) {

		Webkit2gtkBoilerplate.jsapi = new JSApi();
		extension.page_created.connect(jsapi.on_page_created);
		var scriptWorld = WebKit.ScriptWorld.get_default();
		scriptWorld.window_object_cleared.connect(jsapi.on_window_object_cleared);
		Bus.own_name(BusType.SESSION, "io.github.webkit2gtk-boilerplate.JSApi", BusNameOwnerFlags.NONE,
		             jsapi.on_bus_aquired, null, () => { warning("Could not aquire name"); });
  }
  

}

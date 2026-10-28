#include "agent_island_window.h"

#include <gtk-layer-shell.h>
#include <cairo.h>

#include "flutter/generated_plugin_registrant.h"

namespace {

GtkWidget* island_window = nullptr;
FlMethodChannel* main_channel = nullptr;
FlMethodChannel* island_channel = nullptr;
gchar* latest_snapshot = nullptr;
bool island_ready = false;

void set_input_region(gint panel_height) {
  if (island_window == nullptr) return;
  GdkWindow* surface = gtk_widget_get_window(island_window);
  if (surface == nullptr) return;
  cairo_rectangle_int_t pill = {125, 0, 150, 42};
  cairo_region_t* region = cairo_region_create_rectangle(&pill);
  if (panel_height > 0) {
    cairo_rectangle_int_t panel = {10, 36, 380, CLAMP(panel_height, 0, 450)};
    cairo_region_union_rectangle(region, &panel);
  }
  gdk_window_input_shape_combine_region(surface, region, 0, 0);
  cairo_region_destroy(region);
}

void reply(FlMethodCall* call, FlValue* value = nullptr) {
  g_autoptr(FlMethodResponse) response =
      FL_METHOD_RESPONSE(fl_method_success_response_new(value));
  fl_method_call_respond(call, response, nullptr);
}

void on_island_destroy(GtkWidget*, gpointer) {
  island_window = nullptr;
  island_ready = false;
  g_clear_object(&island_channel);
  g_clear_pointer(&latest_snapshot, g_free);
}

void on_island_first_frame(FlView*, gpointer) {
  if (island_window != nullptr) gtk_widget_show(island_window);
}

void on_island_method(FlMethodChannel*, FlMethodCall* call, gpointer) {
  const gchar* method = fl_method_call_get_name(call);
  if (g_strcmp0(method, "ready") == 0) {
    island_ready = true;
    reply(call, fl_value_new_string(latest_snapshot != nullptr
                                        ? latest_snapshot
                                        : "{}"));
    return;
  }
  if (g_strcmp0(method, "shape") == 0) {
    FlValue* value = fl_method_call_get_args(call);
    if (island_window != nullptr && value != nullptr &&
        fl_value_get_type(value) == FL_VALUE_TYPE_INT) {
      set_input_region(static_cast<gint>(fl_value_get_int(value)));
    }
    reply(call);
    return;
  }
  if (g_strcmp0(method, "decide") == 0 ||
      g_strcmp0(method, "reveal") == 0) {
    if (main_channel != nullptr) {
      fl_method_channel_invoke_method(main_channel, method,
                                      fl_method_call_get_args(call), nullptr,
                                      nullptr, nullptr);
    }
    reply(call);
    return;
  }
  fl_method_call_respond_not_implemented(call, nullptr);
}

void create_island_window() {
  GtkApplication* app = GTK_APPLICATION(g_application_get_default());
  island_window = gtk_application_window_new(app);
  g_signal_connect(island_window, "destroy", G_CALLBACK(on_island_destroy),
                   nullptr);
  GtkWindow* window = GTK_WINDOW(island_window);
  gtk_window_set_title(window, "GSH Desktop");
  gtk_window_set_decorated(window, FALSE);
  gtk_window_set_default_size(window, 400, 500);
  gtk_widget_set_app_paintable(island_window, TRUE);
  GdkVisual* rgba = gdk_screen_get_rgba_visual(gtk_widget_get_screen(island_window));
  if (rgba != nullptr) gtk_widget_set_visual(island_window, rgba);

  // layer-shell exige uma GtkWindow ainda não realizada. O callback do
  // desktop_multi_window chega depois do realize, então a ilha nasce aqui.
  gtk_layer_init_for_window(window);
  gtk_layer_set_namespace(window, "gsh-agent-island");
  gtk_layer_set_layer(window, GTK_LAYER_SHELL_LAYER_OVERLAY);
  gtk_layer_set_anchor(window, GTK_LAYER_SHELL_EDGE_TOP, TRUE);
  gtk_layer_set_margin(window, GTK_LAYER_SHELL_EDGE_TOP, 6);
  gtk_layer_set_keyboard_mode(window, GTK_LAYER_SHELL_KEYBOARD_MODE_ON_DEMAND);

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  const char* args[] = {"agent_island", nullptr};
  fl_dart_project_set_dart_entrypoint_arguments(project,
                                                const_cast<char**>(args));
  FlView* view = fl_view_new(project);
  GdkRGBA transparent = {0, 0, 0, 0};
  fl_view_set_background_color(view, &transparent);
  gtk_container_add(GTK_CONTAINER(island_window), GTK_WIDGET(view));
  gtk_widget_show(GTK_WIDGET(view));
  g_signal_connect(view, "first-frame", G_CALLBACK(on_island_first_frame),
                   nullptr);
  gtk_widget_realize(GTK_WIDGET(view));
  set_input_region(0);
  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  g_autoptr(FlPluginRegistrar) registrar =
      fl_plugin_registry_get_registrar_for_plugin(FL_PLUGIN_REGISTRY(view),
                                                  "GshAgentIsland");
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  island_channel = fl_method_channel_new(
      fl_plugin_registrar_get_messenger(registrar), "gsh/agent_island",
      FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(island_channel, on_island_method,
                                            nullptr, nullptr);
}

void on_main_method(FlMethodChannel*, FlMethodCall* call, gpointer) {
  const gchar* method = fl_method_call_get_name(call);
  if (g_strcmp0(method, "update") == 0) {
    FlValue* value = fl_method_call_get_args(call);
    if (value == nullptr || fl_value_get_type(value) != FL_VALUE_TYPE_STRING ||
        !gtk_layer_is_supported()) {
      reply(call, fl_value_new_bool(FALSE));
      return;
    }
    g_free(latest_snapshot);
    latest_snapshot = g_strdup(fl_value_get_string(value));
    if (island_window == nullptr) create_island_window();
    if (island_ready && island_channel != nullptr) {
      fl_method_channel_invoke_method(
          island_channel, "snapshot", fl_value_new_string(latest_snapshot),
          nullptr, nullptr, nullptr);
    }
    reply(call, fl_value_new_bool(TRUE));
    return;
  }
  if (g_strcmp0(method, "hide") == 0) {
    gsh_agent_island_close();
    reply(call);
    return;
  }
  fl_method_call_respond_not_implemented(call, nullptr);
}

}  // namespace

void gsh_agent_island_init_main(FlView* view) {
  g_autoptr(FlPluginRegistrar) registrar =
      fl_plugin_registry_get_registrar_for_plugin(FL_PLUGIN_REGISTRY(view),
                                                  "GshAgentIslandMain");
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  main_channel = fl_method_channel_new(
      fl_plugin_registrar_get_messenger(registrar), "gsh/agent_island",
      FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(main_channel, on_main_method,
                                            nullptr, nullptr);
}

void gsh_agent_island_close() {
  if (island_window != nullptr) gtk_widget_destroy(island_window);
}

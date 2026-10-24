#include "gpu_environment.h"

#include <unistd.h>

#include <cstdlib>

namespace {

bool is_enabled(const char* value) {
  return value != nullptr && std::string(value) == "1";
}

void set_default(const char* name, const char* value) {
  if (std::getenv(name) == nullptr) setenv(name, value, 0);
}

}  // namespace

std::string configure_linux_gpu_environment() {
  if (is_enabled(std::getenv("GSH_USE_NVIDIA"))) {
    set_default("__NV_PRIME_RENDER_OFFLOAD", "1");
    set_default("__GLX_VENDOR_LIBRARY_NAME", "nvidia");
    set_default("__VK_LAYER_NV_optimus", "NVIDIA_only");
    return "nvidia-opt-in";
  }

  // Omarchy/Hyprland sessions can export these globally for the compositor.
  // Letting them leak into Flutter silently selected NVIDIA EGL despite the
  // GSH launcher claiming to prefer Intel, and recent cores ended inside
  // libnvidia-eglcore. This changes only GSH and its descendants.
  unsetenv("__NV_PRIME_RENDER_OFFLOAD");
  unsetenv("__GLX_VENDOR_LIBRARY_NAME");
  unsetenv("__VK_LAYER_NV_optimus");
  unsetenv("__EGL_VENDOR_LIBRARY_FILENAMES");
  unsetenv("VK_ICD_FILENAMES");
  unsetenv("GBM_BACKEND");
  unsetenv("LIBVA_DRIVER_NAME");
  // Integrated GPU is Mesa's default when DRI_PRIME is unset. "0" is not a
  // valid value: Mesa printed "Invalid value (0) for DRI_PRIME" on every
  // child process, and that line even leaked into a terminal's resolved cwd.
  unsetenv("DRI_PRIME");

  // Selecting the integrated GPU is not enough to keep NVIDIA's EGL vendor
  // out of a Wayland client on hybrid systems, so machines with the NVIDIA
  // driver loaded default to XWayland (the non-crashing path). Everyone else
  // on a Wayland session gets native Wayland: under XWayland (seen on
  // COSMIC) the app received a stream of spurious leave/enter crossing
  // events while the pointer rested on a button, so hover highlights
  // blinked like phantom clicks and tooltips never got their 500 ms. An
  // explicit GDK_BACKEND from the user still wins, for diagnostics/rollback.
  const bool wayland_session = std::getenv("WAYLAND_DISPLAY") != nullptr;
  const bool nvidia_loaded = access("/dev/nvidiactl", F_OK) == 0;
  if (wayland_session && !nvidia_loaded) {
    set_default("GDK_BACKEND", "wayland");
    return "integrated-wayland-default";
  }
  set_default("GDK_BACKEND", "x11");
  return "integrated-x11-default";
}

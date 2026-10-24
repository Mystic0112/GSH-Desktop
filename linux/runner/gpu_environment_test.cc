#include "gpu_environment.h"

#include <unistd.h>

#include <cassert>
#include <cstdlib>
#include <string>

int main() {
  // The NVIDIA probe reads /dev/nvidiactl, so the expected default depends
  // on the machine running the test.
  const bool nvidia = access("/dev/nvidiactl", F_OK) == 0;

  setenv("__GLX_VENDOR_LIBRARY_NAME", "nvidia", 1);
  setenv("__NV_PRIME_RENDER_OFFLOAD", "1", 1);
  setenv("LIBVA_DRIVER_NAME", "nvidia", 1);
  setenv("DRI_PRIME", "0", 1);
  unsetenv("GSH_USE_NVIDIA");
  unsetenv("GDK_BACKEND");

  // X11 session: always XWayland-style default.
  unsetenv("WAYLAND_DISPLAY");
  assert(configure_linux_gpu_environment() == "integrated-x11-default");
  assert(std::getenv("__GLX_VENDOR_LIBRARY_NAME") == nullptr);
  assert(std::getenv("__NV_PRIME_RENDER_OFFLOAD") == nullptr);
  assert(std::getenv("LIBVA_DRIVER_NAME") == nullptr);
  assert(std::getenv("DRI_PRIME") == nullptr);
  assert(std::string(std::getenv("GDK_BACKEND")) == "x11");

  // Wayland session: native Wayland unless the NVIDIA driver is loaded.
  unsetenv("GDK_BACKEND");
  setenv("WAYLAND_DISPLAY", "wayland-0", 1);
  assert(configure_linux_gpu_environment() ==
         (nvidia ? "integrated-x11-default" : "integrated-wayland-default"));
  assert(std::string(std::getenv("GDK_BACKEND")) == (nvidia ? "x11" : "wayland"));

  // Explicit user choice always wins.
  setenv("GDK_BACKEND", "x11", 1);
  configure_linux_gpu_environment();
  assert(std::string(std::getenv("GDK_BACKEND")) == "x11");

  setenv("GSH_USE_NVIDIA", "1", 1);
  unsetenv("GDK_BACKEND");
  unsetenv("__GLX_VENDOR_LIBRARY_NAME");
  unsetenv("__NV_PRIME_RENDER_OFFLOAD");
  assert(configure_linux_gpu_environment() == "nvidia-opt-in");
  assert(std::string(std::getenv("__GLX_VENDOR_LIBRARY_NAME")) == "nvidia");
  assert(std::string(std::getenv("__NV_PRIME_RENDER_OFFLOAD")) == "1");
  assert(std::getenv("GDK_BACKEND") == nullptr);

  setenv("CLAUDECODE", "1", 1);
  setenv("CLAUDE_CODE_CHILD_SESSION", "1", 1);
  setenv("CLAUDE_EFFORT", "high", 1);
  assert(drop_inherited_claude_session() >= 2);
  assert(std::getenv("CLAUDECODE") == nullptr);
  assert(std::getenv("CLAUDE_CODE_CHILD_SESSION") == nullptr);
  assert(std::string(std::getenv("CLAUDE_EFFORT")) == "high");
  return 0;
}

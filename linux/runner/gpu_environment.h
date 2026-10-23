#ifndef GSH_GPU_ENVIRONMENT_H_
#define GSH_GPU_ENVIRONMENT_H_

#include <string>

// Applies GSH's process-local hybrid GPU policy before GTK/EGL starts.
// Returns a content-free description suitable for the startup log.
std::string configure_linux_gpu_environment();

#endif  // GSH_GPU_ENVIRONMENT_H_

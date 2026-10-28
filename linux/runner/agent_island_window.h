#ifndef GSH_AGENT_ISLAND_WINDOW_H_
#define GSH_AGENT_ISLAND_WINDOW_H_

#include <flutter_linux/flutter_linux.h>

// Liga o engine principal à janela layer-shell da ilha (Linux/Wayland).
void gsh_agent_island_init_main(FlView* view);
void gsh_agent_island_close();

#endif  // GSH_AGENT_ISLAND_WINDOW_H_

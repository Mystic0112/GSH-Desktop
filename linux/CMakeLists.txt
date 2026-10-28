# Project-level configuration.
cmake_minimum_required(VERSION 3.13)
project(runner LANGUAGES CXX)

# The name of the executable created for the application. Change this to change
# the on-disk name of your application.
set(BINARY_NAME "gsh")
# The unique GTK application identifier for this application. See:
# https://wiki.gnome.org/HowDoI/ChooseApplicationID
set(APPLICATION_ID "work.gorila.gshdesktop")

# Explicitly opt in to modern CMake behaviors to avoid warnings with recent
# versions of CMake.
cmake_policy(SET CMP0063 NEW)

# Load bundled libraries from the lib/ directory relative to the binary.
set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

# Root filesystem for cross-building.
if(FLUTTER_TARGET_PLATFORM_SYSROOT)
  set(CMAKE_SYSROOT ${FLUTTER_TARGET_PLATFORM_SYSROOT})
  set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
  set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
endif()

# Define build configuration options.
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE "Debug" CACHE
    STRING "Flutter build mode" FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Profile" "Release")
endif()

# Compilation settings that should be applied to most targets.
#
# Be cautious about adding new options here, as plugins use this function by
# default. In most cases, you should add new options to specific targets instead
# of modifying this function.
function(APPLY_STANDARD_SETTINGS TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_14)
  target_compile_options(${TARGET} PRIVATE -Wall -Werror)
  target_compile_options(${TARGET} PRIVATE "$<$<NOT:$<CONFIG:Debug>>:-O3>")
  target_compile_definitions(${TARGET} PRIVATE "$<$<NOT:$<CONFIG:Debug>>:NDEBUG>")
endfunction()

# Flutter library and tool build rules.
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(${FLUTTER_MANAGED_DIR})

# System-level dependencies.
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK REQUIRED IMPORTED_TARGET gtk+-3.0)
pkg_check_modules(GTK_LAYER_SHELL REQUIRED IMPORTED_TARGET gtk-layer-shell-0)

# Application build; see runner/CMakeLists.txt.
add_subdirectory("runner")

# Run the Flutter tool portions of the build. This must not be removed.
add_dependencies(${BINARY_NAME} flutter_assemble)

# Only the install-generated bundle's copy of the executable will launch
# correctly, since the resources must in the right relative locations. To avoid
# people trying to run the unbundled copy, put it in a subdirectory instead of
# the default top-level location.
set_target_properties(${BINARY_NAME}
  PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/intermediates_do_not_run"
)


# Generated plugin build rules, which manage building the plugins and adding
# them to the application.
include(flutter/generated_plugins.cmake)

# flutter_secure_storage_linux 1.x bundles an older nlohmann/json header. New
# Clang versions warn about its pre-C++14 literal-operator syntax; plugins share
# APPLY_STANDARD_SETTINGS, so our global -Werror turned that upstream warning
# into a build failure. Keep warnings-as-errors for the app and every other
# warning, but exempt this known third-party deprecation until the secure-storage
# package can be upgraded as a compatible set.
if(TARGET flutter_secure_storage_linux_plugin)
  target_compile_options(flutter_secure_storage_linux_plugin PRIVATE
    "$<$<CXX_COMPILER_ID:Clang>:-Wno-error=deprecated-literal-operator>")
endif()

# === Installation ===
# By default, "installing" just makes a relocatable bundle in the build
# directory.
set(BUILD_BUNDLE_DIR "${PROJECT_BINARY_DIR}/bundle")
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "..." FORCE)
endif()

# Start with a clean build bundle directory every time.
install(CODE "
  file(REMOVE_RECURSE \"${BUILD_BUNDLE_DIR}/\")
  " COMPONENT Runtime)

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib")

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

foreach(bundled_library ${PLUGIN_BUNDLED_LIBRARIES})
  install(FILES "${bundled_library}"
    DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
    COMPONENT Runtime)
endforeach(bundled_library)

# Copy the native assets provided by the build.dart from all packages.
set(NATIVE_ASSETS_DIR "${PROJECT_BUILD_DIR}native_assets/linux/")
install(DIRECTORY "${NATIVE_ASSETS_DIR}"
   DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
   COMPONENT Runtime)

# Fully re-copy the assets directory on each build to avoid having stale files
# from a previous install.
set(FLUTTER_ASSET_DIR_NAME "flutter_assets")
install(CODE "
  file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}\")
  " COMPONENT Runtime)
install(DIRECTORY "${PROJECT_BUILD_DIR}/${FLUTTER_ASSET_DIR_NAME}"
  DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)

# O plugin Linux de notificações lê app_name do version.json do Flutter,
# que vem do nome do pacote Dart. Preserve package_name e só ajuste o nome
# mostrado no COSMIC/GNOME.
install(CODE "
  file(READ \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}/version.json\" GSH_VERSION_JSON)
  string(REPLACE \"\\\"app_name\\\":\\\"gsh_desktop\\\"\"
                 \"\\\"app_name\\\":\\\"GSH Desktop\\\"\"
                 GSH_VERSION_JSON \"\${GSH_VERSION_JSON}\")
  file(WRITE \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}/version.json\"
       \"\${GSH_VERSION_JSON}\")
  " COMPONENT Runtime)

# O tarball é relocável: inclua a biblioteca de layer-shell ao lado do app
# para que a ilha funcione mesmo sem o pacote instalado no host.
find_library(GTK_LAYER_SHELL_RUNTIME NAMES gtk-layer-shell REQUIRED)
get_filename_component(GTK_LAYER_SHELL_REAL "${GTK_LAYER_SHELL_RUNTIME}" REALPATH)
install(FILES "${GTK_LAYER_SHELL_REAL}"
  DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  RENAME "libgtk-layer-shell.so.0"
  COMPONENT Runtime)

# Install the AOT library on non-Debug builds only.
if(NOT CMAKE_BUILD_TYPE MATCHES "Debug")
  install(FILES "${AOT_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
    COMPONENT Runtime)
endif()

# === tool → gsh-hook + gsh-cli (helpers Dart AOT) ===
# Compila o helper de hook (status de turno do claude) e a CLI interna
# (send/send-key/list-panes/open) e os instala **ao lado do binário** (raiz do
# bundle, onde o [_bundledHelper] os procura). Em runtime o ClaudeHookInstaller
# os materializa em ~/.gsh/bin. Equivale ao build_hook.sh/build_cli.sh do
# macOS e ao bloco correspondente no windows/CMakeLists.txt.
if(DEFINED ENV{FLUTTER_ROOT})
  set(DART_EXE "$ENV{FLUTTER_ROOT}/bin/dart")
else()
  set(DART_EXE "dart")
endif()

set(GSH_HOOK_SRC "${CMAKE_SOURCE_DIR}/../tool/gsh_hook.dart")
set(GSH_HOOK_EXE "${CMAKE_BINARY_DIR}/gsh-hook")
add_custom_command(
  OUTPUT "${GSH_HOOK_EXE}"
  COMMAND "${DART_EXE}" compile exe "${GSH_HOOK_SRC}" -o "${GSH_HOOK_EXE}"
  DEPENDS "${GSH_HOOK_SRC}"
  COMMENT "Compilando gsh-hook"
  VERBATIM)
add_custom_target(gsh_hook ALL DEPENDS "${GSH_HOOK_EXE}")
install(PROGRAMS "${GSH_HOOK_EXE}" DESTINATION "${CMAKE_INSTALL_PREFIX}"
  COMPONENT Runtime)

# === cli/ → gsh-cli (CLI interna em Rust, com o hook como subcomando) ===
# A CLI absorveu o antigo helper `gsh-hook`: `gsh hook` faz o mesmo
# papel. Rust porque o `dart compile exe` sai de UMA arquitetura, não
# cross-compila e não sobrevive ao `lipo` — ver macos/build_cli.sh.
set(GSH_CLI_CRATE "${CMAKE_SOURCE_DIR}/../cli")
# O PATH do processo que roda o CMake nem sempre traz o `cargo` (IDE/launcher
# não herda o shell de login), então a instalação padrão do rustup entra como
# hint — mesma resolução do `resolve_cargo` do macos/build_cli.sh. Falhar aqui,
# no configure, troca o "no such file or directory" do ninja por uma causa.
find_program(CARGO_EXECUTABLE cargo HINTS "$ENV{HOME}/.cargo/bin")
if(NOT CARGO_EXECUTABLE)
  message(FATAL_ERROR
    "'cargo' não encontrado: a CLI interna (cli/) é um crate Rust e faz parte "
    "do build. Instale o Rust (https://rustup.rs) e rode o build de novo.")
endif()
# `build.rs` entra na lista: é ele que assa o flavor no binário, e uma
# mudança lá não mexe em `src/` — sem isto o CMake daria a CLI por
# atualizada. Mesma classe do glob do servidor logo abaixo.
file(GLOB_RECURSE GSH_CLI_SOURCES CONFIGURE_DEPENDS
  "${GSH_CLI_CRATE}/src/*.rs" "${GSH_CLI_CRATE}/text/*"
  "${GSH_CLI_CRATE}/build.rs")
set(GSH_CLI_BUILT "${GSH_CLI_CRATE}/target/release/gsh")
set(GSH_CLI_EXE "${CMAKE_BINARY_DIR}/gsh-cli")
# Flavor assado no binário (ver cli/build.rs): decide qual socket a CLI procura
# primeiro quando roda fora de um terminal do GSH.
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(GSH_CLI_FLAVOR "debug")
else()
  set(GSH_CLI_FLAVOR "release")
endif()
add_custom_command(
  OUTPUT "${GSH_CLI_EXE}"
  COMMAND "${CMAKE_COMMAND}" -E env "GSH_FLAVOR=${GSH_CLI_FLAVOR}"
          "${CARGO_EXECUTABLE}" build --release
          --manifest-path "${GSH_CLI_CRATE}/Cargo.toml"
  COMMAND "${CMAKE_COMMAND}" -E copy "${GSH_CLI_BUILT}" "${GSH_CLI_EXE}"
  DEPENDS ${GSH_CLI_SOURCES} "${GSH_CLI_CRATE}/Cargo.toml"
  COMMENT "Compilando gsh-cli (Rust)"
  VERBATIM)
add_custom_target(gsh_cli ALL DEPENDS "${GSH_CLI_EXE}")
install(PROGRAMS "${GSH_CLI_EXE}" DESTINATION "${CMAKE_INSTALL_PREFIX}"
  COMPONENT Runtime)

# === Desktop integration (nome + ícone para publicação) ===
# .desktop com Name=GSH, e ícones do tema hicolor nomeados pelo
# APPLICATION_ID (work.gorila.gshdesktop) — é assim que o launcher/dock e a
# barra de tarefas resolvem nome e ícone do app empacotado (deb/AppImage/snap).
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/gshdesktop.desktop"
  DESTINATION "${CMAKE_INSTALL_PREFIX}/share/applications"
  RENAME "${APPLICATION_ID}.desktop"
  COMPONENT Runtime)

# Tipos de arquivo do GSH (.kanban/.ckp/.dbq/.http) pro "Abrir com" do
# gerenciador de arquivos — o .desktop acima declara os MimeType.
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/${APPLICATION_ID}.xml"
  DESTINATION "${CMAKE_INSTALL_PREFIX}/share/mime/packages"
  COMPONENT Runtime)

foreach(icon_size 64 128 256 512 1024)
  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/runner/resources/app_icon_${icon_size}.png"
    DESTINATION "${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/${icon_size}x${icon_size}/apps"
    RENAME "${APPLICATION_ID}.png"
    COMPONENT Runtime)
endforeach()

# AppStream metainfo — descreve o app pra centros de software/empacotadores.
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/${APPLICATION_ID}.metainfo.xml"
  DESTINATION "${CMAKE_INSTALL_PREFIX}/share/metainfo"
  COMPONENT Runtime)

# === gsh-server (sidecar) ===
# Bundle `bin/` + `lib/` do servidor headless, instalado AO LADO do executável
# (mesmo lugar do gsh-hook e da gsh-cli; o deb/rpm empacota o prefixo
# inteiro). Equivale ao Run Script do macOS (build_server.sh); sem isto o app
# cai no fallback in-process e o Linux roda uma arquitetura diferente do macOS.
#
# `dart build cli` NÃO cross-compila, mas aqui não é problema: o CI compila cada
# arquitetura no seu próprio runner nativo (x64 e arm64).
set(GSH_SERVER_PKG "${CMAKE_SOURCE_DIR}/../packages/gsh_server")
set(GSH_SERVER_DIR "${CMAKE_BINARY_DIR}/server-bundle")
set(GSH_SERVER_EXE "${GSH_SERVER_DIR}/bin/gsh-server")
# O servidor NÃO é só o pacote dele: depende dos irmãos por `path:`
# (gsh_core, gsh_engine, gsh_protocol). Com o glob olhando só
# `gsh_server/`, editar o engine não invalidava nada e o CMake dava o
# bundle por atualizado — o build saía com um `gsh-server` VELHO, em
# silêncio. Mesmo ajuste do windows/CMakeLists.txt.
file(GLOB_RECURSE GSH_SERVER_SOURCES CONFIGURE_DEPENDS
  "${GSH_SERVER_PKG}/bin/*.dart" "${GSH_SERVER_PKG}/lib/*.dart"
  "${GSH_SERVER_PKG}/../gsh_core/lib/*.dart"
  "${GSH_SERVER_PKG}/../gsh_engine/lib/*.dart"
  "${GSH_SERVER_PKG}/../gsh_protocol/lib/*.dart")
add_custom_command(
  OUTPUT "${GSH_SERVER_EXE}"
  # Bundle limpo: `dart build cli` recusa diretório de saída já existente.
  COMMAND "${CMAKE_COMMAND}" -E rm -rf "${GSH_SERVER_DIR}" "${CMAKE_BINARY_DIR}/server-out"
  COMMAND "${CMAKE_COMMAND}" -E chdir "${GSH_SERVER_PKG}" "${DART_EXE}" pub get
  COMMAND "${CMAKE_COMMAND}" -E chdir "${GSH_SERVER_PKG}" "${DART_EXE}" build cli
          -o "${CMAKE_BINARY_DIR}/server-out"
  # `dart build cli` gera <out>/bundle/{bin,lib}; o exe sai com underscore.
  COMMAND "${CMAKE_COMMAND}" -E copy_directory
          "${CMAKE_BINARY_DIR}/server-out/bundle" "${GSH_SERVER_DIR}"
  COMMAND "${CMAKE_COMMAND}" -E rename
          "${GSH_SERVER_DIR}/bin/gsh_server" "${GSH_SERVER_EXE}"
  # A lib do PTY vai ao LADO do exe do servidor: é o 2º candidato do
  # openPtyDylib (o 1º é a env GSH_PTY_DYLIB, que o sidecar preenche).
  # Reusa o artefato do plugin em vez de compilar o mesmo .c duas vezes.
  COMMAND "${CMAKE_COMMAND}" -E copy
          "$<TARGET_FILE:gsh_pty>" "${GSH_SERVER_DIR}/bin/"
  # CLI embarcada ao lado do servidor (plano 60, Wave G): o servidor instala o
  # hook do agente apontando pra ela, e a acha na mesma pasta bin/.
  COMMAND "${CMAKE_COMMAND}" -E copy
          "${GSH_CLI_EXE}" "${GSH_SERVER_DIR}/bin/gsh"
  DEPENDS ${GSH_SERVER_SOURCES} "${GSH_SERVER_PKG}/pubspec.yaml"
          "${GSH_CLI_EXE}" gsh_pty
  COMMENT "Compilando gsh-server (bundle do sidecar)"
  VERBATIM)
add_custom_target(gsh_server ALL DEPENDS "${GSH_SERVER_EXE}")
install(DIRECTORY "${GSH_SERVER_DIR}/"
  DESTINATION "${CMAKE_INSTALL_PREFIX}/gsh-server-bundle"
  USE_SOURCE_PERMISSIONS COMPONENT Runtime)

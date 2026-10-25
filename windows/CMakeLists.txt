# Project-level configuration.
cmake_minimum_required(VERSION 3.14)
project(gsh LANGUAGES CXX)

# The name of the executable created for the application. Change this to change
# the on-disk name of your application.
set(BINARY_NAME "gsh")

# Explicitly opt in to modern CMake behaviors to avoid warnings with recent
# versions of CMake.
cmake_policy(VERSION 3.14...3.25)

# Define build configuration option.
get_property(IS_MULTICONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(IS_MULTICONFIG)
  set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release"
    CACHE STRING "" FORCE)
else()
  if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE
      STRING "Flutter build mode" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
      "Debug" "Profile" "Release")
  endif()
endif()
# Define settings for the Profile build mode.
set(CMAKE_EXE_LINKER_FLAGS_PROFILE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
set(CMAKE_SHARED_LINKER_FLAGS_PROFILE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
set(CMAKE_C_FLAGS_PROFILE "${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_PROFILE "${CMAKE_CXX_FLAGS_RELEASE}")

# Use Unicode for all projects.
add_definitions(-DUNICODE -D_UNICODE)

# O flutter_inappwebview_windows ainda inclui <experimental/coroutine>, que o
# MSVC 14.51 transformou em erro de compilação (STL1011). Enquanto o plugin não
# migra pro <coroutine> do C++20, silencia o guard — senão o build do Windows
# não passa.
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

# Compilações paralelas do MSVC (cl /MP) escrevendo no mesmo .pdb estouram
# C1041 no flutter_inappwebview_windows; /FS serializa o acesso ao PDB.
add_compile_options(/FS)

# Compilation settings that should be applied to most targets.
#
# Be cautious about adding new options here, as plugins use this function by
# default. In most cases, you should add new options to specific targets instead
# of modifying this function.
function(APPLY_STANDARD_SETTINGS TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_17)
  target_compile_options(${TARGET} PRIVATE /W4 /WX /wd"4100")
  target_compile_options(${TARGET} PRIVATE /EHsc)
  target_compile_definitions(${TARGET} PRIVATE "_HAS_EXCEPTIONS=0")
  target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
endfunction()

# Flutter library and tool build rules.
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(${FLUTTER_MANAGED_DIR})

# Application build; see runner/CMakeLists.txt.
add_subdirectory("runner")


# Generated plugin build rules, which manage building the plugins and adding
# them to the application.
include(flutter/generated_plugins.cmake)


# === Installation ===
# Support files are copied into place next to the executable, so that it can
# run in place. This is done instead of making a separate bundle (as on Linux)
# so that building and running from within Visual Studio will work.
set(BUILD_BUNDLE_DIR "$<TARGET_FILE_DIR:${BINARY_NAME}>")
# Make the "install" step default, as it's required to run.
set(CMAKE_VS_INCLUDE_INSTALL_TO_DEFAULT_BUILD 1)
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "..." FORCE)
endif()

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

if(PLUGIN_BUNDLED_LIBRARIES)
  install(FILES "${PLUGIN_BUNDLED_LIBRARIES}"
    DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
    COMPONENT Runtime)
endif()

# === gsh-hook helper (status de turno do claude nas abas) ===
# Compila o helper que o claude invoca nos hooks e o instala ao lado do binário
# (o Inno empacota o bundle inteiro). Em runtime o ClaudeHookInstaller o extrai
# pra ~/.gsh/bin. Equivale ao Run Script phase do macOS (build_hook.sh).
set(GSH_HOOK_SRC "${CMAKE_SOURCE_DIR}/../tool/gsh_hook.dart")
set(GSH_HOOK_EXE "${CMAKE_BINARY_DIR}/gsh-hook.exe")
if(DEFINED ENV{FLUTTER_ROOT})
  set(DART_EXE "$ENV{FLUTTER_ROOT}/bin/dart.bat")
else()
  set(DART_EXE "dart")
endif()
add_custom_command(
  OUTPUT "${GSH_HOOK_EXE}"
  COMMAND "${DART_EXE}" compile exe "${GSH_HOOK_SRC}" -o "${GSH_HOOK_EXE}"
  DEPENDS "${GSH_HOOK_SRC}"
  COMMENT "Compilando gsh-hook.exe"
  VERBATIM)
add_custom_target(gsh_hook ALL DEPENDS "${GSH_HOOK_EXE}")
install(PROGRAMS "${GSH_HOOK_EXE}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

# === gsh CLI (CLI interna: send/send-key/list-panes) ===
# Compila a CLI como `gsh-cli.exe` (nome distinto do runner) e a instala ao
# lado do binário. Em runtime o ClaudeHookInstaller a materializa como
# ~/.gsh/bin/gsh.exe. Equivale ao Run Script phase do macOS (build_cli.sh).
# === cli/ → gsh-cli (CLI interna em Rust, com o hook como subcomando) ===
# A CLI absorveu o antigo helper `gsh-hook`: `gsh hook` faz o mesmo
# papel. Rust porque o `dart compile exe` sai de UMA arquitetura, não
# cross-compila e não sobrevive ao `lipo` — ver macos/build_cli.sh.
set(GSH_CLI_CRATE "${CMAKE_SOURCE_DIR}/../cli")
# O PATH do processo que roda o CMake nem sempre traz o `cargo` (IDE/launcher
# não herda o shell de login), então a instalação padrão do rustup entra como
# hint — mesma resolução do `resolve_cargo` do macos/build_cli.sh. Falhar aqui,
# no configure, troca o "no such file or directory" do ninja por uma causa.
find_program(CARGO_EXECUTABLE cargo HINTS "$ENV{USERPROFILE}/.cargo/bin")
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
set(GSH_CLI_BUILT "${GSH_CLI_CRATE}/target/release/gsh.exe")
set(GSH_CLI_EXE "${CMAKE_BINARY_DIR}/gsh-cli.exe")
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
  COMMENT "Compilando gsh-cli.exe (Rust)"
  VERBATIM)
add_custom_target(gsh_cli ALL DEPENDS "${GSH_CLI_EXE}")
install(PROGRAMS "${GSH_CLI_EXE}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

# === ConPTY moderno (OpenConsole embarcado) ===
# O `CreatePseudoConsole` do kernel32 usa o conhost que vem com o Windows; no
# Windows 10 ele é a geração legada do ConPTY, que não repassa tela alternativa
# (`?1049h`) nem modos de mouse ao terminal e desalinha o cursor na repintura
# do PSReadLine. Embarcamos `conpty.dll` + `OpenConsole.exe` do pacote oficial
# `Microsoft.Windows.Console.ConPTY` (o mesmo que o Windows Terminal, WezTerm e
# Alacritty embarcam); o `gsh_pty.dll` carrega o `conpty.dll` da própria
# pasta e cai no kernel32 se faltar (ver gsh_pty_win.c). Os dois arquivos
# precisam ficar na MESMA pasta do `gsh_pty.dll`: no bundle do sidecar
# (`bin/`) e ao lado do `gsh.exe` (fallback in-process).
set(CONPTY_VERSION "1.25.260930003")
set(CONPTY_SHA256 "02b07b349af66d801159bdf9e440d4a1ce78bb951f37fc8609731665afdae7ee")
set(CONPTY_NUPKG "${CMAKE_BINARY_DIR}/conpty/microsoft.windows.console.conpty.${CONPTY_VERSION}.nupkg")
set(CONPTY_EXTRACT_DIR "${CMAKE_BINARY_DIR}/conpty/pkg")
set(CONPTY_DLL "${CONPTY_EXTRACT_DIR}/runtimes/win-x64/native/conpty.dll")
set(CONPTY_OPENCONSOLE "${CONPTY_EXTRACT_DIR}/build/native/runtimes/x64/OpenConsole.exe")
if(NOT EXISTS "${CONPTY_DLL}" OR NOT EXISTS "${CONPTY_OPENCONSOLE}")
  file(DOWNLOAD
    "https://api.nuget.org/v3-flatcontainer/microsoft.windows.console.conpty/${CONPTY_VERSION}/microsoft.windows.console.conpty.${CONPTY_VERSION}.nupkg"
    "${CONPTY_NUPKG}"
    EXPECTED_HASH SHA256=${CONPTY_SHA256}
    STATUS CONPTY_DOWNLOAD_STATUS)
  list(GET CONPTY_DOWNLOAD_STATUS 0 CONPTY_DOWNLOAD_CODE)
  if(NOT CONPTY_DOWNLOAD_CODE EQUAL 0)
    message(FATAL_ERROR "Falha ao baixar Microsoft.Windows.Console.ConPTY ${CONPTY_VERSION}: ${CONPTY_DOWNLOAD_STATUS}")
  endif()
  file(MAKE_DIRECTORY "${CONPTY_EXTRACT_DIR}")
  # .nupkg é um zip; `cmake -E tar` extrai sem depender de ferramenta externa.
  execute_process(
    COMMAND "${CMAKE_COMMAND}" -E tar xf "${CONPTY_NUPKG}"
    WORKING_DIRECTORY "${CONPTY_EXTRACT_DIR}"
    RESULT_VARIABLE CONPTY_EXTRACT_CODE)
  if(NOT CONPTY_EXTRACT_CODE EQUAL 0 OR NOT EXISTS "${CONPTY_DLL}")
    message(FATAL_ERROR "Falha ao extrair ${CONPTY_NUPKG}")
  endif()
endif()
# Ao lado do gsh.exe (mesma pasta do gsh_pty.dll do plugin).
install(FILES "${CONPTY_DLL}" "${CONPTY_OPENCONSOLE}"
  DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)

# === gsh-server (sidecar) ===
# Bundle `bin/` + `lib/` do servidor headless, instalado AO LADO do executável
# (o Inno empacota o bundle inteiro). Equivale ao Run Script do macOS
# (build_server.sh); sem isto o app cai no fallback in-process e o Windows roda
# uma arquitetura diferente do macOS.
#
# `dart build cli` NÃO cross-compila, mas aqui não é problema: o runner do CI é
# x64 nativo, a única arquitetura que publicamos no Windows.
set(GSH_SERVER_PKG "${CMAKE_SOURCE_DIR}/../packages/gsh_server")
set(GSH_SERVER_DIR "${CMAKE_BINARY_DIR}/server-bundle")
set(GSH_SERVER_EXE "${GSH_SERVER_DIR}/bin/gsh-server.exe")
# O servidor NÃO é só o pacote dele: depende dos irmãos por `path:`
# (gsh_core, gsh_engine, gsh_protocol). Enquanto o glob só olhava
# `gsh_server/`, editar o engine não invalidava nada e o CMake dava o
# bundle por atualizado — o build saía com um `gsh-server.exe` VELHO, em
# silêncio. Aconteceu com a correção do login shell em host Windows.
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
          "${GSH_SERVER_DIR}/bin/gsh_server.exe" "${GSH_SERVER_EXE}"
  # A lib do PTY vai ao LADO do exe do servidor: é o 2º candidato do
  # openPtyDylib (o 1º é a env GSH_PTY_DYLIB, que o sidecar preenche).
  # Reusa o artefato do plugin em vez de compilar o mesmo .c duas vezes.
  COMMAND "${CMAKE_COMMAND}" -E copy
          "$<TARGET_FILE:gsh_pty>" "${GSH_SERVER_DIR}/bin/"
  # ConPTY moderno ao lado do gsh_pty.dll do sidecar (ver bloco acima).
  COMMAND "${CMAKE_COMMAND}" -E copy
          "${CONPTY_DLL}" "${CONPTY_OPENCONSOLE}" "${GSH_SERVER_DIR}/bin/"
  # CLI embarcada ao lado do servidor (plano 60, Wave G): o servidor instala o
  # hook do agente apontando pra ela, e a acha na mesma pasta bin/.
  COMMAND "${CMAKE_COMMAND}" -E copy
          "${GSH_CLI_EXE}" "${GSH_SERVER_DIR}/bin/gsh.exe"
  DEPENDS ${GSH_SERVER_SOURCES} "${GSH_SERVER_PKG}/pubspec.yaml"
          "${GSH_CLI_EXE}" gsh_pty
  COMMENT "Compilando gsh-server (bundle do sidecar)"
  VERBATIM)
add_custom_target(gsh_server ALL DEPENDS "${GSH_SERVER_EXE}")
install(DIRECTORY "${GSH_SERVER_DIR}/"
  DESTINATION "${INSTALL_BUNDLE_LIB_DIR}/gsh-server-bundle"
  USE_SOURCE_PERMISSIONS COMPONENT Runtime)

# Copy the native assets provided by the build.dart from all packages.
set(NATIVE_ASSETS_DIR "${PROJECT_BUILD_DIR}native_assets/windows/")
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

# Install the AOT library on non-Debug builds only.
install(FILES "${AOT_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  CONFIGURATIONS Profile;Release
  COMPONENT Runtime)

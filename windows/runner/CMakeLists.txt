cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# Define the application target. To change its name, change BINARY_NAME in the
# top-level CMakeLists.txt, not the value here, or `flutter run` will no longer
# work.
#
# Any new source files that you add to the application should be added here.
add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
apply_standard_settings(${BINARY_NAME})

# Add preprocessor definitions for the build version.
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION=\"${FLUTTER_VERSION}\"")

# Versão "marketing": o FLUTTER_VERSION vem do pubspec COM o build number
# (`1.8.4+21`), e é ele que o Runner.rc punha no VERSIONINFO. Isso quebra o
# self-update: o WinSparkle compara a versão do appcast com esse string e
# classifica o `+` como Type_String, ou seja, lê `1.8.4+21` como um
# PRÉ-LANÇAMENTO de `1.8.4` (mesma regra que faz `1.5 > 1.5b3`). Resultado: o
# appcast `1.8.4` parece mais novo que o app `1.8.4+21` pra sempre, e o updater
# reoferece a mesma versão em loop.
#
# O appcast do Windows publica a versão marketing (ver gsh-release.yml), então
# o VERSIONINFO precisa publicar a mesma coisa. O build number não se perde: segue
# no 4º campo do FILEVERSION numérico (`1,8,4,21`), que é o lugar convencional
# dele no Windows.
# Sem FLUTTER_VERSION não há o que publicar no VERSIONINFO: abortar no configure
# é melhor que gerar um binário com versão falsa e descobrir pelo self-update
# quebrado na máquina do usuário.
if(NOT FLUTTER_VERSION)
  message(FATAL_ERROR
    "FLUTTER_VERSION não definido: o VERSIONINFO sairia com versão falsa e o "
    "self-update do WinSparkle compararia contra ela.")
endif()
string(REGEX REPLACE "\\+.*$" "" FLUTTER_VERSION_MARKETING "${FLUTTER_VERSION}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MARKETING=\"${FLUTTER_VERSION_MARKETING}\"")

target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}")

# `DartProject::set_impeller_switch` só existe a partir do Flutter 3.47 (quando
# o Impeller virou default no Windows). Em SDK mais antigo o Skia já é o padrão
# e a chamada não compila, então o main.cpp só a usa se o header a declarar.
# Lê o header do cache do SDK: a cópia em ephemeral/ só nasce no build, depois
# do configure. Sem achar o header, assume SDK novo (falha alto, não em silêncio).
set(GSH_DART_PROJECT_H
  "$ENV{FLUTTER_ROOT}/bin/cache/artifacts/engine/windows-x64/cpp_client_wrapper/include/flutter/dart_project.h")
set(GSH_IMPELLER_SWITCH_DECL TRUE)
if(DEFINED ENV{FLUTTER_ROOT} AND EXISTS "${GSH_DART_PROJECT_H}")
  file(STRINGS "${GSH_DART_PROJECT_H}" GSH_IMPELLER_SWITCH_DECL
    REGEX "set_impeller_switch")
endif()
if(GSH_IMPELLER_SWITCH_DECL)
  target_compile_definitions(${BINARY_NAME} PRIVATE "GSH_HAS_IMPELLER_SWITCH")
endif()

# Disable Windows macros that collide with C++ standard library functions.
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Add dependency libraries and include directories. Add any application-specific
# dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE "dwmapi.lib")
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Run the Flutter tool portions of the build. This must not be removed.
add_dependencies(${BINARY_NAME} flutter_assemble)

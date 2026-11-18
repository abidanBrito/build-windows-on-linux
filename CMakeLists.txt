cmake_minimum_required(VERSION 3.25)
project(build-windows-on-linux LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(hello src/hello.cpp)

add_executable(window WIN32 src/window.cpp)
target_compile_definitions(window PRIVATE UNICODE _UNICODE)

if(MINGW)
  target_link_options(window PRIVATE -municode)
endif()

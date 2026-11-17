# llvm-mingw, UCRT build
set(CMAKE_SYSTEM_NAME Windows)

set(CMAKE_CXX_COMPILER /opt/llvm-mingw/llvm-mingw-ucrt/bin/x86_64-w64-mingw32-clang++)
set(CMAKE_CXX_COMPILER_TARGET x86_64-w64-mingw32)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-static")

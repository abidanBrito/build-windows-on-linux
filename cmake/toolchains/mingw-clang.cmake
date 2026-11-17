# Host clang + mingw-w64
set(CMAKE_SYSTEM_NAME Windows)

set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_CXX_COMPILER_TARGET x86_64-w64-mingw32)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-static")

# NOTE(abi): stdc++exp: std::print's Windows terminal code (libstdc++).
#            winpthread: needed by static libstdc++; clang doesn't add it.
#            stdc++ first so winpthread links after it.
link_libraries(stdc++exp stdc++ winpthread)

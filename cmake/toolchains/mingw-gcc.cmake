# GCC cross-compiler
set(CMAKE_SYSTEM_NAME Windows)

set(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-static")

# NOTE(abi): stdc++exp: std::print's Windows terminal code (libstdc++).
#            g++ adds winpthread itself.
link_libraries(stdc++exp)

# clang-cl + Microsoft SDK/CRT via xwin
set(CMAKE_SYSTEM_NAME Windows)

set(CMAKE_CXX_COMPILER clang-cl)
set(CMAKE_CXX_COMPILER_TARGET x86_64-pc-windows-msvc)

# Microsoft's CRT, STL & Windows SDK, downloaded by:
# xwin --accept-license splat --output /opt/xwin
set(XWIN /opt/xwin)

# Headers
set(CMAKE_CXX_FLAGS_INIT
  "/imsvc ${XWIN}/crt/include \
   /imsvc ${XWIN}/sdk/include/ucrt \
   /imsvc ${XWIN}/sdk/include/um \
   /imsvc ${XWIN}/sdk/include/shared")

# Libraries
set(CMAKE_EXE_LINKER_FLAGS_INIT
  "/libpath:${XWIN}/crt/lib/x86_64 \
   /libpath:${XWIN}/sdk/lib/ucrt/x86_64 \
   /libpath:${XWIN}/sdk/lib/um/x86_64")

# Static CRT (/MT)
# NOTE(abi): default xwin splat has no debug CRT (/MTd, /MDd).
set(CMAKE_MSVC_RUNTIME_LIBRARY MultiThreaded)

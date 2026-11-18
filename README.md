# build-windows-on-linux

[![Build](https://github.com/abidanBrito/build-windows-on-linux/actions/workflows/build.yml/badge.svg)](https://github.com/abidanBrito/build-windows-on-linux/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-orange.svg)](https://github.com/abidanBrito/build-windows-on-linux/blob/main/LICENSE)

Cross-compiling a C++ Win32 GUI application from Linux, using four different toolchains. Every build is tested under [Wine](https://www.winehq.org/).

## Toolchains

| Preset          | Compiler        | C++ library | SDK / CRT              | Install (Arch)                                |
|-----------------|-----------------|-------------|------------------------|-----------------------------------------------|
| `mingw-clang`   | host clang      | libstdc++   | mingw-w64 (UCRT)       | `clang mingw-w64-gcc`                         |
| `mingw-gcc`     | GCC             | libstdc++   | mingw-w64 (UCRT)       | `mingw-w64-gcc`                               |
| `llvm-mingw`    | clang           | libc++      | mingw-w64 (UCRT)       | `llvm-mingw-w64-toolchain-ucrt-bin` (AUR)     |
| `xwin-clang-cl` | clang-cl        | MSVC STL    | Microsoft SDK + CRT    | `clang lld llvm` + `xwin` (AUR)               |

The first three use the mingw (GNU) ABI, whereas `xwin-clang-cl` uses the MSVC ABI, so in theory it can link libraries built with Visual Studio.

To download Microsoft's SDK and CRT with `xwin` (accepting Microsoft's license):

```sh
sudo mkdir /opt/xwin && sudo chown $USER: /opt/xwin
xwin --accept-license splat --output /opt/xwin
```

To run the executables (Arch): `pacman -S wine`.

## Build & run

```sh
cmake --preset mingw-clang
cmake --build --preset mingw-clang
wine build/mingw-clang/window.exe
```

`cmake --list-presets` shows all four. Every toolchain links statically, so that no extra DLLs (or `WINEPATH` shenanigans) are needed.

## Some notes

- **`std::print` on libstdc++** needs `-lstdc++exp`, since it lives in libstdc++'s experimental library.
- **Static libstdc++ with clang** needs `-lwinpthread` (after `-lstdc++`), but `g++` adds it by itself.
- **`wWinMain`**: `mingw` only uses it as the entry point with `-municode`, whereas `MSVC` finds it automatically.

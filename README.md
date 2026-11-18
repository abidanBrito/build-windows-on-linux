# build-windows-on-linux

[![Build](https://github.com/abidanBrito/build-windows-on-linux/actions/workflows/build.yml/badge.svg)](https://github.com/abidanBrito/build-windows-on-linux/actions/workflows/build.yml)
[![C++23](https://img.shields.io/badge/C%2B%2B-23-blue.svg)](https://en.cppreference.com/w/cpp/23)
[![CMake 3.25+](https://img.shields.io/badge/CMake-3.25%2B-064F8C.svg)](https://cmake.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-orange.svg)](https://github.com/abidanBrito/build-windows-on-linux/blob/main/LICENSE)

Cross-compiling C++ Windows programs from Linux with four different toolchains.

There are two sample programs, tested under [Wine](https://www.winehq.org/):

- [`hello`](src/hello.cpp): a console hello world, using `std::println`.
- [`window`](src/window.cpp): a basic Win32 GUI window.

## Toolchains

| Preset          | Compiler   | C++ library | SDK / CRT           | ABI   |
|-----------------|------------|-------------|---------------------|-------|
| `mingw-clang`   | host clang | libstdc++   | mingw-w64 (UCRT)    | GNU   |
| `mingw-gcc`     | GCC        | libstdc++   | mingw-w64 (UCRT)    | GNU   |
| `llvm-mingw`    | clang      | libc++      | mingw-w64 (UCRT)    | GNU   |
| `xwin-clang-cl` | clang-cl   | MSVC STL    | Microsoft SDK + CRT | MSVC  |

All of them link statically, so that no extra DLLs (or `WINEPATH` shenanigans) are needed. In theory, `xwin-clang-cl` can also link libraries built with Visual Studio.

## Install

### Ubuntu

```sh
sudo apt install cmake ninja-build wine
```

Ubuntu's own `clang` and `g++-mingw-w64-x86-64` are too old for C++23 (`<print>`, MSVC STL), so get them elsewhere:

- **Clang**: from [apt.llvm.org](https://apt.llvm.org), e.g. `wget https://apt.llvm.org/llvm.sh && sudo bash llvm.sh 23`
- **MinGW GCC**: from [Homebrew](https://brew.sh), with `brew install mingw-w64`, then add `$(brew --prefix mingw-w64)/toolchain-x86_64/bin` to your `PATH`
- **llvm-mingw** and **xwin**: grab the release tarballs from [llvm-mingw](https://github.com/mstorsjo/llvm-mingw/releases) (extracted to `/opt/llvm-mingw/llvm-mingw-ucrt`) and [xwin](https://github.com/Jake-Shadle/xwin/releases)

See [`build.yml`](.github/workflows/build.yml) for the exact steps.

### Arch

```sh
sudo pacman -S cmake ninja clang lld llvm mingw-w64-gcc wine
yay -S llvm-mingw-w64-toolchain-ucrt-bin xwin
```

### Microsoft SDK & CRT

This is only needed for `xwin-clang-cl`:

```sh
sudo mkdir /opt/xwin && sudo chown $USER: /opt/xwin
xwin --accept-license splat --output /opt/xwin
```

## Build & run

```sh
cmake --preset mingw-clang
cmake --build --preset mingw-clang

wine build/mingw-clang/hello.exe
wine build/mingw-clang/window.exe
```

> [!TIP]
> `cmake --list-presets` and `cmake --build --list-presets` show all available CMake presets.

## Some notes

These are already accounted for, but they're worth knowing:

- With `libstdc++`, `std::print` needs to link `stdc++exp`, as it lives in `libstdc++`'s experimental library.
- Linking `libstdc++` statically also requires `winpthread`, linked after `stdc++`. Note that `g++` adds it automatically, but `clang` doesn't.
- `mingw` only uses `wWinMain` as the entry point when linking with `-municode`, whereas `MSVC` picks it up on its own.
- `xwin-clang-cl` needs a recent clang (19+), since MSVC STL refuses older versions.

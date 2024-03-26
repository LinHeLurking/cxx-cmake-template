# SmallCmake

This repository is a small CMake project with vcpkg integration.
The `vcpkg.json` file includes GoogleTest dependency.

## Configure

If you have `VCPKG_ROOT` environment variable, cmake will try to load vcpkg from it.
```Bash
mkdir build && cd build 
cmake ..
```

If you have certain toolchain, cmake will combine it with vcpkg toolchain using vcpkg's chainloading capability.
cmake will find vcpkg from `VCPKG_ROOT` environment variable.
```Bash
mkdir build && cd build 
cmake -DVCPKG_CHAINLOAD_TOOLCHAIN_FILE=<...> ..
```

`toolchain/clang-latest.cmake` is a sample toolchain file trying to use latest installed version of clang.
You can try it.

`configure-clang-vcpkg.sh` is a helper script that uses aforementioned toolchain file and load vcpkg.
Try it with
```Bash
./configure-clang-vcpkg.sh
```

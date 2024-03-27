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

## Multi-Config

If you're using `ninja`, a generator supporting multi-config generation,
`configure-clang-vcpkg.sh` will automatically selects `Ninja Multi-Config`
as generator. Under such circumtance, cmake will produde several different
build files in binary directory with a default `Debug` target.
You can use `cd build && cmake --build . --config Release` or 
`cd build && ninja -f build-Release.ninja` to build Release target.
Replacing `Release` with other types such as `RelWithDebInfo` and `MinSizeRel`
also works.

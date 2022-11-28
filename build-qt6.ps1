$ErrorActionPreference = "Stop"

$qt_ver = "6.4.1"
$qt_main_ver = "6.4"
$qt_url = "https://download.qt.io/archive/qt/$qt_main_ver/$qt_ver/single/"
$qt_src = "qt-everywhere-src-$qt_ver.zip"
$work_dir = $pwd

$env:path += ";$vcpkg_dir\packages\zlib_arm64-windows\bin;$vcpkg_dir\packages\icu_arm64-windows\bin;$ninja_dir;$perl_dir\perl\bin;$cmake_dir\bin;$7zip_dir"

Invoke-Expression "$wget_dir\wget.exe $qt_url/$qt_src"
7z.exe x "$qt_src"

Set-Location  "qt-everywhere-src-$qt_ver"
New-Item -ItemType Directory -Path ./build -Force
Set-Location build
../configure -prefix $qt_install_dir -release -nomake examples -nomake tests -icu -system-zlib -schannel -no-openssl -skip qtwebengine -skip qtopcua -- -DCMAKE_TOOLCHAIN_FILE="$vcpkg_dir\scripts\buildsystems\vcpkg.cmake"
cmake --build .
cmake --install .

Set-Location $work_dir
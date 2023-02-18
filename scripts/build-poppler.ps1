$ErrorActionPreference = "Stop"
$work_dir = $pwd
$poppler_ver = "22.11.0"
$poppler_url = "https://poppler.freedesktop.org/poppler-$poppler_ver.tar.xz"

$env:path += ";$qt_install_dir\bin;$vcpkg_dir\packages\zlib_arm64-windows\bin;$vcpkg_dir\packages\icu_arm64-windows\bin;$ninja_dir;$cmake_dir\bin;$7zip_dir"

Invoke-Expression "$wget_dir\wget.exe $poppler_url"
7z.exe x poppler-$poppler_ver.tar.xz
tar -xf poppler-$poppler_ver.tar
Remove-Item poppler-$poppler_ver.tar

Set-Location poppler-$poppler_ver
New-Item -ItemType Directory -Path ./build -Force
Set-Location build
cmake -G "Ninja" -DCMAKE_INSTALL_PREFIX="$work_dir\install\poppler" -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE="$vcpkg_dir\scripts\buildsystems\vcpkg.cmake" -DENABLE_QT5=OFF -DENABLE_QT6=ON  ..
cmake --build .
cmake --install .

Set-Location $work_dir
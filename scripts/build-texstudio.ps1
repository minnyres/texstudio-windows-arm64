$ErrorActionPreference = "Stop"
$work_dir = $pwd
$texstudio_ver = "4.4.1"
$texstudio_url = "https://github.com/texstudio-org/texstudio/archive/refs/tags/$texstudio_ver.tar.gz"
$texstudio_bin_url = "https://github.com/texstudio-org/texstudio/releases/download/$texstudio_ver/texstudio-$texstudio_ver-win-portable-qt6.zip"
$textablet_url = "https://github.com/minnyres/TexTablet/releases/download/build-20221127/TeXTablet-Release-arm64.zip"
$env:path += ";$qt_install_dir\bin;$vcpkg_dir\packages\zlib_arm64-windows\bin;$vcpkg_dir\packages\icu_arm64-windows\bin;$ninja_dir;$cmake_dir\bin;$7zip_dir;"

Invoke-Expression "$wget_dir\wget.exe $texstudio_url"
Invoke-Expression "$wget_dir\wget.exe $texstudio_bin_url"
Invoke-Expression "$wget_dir\wget.exe $textablet_url"
Move-Item "$texstudio_ver.tar.gz" "texstudio-$texstudio_ver.tar.gz"
tar -xf texstudio-$texstudio_ver.tar.gz

Set-Location texstudio-$texstudio_ver
Set-Content -Path ".\CMakeLists.txt" -Value (get-content -Path ".\CMakeLists.txt" | Select-String -Pattern 'Wno-deprecated-declarations' -NotMatch)
New-Item -ItemType Directory -Path ./build -Force
Set-Location build
cmake -G "Ninja" -DCMAKE_INSTALL_PREFIX="$work_dir\install\texstudio" -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE="$vcpkg_dir\scripts\buildsystems\vcpkg.cmake"  -DCMAKE_PREFIX_PATH="$work_dir\install\poppler\" ..
cmake --build .
cmake --install .

Set-Location "$work_dir\install\texstudio"
7z.exe x "$work_dir\texstudio-$texstudio_ver-win-portable-qt6.zip"
Remove-Item *.dll
Remove-Item *.exe
Remove-Item -r iconengines
Remove-Item -r imageformats
Remove-Item -r platforms
Remove-Item -r styles
Remove-Item -r tls
Move-Item translations translations-copy
Move-Item bin\texstudio.exe . 
Remove-Item bin
windeployqt texstudio.exe
Remove-Item -r translations
Move-Item translations-copy translations
Copy-Item "$vcpkg_dir\installed\arm64-windows\bin\zlib1.dll" .
Copy-Item "$vcpkg_dir\installed\arm64-windows\bin\brotlidec.dll" .
Copy-Item "$vcpkg_dir\installed\arm64-windows\bin\freetype.dll" .
Copy-Item "$vcpkg_dir\installed\arm64-windows\bin\lcms2.dll" .
Copy-Item "$vcpkg_dir\installed\arm64-windows\bin\libpng16.dll" .
Copy-Item "$vcpkg_dir\installed\arm64-windows\bin\brotlicommon.dll" .
Copy-Item "$vcpkg_dir\installed\arm64-windows\bin\icuin71.dll" .
Copy-Item "$vcpkg_dir\installed\arm64-windows\bin\bz2.dll" .
Copy-Item "$vcpkg_dir\installed\arm64-windows\bin\jpeg62.dll" .
Copy-Item "$vcpkg_dir\installed\arm64-windows\bin\tiff.dll" .
Copy-Item "$vcpkg_dir\installed\arm64-windows\bin\liblzma.dll" .
Copy-Item "$vcpkg_dir\installed\arm64-windows\bin\openjp2.dll" .
Copy-Item "$work_dir\install\poppler\bin\poppler-qt6.dll" .
Copy-Item "$work_dir\install\poppler\bin\poppler.dll" .
Move-Item vc_redist.arm64.exe ..
Set-Location TexTablet
Remove-Item -r *
7z.exe x "$work_dir\TeXTablet-Release-arm64.zip"
Set-Location ../..
7z.exe a -mx9 "texstudio-$texstudio_ver-win-arm64-portable-qt6.7z" texstudio
Set-Location $work_dir
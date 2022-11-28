# texstudio-windows-arm64
TeXstudio is a fully featured LaTeX editor. This repository distributes TeXstudio binaries for Windows on ARM64 (WoA).

Please go to [releases](https://github.com/minnyres/texstudio-windows-arm64/releases) for the downloads.

## How to build

It is natively built on Windows 11 ARM64.

### Preparations

You need to install the following tools to build KeePassXC yourself.
+ [Visual Studio 2022 on ARM64](https://devblogs.microsoft.com/visualstudio/arm64-visual-studio-is-officially-here/)
+ Windows Terminal from Microsoft Store
+ Python from Microsoft Store
+ [Perl](https://strawberryperl.com/)
+ [Ninja](https://ninja-build.org/)
+ [cmake](https://cmake.org/)
+ [vcpkg](https://vcpkg.io/en/index.html)
+ [7-Zip](https://www.7-zip.org/)
+ [Wget for Windows](https://github.com/lifenjoiner/wget-for-windows)

In Windows Terminal, set the "Command line" for "Developer PowerShell for VS 2022" by replacing `-host_arch=x64` with `-host_arch=arm64`.

### Build 

Open the "Developer PowerShell for VS 2022" in Windows Terminal. First install some dependencies via vcpkg:
```
.\vcpkg.exe install pkgconf fontconfig zlib icu freetype libjpeg-turbo libpng tiff cairo lcms openjpeg libiconv boost liblzma brotli --triplet=arm64-windows
```
Set up variables
```
$vcpkg_dir="d:\git\vcpkg"
$ninja_dir="d:\git\vcpkg\downloads\tools\ninja\1.10.2-windows"
$perl_dir="d:\git\vcpkg\downloads\tools\perl\5.32.1.1"
$cmake_dir="d:\git\vcpkg\downloads\tools\cmake-3.24.0-windows\cmake-3.24.0-windows-i386"
$qt_install_dir="d:\Qt\Qt_6.4.1_vs2022_arm64"
$wget_dir="d:\Library\wget-v1.21.3.141-91166_WinTLS_win32"
$7zip_dir="c:\Program Files\7-Zip"
```
where 
+ `vcpkg_dir` is the root directory of vcpkg 
+ `ninja_dir` is the directory of Ninja
+ `perl_dir` is the root directory of Perl
+ `cmake_dir` is the root directory of cmake
+ `qt_install_dir` is the place to install Qt
+ `wget_dir` is the directory of wget
+ `7zip_dir` is the installation path of 7-Zip

Then run the PowerShell script to build Qt
```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
.\build-qt6.ps1
```
It may take several hours, so be patient. After building Qt, poppler and texstudio can be built by
```
.\build-poppler.ps1
.\build-texstudio.ps1
```
where the installation path of poppler and texstudio is `.\install`.
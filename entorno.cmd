@echo off
REM ============================================================
REM  Deja una consola de Windows con Swift listo para usar.
REM
REM  Swift en Windows necesita tres cosas que no vienen puestas:
REM    1. El enlazador de MSVC  -> lo da vcvars64.bat
REM    2. Las DLL del runtime   -> van en Runtimes\<version>\usr\bin
REM    3. La biblioteca estandar -> se apunta con SDKROOT
REM
REM  Uso:
REM    entorno.cmd                 abre una consola preparada
REM    entorno.cmd swift build     ejecuta un comando y sale
REM ============================================================
setlocal enabledelayedexpansion

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" (
  echo ERROR: no se encontro vswhere. Falta Visual Studio o sus Build Tools.
  exit /b 1
)

for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSPATH=%%i"
if not defined VSPATH (
  echo ERROR: hay Visual Studio pero sin el toolchain de C++ ^(VC.Tools.x86.x64^).
  exit /b 1
)

call "%VSPATH%\VC\Auxiliary\Build\vcvars64.bat" >nul 2>&1

set "SWIFTROOT=%LOCALAPPDATA%\Programs\Swift"
if not exist "%SWIFTROOT%" (
  echo ERROR: no hay Swift instalado. Instalalo con:
  echo   winget install --id Swift.Toolchain -e
  exit /b 1
)

REM La version se descubre, no se escribe a mano: asi el script no caduca.
for /f "delims=" %%v in ('dir /b /ad "%SWIFTROOT%\Platforms" 2^>nul') do set "SWVER=%%v"
for /f "delims=" %%t in ('dir /b /ad "%SWIFTROOT%\Toolchains" 2^>nul') do set "SWTC=%%t"
if not defined SWVER (
  echo ERROR: no hay ninguna plataforma de Swift bajo %SWIFTROOT%\Platforms.
  exit /b 1
)

REM Ojo: las comillas del set son obligatorias. Sin ellas, cmd mete un espacio
REM al final del valor y el compilador no encuentra la biblioteca estandar.
set "PATH=%SWIFTROOT%\Toolchains\%SWTC%\usr\bin;%SWIFTROOT%\Runtimes\%SWVER%\usr\bin;%PATH%"
set "SDKROOT=%SWIFTROOT%\Platforms\%SWVER%\Windows.platform\Developer\SDKs\Windows.sdk"

if "%~1"=="" (
  echo Swift %SWVER% listo.
  echo SDKROOT=%SDKROOT%
  swift --version
  cmd /k
) else (
  %*
)

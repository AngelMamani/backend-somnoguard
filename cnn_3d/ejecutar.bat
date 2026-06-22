@echo off
REM Flutter/Gradle falla con espacios en la ruta del proyecto.
REM Este script ejecuta desde C:\SomnoGuard (enlace sin espacios).

if not exist C:\SomnoGuard (
    echo Creando enlace C:\SomnoGuard ...
    mklink /J C:\SomnoGuard "%~dp0"
)

cd /d C:\SomnoGuard
flutter run %*

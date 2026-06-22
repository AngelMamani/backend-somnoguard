@echo off
echo Abriendo puerto 5000 para que el celular llegue al backend...
echo Requiere ejecutar como ADMINISTRADOR.
netsh advfirewall firewall add rule name="Flask SomnoGuard 5000" dir=in action=allow protocol=TCP localport=5000
if %errorlevel%==0 (
    echo Puerta 5000 abierta correctamente.
) else (
    echo Error. Clic derecho en este archivo ^> Ejecutar como administrador
)
pause

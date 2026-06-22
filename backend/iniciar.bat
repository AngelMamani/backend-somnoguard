@echo off
cd /d "%~dp0"
echo Instalando dependencias...
python -m pip install -r requirements.txt
echo.
echo Al iniciar veras la IP para configurar en la app movil.
echo.
python app.py
pause

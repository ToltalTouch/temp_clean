@echo off
title Limpeza do Sistema

:: Captura o ESC correto
for /f "delims=" %%i in ('echo prompt $E^| cmd') do set "ESC=%%i"

:: Cores ANSI
set "COLOR_RESET=%ESC%[0m"
set "COLOR_EXEC=%ESC%[37m"
set "COLOR_ETAPA=%ESC%[34m"
set "COLOR_OK=%ESC%[32m"
set "COLOR_ERR=%ESC%[31m"

echo.

call :etapa "Iniciando limpeza de temporarios..."

call :etapa "Limpando TEMP do usuario..."
del /q /f /s "%TEMP%\*" 2>nul && (
  	call :ok "TEMP do usuario limpo."
) || (
  	call :err "ERRO ao limpar TEMP!!!"
)

call :etapa "Limpando cache do Chrome..."
del /q /f /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" 2>nul && (
  	call :ok "Cache do Chrome limpo."
) || (
  	call :err "ERRO ao limpar cache do Chrome!!!"
)

call :etapa "Limpando prefetch..."
del /q /f /s "C:\Windows\Prefetch\*" 2>nul && (
  	call :ok "Prefetch limpo."
) || (
  	call :err "ERRO ao limpar prefetch! Verifique permissao de ADM!"
)

call :etapa "Limpando TEMP do sistema..."
del /q /f /s "C:\Windows\Temp" 2>nul && (
  	call :ok "TEMP do sistema limpo."
) || (
  	call :err "ERRO ao limpar TEMP do sistema! Verifique permissao de ADM!"
)

call :etapa "Limpando miniaturas..."
del /q /f /s "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul && (
  	call :ok "Miniaturas limpas."
) || (
  	call :err "ERRO ao limpar miniaturas! Verifique permissao de ADM!"
)

call :etapa "Limpando logs do Windows..."
PowerShell.exe -NoProfile -Command "Clear-EventLog -Log *" 2>nul && (
  	call :ok "Logs do Windows limpos."
) || (
  	call :err "ERRO ao limpar logs! Verifique permissao de ADM!"
)

call :etapa "Esvaziando lixeira..."
PowerShell.exe -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" && (
	call :ok "Lixeira esvaziada."
) || (
    	call :err "ERRO ao esvaziar lixeira."
)

echo.
call :ok "Script de limpeza concluido."

pause
exit /b

:etapa
echo %COLOR_ETAPA%== %~1 ==%COLOR_RESET%
goto :eof

:ok
echo %COLOR_OK%[OK] %~1%COLOR_RESET%
goto :eof

:err
echo %COLOR_ERR%[ERRO] %~1%COLOR_RESET%
goto :eof

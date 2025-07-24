@echo off
REM Script de Build para Canary (OpenTibiaBR) - Versão Batch
REM Use este script para uma compilação rápida no Windows

setlocal enabledelayedexpansion

REM Configurações padrão
set BUILD_TYPE=Release
set VCPKG_ROOT=C:\tools\vcpkg
set PROJECT_DIR=%~dp0
set BUILD_DIR=%PROJECT_DIR%build

REM Verificar argumentos
if /i "%1"=="debug" (
    set BUILD_TYPE=Debug
    echo Compilando em modo Debug
) else (
    echo Compilando em modo Release
)

echo.
echo === Build do Canary ===
echo Diretorio do projeto: %PROJECT_DIR%
echo Tipo de build: %BUILD_TYPE%
echo VCPKG Root: %VCPKG_ROOT%
echo.

REM Verificar se VCPKG existe
if not exist "%VCPKG_ROOT%" (
    echo ERRO: VCPKG nao encontrado em %VCPKG_ROOT%
    echo Por favor, instale o VCPKG ou ajuste a variavel VCPKG_ROOT
    pause
    exit /b 1
)

REM Configurar variáveis de ambiente
set VCPKG_DEFAULT_TRIPLET=x64-windows-static

REM Limpar e criar diretório de build
if exist "%BUILD_DIR%" (
    echo Limpando diretorio de build existente...
    rmdir /s /q "%BUILD_DIR%"
)

mkdir "%BUILD_DIR%"
cd /d "%BUILD_DIR%"

REM Configurar com CMake
echo Configurando com CMake...
cmake ^
    -DCMAKE_TOOLCHAIN_FILE="%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake" ^
    -DVCPKG_TARGET_TRIPLET=x64-windows-static ^
    -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
    -DBUILD_STATIC_LIBRARY=ON ^
    ..

if errorlevel 1 (
    echo ERRO na configuracao CMake
    pause
    exit /b 1
)

REM Compilar
echo.
echo Compilando... (isso pode demorar varios minutos)
cmake --build . --config %BUILD_TYPE% --parallel

if errorlevel 1 (
    echo ERRO na compilacao
    pause
    exit /b 1
) else (
    echo.
    echo ✓ Compilacao concluida com sucesso!
    
    REM Procurar pelo executável
    if "%BUILD_TYPE%"=="Debug" (
        set EXE_NAME=canary-debug.exe
    ) else (
        set EXE_NAME=canary.exe
    )
    
    for /r . %%f in (!EXE_NAME!) do (
        if exist "%%f" (
            echo Executavel gerado: %%f
            goto :found
        )
    )
    
    :found
    echo.
    echo Build concluido! Pressione qualquer tecla para continuar...
    pause > nul
)

endlocal

#!/bin/bash
# Script de Build Rápido para Canary (OpenTibiaBR) - Versão Simplificada
# Use este script se você já tem VCPKG e dependências instaladas

# Configurações
BUILD_TYPE="Release"
VCPKG_ROOT="${VCPKG_ROOT:-C:/tools/vcpkg}"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$PROJECT_DIR/build"

# Verificar argumentos
if [[ "$1" == "debug" ]] || [[ "$1" == "Debug" ]]; then
    BUILD_TYPE="Debug"
    echo "Compilando em modo Debug"
else
    echo "Compilando em modo Release"
fi

echo "=== Build Rápido do Canary ==="
echo "Diretório do projeto: $PROJECT_DIR"
echo "Tipo de build: $BUILD_TYPE"
echo "VCPKG Root: $VCPKG_ROOT"

# Limpar e criar diretório de build
if [ -d "$BUILD_DIR" ]; then
    echo "Limpando diretório de build existente..."
    rm -rf "$BUILD_DIR"
fi

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configurar com CMake
echo "Configurando com CMake..."
cmake \
    -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" \
    -DVCPKG_TARGET_TRIPLET=x64-windows-static \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DBUILD_STATIC_LIBRARY=ON \
    ..

if [ $? -ne 0 ]; then
    echo "Erro na configuração CMake"
    exit 1
fi

# Compilar
echo "Compilando..."
cmake --build . --config "$BUILD_TYPE" --parallel

if [ $? -eq 0 ]; then
    echo "✓ Compilação concluída com sucesso!"
    
    # Encontrar executável
    if [ "$BUILD_TYPE" == "Debug" ]; then
        EXE_NAME="canary-debug.exe"
    else
        EXE_NAME="canary.exe"
    fi
    
    EXE_PATH=$(find . -name "$EXE_NAME" -type f | head -1)
    if [ -n "$EXE_PATH" ]; then
        echo "Executável gerado: $BUILD_DIR/$EXE_PATH"
    fi
else
    echo "Erro na compilação"
    exit 1
fi

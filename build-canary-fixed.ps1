# Script de Build para Canary (OpenTibiaBR)
# Este script automatiza o processo de compilacao do projeto

param(
    [switch]$Debug,
    [switch]$SkipDependencies,
    [string]$VcpkgPath = "C:\tools\vcpkg",
    [switch]$Help
)

if ($Help) {
    Write-Host "Script de Build para Canary (OpenTibiaBR)" -ForegroundColor Green
    Write-Host ""
    Write-Host "Uso: .\build-canary.ps1 [opcoes]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Opcoes:" -ForegroundColor Yellow
    Write-Host "  -Debug              Compila em modo Debug (padrao e Release)"
    Write-Host "  -SkipDependencies   Pula a instalacao das dependencias VCPKG"
    Write-Host "  -VcpkgPath <path>   Caminho personalizado para o VCPKG (padrao: C:\tools\vcpkg)"
    Write-Host "  -Help               Mostra esta ajuda"
    Write-Host ""
    Write-Host "Exemplos:" -ForegroundColor Yellow
    Write-Host "  .\build-canary.ps1                    # Build Release padrao"
    Write-Host "  .\build-canary.ps1 -Debug            # Build Debug"
    Write-Host "  .\build-canary.ps1 -SkipDependencies # Pula instalacao de dependencias"
    exit 0
}

# Cores para output
$ErrorColor = "Red"
$WarningColor = "Yellow"
$InfoColor = "Cyan"
$SuccessColor = "Green"

# Funcao para log colorido
function Write-Log {
    param($Message, $Color = "White")
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] $Message" -ForegroundColor $Color
}

# Funcao para verificar se um comando existe
function Test-Command {
    param($CommandName)
    try {
        Get-Command $CommandName -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

Write-Log "=== Script de Build do Canary (OpenTibiaBR) ===" $InfoColor
Write-Log "Modo: $(if($Debug) { 'Debug' } else { 'Release' })" $InfoColor
Write-Log ""

# Verificar pre-requisitos
Write-Log "Verificando pre-requisitos..." $InfoColor

$prerequisites = @{
    "git" = "Git nao encontrado. Instale o Git: https://git-scm.com/"
    "cmake" = "CMake nao encontrado. Instale o CMake: https://cmake.org/download/"
}

$missingPrereqs = @()
foreach ($prereq in $prerequisites.Keys) {
    if (-not (Test-Command $prereq)) {
        Write-Log $prerequisites[$prereq] $ErrorColor
        $missingPrereqs += $prereq
    } else {
        Write-Log "$prereq encontrado" $SuccessColor
    }
}

if ($missingPrereqs.Count -gt 0) {
    Write-Log "Por favor, instale os pre-requisitos faltantes e execute o script novamente." $ErrorColor
    exit 1
}

# Verificar/Instalar VCPKG
Write-Log "Verificando VCPKG..." $InfoColor

if (-not (Test-Path $VcpkgPath)) {
    Write-Log "VCPKG nao encontrado em $VcpkgPath" $WarningColor
    Write-Log "Instalando VCPKG..." $InfoColor
    
    $vcpkgParent = Split-Path $VcpkgPath -Parent
    if (-not (Test-Path $vcpkgParent)) {
        New-Item -ItemType Directory -Path $vcpkgParent -Force | Out-Null
    }
    
    try {
        Set-Location $vcpkgParent
        git clone https://github.com/Microsoft/vcpkg.git
        Set-Location $VcpkgPath
        .\bootstrap-vcpkg.bat
        Write-Log "VCPKG instalado com sucesso" $SuccessColor
    }
    catch {
        Write-Log "Erro ao instalar VCPKG: $_" $ErrorColor
        exit 1
    }
} else {
    Write-Log "VCPKG encontrado em $VcpkgPath" $SuccessColor
}

# Configurar variaveis de ambiente
$env:VCPKG_ROOT = $VcpkgPath
$env:VCPKG_DEFAULT_TRIPLET = "x64-windows-static"

Write-Log "VCPKG_ROOT configurado para: $VcpkgPath" $InfoColor

# Instalar dependencias
if (-not $SkipDependencies) {
    Write-Log "Instalando dependencias VCPKG..." $InfoColor
    Write-Log "ATENCAO: Este processo pode demorar muito tempo (30-60 minutos)..." $WarningColor
    
    $dependencies = @(
        "asio", 
        "pugixml", 
        "spdlog", 
        "curl", 
        "protobuf", 
        "parallel-hashmap", 
        "magic-enum", 
        "mio", 
        "luajit", 
        "libmariadb", 
        "mpir", 
        "abseil", 
        "bshoshany-thread-pool",
        "argon2", 
        "bext-di", 
        "bext-ut", 
        "eventpp", 
        "zlib",
        "atomic-queue"
    )
    
    try {
        Set-Location $VcpkgPath
        foreach ($dep in $dependencies) {
            Write-Log "Instalando dependencia: $dep" $InfoColor
            $result = & .\vcpkg.exe install $dep --triplet x64-windows-static 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Log "Erro ao instalar $dep" $ErrorColor
                Write-Log $result $ErrorColor
            }
        }
        
        # Instalar opentelemetry separadamente devido aos colchetes
        Write-Log "Instalando opentelemetry-cpp..." $InfoColor
        & .\vcpkg.exe install "opentelemetry-cpp[otlp-http,prometheus]" --triplet x64-windows-static
        
        Write-Log "Dependencias instaladas com sucesso" $SuccessColor
    }
    catch {
        Write-Log "Erro ao instalar dependencias: $_" $ErrorColor
        Write-Log "Voce pode tentar executar o script novamente com -SkipDependencies" $WarningColor
        exit 1
    }
} else {
    Write-Log "Pulando instalacao de dependencias" $WarningColor
}

# Voltar para o diretorio do projeto
$projectDir = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location $projectDir

Write-Log "Diretorio do projeto: $projectDir" $InfoColor

# Criar diretorio de build
$buildDir = Join-Path $projectDir "build"
if (Test-Path $buildDir) {
    Write-Log "Limpando diretorio de build existente..." $WarningColor
    Remove-Item $buildDir -Recurse -Force
}

New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
Set-Location $buildDir

Write-Log "Diretorio de build criado: $buildDir" $InfoColor

# Configurar build com CMake
Write-Log "Configurando projeto com CMake..." $InfoColor

$buildType = if ($Debug) { "Debug" } else { "Release" }
$toolchainFile = Join-Path $VcpkgPath "scripts\buildsystems\vcpkg.cmake"

try {
    & cmake -DCMAKE_TOOLCHAIN_FILE="$toolchainFile" -DVCPKG_TARGET_TRIPLET=x64-windows-static -DCMAKE_BUILD_TYPE=$buildType -DBUILD_STATIC_LIBRARY=ON ..
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "Configuracao CMake concluida com sucesso" $SuccessColor
    } else {
        Write-Log "Erro na configuracao CMake. Codigo de saida: $LASTEXITCODE" $ErrorColor
        exit 1
    }
}
catch {
    Write-Log "Erro na configuracao CMake: $_" $ErrorColor
    exit 1
}

# Compilar projeto
Write-Log "Compilando projeto..." $InfoColor
Write-Log "ATENCAO: A compilacao pode demorar varios minutos..." $WarningColor

try {
    $startTime = Get-Date
    & cmake --build . --config $buildType --parallel
    $endTime = Get-Date
    $duration = $endTime - $startTime
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "Compilacao concluida com sucesso" $SuccessColor
        Write-Log "Tempo de compilacao: $($duration.TotalMinutes.ToString('F1')) minutos" $InfoColor
        
        # Encontrar o executavel
        $exeName = if ($Debug) { "canary-debug.exe" } else { "canary.exe" }
        $exePath = Get-ChildItem -Path $buildDir -Name $exeName -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        
        if ($exePath) {
            $fullExePath = Join-Path $buildDir $exePath
            Write-Log "Executavel gerado: $fullExePath" $SuccessColor
            $fileSize = [math]::Round((Get-Item $fullExePath).Length / 1MB, 2)
            Write-Log "Tamanho do arquivo: $fileSize MB" $InfoColor
        } else {
            Write-Log "Executavel nao encontrado no diretorio de build" $WarningColor
        }
        
        Write-Log "" 
        Write-Log "=== BUILD CONCLUIDO COM SUCESSO ===" $SuccessColor
        Write-Log "Voce pode encontrar o executavel no diretorio: $buildDir" $InfoColor
        
    } else {
        Write-Log "Erro na compilacao. Codigo de saida: $LASTEXITCODE" $ErrorColor
        exit 1
    }
}
catch {
    Write-Log "Erro na compilacao: $_" $ErrorColor
    exit 1
}

Write-Log "Script concluido!" $SuccessColor

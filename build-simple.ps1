# Script de Build Simples para Canary (OpenTibiaBR)
param(
    [switch]$Debug,
    [string]$VcpkgPath = "C:\tools\vcpkg"
)

$ErrorColor = "Red"
$WarningColor = "Yellow" 
$InfoColor = "Cyan"
$SuccessColor = "Green"

function Write-Log {
    param($Message, $Color = "White")
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] $Message" -ForegroundColor $Color
}

Write-Log "=== Build Simples do Canary ===" $InfoColor
Write-Log "Modo: $(if($Debug) { 'Debug' } else { 'Release' })" $InfoColor

# Verificar VCPKG
if (-not (Test-Path $VcpkgPath)) {
    Write-Log "VCPKG nao encontrado em $VcpkgPath" $WarningColor
    Write-Log "Instalando VCPKG..." $InfoColor
    
    $vcpkgParent = Split-Path $VcpkgPath -Parent
    New-Item -ItemType Directory -Path $vcpkgParent -Force -ErrorAction SilentlyContinue | Out-Null
    
    Set-Location $vcpkgParent
    git clone https://github.com/Microsoft/vcpkg.git
    Set-Location $VcpkgPath
    .\bootstrap-vcpkg.bat
    Write-Log "VCPKG instalado" $SuccessColor
} else {
    Write-Log "VCPKG encontrado" $SuccessColor
}

# Configurar ambiente
$env:VCPKG_ROOT = $VcpkgPath
$env:VCPKG_DEFAULT_TRIPLET = "x64-windows-static"

# Instalar algumas dependencias criticas primeiro
Write-Log "Instalando dependencias criticas..." $InfoColor
Set-Location $VcpkgPath

$criticalDeps = @("asio", "pugixml", "spdlog", "curl", "protobuf")
foreach ($dep in $criticalDeps) {
    Write-Log "Instalando $dep..." $InfoColor
    & .\vcpkg.exe install $dep --triplet x64-windows-static
}

# Voltar ao projeto
$projectDir = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location $projectDir

# Limpar build
$buildDir = "$projectDir\build"
if (Test-Path $buildDir) {
    Remove-Item $buildDir -Recurse -Force
}
New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
Set-Location $buildDir

# Configurar CMake
Write-Log "Configurando CMake..." $InfoColor
$buildType = if ($Debug) { "Debug" } else { "Release" }
$toolchain = "$VcpkgPath\scripts\buildsystems\vcpkg.cmake"

& cmake -DCMAKE_TOOLCHAIN_FILE="$toolchain" -DVCPKG_TARGET_TRIPLET=x64-windows-static -DCMAKE_BUILD_TYPE=$buildType ..

if ($LASTEXITCODE -eq 0) {
    Write-Log "Configuracao CMake OK" $SuccessColor
    
    # Compilar
    Write-Log "Compilando..." $InfoColor
    & cmake --build . --config $buildType --parallel
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "Compilacao concluida!" $SuccessColor
        $exe = if ($Debug) { "canary-debug.exe" } else { "canary.exe" }
        $found = Get-ChildItem -Path . -Name $exe -Recurse | Select-Object -First 1
        if ($found) {
            Write-Log "Executavel: $buildDir\$found" $SuccessColor
        }
    } else {
        Write-Log "Erro na compilacao" $ErrorColor
    }
} else {
    Write-Log "Erro na configuracao CMake" $ErrorColor
}

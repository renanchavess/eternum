# Scripts de Build para Canary (OpenTibiaBR)

Este diretório contém scripts automatizados para compilar o projeto Canary no Windows.

## Scripts Disponíveis

### 1. `build-canary.ps1` (Recomendado)
**Script PowerShell completo com verificação de pré-requisitos e instalação automática**

#### Uso:
```powershell
# Build básico (Release)
.\build-canary.ps1

# Build em modo Debug
.\build-canary.ps1 -Debug

# Pular instalação de dependências (se já estiverem instaladas)
.\build-canary.ps1 -SkipDependencies

# Especificar caminho customizado do VCPKG
.\build-canary.ps1 -VcpkgPath "D:\vcpkg"

# Ver todas as opções
.\build-canary.ps1 -Help
```

#### Recursos:
- ✅ Verifica e instala pré-requisitos automaticamente
- ✅ Instala VCPKG se não estiver presente
- ✅ Instala todas as dependências necessárias
- ✅ Log colorido e informativo
- ✅ Verificação de erros em cada etapa
- ✅ Suporte a builds Debug e Release

### 2. `build-canary.bat`
**Script Batch simples para Windows**

#### Uso:
```batch
REM Build Release
build-canary.bat

REM Build Debug
build-canary.bat debug
```

#### Recursos:
- ✅ Simples de usar
- ✅ Não requer PowerShell
- ⚠️ Requer VCPKG pré-instalado

### 3. `quick-build.sh`
**Script Bash para usuários que preferem linha de comando Unix-style**

#### Uso:
```bash
# Build Release
bash quick-build.sh

# Build Debug
bash quick-build.sh debug
```

## Pré-requisitos

Antes de executar os scripts, certifique-se de ter:

1. **Visual Studio 2019 ou superior** com C++ Build Tools
2. **Git** - [Download](https://git-scm.com/)
3. **CMake 3.22+** - [Download](https://cmake.org/download/)

### Para o script PowerShell completo (`build-canary.ps1`):
- Nenhum pré-requisito adicional (instala tudo automaticamente)

### Para os outros scripts:
4. **VCPKG** instalado em `C:\tools\vcpkg` (ou configure a variável VCPKG_ROOT)
5. **Dependências VCPKG** instaladas

## Instalação Manual do VCPKG (se necessário)

Se você não usar o script PowerShell completo, instale o VCPKG manualmente:

```powershell
# 1. Clonar VCPKG
git clone https://github.com/Microsoft/vcpkg.git C:\tools\vcpkg
cd C:\tools\vcpkg

# 2. Bootstrap
.\bootstrap-vcpkg.bat

# 3. Instalar dependências
.\vcpkg install --triplet x64-windows-static asio pugixml spdlog curl protobuf parallel-hashmap magic-enum mio luajit libmariadb mpir abseil bshoshany-thread-pool argon2 bext-di bext-ut eventpp zlib atomic-queue opentelemetry-cpp[otlp-http,prometheus]

# 4. Configurar variável de ambiente
$env:VCPKG_ROOT = "C:\tools\vcpkg"
```

## Execução de Política do PowerShell

Se você receber um erro de política de execução ao executar o script PowerShell, execute:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Localização do Executável

Após a compilação bem-sucedida, o executável será gerado em:
- **Release**: `build/src/canary.exe`
- **Debug**: `build/src/canary-debug.exe`

## Troubleshooting

### Erro: "cmake não é reconhecido"
- Instale o CMake e certifique-se de que está no PATH do sistema

### Erro: "VCPKG não encontrado"
- Verifique se o VCPKG está instalado em `C:\tools\vcpkg`
- Ou use a opção `-VcpkgPath` para especificar um caminho diferente

### Erro na instalação de dependências
- Certifique-se de ter conexão estável com a internet
- O processo pode demorar 30-60 minutos na primeira vez
- Use `-SkipDependencies` se as dependências já estiverem instaladas

### Erro de compilação
- Verifique se tem o Visual Studio com C++ Build Tools instalado
- Certifique-se de ter espaço suficiente em disco (pelo menos 10GB livres)
- Tente limpar o diretório `build` e executar novamente

## Tempo de Compilação

- **Primeira compilação**: 30-90 minutos (inclui download e compilação de dependências)
- **Compilações subsequentes**: 5-15 minutos (apenas o projeto)

## Contribuições

Se encontrar problemas ou tiver sugestões de melhorias para os scripts, por favor abra uma issue ou pull request.

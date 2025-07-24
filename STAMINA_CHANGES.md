# Mudanças no Sistema de Stamina

## 📊 **RESUMO DAS ALTERAÇÕES**

As zonas de stamina foram ajustadas para tornar mais equilibrado o sistema de bonificação de experiência:

### **🔄 Valores Antigos vs Novos**

| Zona | Valor Antigo | Valor Novo | Mudança | Descrição |
|------|-------------|------------|---------|-----------|
| 🟢 **Verde** | 2340+ min | **2400+ min** | **-60 min** | Bonus XP 150% (Premium) |
| 🟡 **Laranja** | 840-2339 min | **900-2399 min** | **+60 min** | XP Normal 100% |
| 🔴 **Vermelha** | 0-839 min | **0-899 min** | **+60 min** | Penalidade XP 50% |

### **🎯 Impacto das Mudanças**

- **Zona Verde**: Mais difícil de alcançar (requer 60 minutos adicionais)
- **Zona Laranja**: Expandida em 120 minutos total (60 para cima + 60 para baixo)
- **Zona Vermelha**: Expandida em 60 minutos

## 📝 **Arquivos Modificados**

1. **`data/libs/functions/player.lua`** - Função principal de cálculo de bonus
2. **`data/scripts/creaturescripts/player/regenerate_stamina.lua`** - Regeneração offline
3. **`data/libs/systems/daily_reward.lua`** - Sistema de daily rewards
4. **`data/global.lua`** - Regeneração em Protection Zone
5. **`data/events/scripts/player.lua`** - Scripts de eventos do jogador

## 🔧 **Detalhes Técnicos**

### **Função Principal Alterada:**
```lua
function Player.getFinalBonusStamina(self)
    local staminaBonus = 1
    if configManager.getBoolean(configKeys.STAMINA_SYSTEM) then
        local staminaMinutes = self:getStamina()
        if staminaMinutes > 2400 and self:isPremium() then  -- Era 2340
            staminaBonus = 1.5  -- 150% XP
        elseif staminaMinutes <= 900 then  -- Era 840
            staminaBonus = 0.5  -- 50% XP
        end
    end
    return staminaBonus
end
```

### **Regeneração Offline Ajustada:**
```lua
-- Zona normal: até 2400 (era 2340)
local maxNormalStaminaRegen = 2400 - math.min(2400, staminaMinutes)

-- Happy hour: acima de 2400 (era 2340)
staminaMinutes = math.min(2520, math.max(2400, staminaMinutes) + happyHourStaminaRegen)
```

## 📈 **Balanceamento**

### **Benefícios das Mudanças:**
- ✅ **Mais tempo na zona laranja**: Jogadores passam mais tempo com XP normal
- ✅ **Zona verde mais exclusiva**: Recompensa players mais dedicados ou premium
- ✅ **Transições mais suaves**: Menos players na zona vermelha crítica
- ✅ **Melhor retenção**: Evita frustração extrema de XP muito baixo

### **Tempo para Atingir Zonas:**
- **Zona Verde**: ~1 hora adicional de stamina necessária
- **Zona Laranja**: Mantida por mais tempo durante o jogo
- **Recuperação**: Sistemas de regeneração permanecem inalterados

## 🎮 **Impacto no Gameplay**

### **Para Jogadores Premium:**
- Zona verde requer mais planejamento
- Benefício de 150% XP mais valorizado
- Necessário gerenciar melhor o tempo online

### **Para Jogadores Free:**
- Mais tempo em zona laranja (100% XP)
- Menos tempo em zona vermelha penalizante
- Experiência mais consistente

### **Para Administradores:**
- Melhor distribuição de players nas zonas
- Sistema mais equilibrado
- Incentivo natural para premium

## 📊 **Monitoramento Recomendado**

Após implementar as mudanças, monitore:

1. **Distribuição de players por zona de stamina**
2. **Tempo médio gasto em cada zona**
3. **Feedback dos jogadores sobre as mudanças**
4. **Taxa de conversão para contas premium**
5. **Tempo de sessão médio dos jogadores**

## 🔄 **Reversão (se necessário)**

Para reverter as mudanças, altere nos mesmos arquivos:
- `2400` → `2340` (zona verde)
- `900` → `840` (zona laranja/vermelha)

---

**Data da implementação:** 23 de Julho de 2025  
**Versão:** Canary 3.2.0  
**Responsável:** Sistema de Balanceamento

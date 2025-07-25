-- ai_player.lua
-- Módulo inicial de IA para OTServBR
-- Foco: Paladino (aprende magias, itens, runas e caça monstros)

local AIPlayer = {}

-- Tabela de magias do paladino (exemplo, adicione conforme necessário)
AIPlayer.spells = {
    "exori san", -- ataque
    "exura san", -- cura
    "exevo mas san", -- ataque em área
    -- ...adicione outras magias
}

-- Tabela de itens que paladino pode usar
AIPlayer.items = {
    weapons = {"bow", "crossbow", "royal spear", "envenomed arrow"},
    armors = {"paladin armor", "demon shield", "boots of haste"},
    runes = {"ultimate healing rune", "great fireball rune", "explosion rune"},
    -- ...adicione outros itens
}

-- Função para buscar monstros com boa exp/loot
function AIPlayer:findBestMonsters()
    -- Exemplo: busca monstros em uma tabela (deve ser adaptado para ler do servidor)
    local monsters = {
        {name = "Dragon", exp = 700, loot = 500},
        {name = "Hydra", exp = 2100, loot = 1200},
        {name = "Demon", exp = 6000, loot = 3000},
        -- ...adicione outros monstros
    }
    table.sort(monsters, function(a, b)
        return (a.exp + a.loot) > (b.exp + b.loot)
    end)
    return monsters
end

-- Função para simular caça
function AIPlayer:hunt()
    local monsters = self:findBestMonsters()
    local hp = 100 -- Exemplo: vida atual da IA
    local lootBag = {}
    for _, monster in ipairs(monsters) do
        print("IA vai caçar: " .. monster.name .. " (Exp: " .. monster.exp .. ", Loot: " .. monster.loot .. ")")
        -- Regra: Se vida baixa, usar magia de cura
        if hp < 50 then
            print("IA usa magia de cura: " .. self.spells[2])
            hp = hp + 40 -- Simula cura
        end
        -- Regra: Atacar monstro
        print("IA ataca com magia: " .. self.spells[1])
        -- Regra: Pegar loot
        table.insert(lootBag, monster.loot)
        print("IA pegou loot: " .. monster.loot)
        -- Regra: Se vida muito baixa, fugir
        if hp < 20 then
            print("IA está fugindo! Vida muito baixa.")
            break
        end
        -- Simula dano recebido
        hp = hp - math.random(10, 30)
    end
    print("Loot total coletado: ", lootBag)
end

-- Função para aprender magias, itens e runas
function AIPlayer:learnClass(class)
    if class == "paladin" then
        print("IA aprendeu magias, itens e runas de paladino.")
        -- Pode adicionar lógica para buscar magias e itens do XML/Lua do servidor
        -- Exemplo de regras específicas para paladino
        self.attackType = "distance"
        self.preferredRunes = {"ultimate healing rune", "great fireball rune"}
    end
end

-- Exemplo de uso:

-- Simulação detalhada do comportamento do paladino
function AIPlayer:simulate()
    print("--- SIMULAÇÃO DE COMPORTAMENTO DO PALADINO ---")
    self:learnClass("paladin")
    print("IA inicia caça...")
    local monsters = self:findBestMonsters()
    local hp = 100
    local lootBag = {}
    for _, monster in ipairs(monsters) do
        print("\nIA encontra o monstro: " .. monster.name)
        print("Exp: " .. monster.exp .. ", Loot: " .. monster.loot)
        -- Decide atacar ou curar
        if hp < 50 then
            print("Vida baixa! IA usa magia de cura: " .. self.spells[2])
            hp = hp + 40
        end
        print("IA ataca com magia: " .. self.spells[1])
        -- Simula dano recebido
        local danoRecebido = math.random(10, 30)
        hp = hp - danoRecebido
        print("IA recebeu " .. danoRecebido .. " de dano. Vida atual: " .. hp)
        -- Pega loot
        table.insert(lootBag, monster.loot)
        print("IA pegou loot: " .. monster.loot)
        -- Decide fugir se vida muito baixa
        if hp < 20 then
            print("IA está fugindo! Vida muito baixa.")
            break
        end
    end
    print("\nLoot total coletado: ", table.concat(lootBag, ", "))
    print("--- FIM DA SIMULAÇÃO ---")
end

-- Executa a simulação
AIPlayer:simulate()

return AIPlayer

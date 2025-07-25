
local ai_player = dofile("data/modules/ai_player.lua")

-- Posições para patrulha (exemplo)
local patrolPositions = {
    {x = 32369, y = 32241, z = 7},
    {x = 32371, y = 32241, z = 7},
    {x = 32371, y = 32243, z = 7},
    {x = 32369, y = 32243, z = 7},
}
local patrolIndex = 1

function onThink()
    -- Controle de spawn/despawn via arquivo
    local spawnFile = io.open("data/npc/ai_paladin_spawn.txt", "r")
    if spawnFile then
        local cmd = spawnFile:read("*a")
        spawnFile:close()
        if cmd == "despawn" then
            self:remove()
            os.remove("data/npc/ai_paladin_spawn.txt")
            return
        end
        -- Se for "spawn", não faz nada (NPC já está ativo)
        os.remove("data/npc/ai_paladin_spawn.txt")
    end
    -- Controle externo via arquivo: mover
    local moveFile = io.open("data/npc/ai_paladin_move.txt", "r")
    if moveFile then
        local posStr = moveFile:read("*a")
        moveFile:close()
        if posStr and posStr ~= "" then
            local x, y, z = posStr:match("(%d+),(%d+),(%d+)")
            if x and y and z then
                self:moveTo({x = tonumber(x), y = tonumber(y), z = tonumber(z)})
            end
            -- Limpa arquivo após mover
            os.remove("data/npc/ai_paladin_move.txt")
            return
        end
    end

    -- Controle externo via arquivo: parar
    local controlFile = io.open("data/npc/ai_paladin_control.txt", "r")
    if controlFile then
        local cmd = controlFile:read("*a")
        controlFile:close()
        if cmd == "parar" then
            -- Não faz patrulha neste ciclo
            return
        end
    end

    -- Controle externo via arquivo: comportamento
    local behaviorFile = io.open("data/npc/ai_paladin_behavior.txt", "r")
    local modo = "patrulha"
    if behaviorFile then
        modo = behaviorFile:read("*a") or "patrulha"
        behaviorFile:close()
    end

    if modo == "agressivo" then
        -- Exemplo: patrulha mais rápida
        self:moveTo(patrolPositions[patrolIndex])
        patrolIndex = patrolIndex + 1
        if patrolIndex > #patrolPositions then patrolIndex = 1 end
        self:say("Estou em modo agressivo!")
    elseif modo == "passivo" then
        self:say("Estou em modo passivo, apenas observando.")
        -- Não patrulha
    else
        -- Modo padrão: patrulha
        self:moveTo(patrolPositions[patrolIndex])
        patrolIndex = patrolIndex + 1
        if patrolIndex > #patrolPositions then patrolIndex = 1 end
    end

    -- Ataque básico: se houver criatura próxima
    local spectators = Game.getSpectators(self:getPosition(), false, true, 5, 5, 5, 5)
    local monsterNearby = false
    for _, creature in ipairs(spectators) do
        if creature:isMonster() then
            monsterNearby = true
            self:say("Paladino IA ataca " .. creature:getName() .. "!")
            -- Aqui você pode adicionar lógica para atacar de verdade se o sistema permitir
        end
    end

    -- Lógica de fuga: se vida estiver baixa e houver monstro próximo
    if self:getHealth() < 30 and monsterNearby then
        self:say("Estou ferido! Preciso recuar!")
        self:moveTo(patrolPositions[1])
    end

    -- Simula comportamento de caça da IA
    ai_player:hunt()
end

function onCreatureAppear(creature)
    -- Pode adicionar lógica para reagir a jogadores ou monstros
end

function onCreatureDisappear(creature)
    -- Pode adicionar lógica para reagir à saída de criaturas
end

function onCreatureSay(creature, type, msg)
    local lowerMsg = msg:lower()
    if lowerMsg == "oi" or lowerMsg == "olá" then
        self:say("Olá, aventureiro! Precisa de ajuda ou quer caçar comigo?")
    elseif lowerMsg:find("ajuda") then
        self:say("Posso te mostrar como caçar ou usar magias de paladino!")
    elseif lowerMsg:find("caçar") then
        self:say("Vamos juntos! Siga-me e fique atento aos monstros.")
    elseif lowerMsg:find("adeus") or lowerMsg:find("tchau") then
        self:say("Boa sorte na sua jornada!")
    end
end

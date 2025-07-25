-- talkaction para invocar e remover IA do paladino
-- Salve como data/scripts/talkactions/god/ai_paladin.lua


local aiInstance = nil
local aiPaladin = TalkAction("/ai_paladin")

function aiPaladin.onSay(player, words, param)
    if player:getGroup():getId() < 3 then -- Apenas GODs podem usar
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Acesso negado. Apenas GODs.")
        return true
    end

    local args = {}
    for word in string.gmatch(param or "", "[^%s]+") do table.insert(args, word) end

    if args[1] == "invocar" then
        local file = io.open("data/npc/ai_paladin_spawn.txt", "w")
        file:write("spawn")
        file:close()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "NPC IA do paladino será spawnado!")
        return true
    elseif args[1] == "remover" then
        local file = io.open("data/npc/ai_paladin_spawn.txt", "w")
        file:write("despawn")
        file:close()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "NPC IA do paladino será removido!")
        return true
    elseif args[1] == "mover" and args[2] and args[3] and args[4] then
        -- Exemplo: /ai_paladin mover 32369 32241 7
        local x, y, z = tonumber(args[2]), tonumber(args[3]), tonumber(args[4])
        if x and y and z then
            -- Aqui você pode integrar com o script do NPC para mover
            -- Exemplo: salvar posição em arquivo para o NPC ler
            local file = io.open("data/npc/ai_paladin_move.txt", "w")
            file:write(x .. "," .. y .. "," .. z)
            file:close()
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Comando de movimento enviado para IA: " .. x .. ", " .. y .. ", " .. z)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Parâmetros inválidos para mover. Use: /ai_paladin mover x y z")
        end
        return true
    elseif args[1] == "parar" then
        local file = io.open("data/npc/ai_paladin_control.txt", "w")
        file:write("parar")
        file:close()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Comando de parada enviado para IA.")
        return true
    elseif args[1] == "comportamento" and args[2] then
        local modo = args[2]
        local file = io.open("data/npc/ai_paladin_behavior.txt", "w")
        file:write(modo)
        file:close()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Comportamento da IA alterado para: " .. modo)
        return true
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Comandos: /ai_paladin invocar | remover | mover x y z | parar | comportamento <modo>")
        return true
    end
end

aiPaladin:separator(" ")
aiPaladin:groupType("god")
aiPaladin:register()

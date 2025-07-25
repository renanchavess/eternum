-- talkaction para invocar e remover IA do paladino
-- Salve como data/talkactions/scripts/ai_paladin.lua

local aiInstance = nil

function onSay(player, words, param)
    if player:getGroup():getId() < 3 then -- Apenas GODs podem usar
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Acesso negado. Apenas GODs.")
        return false
    end

    if param == "invocar" then
        if aiInstance then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "IA já está ativa.")
            return false
        end
        local AIPlayer = dofile("data/modules/ai_player.lua")
        aiInstance = AIPlayer
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "IA do paladino invocada!")
        aiInstance:simulate()
        return false
    elseif param == "remover" then
        if not aiInstance then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Nenhuma IA ativa.")
            return false
        end
        aiInstance = nil
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "IA do paladino removida!")
        return false
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Use: /ai_paladin invocar ou /ai_paladin remover")
        return false
    end
end

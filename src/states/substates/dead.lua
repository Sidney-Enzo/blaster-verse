local dead = {}

local function toGameScore(_number, _scoreSize)
    local toPrint = ""
    if _scoreSize > string.len(math.floor(_number)) then
        for digitIndex = 1, _scoreSize - string.len(math.floor(_number)), 1 do
            toPrint = toPrint .. "0"
        end
    end
    return toPrint .. math.floor(_number)
end

function dead:enter()
    
end

function dead:draw()
    love.graphics.setFont(bit8AcardeIn)
    love.graphics.print("Game over", love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5, 0, 4, 4, love.graphics.getFont():getWidth("Game over")*0.5, love.graphics.getFont():getHeight()*0.5)
    love.graphics.print("Score " .. toGameScore(score, 5), love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5 + 28, 0, 2, 2, love.graphics.getFont():getWidth("Score " .. toGameScore(score, 5)), 0)
    love.graphics.print("HI " .. toGameScore(lollipop.currentSave.game.highScore, 5), love.graphics.getWidth()*0.5 + 48, love.graphics.getHeight()*0.5 + 28, 0, 2, 2, 0, 0)
    love.graphics.print("Press to go home", love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5 + 52, 0, 1, 1, love.graphics.getFont():getWidth("Press to go home")*0.5, 0)
    love.graphics.setFont(defaultFont)
end

function dead:mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        love.mouse.setVisible(true)
        gamestate.switch(states.mainMenu)
    end
end

function dead:touchpressed(id, x, y, dx, dy, pressure)
    gamestate.switch(states.mainMenu)
end

return dead
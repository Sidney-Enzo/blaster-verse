local credits = {}

function credits:enter()
    
end

function credits:draw()
    love.graphics.setFont(bit8AcardeIn)
    love.graphics.print("Created by", love.graphics.getWidth()*0.5, 32, 0, 3, 3, love.graphics.getFont():getWidth("Created by")*0.5, 0)
    love.graphics.print("Foxy Ayano", love.graphics.getWidth()*0.5, 64, 0, 2, 2, love.graphics.getFont():getWidth("Foxy Ayano")*0.5, 0)
    love.graphics.print("Art by", love.graphics.getWidth()*0.5, 128, 0, 3, 3, love.graphics.getFont():getWidth("Art by")*0.5, 0)
    love.graphics.print("Foxy Ayano and Sathxxip", love.graphics.getWidth()*0.5, 160, 0, 2, 2, love.graphics.getFont():getWidth("Foxy Ayano and sathxxip")*0.5, 0)
    love.graphics.print("Music by", love.graphics.getWidth()*0.5, 224, 0, 3, 3, love.graphics.getFont():getWidth("Music by")*0.5, 0)
    love.graphics.print("Shirobon", love.graphics.getWidth()*0.5, 256, 0, 2, 2, love.graphics.getFont():getWidth("Shirobon")*0.5, 0)
    love.graphics.print("Special thanks", love.graphics.getWidth()*0.5, 290, 0, 3, 3, love.graphics.getFont():getWidth("Special thanks")*0.5, 0)
    love.graphics.print("Moon", love.graphics.getWidth()*0.5, 322, 0, 2, 2, love.graphics.getFont():getWidth("Moon")*0.5, 0)
    love.graphics.print("Angel", love.graphics.getWidth()*0.5, 354, 0, 2, 2, love.graphics.getFont():getWidth("Angel")*0.5, 0)
    love.graphics.setFont(defaultFont)
end

function credits:update(deltaTime)
    if suit.Button("X", {id = "backToHome"}, love.graphics.getWidth() - 48, 16, 32, 32).hit then
        gamestate.switch(states.mainMenu)
    end
end

return credits
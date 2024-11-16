local mainMenu = {}

function mainMenu:enter()
    self.stars = {}

    for star = 0, 50, 1 do
        table.insert(self.stars, 
            {
                x = love.math.random(0, love.graphics.getWidth()),
                y = love.math.random(0, love.graphics.getHeight()),
                r = love.math.random(1, 2)
            }
        )
    end

    backgroundMusic:play()
    backgroundMusic:setVolume(lollipop.currentSave.game.musicVolume)
    backgroundMusic:setLooping(true)
end

function mainMenu:draw()
    for _, star in ipairs(self.stars) do
        love.graphics.circle("fill", star.x, star.y, star.r)
    end
    love.graphics.setFont(bit8AcardeIn)
    love.graphics.print("Blaster", love.graphics.getWidth()*0.5, 16, -math.pi/16, 6, 6, love.graphics.getFont():getWidth("Blaster")*0.5, 0)
    love.graphics.print("Verse", love.graphics.getWidth()*0.5, 64, math.pi/36, 4, 4, 0, 0)
    love.graphics.print("Copyright orange fox 2024", love.graphics.getWidth()*0.5, love.graphics.getHeight() - 32, 0, 1, 1, love.graphics.getFont():getWidth("Copyright orange fox 2024")*0.5, 0)
    love.graphics.setFont(defaultFont)
end

function mainMenu:update(deltaTime)
    if suit.Button("Play", {id = "play", font = bit8AcardeInBig}, love.graphics.getWidth()*0.5 - 128, love.graphics.getHeight()*0.5 - 64, 256, 60).hit then
        backgroundMusic:stop()
        gamestate.switch(states.playstate)
    elseif suit.Button("Options", {id = "options", font = bit8AcardeInBig}, love.graphics.getWidth()*0.5 - 128, love.graphics.getHeight()*0.5, 256, 60).hit then
        gamestate.switch(states.options)
    elseif suit.Button("Credits", {id = "credits", font = bit8AcardeInBig}, love.graphics.getWidth()*0.5 - 128, love.graphics.getHeight()*0.5 + 64, 255, 60).hit then
        gamestate.switch(states.credits)
    elseif suit.Button("Quit", {id = "quit", font = bit8AcardeInBig}, love.graphics.getWidth()*0.5 - 128, love.graphics.getHeight()*0.5 + 128, 255, 60).hit then
        love.event.quit()
    end
end

return mainMenu
local pause = {}

function pause:initialize()
    self.icons = {}
    self.icons.sheet, self.icons.quads = love.graphics.getQuads("assets/images/icons.png", 16, 16, 0, 0)

    audioVolume = {min = 0, value = lollipop.currentSave.game.audioVolume, max = 1}
    musicVolume = {min = 0, value = lollipop.currentSave.game.musicVolume, max = 1}

    optionsOpen = false
end

function pause:draw()
    love.graphics.setColor(0, 0, 0, 0.75)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(bit8AcardeIn)
    if optionsOpen then
        love.graphics.print("Options", love.graphics.getWidth()*0.5, 64, 0, 4, 4, love.graphics.getFont():getWidth("Paused")*0.5, 0)
        love.graphics.print("Audio", love.graphics.getWidth()*0.5 - 128, love.graphics.getHeight()*0.5 - 80, 0, 2, 2, 0, 0)
        love.graphics.print(math.floor(audioVolume.value*100), love.graphics.getWidth()*0.5 + 136, love.graphics.getHeight()*0.5 - 48, 0, 1, 1, 0, 0)
        love.graphics.print("Music", love.graphics.getWidth()*0.5 - 128, love.graphics.getHeight()*0.5 + 16, 0, 2, 2, 0, 0)
        love.graphics.print(math.floor(musicVolume.value*100), love.graphics.getWidth()*0.5 + 136, love.graphics.getHeight()*0.5 + 48, 0, 1, 1, 0, 0)
    else
        love.graphics.print("Paused", love.graphics.getWidth()*0.5, 64, 0, 4, 4, love.graphics.getFont():getWidth("Paused")*0.5, 0)
        love.graphics.draw(self.icons.sheet, self.icons.quads[2], love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5, 0, 4, 4, 8, 8)
        love.graphics.draw(self.icons.sheet, self.icons.quads[3], love.graphics.getWidth()*0.5 + 80, love.graphics.getHeight()*0.5, 0, 3, 3, 8, 8)
        love.graphics.draw(self.icons.sheet, self.icons.quads[4], love.graphics.getWidth()*0.5 - 80, love.graphics.getHeight()*0.5, 0, 3, 3, 8, 8)
    end
    love.graphics.setFont(defaultFont)
end

function pause:update(deltaTime)
    if optionsOpen then
        suit.Slider(audioVolume, {id = "audio"}, love.graphics.getWidth()*0.5 - 128, love.graphics.getHeight()*0.5 - 48, 256, 16)
        suit.Slider(musicVolume, {id = "music"}, love.graphics.getWidth()*0.5 - 128, love.graphics.getHeight()*0.5 + 48, 256, 16)
        lollipop.currentSave.game.audioVolume = audioVolume.value
        lollipop.currentSave.game.musicVolume = musicVolume.value
        if suit.Button("X", {id = "backToPause"}, love.graphics.getWidth()*0.5 + 128, love.graphics.getHeight()*0.5 - 96, 32, 32).hit then
            optionsOpen = false
            pew:setVolume(0.25*lollipop.currentSave.game.audioVolume)
            asteroidExplosion:setVolume(lollipop.currentSave.game.audioVolume)
            shipExplosion:setVolume(lollipop.currentSave.game.audioVolume)

            spaceSound:setVolume(lollipop.currentSave.game.audioVolume)
            backgroundMusic:setVolume(lollipop.currentSave.game.musicVolume)
        end
    else 
        if suit.Button("", {id = "unPause"}, love.graphics.getWidth()*0.5 - 32, love.graphics.getHeight()*0.5 - 32, 64, 64).hit then
            isPaused = false
            love.mouse.setVisible(false)
        elseif suit.Button("", {id = "home"}, love.graphics.getWidth()*0.5 - 104, love.graphics.getHeight()*0.5 - 24, 48, 48).hit then
            optionsOpen = true
        elseif suit.Button("", {id = "options"}, love.graphics.getWidth()*0.5 + 56, love.graphics.getHeight()*0.5 - 24, 48, 48).hit then
            gamestate.switch(states.mainMenu)
        end
    end
end

return pause
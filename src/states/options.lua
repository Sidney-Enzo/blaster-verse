local options = {}

function options:enter()
    audioVolume = {min = 0, value = lollipop.currentSave.game.audioVolume, max = 1}
    musicVolume = {min = 0, value = lollipop.currentSave.game.musicVolume, max = 1}
end

function options:draw()
    love.graphics.setFont(bit8AcardeIn)
    love.graphics.print("Audio", love.graphics.getWidth()*0.5 - 128, love.graphics.getHeight()*0.5 - 80, 0, 2, 2, 0, 0)
    love.graphics.print(math.floor(audioVolume.value*100), love.graphics.getWidth()*0.5 + 136, love.graphics.getHeight()*0.5 - 48, 0, 1, 1, 0, 0)
    love.graphics.print("Music", love.graphics.getWidth()*0.5 - 128, love.graphics.getHeight()*0.5 + 16, 0, 2, 2, 0, 0)
    love.graphics.print(math.floor(musicVolume.value*100), love.graphics.getWidth()*0.5 + 136, love.graphics.getHeight()*0.5 + 48, 0, 1, 1, 0, 0)
    love.graphics.setFont(defaultFont)
end

function options:update(deltaTime)
    suit.Slider(audioVolume, {id = "audio"}, love.graphics.getWidth()*0.5 - 128, love.graphics.getHeight()*0.5 - 48, 256, 16)
    suit.Slider(musicVolume, {id = "music"}, love.graphics.getWidth()*0.5 - 128, love.graphics.getHeight()*0.5 + 48, 256, 16)

    if suit.Button("X", {id = "backToHome"}, love.graphics.getWidth() - 48, 16, 32, 32).hit then
        lollipop.currentSave.game.audioVolume = audioVolume.value
        lollipop.currentSave.game.musicVolume = musicVolume.value
        lollipop.saveSlot("gameSave")
        gamestate.switch(states.mainMenu)
    end
end

return options
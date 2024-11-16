local loadScreen = {}

function loadScreen:enter()
    backgroundMusic = love.audio.newSource("assets/audios/msc/journeyLovingStar.ogg", "stream")
    orangeFoxlogo = love.graphics.newImage("assets/images/logos/orangeFox.png")
    bit8AcardeIn = love.graphics.newFont("assets/fonts/8-bitArcadeIn.ttf", 16)
    bit8AcardeInBig = love.graphics.newFont("assets/fonts/8-bitArcadeIn.ttf", 64)
    self.timer = 0
end

function loadScreen:draw()
    love.graphics.setColor(self.timer/2.5, self.timer/2.5, self.timer/2.5, 1)
    love.graphics.draw(orangeFoxlogo, love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5, 0, 4, 4, orangeFoxlogo:getWidth()*0.5, orangeFoxlogo:getHeight()*0.5)
    love.graphics.setColor(1, 1, 1, 1)
end

function loadScreen:update(deltaTime)
    self.timer = self.timer + deltaTime
    if self.timer > 2.5 then
        orangeFoxlogo:release()
        gamestate.switch(states.mainMenu)
    end
end

return loadScreen
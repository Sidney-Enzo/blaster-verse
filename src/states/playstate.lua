local playstate = {}

local function playsong(audio, looping, volume)
    audio:play()
    audio:setVolume(volume or audio:getVolume())
    audio:setLooping(looping)
end

function playstate:enter()
    player = require 'src/modules/player'
    hud = require 'src/modules/hud'
    background = require 'src/modules/background'
    asteroids = require 'src/modules/asteroids'

    dead = require 'src/states/substates/dead'
    pause = require 'src/states/substates/pause'

    viewCamera = camera.new(love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5, 1.5, 0)

    pew = love.audio.newSource("assets/audios/sfx/pew.ogg", "static")
    shipExplosion = love.audio.newSource("assets/audios/sfx/shipExplosion.ogg", "static")
    asteroidExplosion = love.audio.newSource("assets/audios/sfx/asteroidExplosion.ogg", "static")
    spaceSound = love.audio.newSource("assets/audios/sfx/spaceSound.ogg", "stream")

    score = 0

    isPaused = false

    love.mouse.setVisible(false)

    player:initialize(love.graphics.getWidth()*0.5 - 16, love.graphics.getHeight()*0.5 - 16, 0)
    hud:initialize()
    background:initialize(50)
    asteroids:initialize()
    pause:initialize()

    pew:setVolume(0.25*lollipop.currentSave.game.audioVolume)
    asteroidExplosion:setVolume(lollipop.currentSave.game.audioVolume)
    shipExplosion:setVolume(lollipop.currentSave.game.audioVolume)

    playsong(spaceSound, true, lollipop.currentSave.game.audioVolume)
    playsong(backgroundMusic, true, lollipop.currentSave.game.musicVolume)
end

function playstate:draw()
    if not player.isAlive then
        dead:draw()
        return
    end
    background:draw()
    
    viewCamera:attach()
    player:draw()
    asteroids:draw()
    viewCamera:detach()

    if isPaused then
        pause:draw()
        return
    end
    hud:draw()
end

function playstate:update(deltaTime)
    if isPaused then
        pause:update(deltaTime)
    elseif player.isAlive then
        hud:update(deltaTime)
        player:update(deltaTime)
        asteroids:update(deltaTime)

        score = score + deltaTime*10
    end
end

function playstate:touchpressed(id, x, y, dx, dy, pressure)
    if not player.isAlive then
        dead:touchpressed(id, x, y, dx, dy, pressure)
    end
end

function playstate:mousepressed(x, y, button, istouch, presses)
    if not player.isAlive then
        dead:mousepressed(x, y, button, istouch, presses)
    end
end

return playstate
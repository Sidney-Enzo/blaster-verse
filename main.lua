function love.graphics.getQuads(textureSource, ...)
    local function overload(quadSource, ...)
        if type(quadSource) == 'number' then
            return nil, quadSource, ...
        end

        return json.decode(love.filesystem.read(quadSource))
    end

    local texture = love.graphics.newImage(textureSource)
    local sparrow, quadWidth, quadHeight, quadPaddingX, quadPaddingY = overload(...)
    local quads = {}

    if sparrow then
        for _, quad in ipairs(sparrow.frames) do
            table.insert(quads, 
                love.graphics.newQuad(
                    quad.frame.x,
                    quad.frame.y,
                    quad.frame.w,
                    quad.frame.h,
                    texture
                )
            )
        end

        return texture, quads
    end

    for quadY = 0, texture:getHeight(), quadHeight + (quadPaddingY or 0) do
        for quadX = 0, texture:getWidth(), quadWidth + (quadPaddingX or 0) do
            table.insert(quads,
                love.graphics.newQuad(
                    quadX,
                    quadY,
                    quadWidth,
                    quadHeight,
                    texture
                )
            )
        end
    end
    
    return texture, quads
end

function love.load()
    json = require 'libaries/json'
    camera = require 'libaries/camera'
    collision = require 'libaries/collision'
    gamestate = require 'libaries/gamestate'
    suit = require 'libaries/suit'
    lollipop = require 'libaries/lollipop'

    lollipop.currentSave.game = {
        highScore = 0,
        audioVolume = 1,
        musicVolume = 1
    }
    lollipop.initializeSlot 'gameSave'

    states = {
        loadScreen = require 'src/states/loadscreen',
        mainMenu = require 'src/states/mainMenu',
        options = require 'src/states/options',
        playstate = require 'src/states/playstate',
        credits = require 'src/states/credits'
    }

    suit.theme.color.normal = { fg = { 1, 1, 1, 1 }, bg = { 0, 0, 0, 0 } }
    suit.theme.color.active = { fg = { 1, 1, 1, 1 }, bg = { 1, 1, 1, 0.5 } }
    suit.theme.color.hovered = { fg = { 1, 1, 1, 1 }, bg = { 1, 1, 1, 0.5 } }

    system = love.system.getOS()

    isMobile = (system == 'Android' or system == 'iOS')
    defaultFont = love.graphics.setNewFont(16)

    if isMobile then
        love.window.setFullscreen(true)
    end
    love.graphics.setDefaultFilter('nearest', 'nearest') --better filter
    gamestate.registerEvents({ 'update', 'keypressed', 'touchpressed', 'touchmoved', 'touchreleased', 'wheelmoved', 'mousepressed', 'mousemoved', 'mousereleased' })
    gamestate.switch(states.loadScreen)
end

function love.draw()
    gamestate:current():draw()
    suit.draw()
end

function love.quit()
    --&save game
    if (score or 0) > lollipop.currentSave.game.highScore then
        lollipop.currentSave.game.highScore = score
    end
    lollipop.saveSlot("gameSave")
end
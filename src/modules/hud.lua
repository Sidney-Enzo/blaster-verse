local hud = {}

local function normalize(_x, _y)
    local _lenght = (_x*_x + _y*_y)^0.5
    
    if _lenght == 0 then 
        return 0, 0, 0
    elseif _lenght == 1 then
        return _x, _y, 1
    end
    
    return _x/_lenght, _y/_lenght, _lenght 
end

local function dist2(_x1, _y1, _x2, _y2)
    return ((_x2 - _x1)*(_x2 - _x1) + (_y2 - _y1)*(_y2 - _y1))^0.5
end

local function toGameScore(_number, _scoreSize)
    local toPrint = ""
    if _scoreSize > string.len(math.floor(_number)) then
        for digitIndex = 1, _scoreSize - string.len(math.floor(_number)), 1 do
            toPrint = toPrint .. "0"
        end
    end
    return toPrint .. math.floor(_number)
end

function hud:initialize()
    joystick = require 'src/modules/objects/joystick'

    self.heart = love.graphics.newImage("assets/images/heart.png")
    if isMobile then
        self.joystick = joystick(160, love.graphics.getHeight() - 128, 64)
    end
    joystickConnections = love.joystick.getJoysticks()
    if #joystickConnections > 0 then
        self.joystick = joystickConnections
    end
end

function hud:draw()
--&hud
    love.graphics.setColor(1, 1, 1, 0.75)
    --%score
    love.graphics.setFont(bit8AcardeIn)
    love.graphics.print("SCORE " .. toGameScore(score, 5), 10, 8, 0, 2, 2, 0, 0)
    love.graphics.print("HI " .. toGameScore(lollipop.currentSave.game.highScore, 5), love.graphics.getWidth(), 8, 0, 2, 2, love.graphics.getFont():getWidth("HI " .. toGameScore(lollipop.currentSave.game.highScore, 5)), 0)
    for life = 1, player.hitpoints, 1 do
        love.graphics.draw(self.heart, 8 + 24*(life - 1), 32, 0, 1.5, 1.5, 0, 0)
    end
    love.graphics.setColor(1, 1, 1, 1)
    if isMobile then
        self.joystick:draw()
    --%buttons
        love.graphics.draw(pause.icons.sheet, pause.icons.quads[1], love.graphics.getWidth()*0.5, 16, 0, 2, 2, 8, 0)
    end
    love.graphics.setFont(defaultFont)
    --%debug
--    love.graphics.print("normalizeX " .. self.joystick.normalized.x, 8, 48, 0, 1, 1, 0, 0)
--    love.graphics.print("normalizeY " .. self.joystick.normalized.y, 8, 64, 0, 1, 1, 0, 0)
--    love.graphics.print("playerR " .. player.rotation, 8, 80, 0, 1, 1, 0, 0)
    --%joystick
end

function hud:update(deltaTime)
    local touches = love.touch.getTouches()
    local joystickMoved = false
    if #joystickConnections > 0 then
        local x = self.joystick[1]:getGamepadAxis("leftx")
        local y = self.joystick[1]:getGamepadAxis("lefty")

        if player.velocity.x < player.maxSpeed then
            player.aceleration.x = x*player.speed
        end

        if player.velocity.y < player.maxSpeed then
            player.aceleration.y = y*player.speed
        end

        if x ~= 0 or y ~= 0 then
            joystickMoved = true
        end

        if self.joystick[1]:isGamepadDown("a") then
            player:fire()
        end
    elseif isMobile then
        if suit.Button("", {id = "pause"}, love.graphics.getWidth()*0.5 - 16, 16, 32, 32).hit then
            isPaused = true
            return
        else
            for _, touch in ipairs(touches) do
                local touchX, touchY = love.touch.getPosition(touch)
                if touchX > love.graphics.getWidth()*0.5 then
                    player:fire()
                else
                    --&joystick
                    --%math
                    self.joystick.normalized.x, self.joystick.normalized.y = normalize(touchX - self.joystick.scrollingArea.x, touchY - self.joystick.scrollingArea.y)
                    --%paddle
                    if dist2(self.joystick.scrollingArea.x, self.joystick.scrollingArea.y, touchX, touchY) < self.joystick.scrollingArea.radius then
                        self.joystick.normalized.x = (self.joystick.paddle.x - self.joystick.scrollingArea.x)/self.joystick.scrollingArea.radius
                        self.joystick.normalized.y = (self.joystick.paddle.y - self.joystick.scrollingArea.y)/self.joystick.scrollingArea.radius

                        self.joystick.paddle.x = touchX
                        self.joystick.paddle.y = touchY
                    else
                        self.joystick.paddle.x = self.joystick.scrollingArea.x + self.joystick.normalized.x*self.joystick.scrollingArea.radius
                        self.joystick.paddle.y = self.joystick.scrollingArea.y + self.joystick.normalized.y*self.joystick.scrollingArea.radius
                    end
                    --%player math to convert vector in radians

                    if player.rotation > 0 or player.rotation < -math.pi then
                        player.currentQuad = 2
                    else
                        player.currentQuad = 3
                    end

                    joystickMoved = true
                end
            end
        end
        
        if player.velocity.x < player.maxSpeed then
            player.aceleration.x = self.joystick.normalized.x*player.speed
        end

        if player.velocity.y < player.maxSpeed then
            player.aceleration.y = self.joystick.normalized.y*player.speed
        end
    
        if not joystickMoved then
            player.currentQuad = 1

            self.joystick.normalized.x, self.joystick.normalized.y = 0, 0
            self.joystick.paddle.x = self.joystick.scrollingArea.x
            self.joystick.paddle.y = self.joystick.scrollingArea.y
        end
    else
        if love.keyboard.isDown('escape') then
            isPaused = true
            love.mouse.setVisible(true)
        end
        local accelerationX, accelerationY, normAccelerationX, normAccelerationY = 0, 0
        if love.keyboard.isDown('a', 'left') then
            accelerationX = -1
        end
        if love.keyboard.isDown('w', 'up') then
            accelerationY = -1
        end
        if love.keyboard.isDown('s', 'down') then
            accelerationY = 1
        end
        if love.keyboard.isDown('d', 'right') then
            accelerationX = 1
        end
        normAccelerationX, normAccelerationY = normalize(accelerationX, accelerationY)
        if player.velocity.x < player.maxSpeed then
            player.aceleration.x = normAccelerationX*player.speed
        end
        if player.velocity.y < player.maxSpeed then
            player.aceleration.y = normAccelerationY*player.speed
        end
        if love.mouse.isDown(1) or love.keyboard.isDown('space') then
            player:fire()
        end
    end
    if player.velocity.x ~= 0 or player.velocity.y ~= 0 then
        player.rotation = math.pi - math.atan2(player.velocity.x, player.velocity.y)
    end
end

return hud
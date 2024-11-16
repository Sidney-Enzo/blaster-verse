local joystick = {}
joystick.__index = joystick

local function new(x. y, radius)
    local newJoystick = {
        scrollingArea = {
            x = x, 
            y = y,
            radius = radius
        },
        paddle = {
            x = x,
            y = y,
            radius = radius/2
        },
        normalized = {
            x = 0,
            y = 0
        }
    }
end

function joystick:draw()
    love.graphics.circle('line', self.joystick.scrollingArea.x, self.joystick.scrollingArea.y, self.joystick.scrollingArea.radius)
    love.graphics.circle('fill', self.joystick.paddle.x, self.joystick.paddle.y, self.joystick.paddle.radius)
end

function joystick:getNormalize()

end

return setmetatable(joystick {
    __call = function(_, ...)
        return new(...)
    end
})
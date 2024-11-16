local background = {}

function background:initialize(_starts)
    self.stars = {}
    for star = 0, _starts, 1 do
        table.insert(self.stars, 
            {
                x = love.math.random(0, love.graphics.getWidth()),
                y = love.math.random(0, love.graphics.getHeight()),
                r = love.math.random(1, 2)
            }
        )
    end
    self.blackhole = {}
    self.blackhole.texture = love.graphics.newImage("assets/images/background/blackhole.png")
    self.blackhole.x = love.math.random(0, love.graphics.getWidth() - self.blackhole.texture:getWidth())
    self.blackhole.y = love.math.random(0, love.graphics.getHeight() - self.blackhole.texture:getHeight())

    self.satellite = {}
    self.satellite.texture = love.graphics.newImage("assets/images/background/satellite.png")
    self.satellite.x = love.math.random(0, love.graphics.getWidth() - self.satellite.texture:getWidth())
    self.satellite.y = love.math.random(0, love.graphics.getHeight() - self.satellite.texture:getHeight())

    self.netuno = {}
    self.netuno.texture = love.graphics.newImage("assets/images/background/netuno.png")
    self.netuno.x = love.math.random(0, love.graphics.getWidth() - self.netuno.texture:getWidth())
    self.netuno.y = love.math.random(0, love.graphics.getHeight() - self.netuno.texture:getHeight())

    self.kb28c = {}
    self.kb28c.texture = love.graphics.newImage("assets/images/background/kb-28c.png")
    self.kb28c.x = love.math.random(0, love.graphics.getWidth() - self.kb28c.texture:getWidth())
    self.kb28c.y = love.math.random(0, love.graphics.getHeight() - self.kb28c.texture:getHeight())

    self.moon = {}
    self.moon.texture = love.graphics.newImage("assets/images/background/moon.png")
    self.moon.x = love.math.random(0, love.graphics.getWidth() - self.moon.texture:getWidth())
    self.moon.y = love.math.random(0, love.graphics.getHeight() - self.moon.texture:getHeight())

    self.nebula = {}
    self.nebula.texture = love.graphics.newImage("assets/images/background/nebula.png")
    self.nebula.x = love.math.random(0, love.graphics.getWidth() - self.moon.texture:getWidth())
    self.nebula.y = love.math.random(0, love.graphics.getHeight() - self.moon.texture:getHeight())
end

function background:draw()
    for _, star in ipairs(self.stars) do
        love.graphics.circle("fill", star.x, star.y, star.r)
    end
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.draw(self.nebula.texture, self.nebula.x, self.nebula.y, 0, 3, 3)
    love.graphics.draw(self.blackhole.texture, self.blackhole.x, self.blackhole.y, 0, 4, 4)
    love.graphics.draw(self.satellite.texture, self.satellite.x, self.satellite.y, 0, 0.5, 0.5)
    love.graphics.draw(self.moon.texture, self.moon.x, self.moon.y, 0, 1, 1)
    love.graphics.draw(self.netuno.texture, self.netuno.x, self.netuno.y, 0, 1, 1)
    love.graphics.draw(self.kb28c.texture, self.kb28c.x, self.kb28c.y, 0, 1, 1)
    love.graphics.setColor(1, 1, 1, 1)
end

return background
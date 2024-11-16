local player = {}

function player:initialize(_xPosition, _yPosition, _rotation)
    self.texture, self.quads = love.graphics.getQuads("assets/images/ship.png", 32, 32, 0, 0)

    self.trail = {}
    self.maxTrailWidth = 2
    self.maxTrailLenght = 128
    self.trailTimer = 0
    self.trailDuratuion = 0.03

    self.collider = {
        x = _xPosition or 0,
        y = _yPosition or 0,
        w = 28,
        h = 26,
    }
    self.aceleration = {
        x = 0,
        y = 0
    }
    self.velocity = {
        x = 0,
        y = 0
    }
    self.rotation = _rotation or 0
    self.currentQuad = 1
    self.maxSpeed = 600
    self.speed = 300
    self.friction = 2
    self.hitpoints = 3
    self.damage = 25
    self.bulletSpeed = 512
    self.invencibleTimer = 0
    self.invencibleAnimationTimer = 0
    self.fireTimer = 0
    self.fireRate = 0.25
    self.invencible = false
    self.isAlive = true
end

function player:draw()
    for _, circle in ipairs(self.trail) do
        local color = 1 - (#self.trail - (_ + 1))/#self.trail
        local radius = self.maxTrailWidth*color
        love.graphics.setColor(color, color, color, 0.75)
        love.graphics.circle("fill", circle.x, circle.y, radius)
    end

    if self.invencibleAnimationTimer > 0.25 then
        love.graphics.setColor(1, 1, 1, 0.5)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.draw(self.texture, self.quads[self.currentQuad], self.collider.x + self.collider.w*0.5, self.collider.y + self.collider.h*0.5, self.rotation, 1, 1, 16, 15)
    love.graphics.setColor(1, 1, 1, 1)
    --love.graphics.rectangle("line", self.collider.x, self.collider.y, self.collider.w, self.collider.h)
end

function player:update(deltaTime)
    self.fireTimer = self.fireTimer + deltaTime
    self.velocity.x = self.velocity.x + self.aceleration.x*deltaTime
    self.velocity.y = self.velocity.y + self.aceleration.y*deltaTime

    self.velocity.x = self.velocity.x - self.velocity.x*self.friction*deltaTime
    self.velocity.y = self.velocity.y - self.velocity.y*self.friction*deltaTime

    if math.abs(self.velocity.x) < 2 then
        self.velocity.x = 0
    end
    if math.abs(self.velocity.y) < 2 then
        self.velocity.y = 0
    end

    self.collider.x = self.collider.x + self.velocity.x*deltaTime
    self.collider.y = self.collider.y + self.velocity.y*deltaTime

--&player limits
    local x0, y0 = viewCamera:worldCoords(0, 0)
    local x1, y1 = viewCamera:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())
    if self.collider.x < x0 then
        self.aceleration.x = 0
        self.velocity.x = 0
        self.collider.x = x0
    end
    if self.collider.x + self.collider.w > x1 then
        self.aceleration.x = 0
        self.velocity.x = 0
        self.collider.x = x1 - self.collider.w
    end

    if self.collider.y < y0 then
        self.aceleration.y = 0
        self.velocity.y = 0
        self.collider.y = y0
    end
    if self.collider.y + self.collider.h > y1 then
        self.aceleration.y = 0
        self.velocity.y = 0
        self.collider.y = y1 - self.collider.h
    end

--&player trail
    if self.velocity.x ~= 0 or self.velocity.y ~= 0 then
        self:addTrailSegment(self.collider.x + 4 + (self.collider.w*0.5 - 4)*(1 - math.cos(self.rotation)), self.collider.y + 4 + (self.collider.h*0.5 - 4)*(1 - math.sin(self.rotation)))
        self:addTrailSegment(self.collider.x + 4 + (self.collider.w*0.5 - 4)*(1 - math.cos(self.rotation + math.pi)), self.collider.y + 4 + (self.collider.h*0.5 - 4)*(1 - math.sin(self.rotation + math.pi)))
    end

    if #self.trail > 1 then
        self.trailTimer = self.trailTimer + deltaTime

        if self.trailTimer > self.trailDuratuion then
            table.remove(self.trail, 1)
            table.remove(self.trail, 1)
            self.trailTimer = 0
        end
    end
    
    if #self.trail > self.maxTrailLenght then
        table.remove(self.trail, 1)
        table.remove(self.trail, 1)
    end
--&invencibiliy
    if self.invencibleTimer > 0 then
        self.invencibleTimer = self.invencibleTimer - deltaTime
    else
        self.invencible = false
    end

    if self.invencible then
        self.invencibleAnimationTimer = self.invencibleAnimationTimer + deltaTime

        if self.invencibleAnimationTimer > 0.5 then
            self.invencibleAnimationTimer = 0
        end
    else
        self.invencibleAnimationTimer = 0
    end
end

function player:fire()
    if self.fireTimer > player.fireRate then
        --&fire
        asteroids:createBullet(self.collider.x + (self.collider.w*0.5 - 4)*(1 - math.cos(self.rotation)), self.collider.y + (self.collider.h*0.5 - 4)*(1 - math.sin(self.rotation)), 4, 4, math.cos(self.rotation - math.pi*0.5)*self.bulletSpeed, math.sin(self.rotation - math.pi*0.5)*self.bulletSpeed)
        asteroids:createBullet(self.collider.x + 4 + (self.collider.w*0.5 - 4)*(1 - math.cos(self.rotation + math.pi)), self.collider.y + 4 + (self.collider.h*0.5 - 4)*(1 - math.sin(self.rotation + math.pi)), 4, 4, math.cos(self.rotation - math.pi*0.5)*self.bulletSpeed, math.sin(self.rotation - math.pi*0.5)*self.bulletSpeed)
        self.fireTimer = 0
        --%fire song
        if not pew:isPlaying() then
            pew:play()
        end
        pew:seek(0)
    end
end

function player:addTrailSegment(_x, _y)
    table.insert(self.trail, {
        x = _x,
        y = _y
    })
end

function player:applyImpulse(_impulseX, _impulseY)
    self.aceleration.x = self.aceleration.x + _impulseX
    self.aceleration.y = self.aceleration.y + _impulseY
end

return player
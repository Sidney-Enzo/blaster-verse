local asteroids = {}

function asteroids:initialize()
    self.asteroidsTexture, self.asteroidsQuads = love.graphics.getQuads("assets/images/asteroid.png", 32, 32)

    self.spawn = {}
    self.spawn.list = {}
    self.spawn.rate = 1
    self.spawn.timer = 0

    self.bullets = {}
end

function asteroids:draw()
    for _, asteroid in ipairs(self.spawn.list) do
        love.graphics.draw(self.asteroidsTexture, self.asteroidsQuads[asteroid.quad], asteroid.collider.x + asteroid.collider.w*0.5, asteroid.collider.y + asteroid.collider.h*0.5, asteroid.rotation, asteroid.scale, asteroid.scale, 16, 16)
        --love.graphics.rectangle("line", asteroid.collider.x, asteroid.collider.y, asteroid.collider.w, asteroid.collider.h)
    end

    for _, bullet in ipairs(self.bullets) do
        love.graphics.setColor(1, 1, 0, 1)
        love.graphics.circle("fill", bullet.collider.x + bullet.collider.w*0.5, bullet.collider.y + bullet.collider.h*0.5, bullet.collider.w*0.5)
        love.graphics.setColor(1, 1, 1, 1)
        --love.graphics.rectangle("line", bullet.collider.x, bullet.collider.y, bullet.collider.w, bullet.collider.h)
    end
end

function asteroids:update(deltaTime)
    self.spawn.timer = self.spawn.timer + deltaTime

    local x0, y0 = viewCamera:worldCoords(0, 0)
    local x1, y1 = viewCamera:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())

    if self.spawn.rate > 0.25 then
        self.spawn.rate = self.spawn.rate - deltaTime/120
    end

    if self.spawn.timer >= self.spawn.rate then
        local side = love.math.random(0, 100)

        if side < 25 then
            asteroids:createAsteroid(love.math.random(x0 - 24, x1), y0 - 24, 24, 24, love.math.random(50, 200)*0.01, love.math.random(-50, 50), love.math.random(75, 150), 75, love.math.random(1, 4))
        elseif side >= 25 and side < 50 then
            asteroids:createAsteroid(love.math.random(x0 - 24, x1), y1, 24, 24, love.math.random(50, 200)*0.01, love.math.random(-50, 50), -love.math.random(75, 150), 75, love.math.random(1, 4))
        elseif side >= 50 and side < 75 then
            asteroids:createAsteroid(x0 - 24, love.math.random(y0 - 24, y1), 24, 24, love.math.random(50, 200)*0.01, love.math.random(75, 150), love.math.random(-50, 50), 75, love.math.random(1, 4))
        else
            asteroids:createAsteroid(x1, love.math.random(y0 - 24, y1), 24, 24, love.math.random(50, 200)*0.01, -love.math.random(75, 150), love.math.random(-50, 50), 75, love.math.random(1, 4))
        end

        self.spawn.timer = 0
    end
    
    for b, bullet in ipairs(self.bullets) do
        bullet.collider.x = bullet.collider.x + bullet.velocity.x*deltaTime
        bullet.collider.y = bullet.collider.y + bullet.velocity.y*deltaTime

        for a, asteroid in ipairs(self.spawn.list) do
            if collision.rectangleRectangle(bullet.collider, asteroid.collider) and not asteroid.isDistroyed then
                asteroid.hitpoints = asteroid.hitpoints - player.damage

                if asteroid.hitpoints <= 0 then
                    score = score + 100
                    asteroid.quad = 5
                    asteroid.isDistroyed = true
                    if not asteroidExplosion:isPlaying() then
                        asteroidExplosion:play()
                    else
                        asteroidExplosion:seek(0)
                    end
                end

                table.remove(self.bullets, b)
            end
        end
        
        if bullet.collider.x + bullet.collider.w < x0 or bullet.collider.x > x1 or bullet.collider.y + bullet.collider.h < y0 or bullet.collider.y > y1 then
            table.remove(self.bullets, b)
        end
    end

    for _, asteroid in ipairs(self.spawn.list) do
        if not asteroid.isDistroyed then
            asteroid.collider.x = asteroid.collider.x + asteroid.velocity.x*deltaTime
            asteroid.collider.y = asteroid.collider.y + asteroid.velocity.y*deltaTime
            asteroid.rotation = asteroid.rotation + math.pi*deltaTime
        end

        if collision.rectangleRectangle(asteroid.collider, player.collider) then
            if not player.invencible then
                player.invencible = true
                player.invencibleTimer = 3
                player.hitpoints = player.hitpoints - 1

                if not asteroid.isDistroyed then
                    asteroid.isDistroyed = true
                    asteroid.quad = 5
                    if not asteroidExplosion:isPlaying() then
                        asteroidExplosion:play()
                    else
                        asteroidExplosion:seek(0)
                    end
                end

                if player.hitpoints <= 0 then
                    if not shipExplosion:isPlaying() then
                        shipExplosion:play()
                    else
                        shipExplosion:seek(0)
                    end
                    spaceSound:stop()
                    backgroundMusic:stop()
                    player.isAlive = false
                    --&clear map
                    self.spawn.list = {}
                    self.bullets = {}
                    --&save game
                    if score > lollipop.currentSave.game.highScore then
                        lollipop.currentSave.game.highScore = score
                    end
                    lollipop.saveSlot("gameSave")
                else
                    love.system.vibrate(0.25)
                end
            end
        end

        if asteroid.quad > 7 then
            table.remove(self.spawn.list, _)
        else
            if asteroid.isDistroyed then
                asteroid.animationTime = asteroid.animationTime + deltaTime
            
                if asteroid.animationTime > 1/8 then
                    asteroid.quad = asteroid.quad + 1
                    asteroid.animationTime = 0
                end
            end

            if asteroid.collider.x + asteroid.collider.w < x0 or asteroid.collider.x > x1 or asteroid.collider.y + asteroid.collider.h < y0 or asteroid.collider.y > y1 then
                table.remove(self.spawn.list, _)
            end
        end
    end
end

function asteroids:createBullet(_x, _y, _w, _h, _velocityX, _velocityY)
    table.insert(asteroids.bullets, {
        collider = {
            x = _x,
            y = _y,
            w = _w,
            h = _h
        },
        velocity = {
            x = _velocityX,
            y = _velocityY,
        }
    })
end

function asteroids:createAsteroid(_x, _y, _w, _h, _scale, _velocityX, _velocityY, _hitpoints, _quad)
    table.insert(self.spawn.list, {
        collider = {
            x = _x,
            y = _y,
            w = _w*_scale,
            h = _h*_scale
        },
        velocity = {
            x = _velocityX/_scale,
            y = _velocityY/_scale
        },
        hitpoints = _hitpoints*_scale,
        rotation = 0,
        scale = _scale or 1,
        quad = _quad,
        isDistroyed = false,
        animationTime = 0
    })
end

return asteroids
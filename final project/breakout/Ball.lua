Ball = Class{}

function Ball:init()
    self.x = VIRTUAL_WIDTH/2 + 10
    self.y = VIRTUAL_HEIGHT - 16
    self.radius = 5
    self.dx = 0
    self.dy = BALL_SPEED
    self.width = self.radius * 2
    self.height = self.radius * 2
    self.lives = 3
    self.sfx = {['paddlehit'] = love.audio.newSource('sounds/paddlehit.wav', 'static'),
                ['wallhit'] = love.audio.newSource('sounds/wallhit.wav', 'static'),}
    
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    self:hitPaddle(paddle)
    self:hitWall()
end

function Ball:render()
    love.graphics.setColor(1,1,1,1)
    love.graphics.circle('fill', self.x, self.y, self.radius, 90)
end


function Ball:reset()
    self.x = VIRTUAL_WIDTH/2 + 10
    self.y = VIRTUAL_HEIGHT - 16
    self.dx = 0
    self.dy = BALL_SPEED
end

function Ball:hitPaddle(paddle)
    if self.x - self.radius <= paddle.x + paddle.width and self.x + self.radius >= paddle.x and
        self.y - self.radius <= paddle.y + paddle.height and self.y + self.radius >= paddle.y then
        
        if math.abs(self.dy) < MAX_SPEED then
            self.dy = -self.dy * 1.01
        else
            self.dy = -self.dy
        end
        self.y = paddle.y - self.radius
        self.dx = 0.2 * (paddle.dx + self.dx) + 4 * (self.x - paddle.x - paddle.width / 2)
        if self.dx > MAX_SPEED then
            self.dx = MAX_SPEED
        elseif self.dx < -MAX_SPEED then
            self.dx = -MAX_SPEED
        end

        self.sfx['paddlehit']:play()
    end
end

function Ball:hitWall()
    if self.x + self.radius >= VIRTUAL_WIDTH then
        self.x = self.x - self.radius
        self.dx = -self.dx
        self.sfx['wallhit']:play()
    elseif self.x - self.radius <= 0 then
        self.x = self.x + self.radius
        self.dx = -self.dx
        self.sfx['wallhit']:play()
    end

    if self.y - self.radius <= 0 then
        self.dy = -self.dy
        self.y = self.y + self.radius
        self.sfx['wallhit']:play()
    end
end

function Ball:trace(paddle)
    if gameState == 'serve' then
        self.x = paddle.x + paddle.width / 2
    end
end

function Ball:displayLives()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(smallfont)
    love.graphics.print('Lives: ' .. tostring(self.lives),VIRTUAL_WIDTH - 50, 5)
end

function Ball:resetLives()
    self.lives = 3
end

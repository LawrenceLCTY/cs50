Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = 0
end

function Paddle: update(dt)
    if self.dx > 0 then
        self.x = math.min(VIRTUAL_WIDTH - 40, self.x + self.dx * dt)
    elseif self.dx < 0 then
        self.x = math.max(-10, self.x + self.dx * dt)
    end
end

function Paddle:render()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

end

function Paddle:move()
    if love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    elseif love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    else
        self.dx = 0
    end
end

function Paddle:reset()
    self.x = VIRTUAL_WIDTH/2
    self.y = VIRTUAL_HEIGHT - 10
end

--AI player
function Paddle:trace(ball)
    if ball.dy > 0 then
        if ball.x > self.x + self.width / 2 then
            self.x = self.x + 5
        elseif ball.x < self.x + self.width / 2 then
            self.x = self.x - 5
        end
    end
end


Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(-5, self.y + self.dy * dt)
    elseif self.dy > 0 then
        self.y = math.min(VIRTUAL_HEIGHT - 25, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:callAI(dx)
    if ball.y ~= self.y  and dx > 0 then
        if ball.y - 10 > self.y then
            self.y = math.min(VIRTUAL_HEIGHT - 25, self.y + 2)
        else
            self.y = math.max(-5, self.y - 2)
        end 
    end 
end

function Paddle:callHuman(x, y)
    if love.keyboard.isDown(x) then
        self.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown(y) then
        self.dy = PADDLE_SPEED
    else
        self.dy = 0
    end
end


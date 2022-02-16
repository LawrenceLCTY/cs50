EMPTY_BLOCK = 0
RED_BLOCK = 1
ORANGE_BLOCK = 2
YELLOW_BLOCK = 3 
GREEN_BLOCK = 4
BLUE_BLOCK = 5
INDIGO_BLOCK = 6
VIOLET_BLOCK = 7 

Blocks = Class{}

function Blocks:init()
    self.width = 30
    self.height = 10
    self.rows = 12
    self.columns = 10
    self.topLeftX = 25
    self.topLeftY = 25
    self.gap = 5
    self.noBlocks = false
    self.currentBlocks = {}
    self.score = 0
    self.sfx = {['blockhit1'] = love.audio.newSource('sounds/blockhit1.wav', 'static'),
                ['blockhit2'] = love.audio.newSource('sounds/blockhit2.wav', 'static')}
end

function Blocks:newBlock(x, y, type, width, height)
    return ({ x = x, y = y, type = type, points = type * 100,
    width = width or self.width, height = height or self.height})
end

function Blocks:addBlock(block)
    table.insert(self.currentBlocks, block)
end

function Blocks:render()
    for _, block in pairs(self.currentBlocks) do
        if block.type == RED_BLOCK then
            love.graphics.setColor(1,0,0,1)
        elseif block.type == ORANGE_BLOCK then
            love.graphics.setColor(1,120/255,0,1)
        elseif block.type == YELLOW_BLOCK then
            love.graphics.setColor(1,1,0,1)
        elseif block.type == GREEN_BLOCK then
            love.graphics.setColor(0,1,0,1)
        elseif block.type == BLUE_BLOCK then
            love.graphics.setColor(0,0,1,1)
        elseif block.type == INDIGO_BLOCK then
            love.graphics.setColor(56/255,2/255,130/255,1)
        elseif block.type == VIOLET_BLOCK then
            love.graphics.setColor(154/255,14/255,345/255,1)
        else
            break
        end
        love.graphics.rectangle('fill', block.x - block.width / 2, 
                            block.y - block.height / 2, 
                            block.width, block.height)
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle('line', block.x - block.width / 2, 
                            block.y - block.height / 2, 
                            block.width, block.height)                    
    end
end

function Blocks:buildLevel()
    arrangement = {}
    for i = 1, self.columns do
        arrangement[i] = {}
        for j = 1, self.rows do
            arrangement[i][j] = RED_BLOCK
        end
        for j = 1, self.rows do
            if math.random(3) == 1 then
                arrangement[i][j] = YELLOW_BLOCK
            end
        end 
        for j = 1, self.rows do
            if math.random(6) == 1 then
                arrangement[i][j] = YELLOW_BLOCK
            end
        end 
        for j = 1, self.rows do
            if math.random(9) == 1 then
                arrangement[i][j] = GREEN_BLOCK
            end
        end
        for j = 1, self.rows do
            if math.random(12) == 1 then
                arrangement[i][j] = BLUE_BLOCK
            end
        end
        for j = 1, self.rows do
            if math.random(15) == 1 then
                arrangement[i][j] = INDIGO_BLOCK
            end
        end 
        for j = 1, self.rows do
            if math.random(18) == 1 then
                arrangement[i][j] = VIOLET_BLOCK
            end
        end 
        for x = 1, math.random(self.rows - 5) do
            arrangement[i][math.random(self.rows)] = 0
        end

    end

    self.noBlocks = false
    for row_index, row in ipairs(arrangement) do
        for col_index, blocktype in ipairs(row) do
            if blocktype ~= EMPTY_BLOCK then
                local newX = self.topLeftX + (col_index - 1) *
                            (self.width + self.gap)
                local newY = self.topLeftY + (row_index - 1) *
                            (self.height + self.gap)
                self:addBlock(self:newBlock(newX, newY, blocktype))
            end
        end
    end
end

function Blocks:update(dt)
    if #self.currentBlocks == 0 then
        self.noBlocks = true
        gameState = 'won'
    end
    self:hitBall(ball)
end

function Blocks:clearAllBlocks()
    self.currentBlocks = {}
end

function Blocks:hitBall(ball)
    for i, block in ipairs(self.currentBlocks) do
        if self:checkOverlap(ball, block) then
            block.type = block.type - 1
            if block.type == 0 then
                table.remove(self.currentBlocks, i)
                self.score = self.score + block.points
                self.sfx['blockhit2']:play()
            else
                self.sfx['blockhit1']:play()
            end

            --top collision
            if ball.y - ball.radius < block.y and ball.dy > 0 then
                ball.dy = -ball.dy
                ball.y = block.y - ball.radius

            --bottom collision
            elseif ball.y + ball.radius > block.y + block.height and ball.dy < 0 then
                ball.dy = -ball.dy
                ball.y = block.y + block.height + ball.radius
            
            --left collision
            elseif ball.x - ball.radius < block.x and ball.dx > 0 then
                ball.dx = -ball.dx
                ball.x = block.x - ball.radius
        
            --right collision
            elseif ball.x + ball.radius > block.x + block.width and ball.dx < 0 then
                ball.dx = -ball.dx
                ball.x = block.x + block.width + ball.radius
            end

            break
                
        end
    end
end

function Blocks:checkOverlap(ball, item)
    local x_overlap, x_shift = self:axisOverlap( ball.x, item.x,
                           ball.radius, item.width )
    local y_overlap, y_shift = self:axisOverlap( ball.y, item.y,
                           ball.radius, item.height )
    local overlap = x_overlap > 0 and y_overlap > 0
    return overlap
end
 
function Blocks:axisOverlap( ball_pos, item_pos, ball_size, item_size )
    local diff = item_pos - ball_pos
    local dist = math.abs( diff )
    local overlap = ( ball_size + item_size ) / 2 - dist
    return overlap, diff / dist * overlap
end

function Blocks:displayScore()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(smallfont)
    love.graphics.print('Score: ' .. tostring(self.score), 5, 5)
end

function Blocks:resetScore()
    self.score = 0
end




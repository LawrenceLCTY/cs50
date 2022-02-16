Class = require 'class'
push = require 'push'

require 'Util'
require 'Paddle'
require 'Ball'
require 'Blocks'


WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 675

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 300
BALL_SPEED = -70
MAX_SPEED = 200


BACKGROUND_COLOR = 0.0

function love.load()
    love.window.setTitle("Final Project CS50")
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallfont = love.graphics.newFont('font.TTF', 10)
    midfont = love.graphics.newFont('font.TTF', 40)
    largefont = love.graphics.newFont('font.TTF', 80)

    paddle = Paddle(VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT - 10, 50,5)
    
    ball = Ball()

    rows = math.random(5, 15)
    columns = math.random(5, 10)
    blocks = Blocks()

    blocks:buildLevel()

    gameState = 'start'

    sfx = {['bgm'] = love.audio.newSource('sounds/bgm.mp3', 'static'),
            ['lost'] = love.audio.newSource('sounds/lost.mp3', 'static'),
            ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
            ['hp-1'] = love.audio.newSource('sounds/hp-1.wav', 'static'),
            ['hp+1'] = love.audio.newSource('sounds/hp+1.wav', 'static')}


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        resizeable = true,
        fullscreen = false
    })
end


function love.update(dt)

    paddle:update(dt)
    paddle:move()
    ball:trace(paddle)
    blocks:update(dt)
    sfx['bgm']:setLooping(true)
    sfx['bgm']:setVolume(0.5)
    sfx['bgm']:play()

    if gameState == 'play' then
        --paddle:trace(ball)
        ball:update(dt)
        regen()

        if blocks.noBlocks == 'true' then
            gameState = 'won'
        end

        if ball.y > VIRTUAL_HEIGHT + 5 then
            sfx['hp-1']:play()
            if ball.lives > 0 then 
                ball.lives = ball.lives - 1
                blocks.score = blocks.score - 1000
                gameState = 'serve'
                paddle:reset()
                ball:reset()
            else
                gameState = 'lost'
            end
        end

    elseif gameState == 'lost' then
        paddle:reset()
        ball:reset()
        ball:resetLives()
        blocks:clearAllBlocks()
        blocks:buildLevel()
        blocks:resetScore()

        sfx['bgm']:stop()
        sfx['lost']:setLooping(false)
        sfx['lost']:play()
    elseif gameState == 'won' then
        if BACKGROUND_COLOR <= 1 then
            BACKGROUND_COLOR = BACKGROUND_COLOR + 0.001
        end
        paddle:reset()
        ball:reset()
        ball:resetLives()
        blocks:clearAllBlocks()
        blocks:buildLevel()
        blocks:resetScore()
        sfx['bgm']:stop()
        sfx['victory']:setLooping(false)
        sfx['victory']:play()
    else
        sfx['victory']:stop()
        sfx['lost']:stop()
    end
end

function love.resize(w,h)
    push:resize(w,h)
end


function love.draw()
    push: apply('start')
    
    love.graphics.clear(BACKGROUND_COLOR,BACKGROUND_COLOR,BACKGROUND_COLOR,1)

    if gameState == 'won' then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(midfont)
        love.graphics.printf("THIS IS", 5, VIRTUAL_HEIGHT / 2 - 120, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(largefont)
        love.graphics.printf("CS50", 5, VIRTUAL_HEIGHT / 2 - 80, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1,1,1,1)

    elseif gameState == 'lost' then
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(midfont)
        love.graphics.printf("GAME OVER", 5, VIRTUAL_HEIGHT / 2 - 80, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallfont)
        love.graphics.printf("press Spacebar to restart", 8, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'start' then
        BACKGROUND_COLOR = 0
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(midfont)
        love.graphics.printf("Blockade Breaker", 5, VIRTUAL_HEIGHT / 2 - 80, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallfont)
        love.graphics.printf("press Spacebar to begin", 5, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("use arrow keys to move the paddle", 5, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("break all the blocks to win!", 5, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'serve' then
        love.graphics.setFont(smallfont)
        love.graphics.printf("press Spacebar to serve", 5, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, 'center') 
    end

    if gameState == 'serve' or gameState == 'play' then
        ball:render()
        paddle:render()
        blocks:render()
        blocks:displayScore()
        ball:displayLives()
    end

    
    push:apply('end')

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        if gameState == 'lost' or gameState == 'won' then
            gameState = 'start'
            ball:reset()
            paddle:reset()
        elseif gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' or gameState == 'pause' then
            gameState = 'play'     
        end
    end 
end

local round = 0
function regen()
    local tempHP = blocks.score - round * 10000
    if tempHP >= 10000 then
        ball.lives = ball.lives + 1
        round = round + 1
        sfx['hp+1']:play()
    end 
end
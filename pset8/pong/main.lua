WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 675

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
MAX_SPEED = 1000;

Class = require 'class'
push = require 'push'

require 'Paddle'
require 'Ball'


function love.load()

    love.window.setTitle("Pong CS50")

    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallfont = love.graphics.newFont('font.TTF', 10)
    scorefont = love.graphics.newFont('font.TTF', 40)
    
    score1 = 0
    score2 = 0

    ball = Ball(VIRTUAL_WIDTH / 2 - 3, VIRTUAL_HEIGHT / 2 - 3, 6, 6)
   
    paddle1 = Paddle(5,5,5,30)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 35, 5, 30)

    server = math.random(2) == 1 and 1 or 2
    if server == 1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

    winner = 0

    gameState = 'start'
    gameMode = 'HumanOnly'

    sounds = {
        ['paddlehit'] = love.audio.newSource('paddlehit.wav', 'static'),
        ['wallhit'] = love.audio.newSource('wallhit.wav', 'static'),
        ['scored'] = love.audio.newSource('scored.wav', 'static'),
        ['victory'] = love.audio.newSource('victory.mp3', 'static')
    }

    push: setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizeable = true
    })
end

function love.update(dt)
    if dt > 0.03 then
        return
    end

    if gameState == 'serve' then
        if server == 1 then
            ball.dx = math.random(150, 200)
        else
            ball.dx = -math.random(150, 200)
        end

    elseif gameState == 'play' then
        
        ball:update(dt)
        paddle1:update(dt)
        paddle2:update(dt)

        if ball:collides(paddle1) or ball:collides(paddle2)then
            sounds['paddlehit']:play()
            if ball.dx < MAX_SPEED and ball.dx > -MAX_SPEED then
                ball.dx = -ball.dx * 1.05
            else
                ball.dx = - ball.dx
            end

        end
    
        if ball.y < 0 or ball.y > VIRTUAL_HEIGHT - 5 then
            sounds['wallhit']:play()
            ball.dy = -ball.dy
        end
    
        if ball.x > VIRTUAL_WIDTH then
            sounds['scored']:play()

            score1 = score1 + 1
            if score1 >= 3 then
                sounds['victory']:play()
                gameState = 'victory'
                winner = 1
            else
                gameState = 'serve'
            end
            server = 2
            ball:reset()
            ball.dx = -100

        elseif ball.x < 0 then
            sounds['scored']:play()

            score2 = score2 + 1  
            if score2 >= 3 then
                sounds['victory']:play()
                gameState = 'victory'
                winner = 2
            else
                gameState = 'serve'
            end
            server = 1
            ball:reset()
            ball.dx = 100
        end
        
        if gameMode == 'HumanOnly' then
            paddle1:callHuman('w', 's')
            paddle2:callHuman('up', 'down')
        elseif gameMode == 'AIOnly' then
            paddle1:callAI(-ball.dx)
            paddle2:callAI(ball.dx)
        elseif gameMode == 'HumanAI' then
            paddle1:callHuman('w', 's')
            paddle2:callAI(ball.dx)
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then  
        if gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'victory' then
            gameState = 'start'
            score1 = 0
            score2 = 0
        end
    end

    if gameState == 'start' then
        if key == '1' then
            gameMode = 'HumanAI'
            gameState = 'serve'
        elseif key == '2' then
            gameMode = 'HumanOnly'
            gameState = 'serve'
        elseif key == '3' then
            gameMode = 'AIOnly'
            gameState = 'serve'
        end
    end

    if key == '0'  and gameMode == 'AIOnly' then
        if gameState == 'play' then
            gameState = 'start'
            ball:reset()
            score1 = 0
            score2 = 0
        end
    end
end


function love.draw()
    push: apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 1)
    
    ball:render()

    paddle1:render()
    paddle2:render()

    love.graphics.setFont(smallfont)
    if gameState == 'start' then
        love.graphics.printf("HELLO, PONG!", 0, 5, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press 1 for Human VS AI (1P) mode", 0, VIRTUAL_HEIGHT - 60, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press 2 for Human VS Human (2P) mode", 0, VIRTUAL_HEIGHT - 40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press 3 for AI VS AI (watch only) mode", 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf("Player " .. tostring(server) .. "'s turn!", 0, 5, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press SPACEBAR to serve", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then
        love.graphics.setFont(scorefont)
        love.graphics.printf("Player " .. tostring(winner) .. " wins!", 0, 5, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallfont)
        love.graphics.printf("Press SPACEBAR to restart", 0, 50 , VIRTUAL_WIDTH, 'center')
    end

    displayMode()
    displayFPS()
    displayScore()

    push: apply('end')
end

function love.resize(w,h)
    push:resize(w,h)
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallfont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 20, 5)
    love.graphics.setColor(1, 1, 1, 1)
end

function displayScore()
    love.graphics.setFont(scorefont)
    love.graphics.print(score1, VIRTUAL_WIDTH/2 - 40, VIRTUAL_HEIGHT/3)
    love.graphics.print(score2, VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)
end

function displayMode()
    love.graphics.setFont(smallfont)
    if gameMode == 'HumanAI' then
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.print("Human VS AI", VIRTUAL_WIDTH - 100, 5)
    elseif gameMode == 'HumanOnly' then
        love.graphics.setColor(0, 0, 1, 1)
        love.graphics.print("Human VS Human", VIRTUAL_WIDTH - 100, 5)
    elseif gameMode == 'AIOnly' then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print("AI VS AI", VIRTUAL_WIDTH - 80, 5)
        love.graphics.print("press 0 to end game", VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT - 10)
    end
    love.graphics.setColor(1,1,1,1)
end


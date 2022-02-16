CS50 FINAL PROJECT- BRICK BREAKER
Simple Breakout game using Love2D

Game states: start(menu), serve(prepare to serve ball), play(main gameplay), lost(player loses), won(player wins)
	Ball stays on paddle during serve state, paddle can move anywhere along x-axis
	Game is lost when ball falls below paddle and there is 0 lives left
	Game is won when all blocks are destroyed

Controls: use arrow keys to move the paddle; press spacebar for other commands

Paddle: deflects ball at different angles depending on where does the ball hit the paddle
	Ball speed increases slightly every time ball hits paddle

Blocks: 7 types(in ascending toughness 1 to 7): Red, Orange, Yellow, Green, Blue, Indigo, Violet.
	Blocks change colour to a lower toughness level when hit until completely destroyed.
	Blocks are generated at random every time
	Empty spaces are taken from the block arrangement randomly

Lives and Score:
	lives initialised at 3, score initialised at 0
	loose 1 life and -1000 points every time ball falls below paddle
	bonus: adds 1 life when score exceeds 10000 points
	bonus only activates once every 10000 points

Special thanks to:
	David J. Malan
	Brian Yu
	Colton Ogden
	Jeremy Blake

THIS IS CS50!

By LawrenceLCTY
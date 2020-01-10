menu = {}

function menu.load()
	counter = 0.1
	
	-- Buttons
	playButton = {}
	playButton.img = love.graphics.newImage('/img/menu/title/innate1.png/')
	playButton.img2 = love.graphics.newImage('/img/menu/title/innate2.png/')
	playButton.x = 300
	playButton.y = 490
	
	playButton2 = {}
	playButton2.img = love.graphics.newImage('/img/menu/title/acquired1.png/')
	playButton2.img2 = love.graphics.newImage('/img/menu/title/acquired2.png/')
	playButton2.x = 500
	playButton2.y = 490
	
	returnButton = {}
	returnButton.img = love.graphics.newImage('/img/menu/pause/return.png/')
	returnButton.img2 = love.graphics.newImage('/img/menu/pause/return2.png/')
	returnButton.x = 400
	returnButton.y = 490
	
	quitToTitleButton = {}
	quitToTitleButton.img = love.graphics.newImage('/img/menu/pause/quitToTitle.png/')
	quitToTitleButton.img2 = love.graphics.newImage('/img/menu/pause/quitToTitle2.png/')
	quitToTitleButton.x = 400
	quitToTitleButton.y = 400
	
	--Information
	info1 = love.graphics.newImage('/img/menu/info/1.png/')
	info2 = love.graphics.newImage('/img/menu/info/2.png/')
	info3 = love.graphics.newImage('/img/menu/info/3.png/')
	info4 = love.graphics.newImage('/img/menu/info/4.png/')
	info5 = love.graphics.newImage('/img/menu/info/5.png/')
	
	--Other
	play = 0 -- 0 = titleScreen, 1 = transition, 2 = game, 3 = pauseScreen, 4 = information, 5 = game over, 6 = win!
	info = 0
	clicked = false
end

function menu.draw()
	if play == 0 or play == 1 then
		if touchingButton(playButton) then
			love.graphics.draw(playButton.img2, playButton.x, playButton.y, 0, 1, 1, playButton.img:getWidth() / 2, playButton.img:getHeight() / 2)
		else
			love.graphics.draw(playButton.img, playButton.x, playButton.y, 0, 1, 1, playButton.img:getWidth() / 2, playButton.img:getHeight() / 2)
		end
		if touchingButton(playButton2) then
			love.graphics.draw(playButton2.img2, playButton2.x, playButton2.y, 0, 1, 1, playButton2.img:getWidth() / 2, playButton2.img:getHeight() / 2)
		else
			love.graphics.draw(playButton2.img, playButton2.x, playButton2.y, 0, 1, 1, playButton2.img:getWidth() / 2, playButton2.img:getHeight() / 2)
		end
	elseif play == 3 then
		love.graphics.draw(pauseScreen, 0, 0) -- Pause Screen is left here because of ordering
		
		if touchingButton(returnButton) then
			love.graphics.draw(returnButton.img2, returnButton.x, returnButton.y, 0, 1, 1, returnButton.img2:getWidth() / 2, returnButton.img2:getHeight() / 2)
		else
			love.graphics.draw(returnButton.img, returnButton.x, returnButton.y, 0, 1, 1, returnButton.img:getWidth() / 2, returnButton.img:getHeight() / 2)
		end
		if touchingButton(quitToTitleButton) then
			love.graphics.draw(quitToTitleButton.img2, quitToTitleButton.x, quitToTitleButton.y, 0, 1, 1, quitToTitleButton.img2:getWidth() / 2, quitToTitleButton.img2:getHeight() / 2)
		else
			love.graphics.draw(quitToTitleButton.img, quitToTitleButton.x, quitToTitleButton.y, 0, 1, 1, quitToTitleButton.img:getWidth() / 2, quitToTitleButton.img:getHeight() / 2)
		end
	elseif play == 4 then
		if info == 1 then
			love.graphics.draw(info1, 0, 0)
		elseif info == 2 then
			love.graphics.draw(info2, 0, 0)
		elseif info == 3 then
			love.graphics.draw(info3, 0, 0)
		elseif info == 4 then
			love.graphics.draw(info4, 0, 0)
		elseif info == 5 then
			love.graphics.draw(info5, 0, 0)
		end
	end
end

function menu.update(dt)
	if touchingButton(playButton) and love.mouse.isDown('l') and play == 0 then
		play = 1
		player.mode = 'innate'
	elseif touchingButton(playButton2) and love.mouse.isDown('l') and play == 0 then
		play = 1
		player.mode = 'acquired'
	end
	
	if touchingButton(quitToTitleButton) and love.mouse.isDown('l') and play == 3 then
		play = 0
		counter = 0
		player.x = 400
		player.y = 300
		toCut.x = 1475
		removeEntities()
	end
	
	if touchingButton(returnButton) and love.mouse.isDown('l') and play == 3 then
		play = 2
	end
	
	if play == 1 then
		counter = counter - dt
		if counter < 0 then
			play = 4
			info = 1
			currentLevel = 'skin'
			
			for i = 0, 154 do
				local x = math.random(1600, -800)
				local y = math.random(1200, -600)
				while distance(player.x, x, player.y, y) < 150 do
					x = math.random(1600, -800)
					y = math.random(1200, -600)
			end
				createEnemy('hair', hair[math.random(1, 3)], x, y)
			end

			table.sort(entities, orderY) -- sort enemies table according to y pos
		end
	end
	
	if play == 4 then
		if love.mouse.isDown('l') and not clicked then
			if info == 3 then
				info = 4
			elseif info == 4 then
				info = 5
			else
				play = 2
			end
			clicked = true
		end
	end
end

function love.keypressed(key)
	if key == 'escape' then
		if play == 2 then
			play = 3
		elseif play == 3 then
			play = 2
		end
	end
end

function love.mousereleased(x, y, button)
   if button == "l" then
      clicked = false
   end
end

function touchingButton(button)
	local img = button.img
	local x = button.x
	local y = button.y
	local imgW = img:getWidth() / 2 -- image width
	local imgH = img:getHeight() / 2 -- height
	
	if (mx > x - imgW and mx < imgW + x) and (my > y - imgH and my < imgH + y) then
		return true
	else
		return false
	end
end
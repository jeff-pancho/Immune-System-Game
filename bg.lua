bg = {}

function bg.load()
	skin = love.graphics.newImage('/img/bg/skin.png/')
	cut = love.graphics.newImage('/img/bg/cut.png/')
	body = love.graphics.newImage('/img/bg/body.png/')
	scrollX = 400 -- top left corner
	scrollY = 300
	
	winnterTimer = 60
	
	titleScreen = love.graphics.newImage('/img/bg/titleScreen.png/')
	pauseScreen = love.graphics.newImage('/img/bg/pauseScreen.png/')
	gameOver = love.graphics.newImage('/img/bg/gameOver.png/')
	winner = love.graphics.newImage('/img/bg/winner.png/')
	
	currentLevel = 'skin'
end
function bg.draw()
	if play == 0 or play == 1 then
		love.graphics.draw(titleScreen, 0, 0)
	elseif play == 2 or play == 3 then
		if currentLevel == 'skin' then
			love.graphics.draw(skin, scrollX, scrollY, 0, 1 ,1 , skin:getWidth() / 2, skin:getHeight() / 2)
		elseif currentLevel == 'cut' then
			love.graphics.draw(cut, 0, 0)
		elseif currentLevel == 'body' then
			love.graphics.draw(body, scrollX, scrollY, 0, 1, 1, body:getWidth() / 2, skin:getHeight() / 2)
		end
	elseif play == 5 then
		love.graphics.draw(gameOver, 0, 0)
	elseif play == 6 then
		love.graphics.draw(winner, 0, 0)
	end
	
	--[[love.graphics.print(scrollX .. ', ' .. scrollY, 300, 500)
	love.graphics.print(mx .. ', ' .. my .. ', ' .. #entities, 300, 400)
	love.graphics.print(math.floor(player.xv) .. ', ' .. math.floor(player.yv) .. ', ' .. math.floor(player.x) .. ', ' .. math.floor(player.y), 100, 400) -- debugging
	love.graphics.print(math.floor(math.deg(player.dir)), 100, 500)]]
end

function bg.update(dt)
	if play == 2 or play == 3 then
		if currentLevel == 'skin' or currentLevel == 'body' then
			if player.x < 250 then
				if scrollX > 1119 then
					scrollX = scrollX
				else
					scrollX = scrollX - player.xv * dt
					player.x = 250
				end
			elseif player.x > 550 then
				if scrollX < -399 then
					scrollX = scrollX
				else
					scrollX = scrollX - player.xv * dt
					player.x = 550
				end
			end
			
			if player.y < 250 then
				if scrollY > 899 then
					scrollY = scrollY
				else
					scrollY = scrollY + player.yv * dt
					player.y = 250
				end
			elseif player.y > 450 then
				if scrollY < -299 then
					scrollY = scrollY
				else
					scrollY = scrollY + player.yv * dt
					player.y = 450
				end
			end
			if currentLevel == 'body' then
				winnterTimer = winnterTimer - dt
				if winnterTimer < 0 then
					play = 6
				end
			end
		end
	end
end

function worldPos(v, dt)
	if currentLevel == 'skin' or currentLevel == 'body' then
		if player.x < 250 then
			if scrollX > 1119 then
				v.x = v.x
			else
				v.x = v.x - player.xv * dt
			end
		elseif player.x > 550 then
			if scrollX < -399 then
				v.x = v.x
			else
				v.x = v.x - player.xv * dt
			end
		end
		if player.y < 250 then
			if scrollY > 899 then
				v.y = v.y
			else
				v.y = v.y + player.yv * dt
			end
		elseif player.y > 450 then
			if scrollY < -299 then
				v.y = v.y
			else
				v.y = v.y + player.yv * dt
			end
		end
	end
end
plr = {}

function plr.load()
	player = {}
	player.img = love.graphics.newImage('/img/player/player.png/')
	player.img2 = love.graphics.newImage('/img/player/player2.png/')
	player.x = 400
	player.y = 300 -- inside window coords
	player.xv = 0
	player.yv = 0
	player.dir = 0
	player.speed = 275
	player.mode = 'innate'
end

function plr.update(dt)
	if play == 2 then
		if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
			player.yv = player.speed
		elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
			player.yv = player.speed * -1
		end
		if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
			player.xv = player.speed * -1
		elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
			player.xv = player.speed
		end
		
		if player.x < 60 then
			player.x = 60
		elseif player.x > 740 then
			player.x = 740
		end
		if player.y < 60 then
			player.y = 60
		elseif player.y > 540 then
			player.y = 540
		end
		
		if currentLevel == 'skin' then
			if scrollX < -399 and player.x < 740 then
				player.x = 60
				currentLevel = 'cut'
				removeEntities()
				
				for i = 0, 17 do
					local x = math.random(0, 525)
					local y = math.random(0, 600)
					while distance(player.x, x, player.y, y) < 150 do
						x = math.random(0, 525)
						y = math.random(0, 600)
					end
					createEnemy('hair', hair[math.random(1, 3)], x, y)
				end
				
				table.sort(entities, orderY)
			end
		elseif currentLevel == 'cut' then
			if player.x > 550 then
				play = 4
				player.x = 60
				scrollX = 1200
				scrollY = 900
				removeEntities()
				currentLevel = 'body'
				if player.mode == 'innate' then
					info = 2
					for i = 1, 250 do
						local x = math.random(0, 2400)
						local y = math.random(0, 1800)
						while distance(player.x, x, player.y, y) < 300 do
							x = math.random(0, 2400)
							y = math.random(0, 1800)
						end
						createEnemy('phagocyte', phagocyte, x, y)
					end
				elseif player.mode == 'acquired' then
					info = 3
					for i = 1, 79 do
						local x = math.random(0, 2400)
						local y = math.random(0, 1800)
						while distance(player.x, x, player.y, y) < 300 do
							x = math.random(0, 2400)
							y = math.random(0, 1800)
						end
						createEnemy('cellB', cellB, x, y)
					end
					
					table.sort(entities, orderY)
				end
			end
		end
		
		player.x = player.x + player.xv * dt
		player.y = player.y - player.yv * dt
		player.xv = player.xv * 0.78
		player.yv = player.yv * 0.78
		player.dir = math.atan2(player.y + player.yv * dt - player.y, player.x + player.xv * dt - player.x)
	end
end
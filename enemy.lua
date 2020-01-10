enemy = {}

function enemy.load()
	hair = {}
	hair[1] = love.graphics.newImage('/img/enemy/hair1.png/')
	hair[2] = love.graphics.newImage('/img/enemy/hair2.png/')
	hair[3] = love.graphics.newImage('/img/enemy/hair3.png/')
	
	phagocyte = love.graphics.newImage('/img/enemy/phagocyte.png/')
	cellB = love.graphics.newImage('/img/enemy/cellB.png/')
	
	antibody = love.graphics.newImage('/img/enemy/antibody.png/')
	sweat = love.graphics.newImage('/img/enemy/sweat.png/')
	sweatParticle = love.graphics.newImage('/img/particle/sweat.png/')
	
	entities = {}
end

function enemy.draw()
	local playerDrawn = false
	
	if play == 2 or play == 3 then
		for i, v in ipairs(entities) do
			if not playerDrawn and v.y > player.y then
				if player.mode == 'innate' then
					love.graphics.draw(player.img, player.x, player.y, player.dir, 1, 1, player.img:getWidth() / 2, player.img:getHeight() / 2)
				elseif player.mode == 'acquired' then
					love.graphics.draw(player.img2, player.x, player.y, player.dir, 1, 1, player.img2:getWidth() / 2, player.img2:getHeight() / 2)
				end
				playerDrawn = true
			end
			
			if v.type == 'hair' then
				love.graphics.draw(v.img, v.x, v.y, 0, 1, 1, v.img:getWidth() / 2, 85)
			elseif v.type == 'antibody' then
				love.graphics.draw(v.img, v.x, v.y, v.dir, 1, 1, v.img:getWidth() / 2, v.img:getHeight() / 2)
			else
				love.graphics.draw(v.img, v.x, v.y, 0, 1, 1, v.img:getWidth() / 2, v.img:getHeight() / 2)
			end
		end
		
		if not playerDrawn then
			if player.mode == 'innate' then
				love.graphics.draw(player.img, player.x, player.y, player.dir, 1, 1, player.img:getWidth() / 2, player.img:getHeight() / 2)
			elseif player.mode == 'acquired' then
				love.graphics.draw(player.img2, player.x, player.y, player.dir, 1, 1, player.img2:getWidth() / 2, player.img2:getHeight() / 2)
			end
		end
	end
end

function enemy.update(dt) -- apologies for horrible code :(
	if play == 2 then
		for i = #entities, 1, -1 do
			local v = entities[i]
			worldPos(v, dt)
			if v.type == 'sweat' or v.type == 'sweatParticle' or v.type == 'antibody' then
				v.x = v.x + math.cos(v.dir) * v.speed * dt
				v.y = v.y + math.sin(v.dir) * v.speed * dt
				if v.type == 'sweat' and distance(v.x, player.x, v.y, player.y) < 15 then
					play = 5
				elseif v.type == 'antibody' and distance(v.x, player.x, v.y, player.y) < 8 then
					play = 5
				end
				if v.x > 1600 or v.x < -800 or v.y > 1200 or v.y < -600 then
					table.remove(entities, i)
				end
			end
			if v.type == 'phagocyte' then
				if counter > 0 then
					v.x = v.x + math.cos(v.dir) * v.speed * dt
					v.y = v.y + math.sin(v.dir) * v.speed * dt
					counter = counter - dt
					if distance(v.x, player.x, v.y, player.y) < 43 then
						play = 5
					end
				else
					counter = math.random(1, 1.5)
					if distance(v.x, player.x, v.y, player.y) < 150 then
						v.dir = math.atan2(player.y - v.y, player.x - v.x)
					else
						v.dir = math.rad(math.random(0, 360))
					end
				end
			end
			if v.type == 'cellB' then
				if counter > 0 then
					counter = counter - dt
				else
					counter = math.random(1, 2)
					local dir = math.random(0, 360)
					local n = 3
					for i = 1, n do
						createMovingEntity('antibody', antibody, v.x, v.y, math.rad(dir + ((360 / n) * i)), 100)
					end
				end
			end
			if v.timer then
				v.timer = v.timer - dt
				if v.timer < 0 then
					if v.type == 'hair' then
						for i = 1, math.random(4, 7) do
							createMovingEntity('sweatParticle', sweatParticle, v.x, v.y + 20, math.rad(math.random(0, 360)), 10)
						end
						createMovingEntity('sweat', sweat, v.x, v.y + 20, math.rad(math.random(0, 360)), 150)
						v.timer = math.random(1.7, 4.443)
					elseif v.type == 'sweatParticle' then
						table.remove(entities, i)
					end
				end
			end
		end
	end
end

function createEnemy(enemyType, img, x, y)
	local data = {}
	data.type = enemyType
	data.img = img
	data.x = x
	data.y = y
	data[5] = y -- drawing purposes only
	if enemyType == 'hair' then
		data.timer = math.random(0.3, 1.3)
	elseif enemyType == 'phagocyte' then
		data.dir = math.rad(math.random(0, 360))
		data.speed = 100
		data.counter = math.random(1, 1.5)
	elseif enemyType == 'cellB' then
		data.counter = math.random(0.5, 2)
	end
	
	table.insert(entities, data)
end

function createMovingEntity(entityType, img, x, y, dir, speed)
	local data = {}
	data.type = entityType
	data.img = img
	data.x = x
	data.y = y
	data.dir = dir
	data.speed = speed
	if entityType == 'sweatParticle' then
		data.timer = 1
	end
	
	table.insert(entities, data)
end

function orderY(a, b) -- ripped off of the love2d wiki
	return a[5] < b[5]
end

function distance(x1, x2, y1, y2)
	return math.sqrt(((x2 - x1) * (x2 - x1) + ((y2 - y1) * (y2 - y1))))
end

function removeEntities()
	for i = #entities, 1, -1 do
		table.remove(entities, i)
	end
end
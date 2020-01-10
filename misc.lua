misc = {}

function misc.load()
	-- Markers
	toCut = {}
	toCut.img = love.graphics.newImage('/img/markers/toCut.png/')
	toCut.x = 1475
	toCut.y = 300
	toCut.offsetY = 0
	
	counter2 = 0
end

function misc.draw()
	if play == 2 or play == 3 then
		if currentLevel == 'skin' then
			love.graphics.draw(toCut.img, toCut.x, toCut.y + offsetY, 0, 1, 1, toCut.img:getWidth() / 2, toCut.img:getHeight() / 2)
		end
	end
end

function misc.update(dt)
	if play == 2 or play == 3 then
		worldPos(toCut, dt)
		offsetY = math.sin(counter2 * 4) * 7
		counter2 = counter2 + dt
	end
end
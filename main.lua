require('lovedebug')
require('menu')
require('player')
require('bg')
require('enemy')
require('misc')

function love.load()
	math.randomseed(os.time())

	mx, my = 0
	
	LOAD()
end

function love.draw()
	
	
	DRAW()
end

function love.update(dt)
	mx, my = love.mouse.getPosition()
	
	UPDATE(dt)
end

function LOAD() -- Neatens up things
	menu.load()
	plr.load()
	enemy.load()
	bg.load()
	misc.load()
end

function DRAW() -- Ditto
	bg.draw()
	enemy.draw() -- player is drawn in enemy.lua for z-ordering shenanigans
	misc.draw()
	menu.draw()
	misc.draw()
end

function UPDATE(dt) -- Ditto
	bg.update(dt)
	menu.update(dt)
	plr.update(dt)
	enemy.update(dt)
	misc.update(dt)
end
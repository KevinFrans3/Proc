function aiTick(bot,dt)
	bot.hunger = bot.hunger - 1

	if bot.hunger < 10 then
	end

	bot.y = bot.y - bot.velocity*dt
	-- if bot.velocity > 0 then
		bot.velocity = bot.velocity - 30*dt
	-- end

	-- local falling = false
	if blockAt(math.floor(bot.x),math.floor(bot.y + 1)) then
		if bot.velocity < 0 then
			bot.velocity = 0
		end
	end

	-- jump
	if bot.target.y < bot.y then
		if blockAt(math.floor(bot.x),math.floor(bot.y + 1)) then
			bot.velocity = 15
		end
	end

	-- moving
	if not falling then
		if bot.target.x > bot.x then
			if not blockAt(math.floor(bot.x + 1),math.floor(bot.y)) then
				bot.x = bot.x + 8*dt
			else
				-- bot.target.x = 0
			end
		elseif bot.target.x < bot.x then
			if not blockAt(math.floor(bot.x - 1),math.floor(bot.y)) then
				bot.x = bot.x - 8*dt
			else
				-- bot.target.x = 200
			end
		end
	end

end

function aiInit()
	local bot = {
		x = 0,
		y = 0,
		hunger = 0,
		velocity = 0,
	}
	bot.target = {
		x = 0,
		y = 0,
	}
	bot.path = {};
	return bot
end

function blockAt(x,y)
	if grid[x][y].kind == 0 or grid[x][y].kind == 3 or grid[x][y].kind == 2 or grid[x][y].kind == 4 or grid[x][y].kind == 40 then
		return false
	else
		return true
	end
end

function caveBlockAt(x,y)
	if grid[x][y].kind == 1 or grid[x][y].kind == 20 or grid[x][y].kind == 21 or grid[x][y].kind == 22 or grid[x][y].kind == 23 or grid[x][y].kind == 4 or grid[x][y].kind == 30 then
		return true
	else
		return false
	end
end

function heuristic(x1,y1,x2,y2)
	return math.abs(x1 - x2) + math.abs(y1 - y2)
end


function breadthFirst(bot)
	bot.x = math.floor(player.x)
	bot.y = math.floor(player.y)
	local frontier = Heap.new()
	local startindex = xyToIndex(bot.x,bot.y)
	local target = xyToIndex(bot.target.x,bot.target.y)
	bot.path = {}
	print("bot is " .. bot.x .. " " .. bot.y)

	local camefrom = {}
	camefrom[startindex] = -1

	costsofar = {}
	costsofar[startindex] = 0

	frontier:push(startindex,0)
	while not frontier:isempty() do
		local current = frontier:pop()

		-- print(indexToX(current) .. " " .. indexToY(current))

		if current == target then
			local loopback = current
			while camefrom[loopback] ~= -1 do
				loopback = camefrom[loopback]
				table.insert(bot.path,loopback)
			end
			break
		end


		local neighbors = {}
		if indexToX(current) - 1 > 1 then
			table.insert(neighbors,current - 1)
		end
		if indexToY(current) - 1 > 1 then
			table.insert(neighbors,current - 600)
		end
		if indexToX(current) + 1 < 600 then
			table.insert(neighbors,current + 1)
		end
		if indexToY(current) + 1 < 600 then
			table.insert(neighbors,current + 600)
		end
		for i, neighbor in ipairs(neighbors) do

			local newcost = costsofar[current] + 1
			if grid[indexToX(neighbor)][indexToY(neighbor)].kind == 1 then
				newcost = newcost + 10
			end
			local valid = false
			if not costsofar[neighbor] then
				valid = true
			else
				if newcost < costsofar[neighbor] then
					valid = true
				end
			end
			if valid then
				costsofar[neighbor] = newcost
				local priority = -1 * heuristic(indexToX(neighbor),indexToY(neighbor),bot.target.x,bot.target.y)
				-- print("" .. newcost)
				priority =  - newcost
				if priority ~= nil then
					frontier:push(neighbor,priority)
				end
				camefrom[neighbor] = current
			end
		end
	end


end


function indexToX(index)
	return index % 600
end

function indexToY(index)
	return math.floor(index / 600)
end

function xyToIndex(x,y)
	return y*600 + x
end

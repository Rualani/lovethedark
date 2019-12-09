function pulse(tileMap)
   -- Fills outer layer with darkness every pulse
   cols = 1
   rows = 1
   for i = 1, tileMap.numTiles, 1 do
      cols = i
      tileMap.stateMap[rows][cols] = 1
   end
   for i = 1, tileMap.numTiles, 1 do
      rows = i
      tileMap.stateMap[rows][cols] = 1
   end
   for i = cols, 1, -1 do
      cols = i
      tileMap.stateMap[rows][cols] = 1
   end
   for i = rows , 1, -1 do
      rows = i
      tileMap.stateMap[rows][cols] = 1
   end

   -- It grows...
   for i = 1, tileMap.numTiles, 1 do
      for j = 1, tileMap.numTiles, 1 do
         if tileMap.stateMap[i][j] == 1 and tileMap.burning[i][j] == 0 then
            slowGrowth(i, j)
         elseif tileMap.stateMap[i][j] == 2 and tileMap.burning[i][j] == 0 then
            growth(i, j)
         elseif tileMap.stateMap[i][j] == 3 and tileMap.burnign[i][j] == 0 then
            fastGrowth(i, j)
         end
      end
   end

   -- fire sways with the pulse as well
   for i,b in ipairs(burningtiles) do
      b.burningtime = b.burningtime + 1
   end
end

function fastGrowth(i, j)
   applyGrowths(i,j)
end

function growth(i, j)
   if love.math.random(3) == 1 then
      applyGrowths(i,j)
   end
end

function slowGrowth(i, j)
   if love.math.random(5) == 1 then
      applyGrowths(i, j)
   end
end

function applyGrowths(i, j)
   -- The thing fears the flame
   if (tileMap.burning == 1) then
      return
   end
   -- Top Tile CLaimed
   if i ~= 1 then
      tileMap.growths[i-1][j] = tileMap.stateMap[i-1][j] + 1
   end
   if i ~= tileMap.numTiles then
      tileMap.growths[i+1][j] = tileMap.stateMap[i+1][j] + 1
   end
   if j ~= tileMap.numTiles then
      tileMap.growths[i][j+1] = tileMap.stateMap[i][j+1] + 1
   end
   if j ~= 1 then
      tileMap.growths[i][j-1] = tileMap.stateMap[i][j-1] + 1
   end
end

function thingUpdate(dt)
   for i = 1, tileMap.numTiles, 1 do
     for j = 1, tileMap.numTiles, 1 do
         tileMap.stateMap[i][j] = tileMap.stateMap[i][j] + tileMap.growths[i][j]
     end
   end
   clearGrowths()
end

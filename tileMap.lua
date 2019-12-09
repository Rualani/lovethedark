-- Broad tilemap structure inspired by https://developer.mozilla.org/en-US/docs/Games/Techniques/Tilemaps
-- Objects essentially does all thing tile based.
-- Tile map is a 20 by 20 grid of 32 bits each. Pretty simple... Hopefully

   tileMap = {}
   tileMap.tilesize = 32
   tileMap.mapsize = 640
   tileMap.numTiles = 20
   tileMap.BaseTile = love.graphics.newImage("img/BaseTile.png")
   tileMap.DarkTile1 = love.graphics.newImage("img/1DarkTile.png")
   tileMap.DarkTile2 = love.graphics.newImage("img/2DarkTile.png")
   tileMap.DarkTile3 = love.graphics.newImage("img/3DarkTile.png")

-- Creates all the pretty objects
function loadMap()
   -- Create stateMap and initialize it to base room pattern
   tileMap.stateMap = {}
   for rows = 1, tileMap.numTiles, 1 do
      tileMap.stateMap[rows] = {}
      for cols = 1, tileMap.numTiles, 1 do
         tileMap.stateMap[rows][cols] = 0
      end
   end

   -- Temp map stores growth values before applying them to the state table
   tileMap.growths = {}
   for rows = 1, tileMap.numTiles, 1 do
      tileMap.growths[rows] = {}
      for cols = 1, tileMap.numTiles, 1 do
         tileMap.growths[rows][cols] = 0
      end
   end

   -- This is the part of the story where I regret not using objects and end up
   -- with way too many matrices to check a variety of conditions since I strictly
   -- bounds checked and shrank down the conditions allowed on my original state table.
   -- I'm sad. Also, a state of 1 means it's burning. HAHAHAHAHAHAHAHAHAHA. ; , ;
   tileMap.burning = {}
   for rows = 1, tileMap.numTiles, 1 do
      tileMap.burning[rows] = {}
      for cols = 1, tileMap.numTiles, 1 do
         tileMap.burning[rows][cols] = 0
      end
   end

   burningtiles = {}
end

--Of course this file needed an update function too. Just wouldn't feel right without it.
function tileUpdate(dt, rows, cols)

end

-- Clears growths tree
function clearGrowths()
   for rows = 1, tileMap.numTiles, 1 do
      tileMap.growths[rows] = {}
      for cols = 1, tileMap.numTiles, 1 do
         tileMap.growths[rows][cols] = 0
      end
   end
end

-- For game over condition
function tileMap:resetState()
   -- Reset state table
   for rows = 1, tileMap.numTiles, 1 do
      tileMap.stateMap[rows] = {}
      for cols = 1, tileMap.numTiles, 1 do
         tileMap.stateMap[rows][cols] = 0
      end
   end
   -- Reset growth matrix
   for rows = 1, tileMap.numTiles, 1 do
      tileMap.growths[rows] = {}
      for cols = 1, tileMap.numTiles, 1 do
         tileMap.growths[rows][cols] = 0
      end
   end
end

function drawTile(tile, x, y)
   if (tile == nil) then
      return
   end
   love.graphics.draw(tile, x - tileMap.tilesize, y - tileMap.tilesize)
end

function getTileImg(row, column)
   -- Oh look, we did a thing... NOW FOR BOUNDS CHECKING
   if tileMap.stateMap[row][column] < 0 then
      tileMap.stateMap[row][column] = 0
   end
   if tileMap.stateMap[row][column] > 1 then
      tileMap.stateMap[row][column] = 1
   end
   -- Returns the tile image based on what the current state is
   if tileMap.stateMap[row][column] == 0 then
      return tileMap.BaseTile
   elseif tileMap.stateMap[row][column] == 1 then
      return tileMap.DarkTile1
   elseif tileMap.stateMap[row][column] == 2 then
      return tileMap.BaseTile
   elseif tileMap.stateMap[row][column] == 3 then
      return tileMap.DarkTile3
  end
end

function getTileEffectImg(row, column)
   -- Bounds checking already active on Effects
   if tileMap.burning[row][column] == 1 then
      return sprites.burntImage
   end
end
-- These functions allow for multiple abilities to impact and damage cells

-- Explosion ability. First cell detonates and casts burn on all other cells
-- Given that the cell was in shadows score is upticked by one
function iExplode(i,j)
   iBurn(i,j)      -- Center
   iBurn(i-1,j)    -- Top
   iBurn(i-1,j+1)  -- TopRight
   iBurn(i,j+1)    -- Right
   iBurn(i+1, j+1) -- BottomRight
   iBurn(i+1, j)   -- Bottom
   iBurn(i+1, j-1) -- BottomLeft
   iBurn(i, j-1)   -- Left
   iBurn(i-1,j-1)  -- TopLeft
end

function iBurn(i, j) --Since the cell is casting on itself I can do bounds checking. Muahaha. Baka
   --Bounds checking
   if (1 <= i) and (i <= 20) and (1 <= j) and (j <= 20) then
      -- Score check
      if (tileMap.stateMap[i][j] > 0) then
         Player.score = Player.score + 1
         tileMap.stateMap[i][j] = 0
      end
      -- Through the sheer power of deduction we found that the witch must have been made of wood
      -- and could float. Ducks could, also, float in water which she happened to weight the same as.
      -- Thus with our premises tied up we proved that she was in fact a witch and very flammable.
      tileMap.burning[i][j] = 1
      spawnBurningTile(i, j)
   end
end

function spawnBurningTile(x, y)
      BurntTile = {}
      BurntTile.burningtime = 0
      BurntTile.x = x
      BurntTile.y = y

      table.insert(burningtiles, BurntTile)
end


function iRobot() --??

end

function iPad() --Plz stop

end

-- Broad tilemap structure inspired by https://developer.mozilla.org/en-US/docs/Games/Techniques/Tilemaps
-- Objects essentially does all thing tile based.
-- Tile map is a 20 by 20 grid of 32 bits each. Pretty simple... Hopefully


function loadMap()
   tileMap = {}
   tileMap.tilesize = 32
   tileMap.mapsize = 640
   tileMap.numTiles = 20
   tileMap.BaseTile = love.graphics.newImage("img/BaseTile.png")
   tileMap.DarkTile1 = love.graphics.newImage("img/1DarkTile.png")
   tileMap.DarkTile2 = love.graphics.newImage("img/2DarkTile.png")
   tileMap.DarkTile3 = love.graphics.newImage("img/3DarkTile.png")

   -- Create stateMap and initialize it to base room pattern
   tileMap.stateMap = {}
   for rows = 1, tileMap.numTiles, 1 do
      tileMap.stateMap[rows] = {}
      for cols = 1, tileMap.numTiles, 1 do
         tileMap.stateMap[rows][cols] = 0
      end
   end

end

function drawTile(tile, x, y)
  love.graphics.draw(tile, x - tileMap.tilesize, y - tileMap.tilesize)
end

function getTileImg(row, column)
   if tileMap.stateMap[row][column] == 0 then
      return tileMap.BaseTile
   end
end

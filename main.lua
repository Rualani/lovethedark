function love.load()

   -- For resolution calculations
   resWidth = 640
   resHeight = 640
   love.window.setMode(resWidth, resHeight, flags)

   require("tileMap")
   require("player")

   --holding all sprites images for drawing
   sprites = {}
   sprites.playerImage = love.graphics.newImage("img/Player_Placeholder.png")

   --Loads tileMap object
   loadMap()

end

function love.update(dt)
  playerUpdate(dt)

end

function love.draw()
  -- Draw all tiles
  for rows=1, tileMap.numTiles, 1 do
    for cols=1, tileMap.numTiles, 1 do
      tile = getTileImg(rows,cols)
      x = cols * tileMap.tilesize
      y = rows * tileMap.tilesize
      drawTile(tile, x, y)
    end
  end
  
  -- Draw sprites on top of ... tile map
  love.graphics.draw(sprites.playerImage, player.x, player.y, r, sx, sy, ox, oy, kx, ky)

end

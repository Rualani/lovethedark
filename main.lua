function love.load()

   -- For resolution calculations
   resWidth = 640
   resHeight = 640
   love.window.setMode(resWidth, resHeight, flags)

   require("tileMap")
   require("player")
   require("thing")

   --holding all sprites images for drawing
   sprites = {}
   sprites.playerImage = love.graphics.newImage("img/Player_Placeholder.png")

   --Loads tileMap object
   loadMap()

   --time before next pulse. Shrink this down to increase the speed of the...thing
   pulsepace = 3
   numpulses = 0
   pulsetimer = pulsepace

end

function love.update(dt)
  -- player updates their state
  playerUpdate(dt)

  -- somethings state changes...?
  pulsetimer = pulsetimer - dt
  if pulsetimer < 0 then
     pulsetimer = pulsepace
     numpulses = numpulses + 1
     pulse(tileMap)
  end

  -- Uhm
  --thingUpdate()
  for i = 1, tileMap.numTiles, 1 do
     for j = 1, tileMap.numTiles, 1 do
        tileMap.stateMap[i][j] = tileMap.stateMap[i][j] + tileMap.growths[i][j]
     end
  end

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

  -- Draw pulse timer on top of map tiles
  love.graphics.printf("Pulse in " .. pulsetimer, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center")


  -- Draw sprites on top of ... tile map
  love.graphics.draw(sprites.playerImage, player.x, player.y, r, sx, sy, ox, oy, kx, ky)

end

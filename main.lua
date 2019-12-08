function love.load()

   -- For resolution calculations
   resWidth = 640
   resHeight = 640
   love.window.setMode(resWidth, resHeight, flags)

   require("tileMap")
   require("Player")
   require("thing")
   require("damage")
   require("menus")

   --holding all sprites images for drawing
   sprites = {}
   sprites.PlayerImage = love.graphics.newImage("img/Player_Placeholder.png")

   --Loads tileMap object
   loadMap()

   --time before next pulse. Shrink this down to increase the speed of the...thing
   pulsepace = 1
   numpulses = 0
   pulsetimer = pulsepace

   --Loading Fonts
   font = love.graphics.newFont("Fonts/ShadowsIntoLight-Regular.ttf", 80)

end

function love.update(dt)

   if menus.gameon == true then
     -- somethings state changes...?
     pulsetimer = pulsetimer - dt
     if pulsetimer < 0 then
        pulsetimer = pulsepace
        numpulses = numpulses + 1
        pulse(tileMap)
     end

     thingUpdate()
     playerUpdate(dt)

     -- Checking all the tiles for damage conditions and all that jazz
     for i = 1, tileMap.numTiles, 1 do
        for j = 1, tileMap.numTiles, 1 do
           tileUpdate(dt, i, j)
        end
     end

     --In charge of change damage states and starting damage animations
     --damageCalculations()
     menuUpdate(dt)
  elseif menus.gameover == true then
      menuUpdate(dt)
  end
end

function love.draw()
   if menus.gameon == true then
     -- Draw all tiles
     for rows = 1, tileMap.numTiles, 1 do
       for cols = 1, tileMap.numTiles, 1 do
         tile = getTileImg(rows,cols)
         x = cols * tileMap.tilesize
         y = rows * tileMap.tilesize
         drawTile(tile, x, y)
       end
     end
     -- Draw pulse timer on top of map tiles
     love.graphics.printf("Playerlengthshadows" .. Player.lengthinshadows, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center")
     love.graphics.printf("X,Y" .. Player.xtile .. "," .. Player.ytile, 0, love.graphics.getHeight() - 200, love.graphics.getWidth(), "center")
     love.graphics.printf("Health : " .. Player.health, 0, love.graphics.getHeight() - 600, love.graphics.getWidth() - 600, "center")
     -- Draw sprites on top of ... tile map
     love.graphics.draw(sprites.PlayerImage, Player.x, Player.y, 0, 1, 1, Player.width/2, Player.height/2, kx, ky)
   elseif menus.gameover == true then
      love.graphics.printf("Game", font, 200, 180, resWidth, "justify",r,sx,sy,ox,oy,kx,ky)
      love.graphics.printf("Over", font, 200, 230, resWidth, "justify",r,sx,sy,ox,oy,kx,ky)
      love.graphics.printf("Score: ".. Player.score, font, 200, 300, resWidth, "justify",r,sx,sy,ox,oy,kx,ky)
      love.graphics.printf(Player.score, font, 400, 300, resWidth, "justify",r,sx,sy,ox,oy,kx,ky)
   end
end

function love.mousepressed(x, y, button, isTouch)
   -- Resets if gameover
   if menus.gameover == true then
      menus.gameover = false
      menus.gameon = true
      resetState()
   end
end

function resetState()
   Player.resetState()
   tileMap.resetState()
end

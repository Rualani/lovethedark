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
   require("fireball")

   -- Fireball container... burning tiles container... catastrophe
   explosions = {}

   -- Sound Effects!!!
   firesound = love.audio.newSource("Sounds/foom_0.wav", "static")
   firesound:setVolume(0.4)
   firesound:setPitch(0.4)
   gameoversound = love.audio.newSource("Sounds/Kim Lightyear - And Then We Left.mp3", "static")
   grunt = love.audio.newSource("Sounds/ACK.mp3", "static")
   deathsound = love.audio.newSource("Sounds/DeathSound.mp3","static")
   gameonmusic = love.audio.newSource("Sounds/Juhani Junkala [Retro Game Music Pack] Level 1.wav", "static")
   gameonmusic:setLooping(true)
   gameonmusic:setVolume(0.5)

   --holding all sprites images for drawing
   sprites = {}
   sprites.PlayerImage = love.graphics.newImage("img/Player.png")
   sprites.flameimage = love.graphics.newImage("img/LightFire.png")
   sprites.burntImage = love.graphics.newImage("img/BurningAlpha.png")
   sprites.PlayerOuchImage = love.graphics.newImage("img/ouch.png")

   --Loads tileMap object
   loadMap()

   --time before next pulse. Shrink this down to increase the speed of the...thing
   pulsepace = 2
   numpulses = 0
   pulsetimer = pulsepace
   maxpulse = 2

   --Loading Fonts
   font = love.graphics.newFont("Fonts/ShadowsIntoLight-Regular.ttf", 80)
   otherfont = love.graphics.newFont("Fonts/ShadowsIntoLight-Regular.ttf", 30)

end

function love.update(dt)

   if menus.gameon == true then

      -- Cue the music?
      gameonmusic:play()
     -- Update the shadows
     pulsetimer = pulsetimer - dt
     if pulsetimer < 0 then
        pulsetimer = pulsepace
        numpulses = numpulses + 1
        pulse(tileMap)
     end
     if numpulses == maxpulse then
        pulsepace = pulsepace * .98
        numpulses = 0
     end

     thingUpdate()
     playerUpdate(dt)

     -- Update the fireball positions
      for i,f in ipairs(explosions) do
         f.x = f.x + math.cos(f.angle) * f.speed * dt
         f.y = f.y + math.sin(f.angle) * f.speed * dt
         -- Check For explode
         boom(f.x, f.y, f)
      end

      -- remove fireballs if exploded
      for i = #explosions,1,-1 do
            if explosions[i].exploded == true then
               table.remove(explosions,i)
            end
      end

     -- Checking all the tiles for damage conditions and all that jazz
     -- for i = 1, tileMap.numTiles, 1 do
     --    for j = 1, tileMap.numTiles, 1 do
     --       tileUpdate(dt, i, j)
     --    end
     -- end



     for i = #burningtiles,1,-1 do
        if burningtiles[i].burningtime > 1 then
           tileMap.burning[burningtiles[i].x][burningtiles[i].y] = 0
           table.remove(burningtiles,i)
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

     -- Draw Effects on tiles
     for i = #burningtiles,1,-1 do
         tile = getTileEffectImg(burningtiles[i].x, burningtiles[i].y)
         x = burningtiles[i].x * tileMap.tilesize
         y = burningtiles[i].y * tileMap.tilesize
         drawTile(tile, y, x)
     end

     -- Draw pulse timer on top of map tiles
     --love.graphics.printf("Playerlengthshadows" .. Player.lengthinshadows, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center")
     --love.graphics.printf("X,Y" .. Player.xtile .. "," .. Player.ytile, 0, love.graphics.getHeight() - 200, love.graphics.getWidth(), "center")
     love.graphics.printf("Health : " .. Player.health, otherfont, love.graphics.getWidth() - 600, love.graphics.getHeight() - resHeight, resWidth, "left")
     love.graphics.printf("Score : " .. Player.score, otherfont, love.graphics.getWidth() - 800, love.graphics.getHeight() - resHeight, resWidth, "right")

     -- Draw sprites on top of ... tile map
      if (Player.shadowed == true or Player.timeonfire > 0) then
         love.graphics.draw(sprites.PlayerOuchImage, Player.x, Player.y, 0, 1.5, 1.5, Player.width/2, Player.height/2, kx, ky)
      else
        love.graphics.draw(sprites.PlayerImage, Player.x, Player.y, 0, 1.5, 1.5, Player.width/2, Player.height/2, kx, ky)
      end

     -- Draw all the fireballs
      for i,f in ipairs(explosions) do
         love.graphics.draw(sprites.PlayerImage, f.x, f.y, 0, .5, .5, Player.width/2, Player.height/2, kx, ky)
      end
   elseif menus.gameover == true then
      love.graphics.printf("Game", font, 200, 180, resWidth, "justify",r,sx,sy,ox,oy,kx,ky)
      love.graphics.printf("Over", font, 200, 230, resWidth, "justify",r,sx,sy,ox,oy,kx,ky)
      love.graphics.printf("Score: ".. Player.score, font, 200, 300, resWidth, "justify",r,sx,sy,ox,oy,kx,ky)
      love.graphics.printf(Player.score, font, 400, 300, resWidth, "justify",r,sx,sy,ox,oy,kx,ky)
   end
end

function love.mousepressed(x, y, button, isTouch)
   -- Resets if gameover
   if menus.gameover == true and menus.gameovertimer > 2 then
      restartGame()
   end
   if menus.gameon == true then
      tempx = love.mouse.getX()
      tempy = love.mouse.getY()
      spawnFireball(Player.x, Player.y, tempx, tempy)
   end
end

function resetState()
   Player.resetState()
   tileMap.resetState()
end

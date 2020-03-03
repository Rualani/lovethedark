-- Game Over Screen

menus = {}
menus.gameover = false
menus.start = false
menus.gameon = true
menus.gameovertimer = 0


function menuUpdate(time)
   if (Player.health == 0) then
      gameonmusic:stop()
      menus.gameon = false
      menus.gameover = true
   end
   if menus.gameover == true then
      menus.gameovertimer = menus.gameovertimer + time
      if (menus.gameovertimer > 3) then
         gameoversound:play()
      end
   end
end

function restartGame()
   gameoversound:stop()
   gameonmusic:play()
   menus.gameovertimer = 0
   menus.gameover = false
   menus.gameon = true
   resetState()
   for i,b in ipairs(burningtiles) do
      b = nil
   end
   Player.x = resWidth/2
   Player.y = resHeight/2
end

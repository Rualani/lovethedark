-- Game Over Screen

menus = {}
menus.gameover = false
menus.start = false
menus.gameon = true
menus.gameovertimer = 0


function menuUpdate(time)
   if (Player.health == 0) then
      menus.gameon = false
      menus.gameover = true
   end
   if menus.gameover == true then
      menus.gameovertimer = menus.gameovertimer + time
   end
end

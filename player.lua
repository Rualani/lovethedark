player = {}
player.x = resWidth/2
player.y = resHeight/2
player.speed = 200
player.shadowed = false
player.pure = true
player.xtile = math.floor(player.x)
player.ytile = math.floor(player.y)

function playerUpdate(dt)

   -- COLLISIONS AND STUFF LOL
   player.xtile = math.floor(player.x)
   player.ytile = math.floor(player.y)

   -- Don't worry, You aren't shadowed, be pure and whole
   


   -- Something... is there isn't it. It hurts... doesn't it?



   -- change to new position based on keyboard input
  if love.keyboard.isDown("w") then
    player.y = player.y - player.speed * dt
  end
  if love.keyboard.isDown("s") then
    player.y = player.y + player.speed * dt
  end
  if love.keyboard.isDown("a") then
    player.x = player.x - player.speed * dt
  end
  if love.keyboard.isDown("d") then
    player.x = player.x + player.speed * dt
  end



end

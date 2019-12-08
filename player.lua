Player = {}
Player.x = resWidth/2
Player.y = resHeight/2
Player.speed = 200
Player.shadowed = false
Player.xtile = math.floor(Player.x / 32)
Player.ytile = math.floor(Player.y / 32)
Player.health = 5
Player.lengthinshadows = 0
Player.shadowresistance = 2
Player.damaged = false
Player.width = 32
Player.height = 32
Player.score = 0
Player.maxhealth = 5

function Player.resetState()
   Player.health = Player.maxhealth
end

function playerUpdate(dt)

   -- Bounds checking so bad things don't really happen. OK?
   if (Player.x < 0) then
      Player.x = 0
   end
   if (Player.x > 608) then
      Player.x = 608
   end
   if (Player.y < 0) then
      Player.y = 0
   end
   if (Player.y > 608) then
      Player.y = 608
   end

   -- Which tile player is on
   Player.xtile = math.floor(Player.x / 32) + 1
   Player.ytile = math.floor(Player.y / 32) + 1

   -- You've been in the shadows too long...
   if (Player.shadowed == true) then
      Player.lengthinshadows = Player.lengthinshadows + dt
   end
   if (Player.lengthinshadows > 2) then
      Player.health = Player.health - 1
      Player.lengthinshadows = 0
   end

   -- Don't worry, You aren't shadowed, be pure and whole
   if tileMap.stateMap[Player.ytile][Player.xtile] == 0 then
      Player.shadowed = false
      Player.lengthinshadows = 0
   end
   -- Something... is there isn't it. It hurts... doesn't it?
   if tileMap.stateMap[Player.ytile][Player.xtile] >= 1 then
      Player.shadowed = true
   end

   -- change to new position based on keyboard input
  if love.keyboard.isDown("w") then
    Player.y = Player.y - Player.speed * dt
  end
  if love.keyboard.isDown("s") then
    Player.y = Player.y + Player.speed * dt
  end
  if love.keyboard.isDown("a") then
    Player.x = Player.x - Player.speed * dt
  end
  if love.keyboard.isDown("d") then
    Player.x = Player.x + Player.speed * dt
  end
end

function damageCalculations()
   if Player.damaged == true then
      Player.health = Player.health - 1
      Player.damage = 1
   end
end

function playerDamaged()
   if (Player.health == 1) then
      Player.health = Player.health - 1
      deathsound:play()
   else
      Player.health = Player.health - 1
      damaged = grunt:clone()
      damaged:play()
   end
end

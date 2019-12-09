function spawnFireball(x, y, tx, ty)
   fireball = {}
   fireball.x = x
   fireball.y = y
   fireball.targetx = math.floor(tx / 32) + 1
   fireball.targety = math.floor(ty / 32) + 1
   fireball.speed = 300
   fireball.angle = math.atan2(fireball.y - love.mouse.getY(), fireball.x - love.mouse.getX()) + math.pi
   fireball.xtile = 0
   fireball.ytile = 0
   fireball.exploded = false

   -- Push fireball into vector
   table.insert(explosions, fireball)
end

-- Did it go boom?
function boom(x, y, f)
   f.xtile = math.floor(f.x / 32) + 1
   f.ytile = math.floor(f.y / 32) + 1

   -- this is my favorite part
   if (f.xtile == f.targetx and f.ytile == f.targety) then
      f.exploded = true
      iExplode(f.ytile, f.xtile)
   end
end

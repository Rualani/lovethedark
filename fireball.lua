function spawnFireball(x, y, tx, ty)
   fireball = {}
   fireball.x = x
   fireball.y = y
   fireball.targetx = math.floor(tx / 32) + 1
   fireball.targety = math.floor(ty / 32) + 1
   fireball.speed = 300
   fireball.angle = math.atan2(fireball.y - love.mouse.getY(), fireball.x - love.mouse.getX()) + math.pi

   -- Push fireball into vector
   table.insert(explosions, fireball)
end

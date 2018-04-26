--Credit goes to C0bra5 on the Starbound discord for fixing this!
--Go check out his awesome mod @ https://steamcommunity.com/sharedfiles/filedetails/?id=1348805475
--vvv Prevents that nasty equip exploit
function init()
    script.setUpdateDelta(config.getParameter("refresh"))
    self.started = false;
    self.item = config.getParameter("item")
    self.maxAmount = config.getParameter("maxAmount")
    self.configAmount = config.getParameter("amount")

    script.setUpdateDelta(5)

    self.tickDamagePercentage = 0.030
    self.tickTime = 2
    self.tickTimer = self.tickTime

end

function update(dt)
  if world.entitySpecies(entity.id()) == "webber" then --Player is a webber? give them goodies.
    if self.started then
        local count = world.entityHasCountOfItem(entity.id(), self.item)
        local maxDrop = math.min(self.configAmount, 1000)
        for _, entityID in pairs (world.itemDropQuery(entity.position(), 5)) do
            if world.entityName(entityID) == self.item then
                return
            end
        end
        if count and count < self.maxAmount then
            world.spawnItem(self.item, entity.position(), math.min(self.configAmount, self.maxAmount - count), {price = 0})
        end
    end
  else
    if world.entitySpecies(entity.id()) ~= "webber" then --Is the player not a webber? Pun-ish them.
      --world.sendEntityMessage(entity.id(), "queueRadioMessage", "wrongspeciesusingsilkcollector", 1.0) S.A.I.L. warns the player they they're going to die.
      self.timerRadioMessage = 60
      if (self.tickTimer <= 0) then
          self.tickTimer = self.tickTime
          status.applySelfDamageRequest({
	         damageType = "IgnoresDef",
	         damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 7, --deal a lot of damage.
	         damageSourceKind = "poison",
	         sourceEntityId = entity.id()
          })
      end
    end
  end
    self.started = true;
end

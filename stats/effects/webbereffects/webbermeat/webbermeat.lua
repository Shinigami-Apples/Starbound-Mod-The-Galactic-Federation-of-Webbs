function init()
  script.setUpdateDelta(5)

  self.tickDamagePercentage = 0.010
  self.tickTime = 1.0
  self.tickTimer = self.tickTime

  self.species=world.entitySpecies(entity.id())
  if self.species ~= "webber" then
    self.effectHandler=effect.addStatModifierGroup({{stat = "foodDelta", baseMultiplier = 20.0}})
    world.sendEntityMessage(entity.id(), "queueRadioMessage", "webbermeatillness",1)
  elseif self.species == "webber" then
    self.healingRate = config.getParameter("healAmount", 20) / effect.duration()
  end
end

function update(dt)
  if self.species == "webber" then
    boost()
  end
end


function boost()
        status.modifyResource("health", self.healingRate * dt)
end

function uninit()

end

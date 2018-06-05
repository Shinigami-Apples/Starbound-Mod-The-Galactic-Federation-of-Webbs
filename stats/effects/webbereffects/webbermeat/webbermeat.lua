function init()
    self.species=world.entitySpecies(entity.id())

  if self.species ~= "webber" or "glitch" or "droden" or "trink" or "radien" or "novakid" or "elunite" or "indix" then
    self.effectHandler=effect.addStatModifierGroup({{stat = "foodDelta", baseMultiplier = 20.0}})
    world.sendEntityMessage(entity.id(), "queueRadioMessage", "webbermeatillness",1)
  else
    status.removeEphemeralEffect("webbermeat",math.huge)
  end
end

function update(dt)
end

function uninit()

end

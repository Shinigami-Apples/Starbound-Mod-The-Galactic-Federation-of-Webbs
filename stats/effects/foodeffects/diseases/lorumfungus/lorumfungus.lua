function init()
    self.species=world.entitySpecies(entity.id()) --check player's species

  if self.species ~= "webber" then --if not a webber
    self.effectHandler=effect.addStatModifierGroup({{stat = "foodDelta", baseMultiplier = 40.0}}) --40x the hunger drain.
    world.sendEntityMessage(entity.id(), "queueRadioMessage", "gfowlorumsickness",1) --SAIL screams at you. good job.
    status.removeEphemeralEffect("wellfed",math.huge) --fuck you and your food status immunity, this is gonna stop you dead
  else --if a webber
    self.effectHandler=effect.addStatModifierGroup({{stat = "foodDelta", baseMultiplier = 20.0}}) --20x because there's smth worse
    world.sendEntityMessage(entity.id(), "queueRadioMessage", "gfowlorumsicknesswebbers",1) --SAIL screams at you differently
    status.removeEphemeralEffect("wellfed",math.huge) --math is huge af dude

    script.setUpdateDelta(5) --IDK what this does but no touchy

    self.tickDamagePercentage = 0.050 --05%???? right???
    self.tickTime = 1.0 --set this to 1.0 if the plan didn't cheeki breeki against Kelvin
    self.tickTimer = self.tickTime --IDK what this does but it works so dONOTTOUCHI
  end
end
-- Stinky banana
function update(dt) --script update delta is 5
  if self.species == "webber" then --only update if player is a webber otherwise, the update function does not take effect
    self.tickTimer = self.tickTimer - dt --idk what this does but apprently it works and does stuff so I'm no touchy
    if self.tickTimer <= 0 then --count down to 0
      self.tickTimer = self.tickTime --timer shit idk WTF IS LUA
      status.applySelfDamageRequest({ --damage the guy who ate smelly bread
          damageType = "IgnoresDef", --Ignores defense...
          damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 10, -- I multiplied c:<
          damageSourceKind = "poison", --Webbers have 20% poison resist in FR but this should be powerful enough to fuck one up
          sourceEntityId = entity.id() --deal damage to the webber with this status effect
        })
      end
  end
  effect.setParentDirectives(string.format("fade=00AA00=%.1f", self.tickTimer * 0.4)) --visual effect
end

function uninit()
--Nothing. Fuckin nothing
end
-- *Morty voice* "Im trying."

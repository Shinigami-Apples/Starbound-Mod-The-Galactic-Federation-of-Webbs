--Credit goes to C0bra5 on the Starbound discord for fixing this!
--Go check out his awesome mod @ https://steamcommunity.com/sharedfiles/filedetails/?id=1348805475
--Prevented that nasty equip exploit
--Further credit goes to ZimberZimber on the FU discord for further fixing!
--Fixed the problem where stuff like Woggles weren't being damaged by the pack.
function init()
	self.started = false;
	self.item = config.getParameter("item")
	self.maxAmount = config.getParameter("maxAmount")
	self.configAmount = config.getParameter("amount")
	self.foodDelta = config.getParameter("foodDelta") --does pack change food delta from "1"? change this in json

	self.tickDamagePercentage = 0.030
	self.tickTime = 2
	self.tickTimer = self.tickTime

	if world.entitySpecies(entity.id()) == "webber" then --Player is a webber?

		script.setUpdateDelta(config.getParameter("refresh"))

		effect.addStatModifierGroup({{stat = "foodDelta", baseMultiplier = self.foodDelta}}) --sets hunger drain via a variable. Normal value is "1"

		world.sendEntityMessage(entity.id(), "queueRadioMessage", "silkcollectionstart", 1.0)

		self.timerRadioMessage = 60
	else --if not webber, then NO.

		world.sendEntityMessage(entity.id(), "queueRadioMessage", "wrongspeciesusingsilkcollector", 1.0) --S.A.I.L. warns the player they they're going to die.

		self.timerRadioMessage = 60
	end
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
	else -- Is the player not a webber? Pun-ish them.
		--world.sendEntityMessage(entity.id(), "queueRadioMessage", "wrongspeciesusingsilkcollector", 1.0) S.A.I.L. warns the player they they're going to die.

		--self.timerRadioMessage = 60

		if self.tickTimer <= 0 then
			self.tickTimer = self.tickTime
			status.applySelfDamageRequest({
				damageType = "IgnoresDef",
				damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) * 2, --deal a lot of damage.
				damageSourceKind = "poison",
				sourceEntityId = entity.id()
			})
		else
			self.tickTimer = self.tickTimer - dt
		end
	end

	self.started = true;
end

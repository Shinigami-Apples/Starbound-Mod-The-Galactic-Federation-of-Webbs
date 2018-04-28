--Credit goes to C0bra5 on the Starbound discord for fixing this!
--Go check out his awesome mod @ https://steamcommunity.com/sharedfiles/filedetails/?id=1348805475
--Prevented that nasty equip exploit
--Further credit goes to ZimberZimber on the FU discord for further fixing!
--Fixed the problem where stuff like Woggles weren't being damaged by the pack.
--Even further credit goes to Kherae of the FU discord for fixing the timers that caused silk to be produced at godspeed.


function init()
    self.item = config.getParameter("item")
    self.maxAmount = config.getParameter("maxAmount")
    self.configAmount = config.getParameter("amount")
    self.foodDelta = config.getParameter("foodDelta") --does pack change food delta from "1"? change this in json
    self.tickDamagePercentage = config.getParameter("tickDamagePercentage",0.030)
    self.isWebber = world.entitySpecies(entity.id()) == "webber"
    self.processRate = config.getParameter(self.isWebber and "refreshWebber" or "refreshWrongSpecies",2.0)


    if self.isWebber then --Player is a webber?

        if self.foodDelta then--if food delta config parameter exists, set. if not, don't.
            effect.addStatModifierGroup({{stat = "foodDelta", baseMultiplier = self.foodDelta}}) --sets hunger drain via a variable. Normal value is "1"
        end
    end

    world.sendEntityMessage(entity.id(), "queueRadioMessage", self.isWebber and "silkcollectionstart" or "wrongspeciesusingsilkcollector", 1.0)--if webber, message 1. if not, message2.
end
 
function update(dt)
    if self.isWebber then
        if not self.silkTimer or self.silkTimer > self.processRate then
            local count = world.entityHasCountOfItem(entity.id(), self.item)
            local maxDrop = math.min(self.configAmount, 1000)
            for _, entityID in pairs (world.itemDropQuery(entity.position(), 5)) do
                if world.entityName(entityID) == self.item then
                    self.silkTimer=0.0
                    return
                end
            end

            if count and count < self.maxAmount then
                world.spawnItem(self.item, entity.position(), math.min(self.configAmount, self.maxAmount - count), {price = 0})
            end

            self.silkTimer=0.0
        else
            self.silkTimer=self.silkTimer+dt
        end
    else
        if not self.ouchTimer or self.ouchTimer > self.processRate then
            status.applySelfDamageRequest({
                damageType = "IgnoresDef",
                damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) * 2, --deal a lot of damage.
                damageSourceKind = "poison",
                sourceEntityId = entity.id()
            })
            self.ouchTimer=0.0
        else
            self.ouchTimer=self.ouchTimer+dt
        end
        if not self.timerRadioMessage or self.timerRadioMessage > 60.0 then
            world.sendEntityMessage(entity.id(), "queueRadioMessage", self.isWebber and "silkcollectionstart" or "wrongspeciesusingsilkcollector", 1.0)--if webber, message 1. if not, message2.
            self.timerRadioMessage=0.0
        else
            self.timerRadioMessage=self.timerRadioMessage+dt
        end
    end
end

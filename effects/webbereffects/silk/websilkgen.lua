--Credit goes to C0bra5 on the Starbound discord for fixing this!
--Go check out his awesome mod @ https://steamcommunity.com/sharedfiles/filedetails/?id=1348805475
--vvv Prevents that nasty equip exploit
function init()
    script.setUpdateDelta(config.getParameter("refresh"))
    self.started = false;
    self.item = config.getParameter("item")
    self.maxAmount = config.getParameter("maxAmount")
    self.configAmount = config.getParameter("amount")
end

function update(dt)
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
    self.started = true;
end

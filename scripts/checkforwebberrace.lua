require("/scripts/vec2.lua")
local fuoldInit = init
local fuoldUpdate = update
local fuoldUninit = uninit

function init()
  fuoldInit()
  self.lastYPosition = 0
  self.lastYVelocity = 0
  self.fallDistance = 0
  local bounds = mcontroller.boundBox()
end

function update(dt)
  fuoldUpdate(dt)

	if world.entitySpecies(entity.id()) == "webber" then --check for webber
		status.addEphemeralEffect("webberimmunity",math.huge) 
	end
	return dt

	end

function uninit()

end

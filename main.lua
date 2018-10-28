local chattypes = {
	"say",
	"emote",
	"yell",
	"party",
	"guild",
	"officer",
	"raid",
	"raid_warning",
	"instance_chat",
	"battleground",
}
local chatshortcuts = {
	instance="instance_chat",
	i="instance_chat",
	rw="raid_warning",
	r="raid",
	o="officer",
	p="party",
	s="say",
	e="emote",
	y="yell",
	g="guild",
	bg="battleground",
}

SLASH_WARMODEPRINT1 = "/warmodeprint"
SLASH_WARMODEPRINT2 = "/wmp"
SlashCmdList["WARMODEPRINT"] = function (chatType)
	if not IsInGroup(LE_PARTY_CATEGORY_HOME) then
		local enabled = UnitIsWarModeDesired("player") and "on" or "off"
		print("Not in a group. Your war mode is " .. enabled .. ".")
		return
	end

	local warmode = {}
	local noWarmode = {}
	local warmodeColor = {}
	local noWarmodeColor = {}
	function addPlayer(str)
		local unitName = UnitName(str)
		if not unitName then return end
		local unitClass = select(2, UnitClass(str))
		unitNameColor = "|c" .. RAID_CLASS_COLORS[unitClass].colorStr .. unitName .. "|r"
		unitName = unitName
		local warmodeactive = UnitIsWarModeDesired(str)
		if warmodeactive == true then
			warmode[#warmode + 1] = unitName
			warmodeColor[#warmodeColor + 1] = unitNameColor
		elseif warmodeactive == false then
			noWarmode[#noWarmode + 1] = unitName
			noWarmodeColor[#noWarmodeColor + 1] = unitNameColor
		end
	end
		
	-- Thanks weakauras for this code :)
	local function groupMembers()
		local groupType = IsInRaid() and 'raid' or 'party'
		local numGroupMembers = GetNumGroupMembers() - (groupType == "party" and 1 or 0)
		local i = groupType == 'party' and 0 or 1
		return function()
			local unitId
			if i == 0 then
				unitId = 'player' -- in parties, the player cannot be queried with "partyn".
			elseif i <= numGroupMembers then
				unitId = groupType .. i
			end
			i = i + 1
			return unitId
		end
	end

	for unitId in groupMembers() do
		--print(unitId)
		addPlayer(unitId)
	end

	local function makeString(list, startstr)
		local str = startstr .. " (" .. #list .. "): "
		for i,v in ipairs(list) do
			str = str .. v .. ", "
		end
		str = str:sub(1, str:len() - 2)
		return str
	end

	print(makeString(warmodeColor, "War Mode"))
	print(makeString(noWarmodeColor, "No War Mode"))
	if chatType:len() > 0 then
		local originalChatType = chatType
		chatType = chatType:lower()
		for i,v in pairs(chatshortcuts) do
			if chatType:lower() == i then
				chatType = v
				break
			end
		end
		local found = false
		for i,v in pairs(chattypes) do
			if chatType:lower() == v then
				found = true
				break
			end
		end
		if not found then
			print('"'..originalChatType..'"', "is either not valid or not supported.")
			return
		end

		SendChatMessage(makeString(warmode, "War Mode"), chatType)
		SendChatMessage(makeString(noWarmode, "No War Mode"), chatType)
	end
end

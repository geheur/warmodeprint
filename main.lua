SLASH_WARMODEPRINT1 = "/warmodeprint"
SLASH_WARMODEPRINT2 = "/wmp"
SlashCmdList["WARMODEPRINT"] = function (msg)
	local name, num
	if IsInGroup(LE_PARTY_CATEGORY_HOME) then
		name = "party"
		num = 5
	elseif IsInRaid() then
		name = "raid"
		num = 40
	elseif not IsInGroup(LE_PARTY_CATEGORY_HOME) then
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
		--print(unitName, UnitIsWarModeActive(str), UnitIsWarModePhased(str), UnitIsWarModeDesired(str), str)
		if warmodeactive == true then
			warmode[#warmode + 1] = unitName
			warmodeColor[#warmodeColor + 1] = unitNameColor
		elseif warmodeactive == false then
			noWarmode[#noWarmode + 1] = unitName
			noWarmodeColor[#noWarmodeColor + 1] = unitNameColor
		end
	end
		
	for i=1,num do
		local str = name .. i
		addPlayer(str)
	end
	addPlayer("player")

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
	if msg:len() > 0 then SendChatMessage(makeString(warmode, "War Mode"), msg) end
	if msg:len() > 0 then SendChatMessage(makeString(noWarmode, "No War Mode"), msg) end
end

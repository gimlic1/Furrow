_addon.name = 'Furrow'
_addon.author = 'Algar'
_addon.version = '1.3'
_addon.language = 'english'
_addon.commands = {'furrow'}

require('logger')
require('coroutine')

notice('Furrow can detect how many Furrows you have. Refer to the readme for more information.')

running = false
Furrows_unlocked = 1

function loop()
	if running == true then
		windower.add_to_chat(200, 'Furrow: Starting the planting cycle.')
		plantcycle(true) -- [2026-11-22 Fix] Was: plantcycle() (cleared running = false prematurely inside loop)
		if not running then return end
		coroutine.sleep (.1)
		Sell_junk(true) -- [2026-11-22 Fix] Was: Sell_junk(); running = true
		if not running then return end
		windower.add_to_chat(200, 'Furrow: Sleeping for an hour before the harvest.')
		coroutine.sleep (600)
		windower.add_to_chat(200, 'Reminder: Furrow will commence harvest in fifty minutes. Use //furrow abort to cancel.')
		coroutine.sleep (600)
		windower.add_to_chat(200, 'Reminder: Furrow will commence harvest in forty minutes. Use //furrow abort to cancel.')
		coroutine.sleep (600)
		windower.add_to_chat(200, 'Reminder: Furrow will commence harvest in thirty minutes. Use //furrow abort to cancel.')
		coroutine.sleep (600)
		windower.add_to_chat(200, 'Reminder: Furrow will commence harvest in twenty minutes. Use //furrow abort to cancel.')
		coroutine.sleep (600)
		windower.add_to_chat(200, 'Reminder: Furrow will commence harvest in ten minutes. Use //furrow abort to cancel.')
		coroutine.sleep (600)
		windower.add_to_chat(200, 'Furrow: Starting the harvesting cycle.')
		harvestcycle(true) -- [2026-11-22 Fix] Was: harvestcycle() (cleared running = false prematurely inside loop)
		if not running then return end
		coroutine.sleep (.1)
		windower.add_to_chat(200, 'Furrow: Cycle complete! Restarting the loop shortly...')
		coroutine.sleep(.1)
		loop()
	else
		windower.add_to_chat(200, 'Something went wrong! Please try your command again after reloading Furrow.')
		end
end

-- [2026-11-22 Fix] Was: unbounded recursive target1()..target4() with no < 6 yalms distance check.
-- Converted to bounded while running do loops (max 50 attempts) enforcing Fair-Play < 6 yalms distance.
local function target_furrow_obj(expected_name, found_msg)
	local attempts = 0
	while running and attempts < 50 do
		attempts = attempts + 1
		windower.send_command('setkey TAB down')
		coroutine.sleep(0.01)
		windower.send_command('setkey TAB up')
		coroutine.sleep(0.1)

		player = windower.ffxi.get_player()
		local mob = windower.ffxi.get_mob_by_target('t')

		if mob == nil then
			windower.add_to_chat(200, 'Furrow: No target, cycling.')
			coroutine.sleep(5)
			windower.send_command('setkey escape down')
			coroutine.sleep(0.3)
			windower.send_command('setkey escape up')
			coroutine.sleep(0.1)
		elseif mob.name == expected_name then
			if mob.distance and math.sqrt(mob.distance) < 6 then
				windower.add_to_chat(200, found_msg)
				return true
			else
				windower.add_to_chat(167, 'Furrow: Found ' .. expected_name .. ' but out of range (>= 6 yalms). Please move within 6 yalms.')
				running = false
				return false
			end
		else
			coroutine.sleep(0.1)
		end
	end
	if running then
		windower.add_to_chat(167, 'Furrow: Could not find ' .. expected_name .. ' within 50 attempts; stopping.')
		running = false
	end
	return false
end

function target1()
	return target_furrow_obj("Garden Furrow", 'Furrow: Found the first furrow.')
end	
	
function target2()
	return target_furrow_obj("Garden Furrow #2", 'Furrow: Found the second furrow.')
end	

function target3()
	return target_furrow_obj("Garden Furrow #3", 'Furrow: Found the third furrow.')
end	

function plant()
		windower.add_to_chat(200, 'Furrow: Planting a revival root.')
		windower.chat.input("/item \"Revival Root\" <t>")
		coroutine.sleep(2.5)
		windower.send_command('setkey enter down')
		coroutine.sleep(0.1)
		windower.send_command('setkey enter up')
		coroutine.sleep(1.5)
		windower.send_command('setkey enter down')
		coroutine.sleep(0.1)
		windower.send_command('setkey enter up')
		coroutine.sleep(1.5)
		windower.send_command('setkey enter down')
		coroutine.sleep(0.1)
		windower.send_command('setkey enter up')
		coroutine.sleep(4)
		windower.send_command('setkey escape down')
		coroutine.sleep(0.1)
		windower.send_command('setkey escape up')
		coroutine.sleep(0.5)
end			

function harvest()
		windower.add_to_chat(200, 'Furrow: Harvesting this furrow.')
		windower.send_command('setkey enter down')
		coroutine.sleep(0.1)
		windower.send_command('setkey enter up')
		coroutine.sleep(5)
		windower.send_command('setkey enter down')
		coroutine.sleep(0.1)
		windower.send_command('setkey enter up')
		coroutine.sleep(2)
		windower.send_command('setkey enter down')
		coroutine.sleep(0.1)
		windower.send_command('setkey enter up')
		coroutine.sleep(2)
		windower.send_command('setkey enter down')
		coroutine.sleep(0.1)
		windower.send_command('setkey enter up')
		coroutine.sleep(2)
		windower.send_command('setkey enter down')
		coroutine.sleep(0.1)
		windower.send_command('setkey enter up')
		coroutine.sleep(4)
		windower.send_command('setkey escape down')
		coroutine.sleep(0.1)
		windower.send_command('setkey escape up')
		coroutine.sleep(0.5)
end

function harvestcycle(keep_running) -- [2026-11-22 Fix] Was: function harvestcycle() that unconditionally set running = false
	if running == true then
		Check_KI()
		windower.add_to_chat(200, 'Furrow: Searching for the first furrow.')
		if not target1() then return end
		coroutine.sleep(.1)
		harvest()
		coroutine.sleep(.1)
		if Furrows_unlocked >= 2 then
			windower.add_to_chat(200, 'Furrow: Searching for the second furrow.')
			if not target2() then return end
			coroutine.sleep(.1)
			harvest()
			coroutine.sleep(.1)
		end
		if Furrows_unlocked >= 3 then
			windower.add_to_chat(200, 'Furrow: Searching for the third furrow.')
			if not target3() then return end
			coroutine.sleep(.1)
			harvest()
			coroutine.sleep(.1)
		end
		if not keep_running then running = false end -- [2026-11-22 Fix] Was: running = false
		windower.add_to_chat(200, 'Furrow: Harvesting Complete!')
	else
		windower.add_to_chat(200, 'Furrow: Something went wrong! Please try your command again after reloading Furrow.')
		end
end

function plantcycle(keep_running) -- [2026-11-22 Fix] Was: function plantcycle() that unconditionally set running = false
	if running == true then
		Check_KI()
		windower.add_to_chat(200, 'Furrow: Searching for the first furrow.')
		if not target1() then return end
		coroutine.sleep(.1)
		plant()
		coroutine.sleep(.1)
		if Furrows_unlocked >= 2 then
			windower.add_to_chat(200, 'Furrow: Searching for the second furrow.')
			if not target2() then return end
			coroutine.sleep(.1)
			plant()
			coroutine.sleep(.1)
		end
		if Furrows_unlocked >= 3 then
			windower.add_to_chat(200, 'Furrow: Searching for the third furrow.')
			if not target3() then return end
			coroutine.sleep(.1)
			plant()
			coroutine.sleep(.1)
		end
		if not keep_running then running = false end -- [2026-11-22 Fix] Was: running = false
		windower.add_to_chat(200, 'Furrow: Planting Complete!')
	else
		windower.add_to_chat(200, 'Furrow: Something went wrong! Please try your command again after reloading Furrow.')
		end
end

function furrow_command(...)
    if #arg > 1 then
        windower.add_to_chat(167, 'Invalid command.')
    elseif #arg == 1 and arg[ 1 ]:lower() == 'start' then
        if running == false then
            running = true
            windower.add_to_chat(200, 'Furrow: Begin loop...')
            loop()
        elseif running == true then
            windower.add_to_chat(200, 'It appears Furrow is already running an action, please use //furrow abort to reload the addon and try again.')
        end
    elseif #arg == 1 and arg[ 1 ]:lower() == 'stop' then
        if running == false then
            windower.add_to_chat(200, 'Furrow: There are no current actions to stop. Use //furrow abort to force-reload the addon if necessary.')
		elseif running == true then
			windower.add_to_chat(200, 'Furrow: Aborting all actions and reloading.')
			windower.send_command('lua reload furrow')
        end
	elseif #arg == 1 and arg[ 1 ]:lower() == 'plant' then
		if running == false then
            windower.add_to_chat(200, 'Furrow: Starting a single planting cycle.')
			running = true			
			plantcycle()
		elseif running == true then
            windower.add_to_chat(200, 'It appears Furrow is already running an action, please use //furrow abort to reload the addon and try again.')
		end
	elseif #arg == 1 and arg[ 1 ]:lower() == 'harvest' then
		if running == false then
            windower.add_to_chat(200, 'Furrow: Starting a single harvesting cycle.')
			running = true
			harvestcycle()
		elseif running == true then
            windower.add_to_chat(200, 'It appears Furrow is already running an action, please use //furrow abort to reload the addon and try again.')
		end
	elseif #arg == 1 and arg[ 1 ]:lower() == 'abort' then
        windower.add_to_chat(200, 'Furrow: Aborting all actions and reloading.')
		windower.send_command('lua reload furrow')
	elseif #arg == 1 and arg[ 1 ]:lower() == 'help' then
        windower.add_to_chat(200, 'Furrow commands: start stop abort plant harvest. See readme for additional information.')
	elseif #arg == 1 and arg[ 1 ]:lower() == 'ki' then
        windower.add_to_chat(200, 'Checking Key Items')
		Check_KI()
	elseif #arg == 1 and arg[ 1 ]:lower() == 'sell' then
        if running == false then
			running = true
			windower.add_to_chat(200, 'Selling')
			Sell_junk()
		elseif running == true then
            windower.add_to_chat(200, 'It appears Furrow is already running an action, please use //furrow abort to reload the addon and try again.')
        end
	else
		end
end
function Check_KI()
 local key_items = windower.ffxi.get_key_items()
    Furrows_unlocked = 1
	for k, v in ipairs(key_items) do
        if v == 2413  then
            --print("2nd Furrow")
			Furrows_unlocked = 2
        elseif v == 2415 then
            --print("3rd Furrow")
			Furrows_unlocked = 3
        end
    end
end


function target4()
	-- [2026-11-22 Fix] Was: unbounded recursive target4() with no < 6 yalms distance check
	return target_furrow_obj("Green Thumb Moogle", 'Furrow: Found Moogle')
end	

function Sell_junk(keep_running) -- [2026-11-22 Fix] Was: function Sell_junk() that unconditionally set running = false twice
	if not target4() then return end
	windower.chat.input('//sellnpc junk')
	coroutine.sleep(2)
	
	windower.send_command('setkey enter down')
	coroutine.sleep(0.3)
	windower.send_command('setkey enter up')
	coroutine.sleep(1)
	
	windower.send_command('setkey down down')
	coroutine.sleep(0.1)
	windower.send_command('setkey down up')
	coroutine.sleep(1)
	
	windower.send_command('setkey enter down')
	coroutine.sleep(0.3)
	windower.send_command('setkey enter up')
	coroutine.sleep(1)
	
	windower.send_command('setkey enter down')
	coroutine.sleep(0.3)
	windower.send_command('setkey enter up')
	coroutine.sleep(2)
	
	windower.send_command('setkey escape down')
	coroutine.sleep(0.3)
	windower.send_command('setkey escape up')
	coroutine.sleep(1)
	
	windower.send_command('setkey escape down')
	coroutine.sleep(0.3)
	windower.send_command('setkey escape up')
	if not keep_running then running = false end -- [2026-11-22 Fix] Was: running = false (twice)
end


windower.register_event('addon command', furrow_command)
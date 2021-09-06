library TriggerLib
    
    function CreateAndRegisterUnitEvent takes playerunitevent whichEvent, code condition, code actions returns nothing
		local trigger trig = CreateTrigger()
		local integer index = 0

		loop
			call TriggerRegisterPlayerUnitEvent(trig, Player(index), whichEvent, null)

			set index = index + 1
			exitwhen index == bj_MAX_PLAYER_SLOTS
		endloop

		call TriggerAddCondition(trig, Condition( condition ))
		call TriggerAddAction(trig, actions)
	endfunction
	
	public function RegisterUnitEvent takes trigger trig, playerunitevent whichEvent returns nothing
		local integer index = 0

		loop
			call TriggerRegisterPlayerUnitEvent(trig, Player(index), whichEvent, null)

			set index = index + 1
			exitwhen index == bj_MAX_PLAYER_SLOTS
		endloop
	endfunction

endlibrary
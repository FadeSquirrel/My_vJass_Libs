library PlayerLib
	
	function SetAbilityAvailable takes player whichPlayer, integer abilid, boolean avail returns nothing
		local integer index = 0
		
		if whichPlayer != null then
			call SetPlayerAbilityAvailable(whichPlayer, abilid, avail)
			
		else
			loop
				call SetPlayerAbilityAvailable(Player(index), abilid, avail)

				set index = index + 1
				exitwhen index == bj_MAX_PLAYER_SLOTS
			endloop
		
		endif
			
	endfunction

endlibrary
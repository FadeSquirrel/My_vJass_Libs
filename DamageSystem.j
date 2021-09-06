library DamageLib initializer Init requires DummyLib, TriggerLib

    globals
        
        public integer SourceC1Id
        public integer SourceC2Id
        public integer SourceC3Id
        public unit array SourceC1
        public unit array SourceC2
        public unit array SourceC3
        public trigger TriggerC0 = CreateTrigger()
        public trigger TriggerC1 = CreateTrigger()
        public trigger TriggerC2 = CreateTrigger()
        public trigger TriggerC3 = CreateTrigger()
        public unit RealSource
        
        private group PlayingUnits = CreateGroup()
        
    endglobals
    
    public function SetSourceId takes integer category, integer id returns nothing
        if category == 1 then
            set SourceC1Id = id
            
        elseif category == 2 then
            set SourceC2Id = id
            
        elseif category == 3 then
            set SourceC3Id = id
            
        endif
        
    endfunction
    
    function GetRealSource takes nothing returns unit
        return RealSource
        
    endfunction
    
    function DamageTo takes unit source, unit target, real amount, attacktype attackType, damagetype damageType, integer damageCategory returns nothing
        set RealSource = source
        
        if damageCategory == 0 then
            call UnitDamageTarget(source, target, amount, false, false, attackType, damageType, null)
        elseif damageCategory == 1 then
            call UnitDamageTarget(SourceC1[GetPlayerId(GetOwningPlayer(source))], target, amount, false, false, attackType, damageType, null)
        elseif damageCategory == 2 then
            call UnitDamageTarget(SourceC2[GetPlayerId(GetOwningPlayer(source))], target, amount, false, false, attackType, damageType, null)
        elseif damageCategory == 3 then
            call UnitDamageTarget(SourceC3[GetPlayerId(GetOwningPlayer(source))], target, amount, false, false, attackType, damageType, null)
        endif
        
    endfunction
    
    //==============================================================================
    private function AddUnitsToDamageGroupAndTriggers takes nothing returns nothing
        local unit pickedUnit
        
        if GetEnumUnit() != null then
            set pickedUnit = GetEnumUnit()
        else
            set pickedUnit = GetTriggerUnit()
        endif
        
        call GroupAddUnit(PlayingUnits, pickedUnit)
        call TriggerRegisterUnitEvent(TriggerC0, pickedUnit, EVENT_UNIT_DAMAGED)
        call TriggerRegisterUnitEvent(TriggerC1, pickedUnit, EVENT_UNIT_DAMAGED)
        call TriggerRegisterUnitEvent(TriggerC2, pickedUnit, EVENT_UNIT_DAMAGED)
        call TriggerRegisterUnitEvent(TriggerC3, pickedUnit, EVENT_UNIT_DAMAGED)

        set pickedUnit = null
    endfunction
    
    private function AddUnitsToDamageGroupAndTriggers_Cond takes nothing returns boolean
       if not IsUnitInGroup(GetEnteringUnit(), PlayingUnits) and GetUnitTypeId(GetEnteringUnit()) != Dummy_GetId() then
          return true
          
       endif
       return false
       
    endfunction

    private function RemoveUnitsFromDamageGroup takes nothing returns boolean
        if IsUnitInGroup(GetDyingUnit(), PlayingUnits) then
            call GroupRemoveUnit(PlayingUnits, GetDyingUnit())
            
        endif
        return false
        
    endfunction
    
    private function StartSorting takes nothing returns nothing
        local trigger trig = CreateTrigger()
        local region mapRegion = CreateRegion()
        local integer index = 0
        
        call DestroyTimer(GetExpiredTimer())
        
        set bj_lastCreatedGroup = GetUnitsInRectAll(bj_mapInitialPlayableArea)
        call ForGroup(bj_lastCreatedGroup, function AddUnitsToDamageGroupAndTriggers)
        call DestroyGroup(bj_lastCreatedGroup)
        
        call RegionAddRect(mapRegion, bj_mapInitialPlayableArea)
        call TriggerRegisterEnterRegion(trig, mapRegion, null)
        call TriggerAddCondition(trig, Condition(function AddUnitsToDamageGroupAndTriggers_Cond))
        call TriggerAddAction(trig, function AddUnitsToDamageGroupAndTriggers)

        set trig = CreateTrigger()
        call Trigger_RegisterUnitEvent(trig, EVENT_PLAYER_UNIT_DECAY)
        call TriggerAddCondition(trig, Condition(function RemoveUnitsFromDamageGroup))
        
        loop
            if GetPlayerSlotState(Player(index)) == PLAYER_SLOT_STATE_PLAYING or Player(index) == Player(PLAYER_NEUTRAL_AGGRESSIVE) or Player(index) == Player(bj_PLAYER_NEUTRAL_VICTIM) or Player(index) == Player(bj_PLAYER_NEUTRAL_EXTRA) or Player(index) == Player(PLAYER_NEUTRAL_PASSIVE) then
                set SourceC1[GetPlayerId(Player(index))] = CreateUnit(Player(index), SourceC1Id, 0, 0, 0)
                set SourceC2[GetPlayerId(Player(index))] = CreateUnit(Player(index), SourceC2Id, 0, 0, 0)
                set SourceC3[GetPlayerId(Player(index))] = CreateUnit(Player(index), SourceC3Id, 0, 0, 0)
                
            endif

			set index = index + 1
			exitwhen index == bj_MAX_PLAYER_SLOTS
		endloop
        
        set mapRegion = null
        set trig = null
    endfunction
    
    private function Init takes nothing returns nothing
        call TimerStart(CreateTimer(), 1, false, function StartSorting)
        
    endfunction

endlibrary
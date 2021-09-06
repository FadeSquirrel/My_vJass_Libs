library DummyLib requires optional UnitLib

    globals
        
        private integer ID
        private real Lifetime
        
    endglobals
    
    public function SetID takes integer id returns nothing
        set ID = id

    endfunction
    
    public function SetLifetime takes real amount returns nothing
        if amount <= 10 and amount > 0 then
            set Lifetime = amount
        else
            set Lifetime = 10
        endif

    endfunction
    
    public function GetId takes nothing returns integer
        return ID

    endfunction

    function ApplyAbilityToTarget takes unit caster, unit target, integer abilityId, integer abilityLevel, string abilityOrder, boolean immunityFlag returns boolean
        local unit dummy
        
        if caster != null and target != null and abilityId != 0 and abilityLevel != null and abilityOrder != "" and GetUnitAbilityLevel(target, 'Avul') == 0 and (immunityFlag or not IsUnitType(target, UNIT_TYPE_MAGIC_IMMUNE)) then
            set dummy = CreateUnit(GetOwningPlayer(caster), ID, GetUnitX(target), GetUnitY(target), 0)
            call UnitAddAbility(dummy, abilityId)
            call SetUnitAbilityLevel(dummy, abilityId, abilityLevel)
            call UnitApplyTimedLife(dummy, 'BTLF', Lifetime)
            call IssueTargetOrder(dummy, abilityOrder, target)
            return true
            
        else
            return false
            
        endif
        
    endfunction

    function ApplyAbilityToGroup takes unit caster, group targetGroup, integer abilityId, integer abilityLevel, string abilityOrder, boolean immunityFlag returns boolean
        local unit dummy
        local unit pickedUnit
        
        if caster != null and targetGroup != null and abilityId != 0 and abilityLevel != null and abilityOrder != "" then
            set dummy = CreateUnit(GetOwningPlayer(caster), ID, GetUnitX(caster), GetUnitY(caster), 0)
            call UnitAddAbility(dummy, abilityId)
            call SetUnitAbilityLevel(dummy, abilityId, abilityLevel)
            call UnitApplyTimedLife(dummy, 'BTLF', Lifetime)
            
            loop
                set pickedUnit = FirstOfGroup(targetGroup)
                exitwhen pickedUnit == null
                
                if (immunityFlag or not IsUnitType(pickedUnit, UNIT_TYPE_MAGIC_IMMUNE)) then
                    call SetUnitX(dummy, GetUnitX(pickedUnit))
                    call SetUnitY(dummy, GetUnitY(pickedUnit))
                    call IssueTargetOrder(dummy, abilityOrder, pickedUnit)
                endif
                
                call GroupRemoveUnit(targetGroup, pickedUnit)
            endloop
            
            call DestroyGroup(targetGroup)
            return true
            
        else
            call DestroyGroup(targetGroup)
            return false
            
        endif
        
    endfunction
    
endlibrary
library HeroLib
    
    function AddStr takes unit hero, integer amount returns boolean
        local real percentageHp
        
        if hero != null and amount != 0 then
            set percentageHp = GetUnitState(hero, UNIT_STATE_LIFE) / GetUnitState(hero, UNIT_STATE_MAX_LIFE)
            call SetHeroStr(hero, GetHeroStr(hero, false) + amount, true)
            call SetUnitState(hero, UNIT_STATE_LIFE, GetUnitState(hero, UNIT_STATE_MAX_LIFE) * percentageHp)
            return true
            
        endif
        return false
    
    endfunction
    
    function SetStr takes unit hero, integer amount returns boolean
        local real percentageHp
        
        if hero != null then
            set percentageHp = GetUnitState(hero, UNIT_STATE_LIFE) / GetUnitState(hero, UNIT_STATE_MAX_LIFE)
            call SetHeroStr(hero, amount, true)
            call SetUnitState(hero, UNIT_STATE_LIFE, GetUnitState(hero, UNIT_STATE_MAX_LIFE) * percentageHp)
            return true
            
        endif
        return false
    
    endfunction
    
    function AddInt takes unit hero, integer amount returns boolean
        local real percentageMp
        
        if hero != null and amount != 0 then
            set percentageMp = GetUnitState(hero, UNIT_STATE_MANA) / GetUnitState(hero, UNIT_STATE_MAX_MANA)
            call SetHeroInt(hero, GetHeroInt(hero, false) + amount, true)
            call SetUnitState(hero, UNIT_STATE_MANA, GetUnitState(hero, UNIT_STATE_MAX_MANA) * percentageMp)
            return true
            
        endif
        return false
    
    endfunction
    
    function SetInt takes unit hero, integer amount returns boolean
        local real percentageMp
        
        if hero != null then
            set percentageMp = GetUnitState(hero, UNIT_STATE_MANA) / GetUnitState(hero, UNIT_STATE_MAX_MANA)
            call SetHeroInt(hero, amount, true)
            call SetUnitState(hero, UNIT_STATE_MANA, GetUnitState(hero, UNIT_STATE_MAX_MANA) * percentageMp)
            return true
            
        endif
        return false
    
    endfunction

endlibrary
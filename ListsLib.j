//! textmacro ListsLib takes NAME, TYPE_NAME, VAR_NAME, HASH_TYPE_NAME, RETURN_FALSE
library $NAME$

    //копируется в отдельный триггер в карте или импортируесть через "//! import "...path/ListsLib.j""
    //библиотека позволяет создавать большое количество (до 8190 каждого типа) списков
    //размер каждого отдельного списка неограничен
    //из коробки можно создавать списки: целочисленных, реальных, типы_юнитов, типы_предметов, юнитов, эффектов, предметов
    //используется префикс: IntegerList_, RealList_, UnitIdList_,ItemIdList_,, UnitList_, EffectList_, ItemList_
    //через макрос "//! runtextmacro ListsLib("NAME", "VAR_NAME", "FUNC_NAME")" можно добавлять свои списки
    //каждый список создаётся с указанным тобой индексом через функцию $NAME$List_CreateList
    //Рекомендуется использовать key или StringHash для формирования индекса каждого нового списка
    //Примеры использование:
    //мод all random и команда random в карте (спосок типов юнитов)
    //списки предметов и их компонентов (использование равкода предмета как индекс списка и привязка компонентов к нему)
    
    globals
        
        private hashtable Hash = InitHashtable()
        private integer ListCount = 0
        private integer array ListIndex
        private integer array ListSize
        private boolean array ListFlag
        private constant integer MaxListCount = 8190
        private constant integer Exception = -1
        
    endglobals
    
    private function GetAddressByIndex takes integer listIndex returns integer
        local integer i = 0
        local integer address = Exception
        
        loop
            set i = i + 1
            exitwhen i > ListCount
            
            if listIndex == ListIndex[i] then
                set address = i
                set i = ListCount
            endif
                
        endloop
        
        debug call BJDebugMsg("DebugMsg: address - " + I2S(address)) 
        
        return address
    endfunction
    
    public function CreateList takes integer listIndex returns boolean
        local integer i = 0
        
        if ListCount < MaxListCount then
			
			if listIndex == Exception then
				debug call BJDebugMsg("Failed to create list! Error: invalid index!")
				return false
				
			else
				loop
					set i = i + 1
					exitwhen i > ListCount
					
					if ListIndex[ListCount] == listIndex then
						debug call BJDebugMsg("Failed to create list! Error: list index is taken")
						return false
						
					endif
					
				endloop
				
			endif
            
            set ListCount = ListCount + 1
            set ListIndex[ListCount] = listIndex
            set ListSize[ListCount] = 0
            set ListFlag[ListCount] = true
            call Save$HASH_TYPE_NAME$(Hash, ListCount, Exception, $RETURN_FALSE$)
			return true
            
        endif
        debug call BJDebugMsg("Failed to create list! Error: array is full")
        return false
        
    endfunction
    
    public function DestroyList takes integer listIndex returns boolean
        local integer index = GetAddressByIndex(listIndex)
		local integer i
            
        if index != Exception then
            call FlushChildHashtable(Hash, index)
            set ListIndex[index] = ListIndex[ListCount]
            set ListSize[index] = ListSize[ListCount]
            set ListFlag[index] = ListFlag[ListCount]
			
			loop
				set i = i + 1
				exitwhen i > ListSize[ListCount]
				call Save$HASH_TYPE_NAME$(Hash, index, i, Load$HASH_TYPE_NAME$(Hash, ListCount, i))
			endloop
			
			call FlushChildHashtable(Hash, ListCount)
			
            set ListIndex[ListCount] = Exception
            set ListSize[ListCount] = 0
            set ListFlag[ListCount] = false
            set ListCount = ListCount - 1
            return true
            
        endif
        
        debug call BJDebugMsg("Failed to destroy list! Error: invalid index")
        return false
    endfunction
    
    public function DestroyAllLists takes nothing returns nothing
        local integer index = ListCount
        
        loop
            set index = index - 1
            exitwhen index < 0
            
            set ListIndex[index] = Exception
            set ListSize[index] = 0
            set ListFlag[index] = false
                
        endloop
        
        call FlushParentHashtable(Hash)        
        set ListCount = 0
        
        debug call BJDebugMsg("DebugMsg: call is over =DestroyAllLists=") 
    endfunction
    
    public function GetListSize takes integer listIndex returns integer
        local integer index = GetAddressByIndex(listIndex)
            
        if index != Exception then
            return ListSize[index]
            
        endif
        
        debug call BJDebugMsg("Failed! Error: list index not found")
        return 0
        
    endfunction
    
    public function SetListAvailabilityFlag takes integer listIndex, boolean flag returns nothing
        local integer index = GetAddressByIndex(listIndex)
            
        if index != Exception then
            set ListFlag[index] = flag
            
        debug else
            debug call BJDebugMsg("Setting flag failed! Error: invalid index")
            
        endif
        
    endfunction
    
    function Is$TYPE_NAME$InList takes $VAR_NAME$ which, integer listIndex returns boolean
        local integer index = GetAddressByIndex(listIndex)
        local integer i = 0
        
        loop
            set i = i + 1
            exitwhen i > ListSize[index]
            
            if which == Load$HASH_TYPE_NAME$(Hash, index, i) then
                return true
            endif
                
        endloop
        
        return false
    endfunction
    
    function ListAdd$TYPE_NAME$ takes integer listIndex, $VAR_NAME$ which returns integer
        local integer index = GetAddressByIndex(listIndex)
        
        if ListFlag[index] then
            set ListSize[index] = ListSize[index] + 1
            call Save$HASH_TYPE_NAME$(Hash, index, ListSize[index], which)
            return ListSize[index]
        endif
        
        debug call BJDebugMsg("Failed to add $TYPE_NAME$! Error: the list is blocked")
        return Exception
        
    endfunction
    
    function Get$TYPE_NAME$FromListByIndex takes integer listIndex, integer index returns $VAR_NAME$
        return Load$HASH_TYPE_NAME$(Hash, GetAddressByIndex(listIndex), index)
        
    endfunction
    
    function GetIndexFromListBy$TYPE_NAME$ takes integer listIndex, $VAR_NAME$ which  returns integer
        local integer index = GetAddressByIndex(listIndex)
        local integer i = 0
        
        loop
            set i = i + 1
            exitwhen i > ListSize[index]
            
            if which == Load$HASH_TYPE_NAME$(Hash, index, i) then
                return i
            endif
                    
        endloop
        
        return Exception
        
    endfunction
    
    function GetRandom$TYPE_NAME$FromList takes integer listIndex returns $VAR_NAME$
        local integer index = GetAddressByIndex(listIndex)
        return Load$HASH_TYPE_NAME$(Hash, index, GetRandomInt(1, ListSize[index]))
    
    endfunction
    
    public function GetRandomIndexFromList takes integer listIndex returns integer
        return GetRandomInt(1, ListSize[GetAddressByIndex(listIndex)])
        
    endfunction
    
    function ListRemove$TYPE_NAME$ takes $VAR_NAME$ which, integer listIndex returns boolean
        local integer index = GetAddressByIndex(listIndex)
        local integer whichIndex = GetIndexFromListBy$TYPE_NAME$(listIndex, which)
        
        if ListFlag[index] then
            if Is$TYPE_NAME$InList(which, listIndex) then
                call Save$HASH_TYPE_NAME$(Hash, index, whichIndex, Get$TYPE_NAME$FromListByIndex(listIndex, ListSize[index]))
                call Save$HASH_TYPE_NAME$(Hash, index, ListSize[index], $RETURN_FALSE$)
                set ListSize[index] = ListSize[index] - 1
                return true
                
            debug else
                debug call BJDebugMsg("Failed to remove $TYPE_NAME$! Error: invalid $TYPE_NAME$")
            
            endif
            
        debug else
            debug call BJDebugMsg("Failed to remove $TYPE_NAME$! Error: the list is blocked")
            
        endif
        
        return false
        
    endfunction
    
    function ListRemove$TYPE_NAME$ByIndex takes integer whichIndex, integer listIndex returns boolean
        local integer index = GetAddressByIndex(listIndex)
        
        if ListFlag[index] then
            if Is$TYPE_NAME$InList(Get$TYPE_NAME$FromListByIndex(listIndex, whichIndex), listIndex) then
                call Save$HASH_TYPE_NAME$(Hash, index, whichIndex, Get$TYPE_NAME$FromListByIndex(listIndex, ListSize[index]))
                call Save$HASH_TYPE_NAME$(Hash, index, ListSize[index], $RETURN_FALSE$)
                set ListSize[index] = ListSize[index] - 1
                return true
                
            debug else
                debug call BJDebugMsg("Failed to remove $TYPE_NAME$! Error: invalid index")
            
            endif
            
        debug else
            debug call BJDebugMsg("Failed to remove $TYPE_NAME$! Error: the list is blocked")
            
        endif
        
        return false
        
    endfunction
    
endlibrary
//! endtextmacro

//! runtextmacro ListsLib("Integer", "Integer", "integer", "Integer", "0")
//! runtextmacro ListsLib("Real", "Real", "real", "Real", "0.")

//! runtextmacro ListsLib("UnitId", "UnitId", "integer", "Integer", "0")
//! runtextmacro ListsLib("ItemId", "ItemId", "integer", "Integer", "0")

//! runtextmacro ListsLib("Unit", "Unit", "unit", "UnitHandle", "null")
//! runtextmacro ListsLib("Effect", "Effect", "effect", "EffectHandle", "null")
//! runtextmacro ListsLib("Item", "Item", "item", "ItemHandle", "null")
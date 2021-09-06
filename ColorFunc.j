library ColorLib initializer InitColor

	globals
        integer array RED
        integer array GREEN
        integer array BLUE
        private string array ColorString
    endglobals

    function GetPlayerColorIndex takes integer nPlayerIndex returns integer
        local playercolor pc = GetPlayerColor( Player( nPlayerIndex ) )

        if ( pc == PLAYER_COLOR_RED ) then
            return 0
        elseif ( pc == PLAYER_COLOR_BLUE ) then
            return 1
        elseif ( pc == PLAYER_COLOR_CYAN ) then
            return 2
        elseif ( pc == PLAYER_COLOR_PURPLE ) then
            return 3
        elseif ( pc == PLAYER_COLOR_YELLOW ) then
            return 4
        elseif ( pc == PLAYER_COLOR_ORANGE ) then
            return 5
        elseif ( pc == PLAYER_COLOR_GREEN ) then
            return 6
        elseif ( pc == PLAYER_COLOR_PINK ) then
            return 7
        elseif ( pc == PLAYER_COLOR_LIGHT_GRAY ) then
            return 8
        elseif ( pc == PLAYER_COLOR_LIGHT_BLUE ) then
            return 9
        elseif ( pc == PLAYER_COLOR_AQUA ) then
            return 10
        elseif ( pc == PLAYER_COLOR_BROWN ) then
            return 11
        endif

        return 0
    endfunction

    function GetColoredString takes integer nPlayerIndex, string str returns string
        return ColorString[GetPlayerColorIndex( nPlayerIndex )] + str + "|r"
    endfunction

    function GetColoredPlayerName takes integer nPlayerIndex returns string
        return GetColoredString( nPlayerIndex, GetPlayerName( Player( nPlayerIndex ) ) )
    endfunction

    function InitColor takes nothing returns nothing
        local integer nIndex = 0
        set RED[nIndex] = 255
        set GREEN[nIndex] = 0
        set BLUE[nIndex] = 0
        set ColorString[nIndex] = "|cffff0000" //red

        set nIndex = nIndex + 1
        set RED[nIndex] = 0
        set GREEN[nIndex] = 0
        set BLUE[nIndex] = 255
        set ColorString[nIndex] = "|cff0000ff" //blue

        set nIndex = nIndex + 1
        set RED[nIndex] = 0
        set GREEN[nIndex] = 245
        set BLUE[nIndex] = 255
        set ColorString[nIndex] = "|cff00f5ff" //Teal

        set nIndex = nIndex + 1
        set RED[nIndex] = 85
        set GREEN[nIndex] = 26
        set BLUE[nIndex] = 139
        set ColorString[nIndex] = "|cff551A8B" //Purple

        set nIndex = nIndex + 1
        set RED[nIndex] = 255
        set GREEN[nIndex] = 255
        set BLUE[nIndex] = 0
        set ColorString[nIndex] = "|cffffff00" //Yellow

        set nIndex = nIndex + 1
        set RED[nIndex] = 248
        set GREEN[nIndex] = 154
        set BLUE[nIndex] = 0
        set ColorString[nIndex] = "|cffEE9A00" //Orange

        set nIndex = nIndex + 1
        set RED[nIndex] = 0
        set GREEN[nIndex] = 255
        set BLUE[nIndex] = 0
        set ColorString[nIndex] = "|cff00CD00" //Green

        set nIndex = nIndex + 1
        set RED[nIndex] = 255
        set GREEN[nIndex] = 105
        set BLUE[nIndex] = 180
        set ColorString[nIndex] = "|cffFF69B4" //Pink

        set nIndex = nIndex + 1
        set RED[nIndex] = 192
        set GREEN[nIndex] = 192
        set BLUE[nIndex] = 192
        set ColorString[nIndex] = "|cffC0C0C0" //Gray

        set nIndex = nIndex + 1
        set RED[nIndex] = 176
        set GREEN[nIndex] = 226
        set BLUE[nIndex] = 255
        set ColorString[nIndex] = "|cffB0E2FF" //Light Blue

        set nIndex = nIndex + 1
        set RED[nIndex] = 0
        set GREEN[nIndex] = 100
        set BLUE[nIndex] = 0
        set ColorString[nIndex] = "|cff006400" //Dark Green

        set nIndex = nIndex + 1
        set RED[nIndex] = 139
        set GREEN[nIndex] = 69
        set BLUE[nIndex] = 19
        set ColorString[nIndex] = "|cff8B4513" //Brown
    endfunction

    function ResetPlayerNameColor takes boolean bColored returns nothing
        local integer nIndex = 0
        loop
            exitwhen nIndex >= 8

            if ( bColored ) then
                call SetPlayerName( Player( nIndex ), GetColoredPlayerName( nIndex ) )
            else
                call SetPlayerName( Player( nIndex ), GetPlayerName( Player( nIndex ) ) )
            endif
        
            set nIndex = nIndex + 1
        endloop
    endfunction
    
endlibrary
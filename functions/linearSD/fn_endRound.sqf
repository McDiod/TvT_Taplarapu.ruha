#include "component.hpp"

params [["_endMessage",""],["_winner",sideUnknown],["_isLastSector",false]];

missionNamespace setVariable [QGVAR(roundInProgress),false,true];

// attacker is winner --> set sectors captured
if (_winner != GVAR(defendingSide)) then {
    _linkedSectors = GVAR(sectorTriggers) select GVAR(activeSectorID);
    _oldOwner = [WEST,EAST] select (_winner == WEST);
    {
        _x setVariable [QEGVAR(sectors,currentOwner),_winner];
        _x setVariable [QEGVAR(sectors,previousOwner),_oldOwner];
        _x setVariable [QEGVAR(sectors,blocked),true];
        _x setVariable [QEGVAR(sectors,sideStrenghts),[0,0,0]];
        [_x] call EFUNC(sectors,updateMarker);
    } forEach _linkedSectors;
};



systemChat _endMessage;



private _winnerDisplayName = [_winner] call EFUNC(common,getSideDisplayName);
if (_isLastSector) then {
    ["",format ["%1 wins!",_winnerDisplayName],[_winner],[]] call EFUNC(endings,endMissionServer);

} else {
    private _winMessage = format ["%1 wins the round.",_winnerDisplayName];
    systemChat _winMessage;

    private _nextActiveSector = GVAR(activeSectorID) + GVAR(opforDirection) * ([-1,1] select (_winner == EAST));
    [_nextActiveSector] call FUNC(startNewRound);
};

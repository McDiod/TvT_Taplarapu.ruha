#include "component.hpp"

params [["_endMessage",""],["_winner",sideUnknown],["_isLastSector",false]];

if !(GVAR(roundInProgress)) exitWith {INFO("A different ending is already in progress.")};

missionNamespace setVariable [QGVAR(roundInProgress),false,true];

// attacker is winner --> set sectors captured
if (_winner != GVAR(defendingSide)) then {
    _linkedSectors = GVAR(sectorTriggers) select GVAR(activeSectorID);
    _oldOwner = [WEST,EAST] select (_winner == WEST);
    {
        _x setVariable [QEGVAR(sectors,currentOwner),_winner];
        _x setVariable [QEGVAR(sectors,previousOwner),_oldOwner];
        _x setVariable [QEGVAR(sectors,blocked),true];
        _x setVariable [QEGVAR(sectors,sideStrengths),[0,0,0]];
        [_x] call EFUNC(sectors,updateMarker);
    } forEach _linkedSectors;
};


private _winnerDisplayName = [_winner] call EFUNC(common,getSideDisplayName);
if (_isLastSector) then {
    ["",format ["%1 wins!",_winnerDisplayName],[_winner],[]] call EFUNC(endings,endMissionServer);

} else {
    _messagePic = ["seize_ca","defend_ca"] select (_winner == GVAR(defendingSide));
    _winMessage = format ["%1 wins the round.",_winnerDisplayName];
    [_endMessage,_winMessage,_messagePic] call FUNC(dynamicText);

    private _nextActiveSector = GVAR(activeSectorID) + GVAR(opforDirection) * ([-1,1] select (_winner == EAST));
    [FUNC(startNewRound),[_nextActiveSector],5] call CBA_fnc_waitAndExecute;
};

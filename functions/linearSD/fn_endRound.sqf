#include "component.hpp"

params [["_endMessage",""],["_winner",sideUnknown],["_isLastSector",false]];

missionNamespace setVariable [QGVAR(roundInProgress),false,true];

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

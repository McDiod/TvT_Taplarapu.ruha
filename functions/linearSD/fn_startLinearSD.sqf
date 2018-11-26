#include "component.hpp"

params [["_startingSectorID",-1],["_roundLength",60],["_opforDirection",1]];

if (hasInterface) then {
    [] call FUNC(addTeleportAction);
};

if (isServer) then {

    GVAR(linearSDActive) = true;
    publicVariable QGVAR(linearSDActive);

    GVAR(roundInProgress) = false;
    publicVariable QGVAR(roundInProgress);

    GVAR(roundLength) = _roundLength;
    publicVariable QGVAR(roundLength);

    GVAR(roundTimeLeft) = _roundLength;
    publicVariable QGVAR(roundTimeLeft);

    GVAR(opforDirection) = _opforDirection;
    GVAR(defendingSide) = sideUnknown;

    [_startingSectorID] call FUNC(startNewRound);
    [] call FUNC(startTimeout);
    [WEST] call FUNC(startEliminationCheck);
    [EAST] call FUNC(startEliminationCheck);
};

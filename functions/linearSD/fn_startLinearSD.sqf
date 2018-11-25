#include "component.hpp"

params [["_startingSectorID",-1],["_bluforDirection",1]];

if (hasInterface) then {
    [] call FUNC(addTeleportAction);
};

if (isServer) then {

    GVAR(linearSDActive) = true;
    publicVariable QGVAR(linearSDActive);

    GVAR(roundInProgress) = false;
    publicVariable QGVAR(roundInProgress);

    GVAR(bluforDirection) = _bluforDirection;

    [_startingSectorID] call FUNC(startNewRound);
};

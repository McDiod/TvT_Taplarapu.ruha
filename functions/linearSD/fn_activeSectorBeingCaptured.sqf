#include "component.hpp"

private _activeSectors = GVAR(sectorTriggers) select GVAR(activeSectorID);

private _activeSectorBeingCaptured = false;

{
    _sideStrengths = _x getVariable QEGVAR(sectors,sideStrengths);
    if (selectMax _sideStrengths > 0) exitWith {
        _activeSectorBeingCaptured = true;
    };
} forEach _activeSectors;

_activeSectorBeingCaptured

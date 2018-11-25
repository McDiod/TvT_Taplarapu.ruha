#include "component.hpp"

params [["_activeSectorID",-1]];

private _inactiveSectorTriggers = +GVAR(sectorTriggers);
private _activeSectorTriggers = _inactiveSectorTriggers deleteAt _activeSectorID;

{
    {
        [_x,true,false] call EFUNC(sectors,blockSector);
    } forEach _x;
} forEach _inactiveSectorTriggers;

{
    [_x,false,false] call EFUNC(sectors,blockSector);
} forEach _activeSectorTriggers;

GVAR(activeSectorID) = _activeSectorID;
publicVariable QGVAR(activeSectorID);

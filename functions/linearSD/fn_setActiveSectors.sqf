#include "component.hpp"

params [["_activeSectorID",-1]];

private _inactiveSectorTriggers = +(GVAR(sectorTriggers));
private _activeSectorTriggers = _inactiveSectorTriggers deleteAt _activeSectorID;

{
    {
        [_x,true,false] call EFUNC(sectors,blockSector);
    } forEach _x;
} forEach _inactiveSectorTriggers;

{
    [_x,false,false] call EFUNC(sectors,blockSector);
} forEach _activeSectorTriggers;

private _attackDirection = [-(GVAR(opforDirection)),GVAR(opforDirection)] select (GVAR(defendingSide) == WEST);
GVAR(attackerSectorID) = _activeSectorID - _attackDirection;
publicVariable QGVAR(attackerSectorID);

GVAR(activeSectorID) = _activeSectorID;
publicVariable QGVAR(activeSectorID);

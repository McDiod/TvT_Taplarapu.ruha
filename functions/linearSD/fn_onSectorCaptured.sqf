#include "component.hpp"

params [["_sector",objNull],["_newOwner",sideUnknown],["_oldOwner",sideUnknown]];

private _sectorID = _sector getVariable [QEGVAR(sectors,sectorData),-1];
if (_sectorID < 0) exitWith {ERROR("sectorID undefined")};

private _linkedSectors = GVAR(sectorTriggers) select _sectorID;
{
    _x setVariable [QEGVAR(sectors,currentOwner),_newOwner];
    _x setVariable [QEGVAR(sectors,previousOwner),_oldOwner];
    _x setVariable [QEGVAR(sectors,blocked),true];
    _x setVariable [QEGVAR(sectors,sideStrenghts),[0,0,0]];
    [_x] call EFUNC(sectors,updateMarker);
} forEach _linkedSectors;

private _endMessage = format ["%1 captured!",_sector getVariable [QEGVAR(sectors,sectorName),"ERROR: Sector unknown."]];
private _isLastSector = (_sectorID == 0) || (_sectorID == ((count GVAR(sectorTriggers)) - 1));
[_endMessage,_newOwner,_isLastSector] call FUNC(endRound);

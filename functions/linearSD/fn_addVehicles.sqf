#include "component.hpp"

if (!isServer) exitWith {};

params [["_logic",objNull],["_side",sideUnknown]];

if !(_side in [WEST,EAST]) exitWith {ERROR_1("Side %1 not supported in linearSD.",_side)};

private _vehicles = (synchronizedObjects _logic) select {
    _x isKindOf "LandVehicle" ||
    _x isKindOf "Air" ||
    _x isKindOf "Ship" ||
    _x isKindOf "ThingX"
};
private _sectors = _logic call bis_fnc_moduleTriggers;

private _vehicleArrayVarName = [QGVAR(sectorVehiclesWest),QGVAR(sectorVehiclesEast)] select (_side == EAST);
{
    _vehArray = [
        typeOf _x,
        getPosASL _x,
        getDir _x,
        getItemCargo _x,
        getMagazineCargo _x,
        getWeaponCargo _x,
        getBackpackCargo _x,
        getObjectTextures _x
    ];

    deleteVehicle _x;

    {
        if (isNil {_x getVariable _vehicleArrayVarName}) then {
            _x setVariable [_vehicleArrayVarName,[]];
        };
        _sectorVehicles = _x getVariable _vehicleArrayVarName;

        _sectorVehicles pushBack _vehArray;
    } forEach _sectors;
} forEach _vehicles;

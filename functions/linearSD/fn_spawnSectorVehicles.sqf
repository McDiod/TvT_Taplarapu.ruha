#include "component.hpp"

params ["_trigger","_attackingSide"];

private _vehicleArrayVarName = [QGVAR(sectorVehiclesWest),QGVAR(sectorVehiclesEast)] select (_attackingSide == EAST);
private _sectorVehiclesArray = _trigger getVariable [_vehicleArrayVarName,[]];

{
    _x params [
        "_type",
        "_posASL",
        "_dir",
        ["_itemCargo",[]],
        ["_magazineCargo",[]],
        ["_weaponCargo",[]],
        ["_backpackCargo",[]],
        ["_objectTextures",[]]
    ];

    _veh = createVehicle [_type,[0,0,0],[],0,"CAN_COLLIDE"];
    _veh setDir _dir;
    _veh setPosASL _posASL;

    clearItemCargoGlobal _veh;
    {
        _veh addItemCargoGlobal [_x,(_itemCargo select 1) select _forEachIndex];
    } forEach (_itemCargo select 0);

    clearMagazineCargoGlobal _veh;
    {
        _veh addMagazineCargoGlobal [_x,(_magazineCargo select 1) select _forEachIndex];
    } forEach (_magazineCargo select 0);

    clearWeaponCargoGlobal _veh;
    {
        _veh addWeaponCargoGlobal [_x,(_weaponCargo select 1) select _forEachIndex];
    } forEach (_weaponCargo select 0);

    clearBackpackCargoGlobal _veh;
    {
        _veh addBackpackCargoGlobal [_x,(_backpackCargo select 1) select _forEachIndex];
    } forEach (_backpackCargo select 0);

    {_veh setObjectTextureGlobal [_forEachIndex,_x]} forEach _objectTextures;

    GVAR(allAttackerVehicles) pushBack _veh;
} forEach _sectorVehiclesArray;

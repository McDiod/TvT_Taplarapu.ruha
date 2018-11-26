#include "component.hpp"

if (!hasInterface) exitWith {};

if (isNil QGVAR(playerRespawnEH)) then {
    GVAR(playerRespawnEH) = player addEventHandler ["Respawn",{
        params ["_newUnit","_oldUnit"];

        ["Terminate"] call BIS_fnc_EGSpectator;

        // teleport to respawn position manually, because players who died before new marker position was set do not get the updated position
        _respawnMarker = ["respawn_west","respawn_east"] select (playerSide == EAST);
        _pos = (getMarkerPos _respawnMarker) findEmptyPosition [0,30,"B_Soldier_F"];
        if (_pos isEqualTo []) then {_pos = getMarkerPos _respawnMarker};
        [player,_pos] call EFUNC(common,teleport);

        cutText ["","BLACK IN",1.5];
        setPlayerRespawnTime 99999;

        _assignedCuratorLogic = getAssignedCuratorLogic _oldUnit;
        deleteVehicle _oldUnit;

        if (!isNull _assignedCuratorLogic) then {
            [_newUnit,_assignedCuratorLogic] remoteExecCall ["assignCurator",2,false];
        };
    }];
};

cutText ["","BLACK OUT",0.5];
[{
    setPlayerRespawnTime 2;
    forceRespawn player;
},[],1] call CBA_fnc_waitAndExecute;

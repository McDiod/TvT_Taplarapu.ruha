#include "component.hpp"

if (!hasInterface) exitWith {};

if (isNil QGVAR(playerRespawnEH)) then {
    GVAR(playerRespawnEH) = player addEventHandler ["Respawn",{
        params ["_newUnit","_oldUnit"];

        setPlayerRespawnTime 99999;

        _assignedCuratorLogic = getAssignedCuratorLogic _oldUnit;
        deleteVehicle _oldUnit;

        if (!isNull _assignedCuratorLogic) then {
            [_newUnit,_assignedCuratorLogic] remoteExecCall ["assignCurator",2,false];
        };
    }];
};

setPlayerRespawnTime 2;
forceRespawn player;

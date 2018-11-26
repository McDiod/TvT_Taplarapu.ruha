#include "component.hpp"

if (!hasInterface) exitWith {};

if (isNil QGVAR(playerRespawnEH)) then {
    GVAR(playerRespawnEH) = player addEventHandler ["Respawn",{
        params ["_newUnit","_oldUnit"];

        ["Terminate"] call BIS_fnc_EGSpectator;

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

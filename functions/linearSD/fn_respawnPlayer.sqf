#include "component.hpp"

if (!hasInterface) exitWith {};

if (isNil QGVAR(playerRespawnEH)) then {
    GVAR(playerRespawnEH) = player addEventHandler ["Respawn",{
        params ["","_corpse"];
        deleteVehicle _corpse;
        setPlayerRespawnTime 99999;
    }];
};

setPlayerRespawnTime 2;
forceRespawn player;

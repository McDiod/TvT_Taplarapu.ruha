#include "component.hpp"

params [["_activeSectorID",-1]];

GVAR(roundNumber) = (missionNamespace getVariable [QGVAR(roundNumber),0]) + 1;
publicVariable QGVAR(roundNumber);

[_activeSectorID] call FUNC(setActiveSectors);

private _activeSectors = GVAR(sectorTriggers) select _activeSectorID;

GVAR(defendingSide) = (_activeSectors select 0) getVariable [QEGVAR(sectors,currentOwner),sideUnknown];

private _attackerSectors =  GVAR(sectorTriggers) select GVAR(attackerSectorID);
missionNamespace setVariable [QGVAR(sectorsWest),[_attackerSectors,_activeSectors] select (GVAR(defendingSide) == WEST),true];
missionNamespace setVariable [QGVAR(sectorsEast),[_attackerSectors,_activeSectors] select (GVAR(defendingSide) == EAST),true];

[] call FUNC(activateFortifications);

{
    _respawnMarker = ["respawn_west","respawn_east"] select _forEachIndex;
    _sector = [selectRandom _attackerSectors,selectRandom _activeSectors] select (_x == GVAR(defendingSide));

    _respawnSearchPos = _sector getVariable [QGVAR(respawnPosition),getPos _sector];
    _respawnPos = _respawnSearchPos findEmptyPosition [0,100,"B_Soldier_F"];
    if (count _respawnPos == 0) then {_respawnPos = _respawnSearchPos};

    _respawnMarker setMarkerPos _respawnPos;
} forEach [WEST,EAST];


// don't respawn players in first round
// don't start preparation time in first round (is handled by mission setup instead)
if (GVAR(roundNumber) > 1) then {

    // wait 5s
    [{[] remoteExec [QFUNC(respawnPlayer),0,false]},[],3] call CBA_fnc_waitAndExecute;

    // wait 10s
    [{
        params ["_attackerSectors","_attackingSide"];

        _attackingSide = [WEST,EAST] select (GVAR(defendingSide) == WEST);
        _roundText = format ["Round %1",GVAR(roundNumber)];
        [_roundText,"You are attacking.","cfg\gametypes\seize_ca"] remoteExec [QFUNC(dynamicText),_attackingSide,false];
        [_roundText,"You are defending.","cfg\gametypes\defend_ca"] remoteExec [QFUNC(dynamicText),GVAR(defendingSide),false];

        [] call FUNC(playzoneCleanup);
        {[_x,_attackingSide] call FUNC(spawnSectorVehicles)} forEach _attackerSectors;

        [["PREPARATION_TIME", 0] call BIS_fnc_getParamValue,{
            missionNamespace setVariable [QGVAR(roundTimeLeft),GVAR(roundLength),true];
            missionNamespace setVariable [QGVAR(roundInProgress),true,true];
        }] call EFUNC(missionSetup,startPreparationTime);
    },[_attackerSectors,_attackingSide],10] call CBA_fnc_waitAndExecute;

} else {
    _attackingSide = [WEST,EAST] select (GVAR(defendingSide) == WEST);
    {[_x,_attackingSide] call FUNC(spawnSectorVehicles)} forEach _attackerSectors;

    {
        [{
            _respawnMarker = ["respawn_west","respawn_east"] select (side _this == EAST);
            _pos = (getMarkerPos _respawnMarker) findEmptyPosition [0,30,"B_Soldier_F"];
            if (_pos isEqualTo []) then {_pos = getMarkerPos _respawnMarker};
            [_this,_pos] remoteExec [QEFUNC(common,teleport),_this,false];
        },_x,random 3] call CBA_fnc_waitAndExecute;
    } forEach playableUnits;

    [{missionNamespace getVariable ["GRAD_MISSIONSTARTED",false]},{
        missionNamespace setVariable [QGVAR(roundTimeLeft),GVAR(roundLength),true];
        missionNamespace setVariable [QGVAR(roundInProgress),true,true];
    },[]] call CBA_fnc_waitUntilAndExecute;
};

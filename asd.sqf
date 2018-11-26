#define PREFIX GRAD
#define COMPONENT sectors
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_args","_handle"];
_args params ["_trigger","_previousSideStrengths","_previousSideStrengthsDiff"];

if (isNull _trigger) exitWith {
    [_handle] call CBA_fnc_removePerFrameHandler;
    ERROR("A sector trigger is null. Exiting PFH.");
};

_list = list _trigger;
if (isNil "_list") exitWith {};

_oldOwner = _trigger getVariable "grad_sectors_currentOwner";
_pps = _trigger getVariable "grad_sectors_pointsPerSecond";
if (_pps > 0 && {_oldOwner != sideUnknown}) then {
    _categoryName = format ["Held %1",_trigger getVariable "grad_sectors_sectorName"];
    [_oldOwner,_pps,_categoryName] call grad_points_fnc_addPoints;
};

// sector blocked by fn_blockSector
if (_trigger getVariable [QGVAR(blocked),false]) exitWith {};

_newOwner = [_trigger] call FUNC(evaluateSector);

// notification if new side is taking control
/* if (_trigger getVariable QGVAR(notifyTakingControl)) then {
    _sideStrengths = _trigger getVariable QGVAR(sideStrenghts);

    _captureSides = _trigger getVariable [QGVAR(captureSides),[]];
    {
        _thisSide = _captureSides select _forEachIndex;

        if (_thisSide != _oldOwner) then {
            _previousDiff = _previousSideStrengthsDiff select _forEachIndex;
            _thisDiff = (_sideStrengths select _forEachIndex) - _x;

            if (_thisDiff > 0 && {_previousDiff <= 0}) then {
                _sectorName = _trigger getVariable "grad_sectors_sectorName";
                if (_sectorName == "") then {_sectorName = "a sector"};

                _sideTakingControlName = [_captureSides select _forEachIndex] call EFUNC(common,getSideDisplayName);
                ["grad_notification1",["SECTOR CAPTURING",format ["%1 is taking control of %2.",_sideTakingControlName,_sectorName]]] remoteExec ["bis_fnc_showNotification",0,false];
            };

            if (_thisDiff <= 0 && {_previousDiff > 0}) then {
                _sectorName = _trigger getVariable "grad_sectors_sectorName";
                if (_sectorName == "") then {_sectorName = "a sector"};

                ["grad_notification1",["SECTOR CAPTURING",format ["%1 regained control of %2.",[_oldOwner] call EFUNC(common,getSideDisplayName),_sectorName]]] remoteExec ["bis_fnc_showNotification",0,false];
            };

            _previousSideStrengthsDiff set [_forEachIndex,_thisDiff];
        };
    } forEach _previousSideStrengths;

    _previousSideStrengths resize 0;
    _previousSideStrengths append _sideStrengths;
}; */


if (_newOwner != _oldOwner) then {
    _trigger setVariable ["grad_sectors_previousOwner",_oldOwner];
    _trigger setVariable ["grad_sectors_currentOwner",_newOwner];
    [_trigger] call grad_sectors_fnc_updateMarker;
    [_trigger] call grad_sectors_fnc_notification;

    _sectorName = _trigger getVariable "grad_sectors_sectorName";
    if (_sectorName == "") then {_sectorName = "A sector"};
    _ownerName = [_newOwner] call EFUNC(common,getSideDisplayName);

    ["grad_notification1",["SECTOR CAPTURED",format ["%1 was captured by %2.",_sectorName,_ownerName]]] remoteExec ["bis_fnc_showNotification",0,false];

    _points = _trigger getVariable "grad_sectors_pointsForCapture";
    [_newOwner,_points,_sectorName] call grad_points_fnc_addPoints;
    [_oldOwner,-_points,_sectorName] call grad_points_fnc_addPoints;

    _onSectorCaptured = _trigger getVariable [QGVAR(onSectorCaptured),{}];
    [_trigger,_newOwner,_oldOwner] call _onSectorCaptured;

    [_trigger] call grad_sectors_fnc_updateTasks;

    if (_trigger getVariable "grad_sectors_lockAfterCapture") exitWith {[_handle] call CBA_fnc_removePerFrameHandler};
};

_newOwner

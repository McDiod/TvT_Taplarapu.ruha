#include "component.hpp"

params ["_trigger"];

private _currentOwner = _trigger getVariable QGVAR(currentOwner);

private _list = list _trigger;

(_trigger getVariable [QGVAR(captureMode),0]) params ["_captureMode","_captureModeParams"];

private _captureSides = _trigger getVariable [QGVAR(captureSides),[]];
private _sideStrengths = _trigger getVariable QGVAR(sideStrenghts);

private _return = _currentOwner;

// strength capture mode
if (_captureMode == 0) then {

    // no units in sector trigger --> no change in ownership
    private _countTotal = (count _list) - (sideLogic countSide _list) - (CIVILIAN countSide _list);
    if (_countTotal == 0) exitWith {_return = _currentOwner};

    {
        _currentStrength = _sideStrengths select _forEachIndex;
        _countSide = _x countSide _list;
        _sideStrengths set [_forEachIndex,(_currentStrength + (_countSide/_countTotal - 0.5)/15) max 0 min 1];
    } forEach _captureSides;

    _ownerID = _sideStrengths findIf {_x == 1};
    _return = if (_newOwnerID < 0) then {_currentOwner} else {_captureSides select _ownerID};
};

// time capture mode
if (_captureMode == 1) then {

    // no units in sector trigger --> no change in ownership, reset strengths
    private _countTotal = (count _list) - (sideLogic countSide _list) - (CIVILIAN countSide _list);
    if (_countTotal == 0) exitWith {
        {_sideStrengths set [_forEachIndex,0]} forEach _captureSides;
        _return = _currentOwner;
    };

    _captureTime = _captureModeParams;

    _maxCount = 0;
    _sideInControlID = -1;

    {
        _sideCount = _x countSide _list;
        if (_sideCount > _maxCount) then {
            _maxCount = _sideCount;
            _sideInControlID = _forEachIndex;
        };
    } forEach _captureSides;

    if (_sideInControlID >= 0) then {
        _sideInControl = _captureSides select _sideInControlID;

        // current owner is in control --> reset side strengths
        if (_sideInControl == _currentOwner) then {
            {_sideStrengths set [_forEachIndex,0]} forEach _captureSides;
            _return = _currentOwner;


        // new side is taking control
        } else {

            _previousStrength = _sideStrengths select _sideInControlID;
            _newStrength = (_previousStrength + (1 / _captureTime)) min 1;
            _sideStrengths set [_sideInControlID,_newStrength];

            _return = [_currentOwner,_sideInControl] select (_newStrength == 1);
        };
    } else {

        // no one in control --> reset side strengths
        {_sideStrengths set [_forEachIndex,0]} forEach _captureSides;
    };
};

_return

/*  Wird zum Missionsstart auf Server und Clients ausgeführt.
*   Funktioniert wie die init.sqf.
*/


[{
    [selectRandom [2,3],300] call grad_linearSD_fnc_startLinearSD;
},[],[10,0] select didJIP] call CBA_fnc_waitAndExecute;

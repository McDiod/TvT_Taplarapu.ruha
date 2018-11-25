#include "component.hpp"

params [["_endMessage",""],["_winner",sideUnknown],["_isLastSector",false]];

systemChat _endMessage;

private _winMessage = format ["%1 wins the %2!",[_winner] call EFUNC(common,getSideDisplayName),["round","game"] select _isLastSector];
systemChat _winMessage;

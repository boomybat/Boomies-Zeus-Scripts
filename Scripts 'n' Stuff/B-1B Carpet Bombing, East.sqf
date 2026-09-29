this spawn { 
    params ["_newUnit"]; 
     
    systemChat "[BZS] B1 carpet bombing ready.";  
     
 sleep 3; 
 systemChat "[BZS] Weapons release..."; 
 playSound "addItemOk";  
    for "_i" from 1 to 28 do { 
        [_newUnit] spawn { 
            params ["_unit"]; 
            private _pos = getPosATL _unit;  
             
            for "_j" from 1 to 3 do {   
                private _object = "Bo_Mk82" createVehicle [_pos select 0, _pos select 1, _pos select 2];    
                _object setVectorDirAndUp [vectorDir _unit, vectorUp _unit]; 
    _object setPosATL [(_pos select 0) + (random (1000) - 500), (_pos select 1) + (random (250) - 125), (_pos select 2) + 1000]; 
            };  
        }; 
        sleep 0.5;  
    }; 
 
    systemChat "[BZS] Splash, out.";  
    playSound "addItemOk"; 
}; 

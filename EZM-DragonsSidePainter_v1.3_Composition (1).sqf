if(!isNull (findDisplay 312) && {!isNil "this"} && {!isNull this}) then {
    deleteVehicle this;
};

if(isNil "MAZ_EZM_Version") exitWith {
    systemChat "Enhanced Zeus Modules is not running!";
    playSound "addItemFailed";
};

if(isNil "MAZ_EZM_fnc_addNewModulesToDynamicModules") exitWith {
    ["Your version of EZM is incompatible with dynamic modules. Please use the latest version!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

if(!isNil "MAZ_EZM_DSP") exitWith {
    ["Dragons Side Painter is already loaded!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

MAZ_EZM_DSP_Ver = "1.3";
MAZ_EZM_DSP = true;

comment "==================== SETTINGS ====================";

    MAZ_EZM_DSP_palette = [
        ["Black",         ["#(argb,8,8,3)color(0.03,0.03,0.03,1)","#(argb,8,8,3)color(0.06,0.06,0.06,1)","#(argb,8,8,3)color(0.08,0.07,0.06,1)"]],
        ["Gold",          ["#(argb,8,8,3)color(0.83,0.66,0.22,1)","#(argb,8,8,3)color(0.72,0.55,0.17,1)","#(argb,8,8,3)color(0.92,0.76,0.33,1)"]],
        ["Silver",        ["#(argb,8,8,3)color(0.75,0.75,0.77,1)","#(argb,8,8,3)color(0.62,0.63,0.66,1)","#(argb,8,8,3)color(0.85,0.85,0.87,1)"]],
        ["White",         ["#(argb,8,8,3)color(0.92,0.92,0.92,1)","#(argb,8,8,3)color(0.85,0.85,0.83,1)","#(argb,8,8,3)color(0.96,0.96,0.94,1)"]],
        ["Gunmetal Grey", ["#(argb,8,8,3)color(0.22,0.23,0.25,1)","#(argb,8,8,3)color(0.28,0.29,0.31,1)","#(argb,8,8,3)color(0.18,0.19,0.20,1)"]],
        ["Red",           ["#(argb,8,8,3)color(0.60,0.05,0.05,1)","#(argb,8,8,3)color(0.75,0.08,0.06,1)","#(argb,8,8,3)color(0.50,0.03,0.04,1)"]],
        ["Orange",        ["#(argb,8,8,3)color(0.85,0.38,0.06,1)","#(argb,8,8,3)color(0.75,0.32,0.05,1)","#(argb,8,8,3)color(0.92,0.45,0.10,1)"]],
        ["Yellow",        ["#(argb,8,8,3)color(0.90,0.78,0.10,1)","#(argb,8,8,3)color(0.82,0.70,0.08,1)","#(argb,8,8,3)color(0.95,0.85,0.20,1)"]],
        ["Olive",         ["#(argb,8,8,3)color(0.27,0.30,0.18,1)","#(argb,8,8,3)color(0.22,0.25,0.15,1)","#(argb,8,8,3)color(0.32,0.34,0.22,1)"]],
        ["Forest Green",  ["#(argb,8,8,3)color(0.10,0.25,0.12,1)","#(argb,8,8,3)color(0.08,0.20,0.10,1)","#(argb,8,8,3)color(0.13,0.30,0.15,1)"]],
        ["Desert Tan",    ["#(argb,8,8,3)color(0.66,0.57,0.42,1)","#(argb,8,8,3)color(0.60,0.52,0.38,1)","#(argb,8,8,3)color(0.72,0.63,0.48,1)"]],
        ["Brown",         ["#(argb,8,8,3)color(0.33,0.22,0.13,1)","#(argb,8,8,3)color(0.28,0.18,0.10,1)","#(argb,8,8,3)color(0.38,0.26,0.16,1)"]],
        ["Navy",          ["#(argb,8,8,3)color(0.05,0.08,0.20,1)","#(argb,8,8,3)color(0.04,0.06,0.16,1)","#(argb,8,8,3)color(0.07,0.10,0.25,1)"]],
        ["Blue",          ["#(argb,8,8,3)color(0.10,0.25,0.60,1)","#(argb,8,8,3)color(0.08,0.20,0.50,1)","#(argb,8,8,3)color(0.14,0.32,0.70,1)"]],
        ["Teal",          ["#(argb,8,8,3)color(0.05,0.40,0.40,1)","#(argb,8,8,3)color(0.04,0.33,0.34,1)","#(argb,8,8,3)color(0.08,0.47,0.46,1)"]],
        ["Purple",        ["#(argb,8,8,3)color(0.30,0.08,0.40,1)","#(argb,8,8,3)color(0.25,0.06,0.33,1)","#(argb,8,8,3)color(0.36,0.12,0.48,1)"]]
    ];

    MAZ_EZM_DSP_defaultMain   = 0;
    MAZ_EZM_DSP_defaultAccent = 1;

    MAZ_EZM_DSP_skipParts = ["clan","number","insignia","decal","plate","name"];

comment "==================== HELPERS ====================";

    MAZ_EZM_DSP_fnc_toNum = {
        params ["_v"];
        if (_v isEqualType "") exitWith {parseNumber _v};
        if (_v isEqualType true) exitWith {[0,1] select _v};
        _v
    };

    MAZ_EZM_DSP_fnc_rgbToTexture = {
        params ["_rgb"];
        _rgb params [["_r",0],["_g",0],["_b",0]];
        format ["#(argb,8,8,3)color(%1,%2,%3,1)", _r, _g, _b]
    };

    MAZ_EZM_DSP_fnc_colorList = {
        params ["_choice","_customRGB",["_vary",false]];
        private _i = [_choice] call MAZ_EZM_DSP_fnc_toNum;
        if (_i >= count MAZ_EZM_DSP_palette || _i < 0) exitWith {[[_customRGB] call MAZ_EZM_DSP_fnc_rgbToTexture]};
        private _shades = (MAZ_EZM_DSP_palette select _i) select 1;
        if (_vary) then {+_shades} else {[_shades select 0]}
    };

    MAZ_EZM_DSP_fnc_isSkipPart = {
        params ["_sel"];
        _sel = toLower _sel;
        (MAZ_EZM_DSP_skipParts findIf {(_sel find _x) > -1}) > -1
    };

    MAZ_EZM_DSP_fnc_defaultMode = {
        params ["_sel"];
        [0,1] select (((toLower _sel) find "adds") > -1)
    };

    MAZ_EZM_DSP_fnc_vehicleParts = {
        params ["_vehicle"];
        getArray (configOf _vehicle >> "hiddenSelections")
    };

    MAZ_EZM_DSP_fnc_toSideArray = {
        params ["_v"];
        if (_v isEqualType west) exitWith {[_v]};
        _v
    };

comment "==================== PAINT ====================";

    MAZ_EZM_DSP_fnc_paintMan = {
        params ["_unit","_main","_accent"];
        if (uniform _unit == "") exitWith {};
        private _uniformClass = getText (configFile >> "CfgWeapons" >> uniform _unit >> "ItemInfo" >> "uniformClass");
        {
            if ([_x] call MAZ_EZM_DSP_fnc_isSkipPart) then {continue};
            _unit setObjectTextureGlobal [_forEachIndex, _main];
        } forEach getArray (configFile >> "CfgVehicles" >> _uniformClass >> "hiddenSelections");
        _unit setObjectTextureGlobal ["insignia", _accent];
    };

    MAZ_EZM_DSP_fnc_paintVehicleAuto = {
        params ["_vehicle","_main","_accent"];
        {
            if ([_x] call MAZ_EZM_DSP_fnc_isSkipPart) then {continue};
            _vehicle setObjectTextureGlobal [_forEachIndex, [_main,_accent] select (([_x] call MAZ_EZM_DSP_fnc_defaultMode) == 1)];
        } forEach ([_vehicle] call MAZ_EZM_DSP_fnc_vehicleParts);
    };

    MAZ_EZM_DSP_fnc_resetMan = {
        params ["_unit"];
        if (uniform _unit == "") exitWith {};
        private _uniformClass = getText (configFile >> "CfgWeapons" >> uniform _unit >> "ItemInfo" >> "uniformClass");
        {
            _unit setObjectTextureGlobal [_forEachIndex, _x];
        } forEach getArray (configFile >> "CfgVehicles" >> _uniformClass >> "hiddenSelectionsTextures");
        _unit setObjectTextureGlobal ["insignia", ""];
    };

    MAZ_EZM_DSP_fnc_resetVehicle = {
        params ["_vehicle"];
        {
            _vehicle setObjectTextureGlobal [_forEachIndex, _x];
        } forEach getArray (configOf _vehicle >> "hiddenSelectionsTextures");
    };

comment "==================== AUTO PAINT (runs on the Zeus's machine) ====================";

    MAZ_EZM_DSP_fnc_serverAutoPaint = {
        params ["_sides","_mode","_mains","_accents","_withVehicles"];
        private _rules = missionNamespace getVariable ["MAZ_EZM_DSP_autoRules", createHashMap];
        private _stamp = diag_tickTime;
        { _rules set [str _x, [_mode,_mains,_accents,_withVehicles,_stamp]] } forEach _sides;
        missionNamespace setVariable ["MAZ_EZM_DSP_autoRules", _rules];

        if (missionNamespace getVariable ["MAZ_EZM_DSP_autoRunning", false]) exitWith {};
        missionNamespace setVariable ["MAZ_EZM_DSP_autoRunning", true];

        private _skip = ["clan","number","insignia","decal","plate","name"];
        private _isSkip = {
            params ["_sel"];
            _sel = toLower _sel;
            (_skip findIf {(_sel find _x) > -1}) > -1
        };

        private _modeOk = {
            params ["_hasPlayer","_mode"];
            switch (_mode) do {
                case 0: {!_hasPlayer};
                case 1: {_hasPlayer};
                default {true};
            };
        };

        private _needsPaint = {
            params ["_obj","_key","_stamp"];
            !((_obj getVariable ["MAZ_EZM_DSP_sig", []]) isEqualTo [_key, getObjectTextures _obj, _stamp])
        };
        private _paintMan = {
            params ["_unit","_rule"];
            _rule params ["","_mains","_accents","","_stamp"];
            private _main   = selectRandom _mains;
            private _accent = selectRandom _accents;
            private _uniformClass = getText (configFile >> "CfgWeapons" >> uniform _unit >> "ItemInfo" >> "uniformClass");
            {
                if ([_x] call _isSkip) then {continue};
                _unit setObjectTextureGlobal [_forEachIndex, _main];
            } forEach getArray (configFile >> "CfgVehicles" >> _uniformClass >> "hiddenSelections");
            _unit setObjectTextureGlobal ["insignia", _accent];
            _unit setVariable ["MAZ_EZM_DSP_sig", [uniform _unit, getObjectTextures _unit, _stamp]];
        };
        private _paintVehicle = {
            params ["_veh","_rule"];
            _rule params ["","_mains","_accents","","_stamp"];
            private _main   = selectRandom _mains;
            private _accent = selectRandom _accents;
            {
                if ([_x] call _isSkip) then {continue};
                _veh setObjectTextureGlobal [_forEachIndex, [_main,_accent] select (((toLower _x) find "adds") > -1)];
            } forEach getArray (configOf _veh >> "hiddenSelections");
            _veh setVariable ["MAZ_EZM_DSP_sig", [typeOf _veh, getObjectTextures _veh, _stamp]];
        };

        while {true} do {
            private _rules = missionNamespace getVariable ["MAZ_EZM_DSP_autoRules", createHashMap];
            if (count _rules == 0) exitWith {
                missionNamespace setVariable ["MAZ_EZM_DSP_autoRunning", false];
            };

            {
                private _unit = _x;
                if (!alive _unit || {uniform _unit == ""}) then {continue};
                private _rule = _rules getOrDefault [str (side group _unit), []];
                if (_rule isEqualTo []) then {continue};
                if !([isPlayer _unit, _rule select 0] call _modeOk) then {continue};
                if ([_unit, uniform _unit, _rule select 4] call _needsPaint) then {
                    [_unit, _rule] call _paintMan;
                };
            } forEach allUnits;

            {
                private _veh = _x;
                if (!alive _veh || {_veh isKindOf "CAManBase"}) then {continue};
                private _crew = (crew _veh) select {alive _x};
                if (_crew isEqualTo []) then {continue};
                private _rule = _rules getOrDefault [str (side group (effectiveCommander _veh)), []];
                if (_rule isEqualTo [] || {!(_rule select 3)}) then {continue};
                if !([(_crew findIf {isPlayer _x}) > -1, _rule select 0] call _modeOk) then {continue};
                if ([_veh, typeOf _veh, _rule select 4] call _needsPaint) then {
                    [_veh, _rule] call _paintVehicle;
                };
            } forEach vehicles;

            sleep 3;
        };
    };

    MAZ_EZM_DSP_fnc_serverStopAutoPaint = {
        params ["_sides","_removePaint"];
        private _rules = missionNamespace getVariable ["MAZ_EZM_DSP_autoRules", createHashMap];
        private _keys = _sides apply {str _x};
        { _rules deleteAt _x } forEach _keys;
        missionNamespace setVariable ["MAZ_EZM_DSP_autoRules", _rules];

        if (!_removePaint) exitWith {};
        {
            private _obj = _x;
            if ((_obj getVariable ["MAZ_EZM_DSP_sig", []]) isEqualTo []) then {continue};
            if (_obj isKindOf "CAManBase") then {
                if !((str (side group _obj)) in _keys) then {continue};
                private _uniformClass = getText (configFile >> "CfgWeapons" >> uniform _obj >> "ItemInfo" >> "uniformClass");
                {
                    _obj setObjectTextureGlobal [_forEachIndex, _x];
                } forEach getArray (configFile >> "CfgVehicles" >> _uniformClass >> "hiddenSelectionsTextures");
                _obj setObjectTextureGlobal ["insignia", ""];
            } else {
                if !((str (side group (effectiveCommander _obj))) in _keys) then {continue};
                {
                    _obj setObjectTextureGlobal [_forEachIndex, _x];
                } forEach getArray (configOf _obj >> "hiddenSelectionsTextures");
            };
            _obj setVariable ["MAZ_EZM_DSP_sig", nil];
        } forEach (allUnits + vehicles);
    };

comment "==================== VEHICLE PREVIEW (local only) ====================";

    MAZ_EZM_DSP_preview = [];

    MAZ_EZM_DSP_fnc_refreshPreview = {
        if (MAZ_EZM_DSP_preview isEqualTo []) exitWith {};
        MAZ_EZM_DSP_preview params ["_vehicle","_original","_partModes","_mainChoice","_accentChoice","_mainRGB","_accentRGB"];
        if (isNull _vehicle) exitWith {};
        private _main   = ([_mainChoice, _mainRGB] call MAZ_EZM_DSP_fnc_colorList) select 0;
        private _accent = ([_accentChoice, _accentRGB] call MAZ_EZM_DSP_fnc_colorList) select 0;
        {
            private _texture = switch (_y) do {
                case 0: {_main};
                case 1: {_accent};
                default {_original param [_x, ""]};
            };
            _vehicle setObjectTexture [_x, _texture];
        } forEach _partModes;
    };

    MAZ_EZM_DSP_fnc_previewSet = {
        params ["_field","_value",["_partIndex",-1]];
        if (MAZ_EZM_DSP_preview isEqualTo []) exitWith {};
        if (_field == 2) then {
            (MAZ_EZM_DSP_preview select 2) set [_partIndex, [_value] call MAZ_EZM_DSP_fnc_toNum];
        } else {
            MAZ_EZM_DSP_preview set [_field, _value];
        };
        [] call MAZ_EZM_DSP_fnc_refreshPreview;
    };

    MAZ_EZM_DSP_fnc_endPreview = {
        params [["_restore",true]];
        if (MAZ_EZM_DSP_preview isEqualTo []) exitWith {};
        if (_restore) then {
            MAZ_EZM_DSP_preview params ["_vehicle","_original"];
            if (!isNull _vehicle) then {
                { _vehicle setObjectTexture [_forEachIndex, _x] } forEach _original;
            };
        };
        MAZ_EZM_DSP_preview = [];
    };

comment "==================== DIALOGS ====================";

    MAZ_EZM_DSP_fnc_colorRows = {
        private _data  = [];
        private _names = [];
        {
            _data pushBack (str _forEachIndex);
            _names pushBack (_x select 0);
        } forEach MAZ_EZM_DSP_palette;
        _data pushBack (str (count MAZ_EZM_DSP_palette));
        _names pushBack "Custom (use sliders below)";

        [
            ["COMBO",["Main color","Body / uniform color."],[_data,_names,MAZ_EZM_DSP_defaultMain],{true},{params ["_display","_value"]; [3,_value] call MAZ_EZM_DSP_fnc_previewSet;}],
            ["COMBO",["Accent color","Trim / shoulder patch color."],[_data,_names,MAZ_EZM_DSP_defaultAccent],{true},{params ["_display","_value"]; [4,_value] call MAZ_EZM_DSP_fnc_previewSet;}],
            ["COLOR",["Custom main","Used when Main color is set to Custom."],[[0.10,0.10,0.10]],{true},{params ["_display","_value"]; [5,_value] call MAZ_EZM_DSP_fnc_previewSet;}],
            ["COLOR",["Custom accent","Used when Accent color is set to Custom."],[[0.90,0.70,0.20]],{true},{params ["_display","_value"]; [6,_value] call MAZ_EZM_DSP_fnc_previewSet;}],
            ["TOOLBOX:YESNO",["Vary shades","Each object gets a slightly different shade of the chosen color."],[true,[]]]
        ]
    };

    MAZ_EZM_DSP_fnc_colorValues = {
        params ["_values"];
        _values params ["_mainChoice","_accentChoice","_mainRGB","_accentRGB","_vary"];
        private _doVary = ([_vary] call MAZ_EZM_DSP_fnc_toNum) == 1;
        [
            [_mainChoice, _mainRGB, _doVary] call MAZ_EZM_DSP_fnc_colorList,
            [_accentChoice, _accentRGB, _doVary] call MAZ_EZM_DSP_fnc_colorList
        ]
    };

    MAZ_EZM_DSP_fnc_vehicleDialog = {
        params ["_vehicle"];
        [true] call MAZ_EZM_DSP_fnc_endPreview;
        private _parts = [_vehicle] call MAZ_EZM_DSP_fnc_vehicleParts;
        private _original = getObjectTextures _vehicle;

        private _rows = [] call MAZ_EZM_DSP_fnc_colorRows;
        private _partIndices = [];
        private _partModes = createHashMap;
        {
            if ([_x] call MAZ_EZM_DSP_fnc_isSkipPart) then {continue};
            private _default = [_x] call MAZ_EZM_DSP_fnc_defaultMode;
            _partIndices pushBack _forEachIndex;
            _partModes set [_forEachIndex, _default];
            _rows pushBack [
                "COMBO",
                [format ["Part %1 (%2)", _forEachIndex, _x], "The vehicle previews your choice as you change it."],
                [["0","1","2"],["Main color","Accent color","Leave as is"],_default],
                {true},
                compile format ["params ['_display','_value']; [2,_value,%1] call MAZ_EZM_DSP_fnc_previewSet;", _forEachIndex]
            ];
        } forEach _parts;

        if (_partIndices isEqualTo []) exitWith {
            ["This vehicle has no paintable parts.", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
        };

        _rows pushBack ["TOOLBOX:YESNO", ["Paint crew too","Paints the uniforms of everyone inside."], [true,[]]];

        MAZ_EZM_DSP_preview = [_vehicle, _original, _partModes, MAZ_EZM_DSP_defaultMain, MAZ_EZM_DSP_defaultAccent, [0.10,0.10,0.10], [0.90,0.70,0.20]];
        [] call MAZ_EZM_DSP_fnc_refreshPreview;

        [
            format ["Dragons Side Painter: %1", getText (configOf _vehicle >> "displayName")],
            _rows,
            {
                params ["_values","_args","_display"];
                _args params ["_vehicle","_partIndices","_original"];
                ([_values select [0,5]] call MAZ_EZM_DSP_fnc_colorValues) params ["_mains","_accents"];
                private _main   = selectRandom _mains;
                private _accent = selectRandom _accents;
                [false] call MAZ_EZM_DSP_fnc_endPreview;
                {
                    private _index = _x;
                    switch ([_values select (5 + _forEachIndex)] call MAZ_EZM_DSP_fnc_toNum) do {
                        case 0: {_vehicle setObjectTextureGlobal [_index, _main]};
                        case 1: {_vehicle setObjectTextureGlobal [_index, _accent]};
                        default {_vehicle setObjectTexture [_index, _original param [_index, ""]]};
                    };
                } forEach _partIndices;

                if (([_values select ((count _values) - 1)] call MAZ_EZM_DSP_fnc_toNum) == 1) then {
                    {
                        [_x, selectRandom _mains, selectRandom _accents] call MAZ_EZM_DSP_fnc_paintMan;
                    } forEach (crew _vehicle);
                };

                ["Vehicle painted."] call MAZ_EZM_fnc_systemMessage;
                _display closeDisplay 1;
            },
            {
                params ["_values","_args","_display"];
                [true] call MAZ_EZM_DSP_fnc_endPreview;
                _display closeDisplay 2;
            },
            [_vehicle, _partIndices, _original]
        ] call MAZ_EZM_fnc_createDialog;
    };

    MAZ_EZM_DSP_fnc_unitDialog = {
        params ["_unit"];
        [true] call MAZ_EZM_DSP_fnc_endPreview;
        private _rows = [] call MAZ_EZM_DSP_fnc_colorRows;
        _rows pushBack ["TOOLBOX:YESNO", ["Whole group","Paint everyone in this soldier's group."], [true,[]]];
        _rows pushBack ["TOOLBOX:YESNO", ["Their vehicles too","Paint vehicles they're riding in (trim parts accent, rest main)."], [false,[]]];

        [
            "Dragons Side Painter: Soldiers",
            _rows,
            {
                params ["_values","_args","_display"];
                _args params ["_unit"];
                ([_values select [0,5]] call MAZ_EZM_DSP_fnc_colorValues) params ["_mains","_accents"];
                private _wholeGroup = ([_values select 5] call MAZ_EZM_DSP_fnc_toNum) == 1;
                private _vehicles   = ([_values select 6] call MAZ_EZM_DSP_fnc_toNum) == 1;

                private _units = if (_wholeGroup) then {units group _unit} else {[_unit]};
                {
                    [_x, selectRandom _mains, selectRandom _accents] call MAZ_EZM_DSP_fnc_paintMan;
                } forEach _units;

                if (_vehicles) then {
                    private _vehs = (_units apply {objectParent _x}) select {!isNull _x};
                    {
                        [_x, selectRandom _mains, selectRandom _accents] call MAZ_EZM_DSP_fnc_paintVehicleAuto;
                    } forEach (_vehs arrayIntersect _vehs);
                };

                [format ["Painted %1 soldier(s).", count _units]] call MAZ_EZM_fnc_systemMessage;
                _display closeDisplay 1;
            },
            {
                params ["_values","_args","_display"];
                _display closeDisplay 2;
            },
            [_unit]
        ] call MAZ_EZM_fnc_createDialog;
    };

    MAZ_EZM_DSP_fnc_autoPaintDialog = {
        [true] call MAZ_EZM_DSP_fnc_endPreview;
        private _rows = [
            ["SIDES", ["Sides","Every soldier on the selected side(s) is kept painted."], [west]],
            ["COMBO", ["Apply to","Who on those sides gets painted."], [["0","1","2"],["AI only","Players only","AI and players"],1]]
        ];
        _rows append ([] call MAZ_EZM_DSP_fnc_colorRows);
        _rows pushBack ["TOOLBOX:YESNO", ["Their vehicles too","Also keep vehicles they crew painted (trim parts accent, rest main)."], [false,[]]];

        [
            "Dragons Side Painter: Auto Paint",
            _rows,
            {
                params ["_values","_args","_display"];
                private _sides = [_values select 0] call MAZ_EZM_DSP_fnc_toSideArray;
                if (_sides isEqualTo []) exitWith {
                    ["Select at least one side.", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
                };
                private _mode = [_values select 1] call MAZ_EZM_DSP_fnc_toNum;
                ([_values select [2,5]] call MAZ_EZM_DSP_fnc_colorValues) params ["_mains","_accents"];
                private _withVehicles = ([_values select 7] call MAZ_EZM_DSP_fnc_toNum) == 1;

                [_sides, _mode, _mains, _accents, _withVehicles] spawn MAZ_EZM_DSP_fnc_serverAutoPaint;

                [format ["Auto Paint on for %1 (%2). Respawns and gear changes get repainted within a few seconds.",
                    (_sides apply {str _x}) joinString ", ",
                    ["AI only","players only","AI and players"] select (_mode max 0 min 2)
                ]] call MAZ_EZM_fnc_systemMessage;
                _display closeDisplay 1;
            },
            {
                params ["_values","_args","_display"];
                _display closeDisplay 2;
            }
        ] call MAZ_EZM_fnc_createDialog;
    };

    MAZ_EZM_DSP_fnc_stopAutoPaintDialog = {
        [
            "Dragons Side Painter: Stop Auto Paint",
            [
                ["SIDES", ["Sides","Stop auto painting these sides."], [west,east,independent,civilian]],
                ["TOOLBOX:YESNO", ["Remove their paint","Also restore default textures on everything auto paint touched."], [true,[]]]
            ],
            {
                params ["_values","_args","_display"];
                _values params ["_sidesValue","_remove"];
                private _sides = [_sidesValue] call MAZ_EZM_DSP_fnc_toSideArray;
                [_sides, ([_remove] call MAZ_EZM_DSP_fnc_toNum) == 1] spawn MAZ_EZM_DSP_fnc_serverStopAutoPaint;
                [format ["Auto Paint stopped for %1.", (_sides apply {str _x}) joinString ", "]] call MAZ_EZM_fnc_systemMessage;
                _display closeDisplay 1;
            },
            {
                params ["_values","_args","_display"];
                _display closeDisplay 2;
            }
        ] call MAZ_EZM_fnc_createDialog;
    };

comment "==================== MODULE FUNCTIONS ====================";

    MAZ_EZM_DSP_fnc_paintModule = {
        params [["_entity",objNull],["_position",[]]];
        if (_entity isEqualType grpNull) then {_entity = leader _entity};
        if (!(_entity isEqualType objNull) || {isNull _entity}) exitWith {
            ["Place this module on a vehicle or soldier.", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
        };
        if (_entity isKindOf "CAManBase") exitWith {[_entity] call MAZ_EZM_DSP_fnc_unitDialog};
        [_entity] call MAZ_EZM_DSP_fnc_vehicleDialog;
    };

    MAZ_EZM_DSP_fnc_removePaintModule = {
        params [["_entity",objNull],["_position",[]]];
        if (_entity isEqualType grpNull) then {_entity = leader _entity};
        if (!(_entity isEqualType objNull) || {isNull _entity}) exitWith {
            ["Place this module on a vehicle or soldier.", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
        };
        if (_entity isKindOf "CAManBase") then {
            { [_x] call MAZ_EZM_DSP_fnc_resetMan } forEach (units group _entity);
            ["Paint removed from group."] call MAZ_EZM_fnc_systemMessage;
        } else {
            [_entity] call MAZ_EZM_DSP_fnc_resetVehicle;
            { [_x] call MAZ_EZM_DSP_fnc_resetMan } forEach (crew _entity);
            ["Paint removed from vehicle and crew."] call MAZ_EZM_fnc_systemMessage;
        };
    };

    MAZ_EZM_DSP_fnc_autoPaintModule = {
        [] call MAZ_EZM_DSP_fnc_autoPaintDialog;
    };

    MAZ_EZM_DSP_fnc_stopAutoPaintModule = {
        [] call MAZ_EZM_DSP_fnc_stopAutoPaintDialog;
    };

comment "==================== ZEUS INTERFACE ====================";
MAZ_EZM_DSP_fnc_addModules = {
    with uiNamespace do {
        MAZ_DSPTree = [
            MAZ_zeusModulesTree,
            format ["Dragons Side Painter v%1", missionNamespace getVariable ["MAZ_EZM_DSP_Ver",""]],
            '\a3\ui_f_curator\Data\Displays\RscDisplayCurator\modeModules_ca.paa',
            [0.92,0.76,0.33,1],
            "Repaint vehicles and soldiers with a main and accent color."
        ] call MAZ_EZM_fnc_zeusAddCategory;

        [
            MAZ_zeusModulesTree,
            MAZ_DSPTree,
            "Paint Object",
            "Place on a vehicle to choose main/accent color for each part (with live preview),\nor on a soldier to paint them and their group.",
            "MAZ_EZM_DSP_fnc_paintModule",
            ""
        ] call MAZ_EZM_fnc_zeusAddModule;

        [
            MAZ_zeusModulesTree,
            MAZ_DSPTree,
            "Remove Paint",
            "Place on a vehicle or soldier to restore default textures (crew/group included).",
            "MAZ_EZM_DSP_fnc_removePaintModule",
            ""
        ] call MAZ_EZM_fnc_zeusAddModule;

        [
            MAZ_zeusModulesTree,
            MAZ_DSPTree,
            "Auto Paint (Side)",
            "Keep every soldier on a side painted - AI, players or both.\nRepaints after respawns and gear changes. Runs while you are connected, place anywhere.",
            "MAZ_EZM_DSP_fnc_autoPaintModule",
            ""
        ] call MAZ_EZM_fnc_zeusAddModule;

        [
            MAZ_zeusModulesTree,
            MAZ_DSPTree,
            "Stop Auto Paint",
            "Stop auto painting one or more sides, and optionally remove the paint.",
            "MAZ_EZM_DSP_fnc_stopAutoPaintModule",
            ""
        ] call MAZ_EZM_fnc_zeusAddModule;
    };
};

["MAZ_EZM_DSP_fnc_addModules"] call MAZ_EZM_fnc_addNewModulesToDynamicModules;
[format ["Dragons Side Painter v%1 loaded. Find it in the Modules tab.", MAZ_EZM_DSP_Ver]] call MAZ_EZM_fnc_systemMessage;

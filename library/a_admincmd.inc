// Command`s admin
CMD:setint(playerid, params[])
{
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(admin_info[playerid][alevel] < 1) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
    if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� /setint - [id] - [int]");
	SetPlayerInterior(params[0], params[1]);
	return 1;
}

// Command`s 1 lvl

CMD:alogin(playerid)
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(temp_info[playerid][pAdminStatus] != false) return true;
	if(admin_info[playerid][alevel] < 1) return true;
	if(strlen(admin_info[playerid][apassword]) == 0) return SPD(playerid, DLG_ALOGIN_REG, DSP, "{EDD682}AP - �����������", "{FFFFFF}��� ����� � ����� �����������������, ����������, �����������������:", "����", "������");
	else SPD(playerid, DLG_ALOGIN, DSP, "{EDD682}AP - �����������", "{FFFFFF}��� ����� � ����� �����������������, ����������, ���������������:", "����", "������");
	return 1;
}

CMD:apanel(playerid)
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(admin_info[playerid][alevel] < 1) return true;
	SPD(playerid, DLG_APANEL, DSL, "{EDD682}AP - ������ ��������������", "{FFFFFF}1. ������� ��������������", "�������", "������");					
	return 1;
}

CMD:a(playerid, params[])
{
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(admin_info[playerid][alevel] < 1) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
    if(sscanf(params, "s[144]", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� /a - [message]");
	new string[144];
	format(string, sizeof(string), "[A][%d] %s[%d]: %s", admin_info[playerid][alevel], player_info[playerid][name], playerid, params[0]);
	SAM(COLOR_ACHAT, string, 1);
	return 1;
}

CMD:world(playerid, params[])
{
	new string[32];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(admin_info[playerid][alevel] < 1) return true;	
	format(string, sizeof(string), "Your virtual world: %i", GetPlayerVirtualWorld(playerid));
	SCM(playerid, 0xFFFFFFFF, string);					
	return 1;
}

CMD:sethp(playerid, params[])
{
	new string[144];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /sethp - [id] - [health]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	SetPlayerHealth(params[0], float(params[1]));
	SetPlayerParamFloat(params[0], 0, float(params[1]));

	format(string, sizeof(string), "������������� %d ������ %s[%d] ��������� �������� HEALTH ������ %s[%d] �� %d ������",
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	SAM(COLOR_SRED, string, 1);
	return 1;
}

CMD:setarm(playerid, params[])
{
	new string[144];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /setarm - [id] - [armor]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	SetPlayerArmour(params[0], float(params[1]));
	SetPlayerParamFloat(params[0], 1, float(params[1]));

	format(string, sizeof(string), "������������� %d ������ %s[%d] ��������� �������� ARMOR ������ %s[%d] �� %d ������",
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	SAM(COLOR_SRED, string, 1);
	return 1;
}

CMD:seteat(playerid, params[])
{
	new string[144];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /seteat - [id] - [eat]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	SetPlayerParam(params[0], PLAYER_PARAM_EAT, params[1]);

	format(string, sizeof(string), "������������� %d ������ %s[%d] ��������� �������� EAT ������ %s[%d] �� %d ������",
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	SAM(COLOR_SRED, string, 1);
	
	_updateTDSatietyEat(params[0]);
	return 1;
}

CMD:setwater(playerid, params[])
{
	new string[144];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /setwater - [id] - [eat]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	SetPlayerParam(params[0], PLAYER_PARAM_THIRST, params[1]);

	format(string, sizeof(string), "������������� %d ������ %s[%d] ��������� �������� WATER ������ %s[%d] �� %d ������",
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	SAM(COLOR_SRED, string, 1);

	_updateTDSatietyWater(params[0]);
	return 1;
}

CMD:tpcoord(playerid, params[])
{
	new Float:x, Float:y, Float:z;
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "p<,>fff", x, y, z)) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /tpcoord - [X] - [Y] - [Z]");
	SetPlayerPos(playerid, x, y, z);
	return true;
}

CMD:slap(playerid, params[])
{
	new Float:xplayer, Float:yplayer, Float:zplayer;
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /slap - [id]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	GetPlayerPos(params[0], xplayer, yplayer, zplayer);
	SetPlayerPos(params[0], xplayer, yplayer, zplayer+3);
	SCM(params[0], COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}������������� ��� ��� �����.");	
	return 1;
}

CMD:for(playerid, params[])
{
	new Float:xplayer, Float:yplayer, Float:zplayer;
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /for - [id]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	GetPlayerPos(params[0], xplayer, yplayer, zplayer);
	SetPlayerPos(params[0], xplayer-3, yplayer, zplayer);
	SCM(params[0], COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}������������� �������� ���.");	
	return 1;
}

CMD:freeze(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /freeze - [id]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	if(temp_info[params[0]][pFreezeStatus] == false)
	{
		temp_info[params[0]][pFreezeStatus] = true;
		TogglePlayerControllable(params[0], 0);
		SCM(params[0], COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}������������� ��� ���������!");	
	}
	else
	{
		temp_info[params[0]][pFreezeStatus] = false;
		TogglePlayerControllable(params[0], 1);
		SCM(params[0], COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}������������� ��� ����������!");	
	}	
	return 1;
}

// Command`s 2 lvl

CMD:gethere(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(admin_info[playerid][alevel] < 2) return true;	
	new Float:xplayer, Float:yplayer, Float:zplayer;
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /gethere - [id]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	GetPlayerPos(playerid, xplayer, yplayer, zplayer);
	new world = GetPlayerVirtualWorld(playerid);
	new interior = GetPlayerInterior(playerid);
	SetPlayerPos(params[0], xplayer, yplayer, zplayer);
	SetPlayerVirtualWorld(params[0], world);
	SetPlayerInterior(params[0], interior);
	SCM(params[0], COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}������������� �������������� ��� � ����.");
	return 1;
}

CMD:goto(playerid, params[])
{
	new Float:xplayer, Float:yplayer, Float:zplayer;
	if(temp_info[playerid][pLoginStatus] != true) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(admin_info[playerid][alevel] < 2) return true;	
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /goto - [id]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	GetPlayerPos(params[0], xplayer, yplayer, zplayer);
	new world = GetPlayerVirtualWorld(params[0]);
	new interior = GetPlayerInterior(params[0]);	
	SetPlayerPos(playerid, xplayer, yplayer, zplayer);
	SetPlayerVirtualWorld(playerid, world);
	SetPlayerInterior(playerid, interior);	
	SCM(params[0], COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}� ��� ���������������� �������������.");
	return 1;
}

CMD:veh(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "ddd", params[0], params[1], params[2])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /veh - [id auto] - [color] - [color]");
	if(params[0] > 620 || params[0] < 400) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����������� ID ���������� � ���� ���������� - '400-620'!");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	new vehicleid = CreateVehicle(params[0], x, y, z, 0.0, params[1], params[2], -1);
	PutPlayerInVehicle(playerid, vehicleid, 0);
	SetVehicleEngine(vehicleid, 0);
	SetVehicleNumberPlate(vehicleid, "ADMIN");
	vehicle_info[vehicleid][v_fuel] = 50.0;
	TOTALVEH++;
	CreateCar[vehicleid] = true;
	return 1;
}

CMD:hpcar(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	new vehicleid = GetPlayerVehicleID(playerid);
	RepairVehicle(vehicleid);	
	return 1;
}

CMD:setfuel(playerid, params[])
{
	new fuel;
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "d", fuel)) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /setfuel - [fuel]");	
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
	new vehicleid = GetPlayerVehicleID(playerid);
	vehicle_info[vehicleid][v_fuel] = float(fuel);

	new string[80];
	format(string, sizeof(string), "{FFFFFF}�� �������� �������� ������� �� {EDD682}%d {FFFFFF}������", fuel);
	SCM(playerid, COLOR_WHITE, string);	
	return 1;		
}

CMD:dellveh(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(!IsPlayerInAnyVehicle(playerid)) return true;
	if(CreateCar[vehicleid] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}���� ��������� ������ �������!");
	CreateCar[vehicleid] = false;
	DestroyVehicle(vehicleid);
	TOTALVEH--;
	return 1;
}

CMD:dellvehr(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}�����������: /dellvehr - [radius]");
	if(params[0] > 2000 || params[0] < 0) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� ������ 1 �� 2000!");
	new total = 0;
	for(new i = 0; i < MAX_VEHICLES-1; i++)
	{
		if(!IsValidVehicle(i) || !IsPlayerInRangeOfVehicle(playerid, params[0], i) || CreateCar[i] == false) continue;
		DestroyVehicle(i);
		CreateCar[i] = false;
		total++;
		TOTALVEH--;
	}
	return 1;
}

CMD:setskin(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /setskin - [id] - [skin]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	if(params[1] > 311 || params[1] < 0)  return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����������� ID ����� � ���� ���������� - '0-311'!");
	new string[256];
	format(string, sizeof(string), "������������� %d ������ %s[%d] ����� ��������� ��������� ������ %s[%d]",
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0]);
	SAM(COLOR_SRED, string, 1);
	SetPlayerSkin(params[0], params[1]);
	return 1;
}

CMD:givegun(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "ddd", params[0], params[1], params[2])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /givegun - [id] - [gun] - [ammo]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	if(params[1] > 46 || params[1] < 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����������� ID ������ � ���� ���������� - '1-46'!");
	if(params[2] > 1000 || params[2] < 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����������� ���-�� ������ � ���� ���������� - '1-1000'!");
	new string[256];
	format(string, sizeof(string), "������������� %d ������ %s[%d] ����� ������ ������ %s[%d]",
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0]);
	SAM(COLOR_SRED, string, 1);
	GivePlayerWeapon(params[0], params[1], params[2]);
	return 1;
}

CMD:kick(playerid, params[])
{
	new string[144];
	new hour, minute, second, day, month, year; 
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "ds[64]", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /kick - [id] - [reason]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	gettime(hour, minute, second);
	getdate(year, month, day);
	format(string, sizeof(string), "������������� %d ������ %s[%d] ������ ������ %s[%d]. �������: %s", 
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	SCMTA(COLOR_SRED, string);
	format(string, sizeof(string), 
	"{FFFFFF}�������������: %s\n\
	���� � �����: %02d.%02d.%d %02d:%02d:%02d\n\
	�������: %s",
	player_info[playerid][name], day, month, year, hour, minute, second, params[1]);
	SPD(params[0], 0, DSM, "{EDD682}����������", string, "�������", "");
	Kick(params[0]);
	return 1;
}

CMD:skick(playerid, params[])
{
	new string[144];
	new hour, minute, second, day, month, year; 
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "ds[64]", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /kick - [id] - [reason]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	gettime(hour, minute, second);
	getdate(year, month, day);
	format(string, sizeof(string), "������������� %d ������ %s[%d] ���� ������ ������ %s[%d]. �������: %s", 
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	SAM(COLOR_SRED, string, 1);
	format(string, sizeof(string), 
	"{FFFFFF}�������������: %s\n\
	���� � �����: %02d.%02d.%d %02d:%02d:%02d\n\
	�������: %s",
	player_info[playerid][name], day, month, year, hour, minute, second, params[1]);
	SPD(params[0], 0, DSM, "{EDD682}����������", string, "�������", "");
	Kick(params[0]);
	return 1;
}

CMD:mute(playerid, params[])
{
	new string[144];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "dds[32]", params[0], params[1], params[2])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /mute - [id] - [minute] - [reason]");
	if(params[1] < 1 || params[1] > 180) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}��������� ������� ���-�� �����, ������� �� 1 �� 180.");
	//if(params[2] > 32) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}��������� ������� ���� �������.");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	if(player_info[params[0]][mutetime] > 0) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� ��� �������");
	SetPlayerParam(params[0], PLAYER_PARAM_MUTETIME, params[1] * 60);
	
	format(string, sizeof(string), "������������� %s[%d] ������������ ��� ������ %s[%d] �� %d �����. �������: %s", 
	player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1], params[2]);
	SCMTA(COLOR_SRED, string);

	format(string, sizeof(string), "{FFFFFF}��� ������������ ��� %s[%d] �� %d �����. �������: %s", 
	player_info[playerid][name], playerid, params[1], params[2]);
	SCM(params[0], COLOR_WHITE, string);

	return 1;
}

CMD:unmute(playerid, params[])
{
	new string[144];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "ds[32]", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /unmute - [id] - [reason]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	if(player_info[params[0]][mutetime] == 0) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}��� ������ �� ������������");
	SetPlayerParam(params[0], PLAYER_PARAM_MUTETIME, 0);

	format(string, sizeof(string), "������������� %s[%d] ������������� ��� ������ %s[%d]. �������: %s", 
	player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	SCMTA(COLOR_SRED, string);

	format(string, sizeof(string), "{FFFFFF}��� ������������� ��� %s[%d]. �������: %s", 
	player_info[playerid][name], playerid, params[1]);
	SCM(params[0], COLOR_WHITE, string);

	return 1;
}

// Command`s 3 lvl

CMD:ban(playerid, params[])
{
	new hour, minute, second, day, month, year, string[450], timeban[28]; 	
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 3) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(sscanf(params, "dds[128]", params[0], params[1], params[2])) return SCM(playerid, COLOR_WHITE, "{9D2D30}[������] {FFFFFF}������� /ban - [id] - [day] - [reason]");
	//if(params[0] == playerid) return true;	
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{9D2D30}[������] {FFFFFF}����� �� � ����!");
	if(params[1] < 1 || params[1] > 30) return SCM(playerid, COLOR_WHITE, "{9D2D30}[������] {FFFFFF}����������� ���-�� ���� �� 1 �� 30.");
	gettime(hour, minute, second);
	getdate(year, month, day);	
	new end = gettime() + 86400*params[1];
	format(string, sizeof(string), 
	"{FFFFFF}������������ : %s\n\
	���-�� ����: %d\n\
	���� ����������: %02d.%02d.%d %02d:%02d:%02d\n\
	�������: %s\n\
	�� ������� �������� ������� ��������������, ����� ������ �� �����!",
	player_info[playerid][name], params[1], day, month, year, hour, minute, second, params[2]);
	SPD(params[0], 0, DSM, "{9D2D30}������� ������������", string, "�������", "");
	format(string, sizeof(string), "������������� %d ������ %s[%d] ������������ ������ %s[%d] �� %d ����. �������: %s", 
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1], params[2]);
	SCMTA(COLOR_SRED, string);
	player_info[params[0]][baninfo] = 1;
	Kick(params[0]);

	format(timeban, sizeof(timeban), "%02d:%02d:%d %02d:%02d:%02d", day, month, year, hour, minute, second);

	mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `baninfo` = '%d'  WHERE `id` = '%d'", player_info[params[0]][baninfo], player_info[params[0]][id]);
	mysql_query(ConnectMysql, query);

	query[0] = EOS;
	mysql_format(ConnectMysql, query, sizeof(query), "INSERT INTO `ban_accounts`(`aname`, `name`, `whendate`, `enddate`, `dayban`, `reason`) VALUES ('%s','%s','%s','%d', '%d', '%s')", 
	player_info[playerid][name], player_info[params[0]][name], timeban, end, params[1], params[2]);
	mysql_query(ConnectMysql, query);
	return 1;
}

CMD:offban(playerid, params[])
{
	new dayb, reason[64];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 3) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(sscanf(params, "s[30]ds[64]", params[0], dayb, reason)) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� /offban - [nickname] - [day] - [reason]");
	//if(strlen(nickname) < 0 || strlen(nickname) > 30) return SCM(playerid, COLOR_WHITE, "{9D2D30}[������] {FFFFFF}����� ����� �� ������ ���� ������ 30 � ������ 0 ��������.");
	if(dayb < 1 || dayb > 30) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}���-�� ���� �� ������ ���� ������ 30 ��� ������ 1.");
	new scdplayerid = GetPlayerID(params[0]);
	if(scdplayerid != INVALID_PLAYER_ID) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������ ����� � ����, ����������� /ban!");

	query[0] = EOS;
	mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `accounts` WHERE `name` = '%s'", params[0]);
	mysql_tquery(ConnectMysql, query, "OffBanAccount", "isds", playerid, params[0], dayb, reason);				
	return 1;
}

CMD:unban(playerid, params[])
{
	new len = strlen(params[0]);
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 3) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(sscanf(params, "s[24]", params[0])) return SendClientMessage(playerid, -1, "{EDD682}[������]: {FFFFFF}������� /unban - [nickname]");
	if(len < 4 || len > MAX_PLAYER_NAME) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}��������� ��������� ���� ���!");

	query[0] = EOS;
	mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `ban_accounts` WHERE `name` = '%s'", params[0]);
	mysql_tquery(ConnectMysql, query, "UnBanAccount", "is", playerid, params[0]);
	return 1;
}

CMD:clearchat(playerid, params[])
{
	new clear, string[49+(-2+1)+(-2+MAX_PLAYER_NAME)+(-2+4)];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 3) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	for(clear++; clear<101; clear++) SCMTA(COLOR_WHITE, "");
	format(string, sizeof(string), "������������� %d ������ %s[%d] ������� ��� � ���� �������", admin_info[playerid][alevel], player_info[playerid][name], playerid);
	SAM(COLOR_SRED, string, 1);
	SCMTA(COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}������������� ������� ������� �������� ����.");
	return 1;
}

CMD:setweather(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 3) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");	
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /setweather - [weather]");
	if(params[0] < 0 || params[0] > 45) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� �������� �� 0 �� 45."); 	
	SetWeather(params[0]);

	new string[56+(-2+MAX_PLAYER_NAME)+(-2+11)];
	format(string, sizeof(string), "������������� %s[%d] ������� ������ ������� ��� ���� �������", player_info[playerid][name], playerid);
	SCMTA(COLOR_SRED, string);
	return 1;
}

// Command`s 4 lvl

CMD:set_lvl(playerid, params[])
{
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(admin_info[playerid][alevel] < 4) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}������� /setlvl - [id] - [lvl]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������] {FFFFFF}����� �� � ����!");
	SetPlayerParam(params[0], PLAYER_PARAM_EXP, 0);
	SetPlayerParam(params[0], PLAYER_PARAM_LEVEL, params[1]);
	SetPlayerScore(params[0], params[1]);
	return 1;
}

CMD:set_leader(playerid, params[])
{
	new string[38+(-2+MAX_PLAYER_NAME)];
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(admin_info[playerid][alevel] < 4) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� /set_leader - [playerid]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����� �� � ����!");
	if(temp_info[params[0]][pLoginStatus] != true) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����� �� � ����!");
	format(string, sizeof(string), "{FFFFFF}��������� ������� - {EDD682}%s", player_info[params[0]][name]);
	SPD(playerid, DLG_SETLEADER, DSL, string, 
	"{FFFFFF}- ����� ���������\n������������� �������\n������� (���)\n������� (�����)\n�����\n����������� ������ ������������\n�������� �.�����\
	\n���\n����������� ������\n����� ������",
	"�������", "�������");
	SetPVarInt(playerid, "_isLeader", params[0]);
	return 1;
}

CMD:give_lic(playerid, params[])
{
	new string[46+MAX_PLAYER_NAME+4+20];
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(admin_info[playerid][alevel] < 4) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� /give_lic - [playerid] - [lic] (help: 0-car, 1-air, 2-ship, 3-gun, 4-fish, 5-business)");
	
	switch(params[1])
	{
		case 0..5:
		{
			player_info[params[0]][lic][params[1]] = 1;
			format(string, sizeof(string), "������������� %s[%d] ����� ��� �������� �� %s!", player_info[playerid][name], playerid, _licensesName[params[1]]);
			SCM(params[0], COLOR_BLIM, string);

			format(string, sizeof(string), "�� ������ �������� �� %s ������ %s[%d]!", _licensesName[params[1]], player_info[params[0]][name], params[0]);
			SCM(playerid, COLOR_BLIM, string);
		}
		default: SCM(playerid, COLOR_BLIM, "{EDD682}[������]: {FFFFFF}������� �� �������: (help: 0-car, 1-air, 2-ship, 3-gun, 4-fish, 5-business)!");												
	}
	return 1;
}

// Command`s 5 lvl
CMD:set_admin(playerid, params[])
{
	new string[140];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 5) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� /setadmin - [playerid] - [level]");
	if(!IsPlayerConnected(params[0]) ) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����� �� � ����!");
	if(params[1] < 1 || params[1] > 4) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}�������� ������ �� ������ ���� ������ 1 � ������ 4!");
	if(params[0] == playerid) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}�� ������� ���� id!");
	admin_info[params[0]][alevel] = params[1];

	query[0] = EOS;
	mysql_format(ConnectMysql, query, sizeof(query), "INSERT INTO `admins` (`name`, `alevel`) VALUES ('%s', '%d')", 
	player_info[params[0]][name], params[1]);
	mysql_query(ConnectMysql, query);

	format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}�� ��������� {EDD682}%s {FFFFFF}��������������� {EDD682}%d {FFFFFF}������.", player_info[params[0]][name], params[1]);
	SCM(playerid, COLOR_WHITE, string);	

	format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}������������� {EDD682}%s {FFFFFF}�������� ��� ��������������� {EDD682}%d {FFFFFF}������.", player_info[playerid][name], params[1]);
	SCM(params[0], COLOR_WHITE, string);	
	return 1;
}

CMD:set_money(playerid, params[])
{
	new string[280];
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(admin_info[playerid][alevel] < 5) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� /set_money - [playerid] - [money]");
	if(!IsPlayerConnected(params[0]) ) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����� �� � ����!");
	if(params[1] > 1000000)	return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������ �������� ������ 1000000 ������!");
	_giveMoney(params[0], params[1]);

	format(string, sizeof(string), "������������� %s[%d][%d] ����� ������ %s[%d] %d ������.", player_info[playerid][name], playerid, admin_info[playerid][alevel], player_info[params[0]][name], params[0], params[1]);
	SAM(COLOR_SRED, string, 1);

	format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}������������� {EDD682}%s{EDD682}[%d] {FFFFFF}����� ��� {EDD682}%d ������.", player_info[playerid][name], playerid, params[1]);
	SCM(params[0], COLOR_WHITE, string);

	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~g~+%d PY�", params[1]);
	PlayerPlaySound(params[0], 1083, 0.0, 0.0, 0.0);
	GameTextForPlayer(params[0], string, 1000, 3);
	return 1;	
}

CMD:create(playerid)
{
	new string[148];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	if(admin_info[playerid][alevel] < 5) return true;
	format(string, sizeof(string), "{FFFFFF}1. ������� ���\t������� �����: (%d)\n{FFFFFF}2. ������� �������\t������� �����: (%d)\n\
	{FFFFFF}3. ������� ��������\t������� �����: (%d)", totalhouse, totalporch, totalapart);
	SPD(playerid, DLG_CREATE, DST, "{EDD682}���� ��������", string, "�������", "�������");
	return 1;
}

CMD:payday(playerid, params[])
{
	//if(temp_info[playerid][pLoginStatus] != true) return true;
	//if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������� '/alogin', ����� ����������������!");
	//if(admin_info[playerid][alevel] < 5) return true;	
	PayDay();
	SCM(playerid, COLOR_WHITE, "�� ������� �������� PAYDAY!");
	return 1;
}

CMD:test(playerid)
{
	cef_create_browser(playerid, 0x12346, "wh17754.web1.maze-host.ru", false, false);
	return 1;
}

// Command`s admin
CMD:setint(playerid, params[])
{
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(admin_info[playerid][alevel] < 1) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
    if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте /setint - [id] - [int]");
	SetPlayerInterior(params[0], params[1]);
	return 1;
}

// Command`s 1 lvl

CMD:alogin(playerid)
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(temp_info[playerid][pAdminStatus] != false) return true;
	if(admin_info[playerid][alevel] < 1) return true;
	if(strlen(admin_info[playerid][apassword]) == 0) return SPD(playerid, DLG_ALOGIN_REG, DSP, "{EDD682}AP - Регистрация", "{FFFFFF}Для входа в центр администрирования, пожалуйста, зарегистрируйтесь:", "Ввод", "Отмена");
	else SPD(playerid, DLG_ALOGIN, DSP, "{EDD682}AP - Авторизация", "{FFFFFF}Для входа в центр администрирования, пожалуйста, авторизируйтесь:", "Ввод", "Отмена");
	return 1;
}

CMD:apanel(playerid)
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(admin_info[playerid][alevel] < 1) return true;
	SPD(playerid, DLG_APANEL, DSL, "{EDD682}AP - Панель администратора", "{FFFFFF}1. Команды администратора", "Выбрать", "Отмена");					
	return 1;
}

CMD:a(playerid, params[])
{
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(admin_info[playerid][alevel] < 1) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
    if(sscanf(params, "s[144]", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте /a - [message]");
	new string[144];
	format(string, sizeof(string), "[A][%d] %s[%d]: %s", admin_info[playerid][alevel], player_info[playerid][name], playerid, params[0]);
	SAM(COLOR_ACHAT, string, 1);
	return 1;
}

CMD:world(playerid, params[])
{
	new string[32];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
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
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /sethp - [id] - [health]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	SetPlayerParamFloat(params[0], PLAYER_PARAM_HEALTH, float(params[1]));

	format(string, sizeof(string), "Администратор %d уровня %s[%d] установил значение HEALTH игроку %s[%d] на %d единиц",
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	SAM(COLOR_SRED, string, 1);
	return 1;
}

CMD:setarm(playerid, params[])
{
	new string[144];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /setarm - [id] - [armor]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	SetPlayerParamFloat(params[0], PLAYER_PARAM_ARMOR, float(params[1]));

	format(string, sizeof(string), "Администратор %d уровня %s[%d] установил значение ARMOR игроку %s[%d] на %d единиц",
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	SAM(COLOR_SRED, string, 1);
	return 1;
}

CMD:seteat(playerid, params[])
{
	new string[144];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /seteat - [id] - [eat]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	SetPlayerParam(params[0], PLAYER_PARAM_EAT, params[1]);

	format(string, sizeof(string), "Администратор %d уровня %s[%d] установил значение EAT игроку %s[%d] на %d единиц",
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
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /setwater - [id] - [eat]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	SetPlayerParam(params[0], PLAYER_PARAM_THIRST, params[1]);

	format(string, sizeof(string), "Администратор %d уровня %s[%d] установил значение WATER игроку %s[%d] на %d единиц",
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
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "p<,>fff", x, y, z)) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /tpcoord - [X] - [Y] - [Z]");
	SetPlayerPos(playerid, x, y, z);
	return true;
}

CMD:slap(playerid, params[])
{
	new Float:xplayer, Float:yplayer, Float:zplayer;
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /slap - [id]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	GetPlayerPos(params[0], xplayer, yplayer, zplayer);
	SetPlayerPos(params[0], xplayer, yplayer, zplayer+3);
	SCM(params[0], COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Администратор дал вам пинка.");	
	return 1;
}

CMD:for(playerid, params[])
{
	new Float:xplayer, Float:yplayer, Float:zplayer;
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /for - [id]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	GetPlayerPos(params[0], xplayer, yplayer, zplayer);
	SetPlayerPos(params[0], xplayer-3, yplayer, zplayer);
	SCM(params[0], COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Администратор подвинул вас.");	
	return 1;
}

CMD:freeze(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 1) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /freeze - [id]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	if(temp_info[params[0]][pFreezeStatus] == false)
	{
		temp_info[params[0]][pFreezeStatus] = true;
		TogglePlayerControllable(params[0], 0);
		SCM(params[0], COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Администратор вас заморозил!");	
	}
	else
	{
		temp_info[params[0]][pFreezeStatus] = false;
		TogglePlayerControllable(params[0], 1);
		SCM(params[0], COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Администратор вас разморозил!");	
	}	
	return 1;
}

// Command`s 2 lvl

CMD:gethere(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(admin_info[playerid][alevel] < 2) return true;	
	new Float:xplayer, Float:yplayer, Float:zplayer;
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /gethere - [id]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	GetPlayerPos(playerid, xplayer, yplayer, zplayer);
	new world = GetPlayerVirtualWorld(playerid);
	new interior = GetPlayerInterior(playerid);
	SetPlayerPos(params[0], xplayer, yplayer, zplayer);
	SetPlayerVirtualWorld(params[0], world);
	SetPlayerInterior(params[0], interior);
	SCM(params[0], COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Администратор телепортировал вас к себе.");
	return 1;
}

CMD:goto(playerid, params[])
{
	new Float:xplayer, Float:yplayer, Float:zplayer;
	if(temp_info[playerid][pLoginStatus] != true) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(admin_info[playerid][alevel] < 2) return true;	
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /goto - [id]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	GetPlayerPos(params[0], xplayer, yplayer, zplayer);
	new world = GetPlayerVirtualWorld(params[0]);
	new interior = GetPlayerInterior(params[0]);	
	SetPlayerPos(playerid, xplayer, yplayer, zplayer);
	SetPlayerVirtualWorld(playerid, world);
	SetPlayerInterior(playerid, interior);	
	SCM(params[0], COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}К вам телепортировался администратор.");
	return 1;
}

CMD:veh(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "ddd", params[0], params[1], params[2])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /veh - [id auto] - [color] - [color]");
	if(params[0] > 620 || params[0] < 400) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Используйте ID транспорта в этом промежутке - '400-620'!");
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

cmd:delveh(playerid, params[]){
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	new targetid;
	if(sscanf(params, "d", targetid)) return SCM(playerid, COLOR_ERROR, "[Ошибка] {FFFFFF} Используйте /delveh [id]");
	DestroyVehicle(targetid);
	new output[128];
	format(output, sizeof(output), "Администратор %s удалил транспорт ID:%d", player_info[playerid][name], targetid);
	SAM(COLOR_SRED, output, 1);
	
}

CMD:hpcar(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	new vehicleid = GetPlayerVehicleID(playerid);
	RepairVehicle(vehicleid);	
	return 1;
}

CMD:setfuel(playerid, params[])
{
	new fuel;
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "d", fuel)) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /setfuel - [fuel]");	
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
	new vehicleid = GetPlayerVehicleID(playerid);
	vehicle_info[vehicleid][v_fuel] = float(fuel);

	new string[80];
	format(string, sizeof(string), "{FFFFFF}Вы изменили значение топлива на {EDD682}%d {FFFFFF}литров", fuel);
	SCM(playerid, COLOR_WHITE, string);	
	return 1;		
}

CMD:dellveh(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(!IsPlayerInAnyVehicle(playerid)) return true;
	if(CreateCar[vehicleid] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Этот транспорт нельзя удалить!");
	CreateCar[vehicleid] = false;
	DestroyVehicle(vehicleid);
	TOTALVEH--;
	return 1;
}

CMD:dellvehr(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Используйте: /dellvehr - [radius]");
	if(params[0] > 2000 || params[0] < 0) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите радиус 1 до 2000!");
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
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /setskin - [id] - [skin]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	if(params[1] > 311 || params[1] < 0)  return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Используйте ID скина в этом промежутке - '0-311'!");
	new string[256];
	format(string, sizeof(string), "Администратор %d уровня %s[%d] выдал временную внешность игроку %s[%d]",
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0]);
	SAM(COLOR_SRED, string, 1);
	SetPlayerSkin(params[0], params[1]);
	return 1;
}

CMD:givegun(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "ddd", params[0], params[1], params[2])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /givegun - [id] - [gun] - [ammo]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	if(params[1] > 46 || params[1] < 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Используйте ID оружия в этом промежутке - '1-46'!");
	if(params[2] > 1000 || params[2] < 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Используйте кол-во патрон в этом промежутке - '1-1000'!");
	new string[256];
	format(string, sizeof(string), "Администратор %d уровня %s[%d] выдал оружие игроку %s[%d]",
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
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "ds[64]", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /kick - [id] - [reason]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	gettime(hour, minute, second);
	getdate(year, month, day);
	format(string, sizeof(string), "Администратор %d уровня %s[%d] кикнул игрока %s[%d]. Причина: %s", 
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	SCMTA(COLOR_SRED, string);
	format(string, sizeof(string), 
	"{FFFFFF}Администратор: %s\n\
	Дата и время: %02d.%02d.%d %02d:%02d:%02d\n\
	Причина: %s",
	player_info[playerid][name], day, month, year, hour, minute, second, params[1]);
	SPD(params[0], 0, DSM, "{EDD682}Информация", string, "Закрыть", "");
	Kick(params[0]);
	return 1;
}

CMD:skick(playerid, params[])
{
	new string[144];
	new hour, minute, second, day, month, year; 
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "ds[64]", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /kick - [id] - [reason]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	gettime(hour, minute, second);
	getdate(year, month, day);
	format(string, sizeof(string), "Администратор %d уровня %s[%d] тихо кикнул игрока %s[%d]. Причина: %s", 
	admin_info[playerid][alevel], player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	SAM(COLOR_SRED, string, 1);
	format(string, sizeof(string), 
	"{FFFFFF}Администратор: %s\n\
	Дата и время: %02d.%02d.%d %02d:%02d:%02d\n\
	Причина: %s",
	player_info[playerid][name], day, month, year, hour, minute, second, params[1]);
	SPD(params[0], 0, DSM, "{EDD682}Информация", string, "Закрыть", "");
	Kick(params[0]);
	return 1;
}

CMD:mute(playerid, params[])
{
	new string[144];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "dds[32]", params[0], params[1], params[2])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /mute - [id] - [minute] - [reason]");
	if(params[1] < 1 || params[1] > 180) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Корректно укажите кол-во минут, укажите от 1 до 180.");
	//if(params[2] > 32) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Корректно укажите вашу причину.");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	if(player_info[params[0]][mutetime] > 0) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок уже наказан");
	SetPlayerParam(params[0], PLAYER_PARAM_MUTETIME, params[1] * 60);
	
	format(string, sizeof(string), "Администратор %s[%d] заблокировал чат игроку %s[%d] на %d минут. Причина: %s", 
	player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1], params[2]);
	SCMTA(COLOR_SRED, string);

	format(string, sizeof(string), "{FFFFFF}Вам заблокировал чат %s[%d] на %d минут. Причина: %s", 
	player_info[playerid][name], playerid, params[1], params[2]);
	SCM(params[0], COLOR_WHITE, string);

	return 1;
}

CMD:unmute(playerid, params[])
{
	new string[144];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 2) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "ds[32]", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /unmute - [id] - [reason]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	if(player_info[params[0]][mutetime] == 0) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Чат игрока не заблокирован");
	SetPlayerParam(params[0], PLAYER_PARAM_MUTETIME, 0);

	format(string, sizeof(string), "Администратор %s[%d] разблокировал чат игроку %s[%d]. Причина: %s", 
	player_info[playerid][name], playerid, player_info[params[0]][name], params[0], params[1]);
	SCMTA(COLOR_SRED, string);

	format(string, sizeof(string), "{FFFFFF}Вам разблокировал чат %s[%d]. Причина: %s", 
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
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(sscanf(params, "dds[128]", params[0], params[1], params[2])) return SCM(playerid, COLOR_WHITE, "{9D2D30}[Ошибка] {FFFFFF}Введите /ban - [id] - [day] - [reason]");
	//if(params[0] == playerid) return true;	
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{9D2D30}[Ошибка] {FFFFFF}Игрок не в сети!");
	if(params[1] < 1 || params[1] > 30) return SCM(playerid, COLOR_WHITE, "{9D2D30}[Ошибка] {FFFFFF}Используйте кол-во дней от 1 до 30.");
	gettime(hour, minute, second);
	getdate(year, month, day);	
	new end = gettime() + 86400*params[1];
	format(string, sizeof(string), 
	"{FFFFFF}Заблокировал : %s\n\
	Кол-во дней: %d\n\
	Дата блокировки: %02d.%02d.%d %02d:%02d:%02d\n\
	Причина: %s\n\
	Вы сможете оспорить решение администратора, подав жалобу на форум!",
	player_info[playerid][name], params[1], day, month, year, hour, minute, second, params[2]);
	SPD(params[0], 0, DSM, "{9D2D30}Аккаунт заблокирован", string, "Закрыть", "");
	format(string, sizeof(string), "Администратор %d уровня %s[%d] заблокировал игрока %s[%d] на %d дней. Причина: %s", 
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
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(sscanf(params, "s[30]ds[64]", params[0], dayb, reason)) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите /offban - [nickname] - [day] - [reason]");
	//if(strlen(nickname) < 0 || strlen(nickname) > 30) return SCM(playerid, COLOR_WHITE, "{9D2D30}[Ошибка] {FFFFFF}Длина имени не должна быть больше 30 и меньше 0 символов.");
	if(dayb < 1 || dayb > 30) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Кол-во дней не должно быть больше 30 или меньше 1.");
	new scdplayerid = GetPlayerID(params[0]);
	if(scdplayerid != INVALID_PLAYER_ID) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Данный игрок в сети, используйте /ban!");

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
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(sscanf(params, "s[24]", params[0])) return SendClientMessage(playerid, -1, "{EDD682}[Ошибка]: {FFFFFF}Введите /unban - [nickname]");
	if(len < 4 || len > MAX_PLAYER_NAME) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Проверьте введенное вами имя!");

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
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	for(clear++; clear<101; clear++) SCMTA(COLOR_WHITE, "");
	format(string, sizeof(string), "Администратор %d уровня %s[%d] очистил чат у всех игроков", admin_info[playerid][alevel], player_info[playerid][name], playerid);
	SAM(COLOR_SRED, string, 1);
	SCMTA(COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Администратор произвёл очистку игрового чата.");
	return 1;
}

CMD:setweather(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 3) return true;	
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");	
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /setweather - [weather]");
	if(params[0] < 0 || params[0] > 45) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Укажите значение от 0 до 45."); 	
	SetWeather(params[0]);

	new string[56+(-2+MAX_PLAYER_NAME)+(-2+11)];
	format(string, sizeof(string), "Администратор %s[%d] изменил погоду сервера для всех игроков", player_info[playerid][name], playerid);
	SCMTA(COLOR_SRED, string);
	return 1;
}

// Command`s 4 lvl

CMD:set_lvl(playerid, params[])
{
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(admin_info[playerid][alevel] < 4) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /setlvl - [id] - [lvl]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
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
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите /set_leader - [playerid]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Игрок не в сети!");
	if(temp_info[params[0]][pLoginStatus] != true) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Игрок не в сети!");
	format(string, sizeof(string), "{FFFFFF}Назначить лидером - {EDD682}%s", player_info[params[0]][name]);
	SPD(playerid, DLG_SETLEADER, DSL, string, 
	"{FFFFFF}- Снять лидерство\nThe Government of Los Santos\nПолиция (ППС)\nПолиция (ГИБДД)\nАрмия\nФедеральная служба безопасности\nБольница г.Южный\
	\nСМИ\nБатыревская братва\nЮжная братва",
	"Выбрать", "Закрыть");
	SetPVarInt(playerid, "_isLeader", params[0]);
	return 1;
}

CMD:give_lic(playerid, params[])
{
	new string[46+MAX_PLAYER_NAME+4+20];
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(admin_info[playerid][alevel] < 4) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите /give_lic - [playerid] - [lic] (help: 0-car, 1-air, 2-ship, 3-gun, 4-fish, 5-business)");
	
	switch(params[1])
	{
		case 0..5:
		{
			player_info[params[0]][lic][params[1]] = 1;
			format(string, sizeof(string), "Администратор %s[%d] выдал вам лицензию на %s!", player_info[playerid][name], playerid, _licensesName[params[1]]);
			SCM(params[0], COLOR_BLIM, string);

			format(string, sizeof(string), "Вы выдали лицензию на %s игроку %s[%d]!", _licensesName[params[1]], player_info[params[0]][name], params[0]);
			SCM(playerid, COLOR_BLIM, string);
		}
		default: SCM(playerid, COLOR_BLIM, "{EDD682}[Ошибка]: {FFFFFF}Вводите по шаблону: (help: 0-car, 1-air, 2-ship, 3-gun, 4-fish, 5-business)!");												
	}
	return 1;
}

// Command`s 5 lvl
CMD:set_admin(playerid, params[])
{
	new string[140];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(admin_info[playerid][alevel] < 5) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите /setadmin - [playerid] - [level]");
	if(!IsPlayerConnected(params[0]) ) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Игрок не в сети!");
	if(params[1] < 1 || params[1] > 4) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Значение уровня не должно быть меньше 1 и больше 4!");
	if(params[0] == playerid) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Вы указали свой id!");
	admin_info[params[0]][alevel] = params[1];

	query[0] = EOS;
	mysql_format(ConnectMysql, query, sizeof(query), "INSERT INTO `admins` (`name`, `alevel`) VALUES ('%s', '%d')", 
	player_info[params[0]][name], params[1]);
	mysql_query(ConnectMysql, query);

	format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Вы назначили {EDD682}%s {FFFFFF}администратором {EDD682}%d {FFFFFF}уровня.", player_info[params[0]][name], params[1]);
	SCM(playerid, COLOR_WHITE, string);	

	format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Администратор {EDD682}%s {FFFFFF}назначил вас администратором {EDD682}%d {FFFFFF}уровня.", player_info[playerid][name], params[1]);
	SCM(params[0], COLOR_WHITE, string);	
	return 1;
}

CMD:set_money(playerid, params[])
{
	new string[280];
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(admin_info[playerid][alevel] < 5) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите /set_money - [playerid] - [money]");
	if(!IsPlayerConnected(params[0]) ) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Игрок не в сети!");
	if(params[1] > 1000000)	return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Нельзя выдавать больше 1000000 рублей!");
	_giveMoney(params[0], params[1]);

	format(string, sizeof(string), "Администратор %s[%d][%d] выдал игроку %s[%d] %d рублей.", player_info[playerid][name], playerid, admin_info[playerid][alevel], player_info[params[0]][name], params[0], params[1]);
	SAM(COLOR_SRED, string, 1);

	format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Администратор {EDD682}%s{EDD682}[%d] {FFFFFF}выдал вам {EDD682}%d рублей.", player_info[playerid][name], playerid, params[1]);
	SCM(params[0], COLOR_WHITE, string);

	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~g~+%d PYЂ", params[1]);
	PlayerPlaySound(params[0], 1083, 0.0, 0.0, 0.0);
	GameTextForPlayer(params[0], string, 1000, 3);
	return 1;	
}

CMD:create(playerid)
{
	new string[148];
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	if(admin_info[playerid][alevel] < 5) return true;
	format(string, sizeof(string), "{FFFFFF}1. Создать дом\tСоздано всего: (%d)\n{FFFFFF}2. Создать подъезд\tСоздано всего: (%d)\n\
	{FFFFFF}3. Создать квартиру\tСоздано всего: (%d)", totalhouse, totalporch, totalapart);
	SPD(playerid, DLG_CREATE, DST, "{EDD682}Меню создания", string, "Выбрать", "Закрыть");
	return 1;
}

CMD:payday(playerid, params[])
{
	//if(temp_info[playerid][pLoginStatus] != true) return true;
	//if(temp_info[playerid][pAdminStatus] == false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте '/alogin', чтобы авторизироваться!");
	//if(admin_info[playerid][alevel] < 5) return true;	
	PayDay();
	SCM(playerid, COLOR_WHITE, "Вы вызвали тестовый PAYDAY!");
	return 1;
}

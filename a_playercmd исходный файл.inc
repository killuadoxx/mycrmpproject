// Command`s player
CMD:need(playerid)
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	new string[500];
	format(string, sizeof(string), "{EDD682}Потребность:\t\t\t\tЗначение:\n\
	1. Голод\t\t\t\t%d из 100\n\
	2. Жажда\t\t\t\t%d из 100", player_info[playerid][eat], player_info[playerid][thirst]);
	SPD(playerid, DLG_NEED, DSL, "{EDD682}Потребности персонажа", string, "Назад", "");
	return 1;
}

CMD:time(playerid)
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 0, 0, 0, 0, 0);
	new hour,
		minute,
		year,
		month,
		day,
		text[11],
		string[144];

	format(string, sizeof(string), "%s вглянул(а) на часы", player_info[playerid][name]);
	SetPlayerChatBubble(playerid, string, COLOR_BUDDLE, 10.0, 5000);

	getdate(year, month, day);
	gettime(hour, minute);

	switch(month)
	{
		case 1: text = "January";
		case 2: text = "February";
		case 3: text = "March";
		case 4: text = "April";
		case 5: text = "May";
		case 6: text = "June";
		case 7: text = "July";
		case 8: text = "August";
		case 9: text = "September";
		case 10: text = "October";
		case 11: text = "November";
		case 12: text = "December";
	}

	format(string, sizeof(string), "~w~%02d  ~y~%s ~w~%d~n~~w~%02d:%02d", day, text, year, hour, minute);
	GameTextForPlayer(playerid, string, 5000, 1);
	return 1;
}

CMD:menu(playerid)
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	SPD(playerid, DLG_MENU, DSL, "{EDD682}Меню персонажа", 
	"{EDD682}[1]{FFFFFF} - Статистика персонажа\n\
	{EDD682}[2]{FFFFFF} - Команды сервера\n\
	{EDD682}[3]{FFFFFF} - Настройки интерфейса\n\
	{EDD682}[4]{FFFFFF} - Настройки безопасности\n\
	{EDD682}[5]{FFFFFF} - Связь с администрацией\n\
	{EDD682}[6]{FFFFFF} - Потребности персонажа\n\
	{EDD682}[7]{FFFFFF} - Квестовые задания\n\
	{EDD682}[8]{FFFFFF} - Правила проекта\n\
	{EDD682}[9]{FFFFFF} - Донат услуги", 
	"Выбрать", "Закрыть");
	return 1;
}

CMD:me(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(sscanf(params, "s[168]", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Подсказка] {FFFFFF}Используйте: /me [текст]");
	new string[144];
	format(string, 144, "%s %s", player_info[playerid][name], params[0]);
	ProxDetector(20.0, playerid, string, 0xDE92FFFF, 0xDE92FFFF, 0xDE92FFFF, 0xDE92FFFF, 0xDE92FFFF);
	SetPlayerChatBubble(playerid, params[0], 0xDE92FFFF, 20, 7500);
	return 1;
}

CMD:do(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(sscanf(params, "s[168]", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Подсказка] {FFFFFF}Используйте: /do [текст]");
	new string[144];
	format(string, sizeof(string), "%s (%s)",params[0], player_info[playerid][name]);
	ProxDetector(20.0, playerid, string, 0xDE92FFFF, 0xDE92FFFF, 0xDE92FFFF, 0xDE92FFFF, 0xDE92FFFF);
	SetPlayerChatBubble(playerid, params[0], 0xDE92FFFF, 20, 7500);
	return 1;
}

CMD:try(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(sscanf(params, "s[168]", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Подсказка] {FFFFFF}Используйте: /try [текст]");
	new temptryrand = random(2);
	new string[144];
	if(temptryrand == 1) format(string, sizeof(string), "%s %s | {32CD32}Удачно", player_info[playerid][name], params[0]);
	else format(string, sizeof(string), "%s %s | {FF0000}Неудачно", player_info[playerid][name], params[0]);
	ProxDetector(20.0, playerid, string, 0xDE92FFFF, 0xDE92FFFF, 0xDE92FFFF, 0xDE92FFFF, 0xDE92FFFF);
	return 1;
}

CMD:todo(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	new text[168], make[168], string[144];
	if(sscanf(params, "p<*>s[168]s[168]", text, make)) return SCM(playerid, COLOR_WHITE, "{EDD682}[Подсказка] {FFFFFF}Используйте: /todo [текст*действие]");
	format(string, sizeof(string), "%s говорит: %s - {C2A2DA}%s", player_info[playerid][name], text, make);
	ProxDetector(20.0, playerid, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE);
	return true;
}

CMD:n(playerid, params[])
{
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(sscanf(params, "s[107]", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Подсказка] {FFFFFF}Используйте: /n [сообщение]");
    new string[144];
    format(string, sizeof(string), "(( %s[%d]: %s ))", player_info[playerid][name], playerid, params[0]);
    ProxDetector(20.0, playerid, string, 0xCCCC99FF, 0xCCCC99FF, 0xCCCC99FF, 0xCCCC99FF, 0xCCCC99FF);
    return 1;
}

CMD:s(playerid, params[])
{
    if(temp_info[playerid][pLoginStatus] != true) return true;
    if(sscanf(params, "s[105]", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Подсказка] {FFFFFF}Используйте: /s [сообщение]");
    new string[144];
    format(string, sizeof(string), "%s[%d] кричит: %s", player_info[playerid][name], playerid, params[0]);
    ProxDetector(30.0, playerid, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE);
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.1, 0, 0, 0, 0, 0);
	SetPlayerChatBubble(playerid, params[0], COLOR_WHITE, 25, 7500);
    return 1;
}

CMD:pay(playerid, params[])
{
	new string[144];
	new Float:x, Float:y, Float:z;
    if(temp_info[playerid][pLoginStatus] != true) return true;
	if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Введите /pay - [id] - [money]");
	if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
	if(params[0] == playerid) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Нельзя передавать деньги самому себе!");
	if(temp_info[params[0]][pLoginStatus] != true) return true;
	if(params[1] > 50000) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Чтобы передать сумму больше, воспользуйтесь банком!");
	if(params[1] < 1 && params[1] > 50000) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Вы можете передавать от 1 рубля и до 50.000 тысяч!");
	GetPlayerPos(params[0], x, y, z);
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z)) return SendClientMessage(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок находится слишком далеко!");
	if(params[1] > player_info[playerid][money]) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}У вас нет столько денег!");

	_giveMoney(playerid, -params[1]);
	_giveMoney(params[0], params[1]);

	format(string, sizeof(string), "{FFFFFF}Игрок %s[%d] передал вам {EDD682}%d {FFFFFF}рублей", player_info[playerid][name], playerid, params[1]);
	SCM(params[0], COLOR_WHITE, string);

	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~g~+%d PYЂ", params[1]);
	PlayerPlaySound(params[0], 1083, 0.0, 0.0, 0.0);
	GameTextForPlayer(params[0], string, 1000, 3);	

	format(string, sizeof(string), "{FFFFFF}Вы передали игроку %s[%d] {EDD682}%d {FFFFFF}рублей", player_info[params[0]][name], params[0], params[1]);
	SCM(playerid, COLOR_WHITE, string);	

	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~r~-%d PYЂ", params[1]);
	PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
	GameTextForPlayer(playerid, string, 1000, 3);
	return 1;
}

CMD:pass(playerid, params[])
{
	
	return 1;
}

CMD:vb(playerid, params[])
{
	
	return 1;
}

CMD:med(playerid, params[])
{
	
	return 1;
}

CMD:lic(playerid, params[])
{
	
	return 1;
}


// Car command`s
CMD:engine(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	GetVehicleHealth(vehicleid, vehicle_info[vehicleid][v_health]);
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
	if(StartEngine[playerid] != false) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Подождите, двигатель заводится!");
	if(!IsABMX(vehicleid))	
	{
		if(vehicle_info[vehicleid][v_engine] == true)
		{
			callcmd::me(playerid, !"заглушил двигатель");
			SetVehicleEngine(vehicleid, 0);
		}
		else
		{
			if(vehicle_info[vehicleid][v_health] <= 350) return SCM(playerid, COLOR_WHITE, !"{EDD682}[Ошибка] {FFFFFF}Ваш транспорт повреждён, вызовите механика, либо попробуйте решить проблему самостоятельно!");
			if(vehicle_info[vehicleid][v_fuel] <= 0.1) return SCM(playerid, COLOR_WHITE, !"{EDD682}[Ошибка] {FFFFFF}В транспорте закончилось топливо!");
			StartEngine[playerid] = true;
			callcmd::me(playerid, "пытается завести машину");
			SetTimerEx("VehicleEngineTimer", (random(2) + 1) * 1000, false, "dd", playerid, vehicleid);
		}
	}
	else SetVehicleEngine(vehicleid, 1);	
	return 1;
}

CMD:fixcar(playerid)
{
    if(player_info[playerid][p_model] <= 0) return SendClientMessage(playerid, COLOR_WHITE, !"Вы не владеете машиной");
	if(player_info[playerid][money] < 300) return SendClientMessage(playerid, COLOR_WHITE, !"Недостаточно денег. Требуется 350$");
	DestroyVehicle(pCarID[playerid]);
	pCarID[playerid] = CreateVehicle(player_info[playerid][p_model], player_info[playerid][p_posx], player_info[playerid][p_posy], player_info[playerid][p_posz], player_info[playerid][p_posfa], player_info[playerid][p_color1], player_info[playerid][p_color2], -1);
	//VehSpwn(p_info[playerid][veh_id]);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	_giveMoney(playerid, -350);
	return SendClientMessage(playerid, COLOR_WHITE, !"Ваш транспорт доставлен к дому");
}

CMD:light(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
	new vehicleid = GetPlayerVehicleID(playerid);
	SetVehicleLight(vehicleid, (vehicle_info[vehicleid][v_lights] == true) ? 0 : 1);
	return 1;	
}

CMD:lock(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
	new vehicleid = GetPlayerVehicleID(playerid);
	SetVehicleDoors(vehicleid, (vehicle_info[vehicleid][v_lock] == true) ? 0 : 1);
	return 1;	
}



// Commands`s Home
CMD:hmenu(playerid, params[])
{
	new i = player_info[playerid][keyh];
	if(i == -1) return 1;
	if(strcmp(player_info[playerid][name], house_info[i][h_owner], true) == 0)
	{
		if(IsPlayerInRangeOfPoint(playerid,5.0,house_info[i][h_exit][0], house_info[i][h_exit][1], house_info[i][h_exit][2]) && GetPlayerVirtualWorld(playerid) == i+50)
		{		
			SPD(playerid, DLG_HOMEMENU, DSL, "{EDD682}Управление домом", 
			"{EDD682}[1]{FFFFFF} - Информация о доме\n\
			{EDD682}[2]{FFFFFF} - Продать дом государству\n\
			{EDD682}[3]{FFFFFF} - Продать дом игроку", "Далее", "Закрыть");
		}
		else SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Необходимо находиться в своём доме!");	
	}						
	return 1;
}

CMD:hlock(playerid, params[])
{
	new i = player_info[playerid][keyh];
	if(i == -1) return 1;
	if(strcmp(player_info[playerid][name], house_info[i][h_owner], true) == 0)
	{
		if(IsPlayerInRangeOfPoint(playerid,5.0,house_info[i][h_exit][0], house_info[i][h_exit][1], house_info[i][h_exit][2]) || IsPlayerInRangeOfPoint(playerid,2.0,house_info[i][h_enter][0], house_info[i][h_enter][1], house_info[i][h_enter][2]))
		{		
			switch(house_info[i][h_lock])
			{
				case 0:
				{
					house_info[i][h_lock] = 1;
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Вы успешно закрыли двери своего дома!");

					query[0] = EOS;
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_lock` = '1' WHERE `hid` = '%d'", i);
					mysql_query(ConnectMysql, query);					
				}
				case 1:
				{
					house_info[i][h_lock] = 0;
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Вы успешно открыли двери своего дома!");

					query[0] = EOS;
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_lock` = '0' WHERE `hid` = '%d'", i);
					mysql_query(ConnectMysql, query);											
				}
			}
		}
		else SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Необходимо находиться в доме, либо рядом с ним!");	
	}						
	return 1;
}



// Command`s Apart
CMD:amenu(playerid, params[])
{
	new i = player_info[playerid][keya];
	if(i == -1) return 1;
	if(strcmp(player_info[playerid][name], apart_info[i][a_owner], true) == 0)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, apart_info[i][a_exit][0], apart_info[i][a_exit][1], apart_info[i][a_exit][2]) && GetPlayerVirtualWorld(playerid) == i+50)
		{		
			SPD(playerid, DLG_APARTMENU, DSL, "{EDD682}Управление квартирой", 
			"{EDD682}[1]{FFFFFF} - Информация о квартире\n\
			{EDD682}[2]{FFFFFF} - Продать квартиру государству\n\
			{EDD682}[3]{FFFFFF} - Продать квартиру игроку", "Далее", "Закрыть");
		}
		else SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Необходимо находиться в своей квартире!");	
	}						
	return 1;
}

CMD:alock(playerid, params[])
{
	new i = player_info[playerid][keya];
	if(i == -1) return 1;
	if(strcmp(player_info[playerid][name], apart_info[i][a_owner], true) == 0)
	{
		if(IsPlayerInRangeOfPoint(playerid,5.0,apart_info[i][a_exit][0], apart_info[i][a_exit][1], apart_info[i][a_exit][2]) || IsPlayerInRangeOfPoint(playerid,2.0,apart_info[i][a_enter][0], apart_info[i][a_enter][1], apart_info[i][a_enter][2]))
		{		
			switch(apart_info[i][a_lock])
			{
				case 0:
				{
					apart_info[i][a_lock] = 1;
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Вы успешно закрыли двери своей квартиры!");

					query[0] = EOS;
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_lock` = '1' WHERE `aid` = '%d'", i);
					mysql_query(ConnectMysql, query);					
				}
				case 1:
				{
					apart_info[i][a_lock] = 0;
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Вы успешно открыли двери своей квартиры!");

					query[0] = EOS;
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_lock` = '0' WHERE `aid` = '%d'", i);
					mysql_query(ConnectMysql, query);											
				}
			}
		}
		else SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Необходимо находиться в квартире, либо рядом с ней!");	
	}						
	return 1;
}

// Commands`s Fraction

CMD:r(playerid, params[])
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(!_gosFrac(playerid)) return true;
	if(sscanf(params, "s[144]", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Используйте: /r - [текст]");
	if(strlen(params[0]) > 144) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Слишком длинное предложение.");
	new string[144];
	format(string, sizeof(string), "{607f61}[R]: %s - %s[%d]: {FFFFFF}%s", 
	FractionName[player_info[playerid][member]][player_info[playerid][rang]], player_info[playerid][name], playerid, params[0]);
	SFM(player_info[playerid][member], COLOR_WHITE, string);
	SetPlayerChatBubble(playerid,"сообщает в рацию", 0xDE92FFFF, 30.0, 10000);
	return 1;
}

CMD:changeskin(playerid, params[])
{	
	new Float:x, Float:y, Float:z;
	new p_rang = FactionMaxRanks[player_info[playerid][member]] - 1;
	GetPlayerPos(playerid, x, y, z);
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(player_info[playerid][leader] > 0 || player_info[playerid][rang] == p_rang)
	{
		if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите /changeskin - [id]");
		if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
		if(player_info[params[0]][member] != player_info[playerid][member]) return true;
		if(!IsPlayerInRangeOfPoint(params[0], 5.0, x, y, z)) return SendClientMessage(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок находится слишком далеко!");

		SetPVarInt(playerid, "actplayerid", params[0]);
		new fractionid = player_info[playerid][member];
		new mes[128];
		for(new i; i < 10; i++)
		{
			new skinid = FractionSkin[fractionid][i];
			if(!skinid) break;
			if(!i) format(mes, sizeof(mes), "Внешность %d [%d]", i+1, skinid);
			else format(mes, sizeof(mes), "%s\nВнешность %d [%d]", mes, i+1, skinid);
		}
		ShowPlayerDialog(playerid, DLG_CHANGESKIN, DSL, "{EDD682}Выбор внешности", mes, "Принять", "");	
	}
	return 1;
}

CMD:invite(playerid, params[])
{
	new string[120];
	new p_rang = FactionMaxRanks[player_info[playerid][member]] - 1;
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(player_info[playerid][leader] > 0 || player_info[playerid][rang] == p_rang)
	{
		if(sscanf(params, "d", params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите /invite - [id]");
		if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
		if(params[0] == playerid) return true;
		if(!IsPlayerInRangeOfPoint(params[0], 5.0, x, y, z)) return SendClientMessage(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок находится слишком далеко!");
		if(player_info[params[0]][lvl] < 2) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Выбранный игрок, ниже 2-го уровня!");	
		if(player_info[params[0]][member] != 0) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Игрок уже состоит в организации!");
		if(GetPVarInt(params[0], "_inviteGo") == 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Дождитесь решения игрока!");
		format(string, sizeof(string), "{FFFFFF}Руководитель организации {EDD682}%s[%d] {FFFFFF}приглашает Вас вступить в {EDD682}%s", player_info[playerid][name], playerid, _fracName(playerid));
		SPD(params[0], DLG_INVITE, DSM, "{EDD682}Приглашение", string, "Принять", "Отказаться");

		SetPVarInt(params[0], "_invitePlayer", playerid);
		SetPVarInt(params[0], "_inviteGo", 1);
	}
	return 1;
}

CMD:uninvite(playerid, params[])
{
	new string[170];
	new p_rang = FactionMaxRanks[player_info[playerid][member]] - 1;
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(player_info[playerid][leader] > 0 || player_info[playerid][rang] == p_rang)
	{
		if(sscanf(params, "ds[32]", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите /uninvite - [id] - [reason]");
		if(player_info[params[0]][rang] > player_info[playerid][rang]) return true;
		if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
		if(player_info[params[0]][member] != player_info[playerid][member]) return true;

		player_info[params[0]][rang] = 0;
		player_info[params[0]][member] = 0;
		player_info[params[0]][fskin] = 0;
		SetPlayerSkin(params[0], player_info[params[0]][skin]);

		format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Игрок {EDD682}%s[%d] {FFFFFF}уволил вас из организации. Причина: {EDD682}%s", player_info[playerid][name], playerid, params[1]);
		SCM(params[0], COLOR_WHITE, string);

		format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Игрок {EDD682}%s[%d] {FFFFFF}уволил {EDD682}%s[%d] {FFFFFF}из организации. Причина {EDD682}%s", player_info[playerid][name], playerid, 
		player_info[params[0]][name], params[0], params[1]);
		SFM(player_info[playerid][member], COLOR_WHITE, string);
	}
	return 1;
}

CMD:giverang(playerid, params[])
{
	new string[340];
	new p_rang = FactionMaxRanks[player_info[playerid][member]] - 1;
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(player_info[playerid][leader] > 0 || player_info[playerid][rang] == p_rang)
	{
		if(sscanf(params, "dd", params[0], params[1])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите /giverang - [id] - [rang]");
		if(player_info[params[0]][rang] > player_info[playerid][rang]) return true;
		if(!IsPlayerConnected(params[0])) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка] {FFFFFF}Игрок не в сети!");
		if(player_info[params[0]][member] != player_info[playerid][member]) return true;
		if(IsSpecificConditionMet(playerid, params[1])) return true;
		if(params[1] <= 0 || params[1] >= FactionMaxRanks[player_info[params[0]][member]]) return true;

		player_info[params[0]][rang] = params[1];
		format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Игрок {EDD682}%s[%d] {FFFFFF}повысил вас в должности до {EDD682}%s{FFFFFF}!", player_info[playerid][name], playerid, 
		FractionName[player_info[params[0]][member]][player_info[params[0]][rang]]);
		SCM(params[0], COLOR_WHITE, string);
		
		format(string, sizeof(string), "Игрок %s[%d] изменил должность %s[%d] на %s[%d]!", player_info[playerid][name], playerid, 
		player_info[params[0]][name], params[0], FractionName[player_info[params[0]][member]][player_info[params[0]][rang]], player_info[params[0]][rang]);
		SFM(player_info[playerid][member], COLOR_WHITE, string);		
	}
	return 1;
}

CMD:lpanel(playerid)
{
	new p_rang = FactionMaxRanks[player_info[playerid][member]] - 1;
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(player_info[playerid][leader] > 0 || player_info[playerid][rang] == p_rang)
	{
		SPD(playerid, DLG_LPANEL, DSL, "{EDD682}Управление организацией",
		"{EDD682}--{FFFFFF} Список сотрудников\n\
		{EDD682}[1]{FFFFFF} Информация об организации", "Далее", "Закрыть");		
	}
	return true;
}

CMD:members(playerid)
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(player_info[playerid][member] == 0) return true;
	
	query[0] = EOS;
	mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `accounts` WHERE `member` = '%d'", player_info[playerid][member]);
	mysql_tquery(ConnectMysql, query, "OnlineMembersFraction", "d", playerid);	
	return 1;
}
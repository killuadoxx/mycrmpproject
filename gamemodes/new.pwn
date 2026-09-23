// prod. by @shkipA [pawn.wiki]
#include <a_samp>
#include <sscanf2>
#include <a_mysql>
#include <Foreach>
#include <streamer>
#include <crashdetect>
#include <fix>
#include <Pawn.CMD>
#include <Pawn.Regex>
#include <TOTP>
#include <dc_spp>
#include <time_t>
#include <Pawn_RakNet>
#include <cef>
#include <fixobject>

#include "../library/a_define.inc"			// --------- [Подгружаемые макросы]       
#include "../library/a_array.inc"			// --------- [Глобальные переменные]
#include "../library/a_publics.inc"			// --------- [Загрузка пабликов]
#include "../library/a_stocks.inc"			// --------- [Загрузка стоков]
#include "../library/a_admincmd.inc"		// --------- [Команды администратора]
#include "../library/a_playercmd.inc"		// --------- [Команды игрока]


main()	{	print("** Successful launch of the Russian Role Play server! **\n");	
			print("** >>> Загрузка содержимого:\n");
		}


public OnGameModeInit()
{
	#include "../library/objects/a_allobject.inc"		// --------- [Загрузка добавочных объектов]
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
		VehicleDriverID[i] = -1;
		vehicle_info[i][v_fuel] = 50.0;
	}
    _connectMySQL();
	SendRconCommand("hostname "#SERVER_NAME);
	SendRconCommand("language "#SERVER_LANGUAGE);
	SendRconCommand("weburl "#SERVER_WEBURL);
	SendRconCommand("mapname "#SERVER_MAPNAME);
	SetGameModeText(""SERVER_GAMEMODE"");
	SetTimeForServer();
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	SetNameTagDrawDistance(25.0);
	ManualVehicleEngineAndLights();

	//Таймеры
	SetTimer("MinuteUpdate", 60000, true);
	SetTimer("OneSecondUpdate", 1000, true);

	//Load Server`s
	mysql_tquery(ConnectMysql, "SELECT * FROM `house`", "LoadHouse", "");
	mysql_tquery(ConnectMysql, "SELECT * FROM `porch`", "LoadPorch", "");
	mysql_tquery(ConnectMysql, "SELECT * FROM `apartament`", "LoadApart", "");
	//mysql_tquery(ConnectMysql, "SELECT * FROM `player_vehicle`", "LoadPlayerCars", "");	

	// Stock`s
	_loadPickup();
	_loadCars();
	_load3Dtext();
	_loadActor();
	return 1;
}

public OnGameModeExit()
{
	mysql_close(ConnectMysql);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(temp_info[playerid][pLoginStatus] == true)
	{
		SetSpawnInfo(playerid, 255, player_info[playerid][skin], 0, 0, 0, 1.0, -1, -1, -1, -1, -1, -1);
		return SpawnPlayer(playerid);
	}
	return 0;
}

public OnPlayerConnect(playerid)
{
	GetPlayerName(playerid, player_info[playerid][name], MAX_PLAYER_NAME);
	mysql_format(ConnectMysql, query, sizeof(query), "SELECT `password`, `salt`, `baninfo`, `member`, `keyh`, `keya`,\n\
	`exitx`, `exity`, `exitz`, `exitfa`, `p_world`, `p_interior` FROM `accounts` WHERE `name` = '%s'", player_info[playerid][name]);
	mysql_tquery(ConnectMysql, query, "CheckAccount", "i", playerid);

	SetPVarInt(playerid, "ErrorPassword", 3);
	_playerTextDraw(playerid);
	_globalTextDraws();

	SetPlayerColor(playerid, COLOR_CLEAR);

	temp_info[playerid][pLoginStatus] = false;
	temp_info[playerid][pAdminStatus] = false;
	temp_info[playerid][AFK] = 0;
	LoadAdminData(playerid);


	static animlibs[131][] = // Прогружаем заранее для игрока все анимации, для пресечения дальнейших багов с анимациями
	{
	"AIRPORT", "Attractors", "BAR", "BASEBALL", "BD_FIRE", "BEACH", "benchpress", "BF_injection", "BIKED", "BIKEH", "BIKELEAP",
	"BIKES", "BIKES", "BIKEV", "BIKE_DBZ", "BLOWJOBZ", "BMX", "BOMBER", "BOX", "BSKTBALL", "BUDDY", "BUS", "CAMERA", "CAR", "CARRY",
	"CAR_CHAT", "CASINO", "CHAINSAW", "CHOPPA", "CLOTHES", "COACH", "COLT45", "COP_AMBIENT", "COP_DVBYZ", "CRACK", "CRIB", "DAM_JUMP",
	"DANCING", "DEALER", "DILDO", "DODGE", "DOZER", "DRIVEBYS", "FAT", "FIGHT_B", "FIGHT_C", "FIGHT_D", "FIGHT_E", "FINALE", "FINALE2",
	"FLAME", "Flowers", "FOOD", "Freeweights", "GANGS", "GHANDS", "GHETTO_DB", "goggles", "GRAFFITI", "GRAVEYARD", "GRENADE", "GYMNASIUM",
	"HAIRCUTS", "HEIST9", "INT_HOUSE", "INT_OFFICE", "INT_SHOP", "JST_BUISNESS", "KART", "KISSING", "KNIFE", "LAPDAN1", "LAPDAN2",
	"LAPDAN3", "LOWRIDER", "MD_CHASE", "MD_END", "MEDIC", "MISC", "MTB", "MUSCULAR", "NEVADA", "ON_LOOKERS", "OTB", "PARACHUTE",
	"PARK", "PAULNMAC", "PED", "PLAYER_DVBYS", "PLAYIDLES", "POLICE", "POOL", "POOR", "PYTHON", "QUAD", "QUAD_DBZ", "RAPPING",
	"RIFLE", "RIOT", "ROB_BANK", "ROCKET", "RUSTLER", "RYDER", "SCRATCHING", "SEX", "SHAMAL", "SHOP", "SHOTGUN", "SILENCED", "SKATE",
 	"SMOKING", "SNIPER", "SPRAYCAN", "STRIP", "SUNBATHE", "SWAT", "SWEET", "SWIM", "SWORD", "TANK", "TATTOOS", "TEC", "TRAIN", "TRUCK",
  	"UZI", "VAN", "VENDING", "VORTEX", "WAYFARER", "WEAPONS", "WUZI"
  	};
	for(new i = 0; i < 131; i++) ApplyAnimation(playerid, animlibs[i][0], "null", 0.0, 0, 0, 0, 0, 0);

	#include "../library/objects/a_remove-objects.inc"		// --------- [Загрузка удаленных объектов]
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(pCarID[playerid] != INVALID_VEHICLE_ID)
	{
		DestroyVehicle(pCarID[playerid]);
		pCarID[playerid] = INVALID_VEHICLE_ID;
	}
    // Проверяем, арендовал ли игрок велосипед
    if(_playerBikeID[playerid] != 0)
    {
        // Удаляем велосипед
        DestroyVehicle(_playerBikeID[playerid]);
        // Обнуляем значение в массиве, так как велосипед удален
        _playerBikeID[playerid] = 0;
    }		
	GetPlayerArmour(playerid, player_info[playerid][armor]);
	GetPlayerHealth(playerid, player_info[playerid][health]);
	GetPlayerPos(playerid, player_info[playerid][exitx], player_info[playerid][exity], player_info[playerid][exitz]);
	GetPlayerFacingAngle(playerid, player_info[playerid][exitfa]);
	player_info[playerid][p_world] = GetPlayerVirtualWorld(playerid);
	player_info[playerid][p_interior] = GetPlayerInterior(playerid);
	SavePlayerAccount(playerid);
	KillTimer(mute_timer[playerid]);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(temp_info[playerid][pLoginStatus] != true)
	{
        SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Для игры на сервере необходимо авторизоваться.");
        return 0;
	}
   	if(GetPVarInt(playerid, "@skin_reg") == 1)
    {
 		SetPlayerPos(playerid, 201.97289, -128.07918, 1003.51062);//позиция игрока
    	SetPlayerFacingAngle(playerid, 180.00000);//поворот
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 3);
    	SetPlayerCameraPos(playerid, 201.6538, -133.1275, 1004.1354);//позиция камеры
    	SetPlayerCameraLookAt(playerid, 201.6471, -132.1290, 1003.9761);//позиция камеры
		if(player_info[playerid][sex] == 1) 
		{		
			SetPlayerSkin(playerid, skinRegister[0][0]);
			SetPVarInt(playerid, "@clothes",0);
		}
	   	else 
		{
			SetPlayerSkin(playerid, skinRegister[3][0]);
			SetPVarInt(playerid, "@clothes",3);
		}	
	    TogglePlayerControllable(playerid, 0);
		for(new i; i < 6 ; i ++) TextDrawShowForPlayer(playerid,skinTextDraw[i]);
		SelectTextDraw(playerid, 0xF7EDBCFF);
		return 1;
	}
	if(player_info[playerid][hospitaltime] != 0)
	{
		SetPlayerPos(playerid, 357.5067, 151.0853, 1003.8500);
		SetPlayerFacingAngle(playerid, 272.7061);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 2);
		_freezePlayerPickup(playerid);
		ApplyAnimation(playerid,"PED","KO_shot_stom",4.1,0,1,1,1,1);
		player_info[playerid][health] = 40.0; 
		SetPlayerHealth(playerid, player_info[playerid][health]);
		SetPlayerSkin(playerid, player_info[playerid][skin]);
		SetPlayerScore(playerid, player_info[playerid][lvl]);		
		return 1;
	}
	temp_info[playerid][AFK] = 0;

	// Информация игрока
	SetPlayerSkin(playerid, player_info[playerid][skin]);
	SetPlayerScore(playerid, player_info[playerid][lvl]);	
	PlayerTextDrawShow(playerid, logo[playerid]);
	for(new i = 0; i < 6; i++) PlayerTextDrawShow(playerid, _tdSatiety[i][playerid]);
	_updateTDSatietyEat(playerid);
	_updateTDSatietyWater(playerid);

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	player_info[playerid][hospitaltime] = 60;		
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(temp_info[playerid][pLoginStatus] != true)
	{
        SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Авторизируйтесь, чтобы использовать чат.");
        return 0;
	}
	if(IsPlayerMuted(playerid)) return 0;
	new string[144];
	if(strlen(text) < 113)
	{
		format(string, sizeof(string), "%s[%d] говорит: %s", player_info[playerid][name], playerid, text);
		ProxDetector(20.0, playerid, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE);
		SetPlayerChatBubble(playerid, text, COLOR_WHITE, 20, 7000);
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
		    ApplyAnimation(playerid, "PED", "IDLE_chat", 4.1, 0, 1, 1, 1, 1);
		    SetTimerEx("StopAnimChat", 3200, false, "d", playerid);
		}
	}
	else
	{
	    SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Сообщение слишком длинное!");
	    return 0;
	}
	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{	
	if(_playerBikeID[playerid] != vehicleid) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Этот велосипед пренадлежит не Вам!");	
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(vehicleid == _playerBikeID[playerid]) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}У вас есть 15 минут, чтобы вернуться в транспорт!");
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	switch(newstate)
	{
		case PLAYER_STATE_DRIVER:
		{
			new vehicleid = GetPlayerVehicleID(playerid);		
			GetVehicleHealth(vehicleid, vehicle_info[vehicleid][v_health]);
			if(vehicle_info[vehicleid][v_health] <= 350) SetVehicleEngine(vehicleid, 0);
			if(!IsABMX(vehicleid))
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Подcказка]: {FFFFFF}Чтобы завести двигатель нажмите на {EDD682}\"LCTRL\"{FFFFFF}, включить фары {EDD682}\"LALT\".");
				TextDrawShowForPlayer(playerid, SPEEDTD);
				for(new i; i < 6; i++) PlayerTextDrawShow(playerid, SPEEDPTD[i][playerid]);
				speedtimer[playerid] = SetTimerEx("TransportUpdate", 300, true, "i", playerid);
				speedtimertwo[playerid] = SetTimerEx("TransportUpdateTwo", 50, true, "i", playerid);
				VehicleDriverID[vehicleid] = playerid;
				PlayerVehicleID[playerid] = vehicleid;		
			}
			if(vehicleid >= lead_one[0] && vehicleid <= lead_one[4])
			{
				if(player_info[playerid][leader] != 1 || player_info[playerid][member] != 1)
				{
				    SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У вас нет ключей от этого транспорта!");
					RemovePlayerFromVehicle(playerid);
				}
				return true;
			}			
			/*if(GetPlayerVehicleID(playerid) >= _carsBuyEconomy[0] && GetPlayerVehicleID(playerid) <= _carsBuyEconomy[1])
			{
				new string[174];
				format(string, sizeof(string), "{FFFFFF}Марка автомобиля: %s\nСтоимость автомобиля: %d", VehicleNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400], _priceCar(GetPlayerVehicleID(playerid)));
				SPD(playerid, DLG_BUYCAR, DSM, "{EDD682}Автосолон эконом класса", string, "Приобрести", "Выйти");
			}	*/	
			if(_heliCar(GetPlayerVehicleID(playerid)) && player_info[playerid][lic][1] < 1)
				return SendClientMessage(playerid, COLOR_WHITEOR, "{EDD682}[Ошибка]: {FFFFFF}Ваш персонаж не умеет управлять самолетом/вертолетом!"), RemovePlayerFromVehicle(playerid);
			else if(_shipCar(GetPlayerVehicleID(playerid)) && player_info[playerid][lic][2] < 1)
				return SCM(playerid, COLOR_WHITEOR, "{EDD682}[Ошибка]: {FFFFFF}Ваш персонаж не умеет управлять лодкой!"), RemovePlayerFromVehicle(playerid);
			else
			{
				if(player_info[playerid][lic][0] < 1)
					return SCM(playerid, COLOR_WHITEOR, "{EDD682}[Ошибка]: {FFFFFF}Вам необходимо посетить автошколу, чтобы ездить на этом транспорте!"), RemovePlayerFromVehicle(playerid);
			}													
		}
		case PLAYER_STATE_PASSENGER:{}
	}
	switch(oldstate)
	{
		case PLAYER_STATE_DRIVER:
		{
			TextDrawHideForPlayer(playerid, SPEEDTD);
			for(new i; i < 6; i++) PlayerTextDrawHide(playerid, SPEEDPTD[i][playerid]);
			for(new i; i < 3; i++) PlayerTextDrawHide(playerid, SPEEDOPTD[i][playerid]);	
			KillTimer(speedtimer[playerid]);
			KillTimer(speedtimertwo[playerid]);
			if(PlayerVehicleID[playerid] != 0) VehicleDriverID[PlayerVehicleID[playerid]] = -1;
			PlayerVehicleID[playerid] = 0;									
		}		
	}	
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == bank[0]) // - Вход в банк
	{
		SetPlayerPos(playerid, 2375.7273, -1907.8339, 1126.9100);
		SetPlayerFacingAngle(playerid, 356.9003);
		SetPlayerVirtualWorld(playerid, 1);
		SetPlayerInterior(playerid, 0);
		_freezePlayerPickup(playerid);
		SetCameraBehindPlayer(playerid);
		SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы посетили центральный банк г.Южный.");		
	}
	if(pickupid == bank[1]) // - Выход с банка
	{
		SetPlayerPos(playerid, 2376.4312, -2142.4109, 21.9582);
		SetPlayerFacingAngle(playerid, 175.1358);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetCameraBehindPlayer(playerid);
		_freezePlayerPickup(playerid);
	}
	if(pickupid == hospital[0]) // Вход в больницу г.Южный
	{
		SetPlayerPos(playerid, 367.2120, 127.5249, 1003.8500);
		SetPlayerFacingAngle(playerid, 4.7312);
		SetPlayerVirtualWorld(playerid, 2);
		SetPlayerInterior(playerid, 10);
		_freezePlayerPickup(playerid);
		SetCameraBehindPlayer(playerid);
	}
	if(pickupid == hospital[1]) // Выход с больницу г.Южный
	{
		if(player_info[playerid][hospitaltime] > 0) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Ваше лечение не закончилось! Ждите!");
		SetPlayerPos(playerid, 2113.8765, -2389.9683, 22.6821);
		SetPlayerFacingAngle(playerid, 358.3461);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetCameraBehindPlayer(playerid);
		_freezePlayerPickup(playerid);
	}	
	if(pickupid >= eda[0] && pickupid <= eda[1])
	{
		if(player_info[playerid][lvl] > 2) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы не можете воспользоваться этой услугой!");
		SPD(playerid, DLG_EDA, DSL, "{EDD682}Государство - {FFFFFF}Помощь нуждающимся", 
		"{EDD682}[1]{FFFFFF} - Съесть кусок пиццы\n\
		 {EDD682}[2]{FFFFFF} - Выпить стакан воды", "Выбрать", "Закрыть");
	}
	if(pickupid == _pickupm[0]) // Вход в правительство Лос-Сантос
	{
		SetPlayerPos(playerid, 388.0343, 173.5585, 1008.3828);
		SetPlayerFacingAngle(playerid, 87.8041);
		SetPlayerVirtualWorld(playerid, 1);
		SetPlayerInterior(playerid, 3);
		SetCameraBehindPlayer(playerid);
		_freezePlayerPickup(playerid);
	}
	if(pickupid == _arendBike[0]) // Аренда велосипеда
	{
		new Float:x, Float:y, Float:z;		
		if(player_info[playerid][lvl] > 1) return true;
		GetPlayerPos(playerid, x, y, z);
		new vehicleid = CreateVehicle(509, x, y, z, 0.0, 1, 1, -1);
		_playerBikeID[playerid] = vehicleid;
		PutPlayerInVehicle(playerid, vehicleid, 0);	
	}
	if(pickupid == _pickupm[1]) // Выход с правительства Лос-Сантос
	{
		SetPlayerPos(playerid, 1481.8853, -1769.0585, 18.7958);
		SetPlayerFacingAngle(playerid, 357.5189);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetCameraBehindPlayer(playerid);
		_freezePlayerPickup(playerid);
	}	
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == bank[2]) // - Вход в банк
	{
		if(player_info[playerid][bank_pin][0] == 0)
		{
			SPD(playerid, DLG_CREATEBANKPIN, DSP, "{EDD682}Банк - {FFFFFF}Оформление счёта", 
			"{FFFFFF}Рады видеть вас в нашем банке!\n\
			Оформите банковский счёт, чтобы воспользоваться нашими услугами.\n\
			Придумайте будущий PIN-код и запишите его в поле ниже:\n\
			\n\
			{EDD682}(PIN-код должен состять из 4 символов и начинаться с 0! Пример: 1111)", "Оформить", "Закрыть");	
		}
		else if(player_info[playerid][bank_pin][0] == 1)
		{
			SPD(playerid, DLG_LOGINBANK, DSP, "{EDD682}Банк - {FFFFFF}Идентификация", 
			"{FFFFFF}Введите ваш PIN-код от банковского счёта в поле ниже:\n\
			{EDD682}(Если вы забыли свой PIN-код, обратитесь к администрации проекта)", "Войти", "Закрыть");			
		}		
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == 262144) return callcmd::menu(playerid);
	if(newkeys & KEY_ACTION) callcmd::engine(playerid);
	if(newkeys & KEY_FIRE) callcmd::light(playerid);
	if(newkeys & KEY_WALK)
	{
        for(new h = 1; h <= totalhouse; h++)
		{
	        new string[255],text[25];
   			if(IsPlayerInRangeOfPoint(playerid,1.0,house_info[h][h_enter][0], house_info[h][h_enter][1], house_info[h][h_enter][2]))
			{
		    	if(house_info[h][h_owned] == 1)
				{
					format(string, sizeof(string), "{FFFFFF}Владелец: %s\nНомер дома: %d", house_info[h][h_owner], h);
					SPD(playerid, DLG_HOME, DSM, "Дом не продаётся", string, "Далее", "Отмена");
				}
				else
				{
					switch(house_info[h][h_class])
					{
						case 1: text = "Эконом класс";
						case 2: text = "Средний класс";
						case 3: text = "Высокий класс";
					}
					format(string, sizeof(string), "{FFFFFF}Класс дома:\t%s\nНомер дома:\t%d\n\nСтоимость:\t%d", text, h, house_info[h][h_money]);
					SPD(playerid, DLG_HOMEBUY, DSM, "Дом свободен", string, "Купить"," Отмена");
				}
			}
   			if(IsPlayerInRangeOfPoint(playerid, 1.0, house_info[h][h_exit][0], house_info[h][h_exit][1], house_info[h][h_exit][2]))
			{
				if (GetPlayerVirtualWorld(playerid) == h+50)
				{
					SetPlayerInterior(playerid,0);
					SetPlayerVirtualWorld(playerid,0);
					SetPlayerPos(playerid,house_info[h][h_enter][0], house_info[h][h_enter][1], house_info[h][h_enter][2]);
				}	
			}
		}
		for(new a = 1; a <= totalapart; a++)
		{
	        new string[255],text[25];
   			if(IsPlayerInRangeOfPoint(playerid,1.0, apart_info[a][a_enter][0], apart_info[a][a_enter][1], apart_info[a][a_enter][2]) && GetPlayerVirtualWorld(playerid) == apart_info[a][a_world])
			{
		    	if(apart_info[a][a_owned] == 1)
				{
					format(string, sizeof(string), "{FFFFFF}Владелец: %s\nНомер квартиры: %d", apart_info[a][a_owner], a);
					SPD(playerid, DLG_APART, DSM, "Квартира не продаётся", string, "Далее", "Отмена");
				}
				else
				{
					switch(apart_info[a][a_class])
					{
						case 1: text = "Эконом класс";
						case 2: text = "Средний класс";
						case 3: text = "Высокий класс";
					}
					format(string, sizeof(string), "{FFFFFF}Класс квартиры:\t%s\nНомер квартиры:\t%d\n\nСтоимость:\t%d", text, a, apart_info[a][a_money]);
					SPD(playerid, DLG_APARTBUY, DSM, "Квартира свободна", string, "Купить"," Отмена");
				}
			}
   			if(IsPlayerInRangeOfPoint(playerid, 1.0, apart_info[a][a_exit][0], apart_info[a][a_exit][1], apart_info[a][a_exit][2]))
			{
				if(GetPlayerVirtualWorld(playerid) == a+50)
				{
					SetPlayerInterior(playerid,0);
					SetPlayerVirtualWorld(playerid, apart_info[a][a_world]);
					SetPlayerPos(playerid, apart_info[a][a_enter][0], apart_info[a][a_enter][1], apart_info[a][a_enter][2]);
				}	
			}
		}		
		for(new p = 1; p <= totalporch; p++)
		{
   			if(IsPlayerInRangeOfPoint(playerid, 1.0, porch_info[p][p_enter][0], porch_info[p][p_enter][1], porch_info[p][p_enter][2]))
			{
				SetPlayerPos(playerid, porch_info[p][p_exit][0], porch_info[p][p_exit][1], porch_info[p][p_exit][2]);
				SetPlayerVirtualWorld(playerid,p+50);
				SetCameraBehindPlayer(playerid);
				_freezePlayerPickup(playerid);	
			}
   			if(IsPlayerInRangeOfPoint(playerid, 1.0, porch_info[p][p_exit][0], porch_info[p][p_exit][1], porch_info[p][p_exit][2]))
			{
				if(GetPlayerVirtualWorld(playerid) == p+50)
				{
					SetPlayerInterior(playerid,0);
					SetPlayerVirtualWorld(playerid,0);
					SetPlayerPos(playerid,porch_info[p][p_enter][0], porch_info[p][p_enter][1], porch_info[p][p_enter][2]);
				}	
			}
			if(IsPlayerInRangeOfPoint(playerid, 1.0, 884.0126, 2125.7830, 2002.4259))
			{
				new i = GetPlayerVirtualWorld(playerid);
				SetPlayerPos(playerid, 884.0977, 2125.9177, 2006.2959);
				SetPlayerVirtualWorld(playerid, i);
				SetCameraBehindPlayer(playerid);
				_freezePlayerPickup(playerid);										
			}
			if(IsPlayerInRangeOfPoint(playerid, 1.0, 884.0977, 2125.9177, 2006.2959))
			{
				new i = GetPlayerVirtualWorld(playerid);
				SetPlayerPos(playerid, 884.0126, 2125.7830, 2002.4259);
				SetPlayerVirtualWorld(playerid, i);
				SetCameraBehindPlayer(playerid);
				_freezePlayerPickup(playerid);										
			}
		}
		if(IsPlayerInRangeOfPoint(playerid, 1.0,  1797.1179, 2509.8589, 16.2770)) _questPlayer(playerid);
		if(IsPlayerInRangeOfPoint(playerid, 1.0,  1808.1010, 2506.8914, 15.8725)) _rulesPlayer(playerid);							
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{	
	if(temp_info[playerid][AFK] != 0)
	{
		if(temp_info[playerid][PlayerAFK] > 3)  
		{  
			new string[120];
			format(string,sizeof(string),"{FFFFFF}Время вашего АФК: {EDD682}%s", ConvertSeconds(temp_info[playerid][PlayerAFK]));  
			SendClientMessage(playerid, COLOR_WHITE, string);  
			SetPlayerChatBubble(playerid, "АФК: завершено", COLOR_WHITE, 10.0, 1); 
		}    		
	}
	temp_info[playerid][AFK] = 0;
	temp_info[playerid][PlayerAFK] = 0;
	if(GetPlayerMoney(playerid) != player_info[playerid][money])
	{
	    ResetPlayerMoney(playerid);
	    GivePlayerMoney(playerid, player_info[playerid][money]);
	}	
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DLG_REG:
		{
			if(response)
			{
				if(!strlen(inputtext))
				{
					_showRegistration(playerid);
					return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите пароль в поле ниже и нажмите \"Далее\".");
				}
				if(!( 8 <= strlen(inputtext) <= 32))
				{
					_showRegistration(playerid);
					return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Длина пароля должна быть от 8-ми до 32-ух символов.");
				}
				new regex:rg_passwordcheck = regex_new("^[a-zA-Z0-9]{1,}$");
				if(regex_check(inputtext, rg_passwordcheck))
				{
					new buffer[11];
					for(new i; i < 10; i++)
					{
						buffer[i] = random(43) + 48;
					}
					buffer[10] = 0;
					SHA256_PassHash(inputtext, buffer, player_info[playerid][pass], 65);
					strmid(player_info[playerid][salt], buffer, 0, 11, 11);
					SPD(playerid, DLG_REGEMAIL, DSI, "{EDD682}Регистрация {FFFFFF}| Ввод Email",
					"{FFFFFF}Если вы потеряете доступ к аккаунту, то сможете восстановить его через Email\n\
					Введите ваш настоящий Email, после нажмите на кнопку \"Далее\"", "Далее", "");
				}
				else
				{
					_showRegistration(playerid);
					regex_delete(rg_passwordcheck);
					return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Пароль должен состоять только из цифр и латинских символов.");
				}
			}
			else
			{
				SCM(playerid, COLOR_ERROR, "Используйте \"/q\", чтобы покинуть сервер.");
				return Kick(playerid);
			}
		}
		case DLG_REGEMAIL:
		{
			if(!strlen(inputtext))
			{
				SPD(playerid, DLG_REGEMAIL, DSI, "{EDD682}Регистрация {FFFFFF}| Ввод Email",
				"{FFFFFF}Если вы потеряете доступ к аккаунту, то сможете восстановить его через Email\n\
				Введите ваш настоящий Email, после нажмите на кнопку \"Далее\"", "Далее", "");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите Email в поле ниже и нажмите \"Далее\".");
			}
			new regex:rg_emailcheck = regex_new("^([-A-Za-z0-9_]+\\.)*[-A-Za-z0-9_]+@([A-Za-z0-9][-A-Za-z0-9]*\\.)+[A-Za-z]{2,6}$");
			if(regex_check(inputtext, rg_emailcheck))
			{
				strmid(player_info[playerid][email], inputtext, 0, strlen(inputtext), 64);
				SPD(playerid, DLG_REGREF, DSI, "{EDD682}Регистрация {FFFFFF}| Ввод пригласившего",
				"{FFFFFF}Ты можешь указать имя пригласившего тебя человека\n\
				Для этого просто запиши имя в поле ниже, либо нажми на кнопку \"Пропустить\"",
				"Далее", "Пропустить");
			}
			else
			{
				SPD(playerid, DLG_REGEMAIL, DSI, "{EDD682}Регистрация {FFFFFF}| Ввод Email",
				"{FFFFFF}Если вы потеряете доступ к аккаунту, то сможете восстановить его через Email\n\
				Введите ваш настоящий Email, после нажмите на кнопку \"Далее\"", "Далее", "");
				regex_delete(rg_emailcheck);
				return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Пожалуйста, корректно введите ваш Email и нажмите \"Далее\".");
			}
		}
		case DLG_REGREF:
		{
			if(response)
			{
				mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `accounts` WHERE `name` = '%s'", inputtext);
				mysql_tquery(ConnectMysql, query, "CheckReferal", "is", playerid, inputtext);
			}
			else
			{
				SPD(playerid, DLG_REGSEX, DSM, "{EDD682}Регистрация {FFFFFF}| Выбор пола",
				"{FFFFFF}Выберите пол вашего будущего персонажа",
				"Мужской", "Женский");
			}
		}
		case DLG_REGSEX:
		{
			if(response) player_info[playerid][sex] = 1;
			else player_info[playerid][sex] = 2;
			SPD(playerid, DLG_REGAGE, DSI, "{EDD682}Регистрация {FFFFFF}| Выбор возраста персонажа",
			"{FFFFFF}Введите возраст вашего будущего персонажа\n\n\
			{EDD682}Примечание:\n\
			1. Возраст персонажа должен быть от 18-ти до 30-ти лет",
			"Далее", "");
		}
		case DLG_REGAGE:
		{
			if(!strlen(inputtext))
			{
				SPD(playerid, DLG_REGAGE, DSI, "{EDD682}Регистрация {FFFFFF}| Выбор возраста персонажа",
				"{FFFFFF}Введите возраст вашего будущего персонажа\n\n\
				{EDD682}Примечание:\n\
				1. Возраст персонажа должен быть от 18-ти до 30-ти лет",
				"Далее", "");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите возраст вашего будущего персонажа и нажмите \"Далее\".");
			}
			if(!( 18 <= strval(inputtext) <= 30))
			{
				SPD(playerid, DLG_REGAGE, DSI, "{EDD682}Регистрация {FFFFFF}| Выбор возраста персонажа",
				"{FFFFFF}Введите возраст вашего будущего персонажа\n\n\
				{EDD682}Примечание:\n\
				1. Возраст персонажа должен быть от 18-ти до 30-ти лет",
				"Далее", "");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Возраст персонажа должен быть от 18-ти до 30-ти лет.");
			}
			player_info[playerid][age] = strval(inputtext);
			SetPVarInt(playerid, "@skin_reg",1);
			SetPVarInt(playerid, "@clothes",1);
			temp_info[playerid][pLoginStatus] = true;
			SetSpawnInfo(playerid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);			
		}
		case DLG_SPAWN:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						SetSpawnInfo(playerid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
						SpawnPlayer(playerid);
						_infoPlayer(playerid);

						SetPlayerPos(playerid, _playerSpawn[0][0], _playerSpawn[0][1], _playerSpawn[0][2]);
						SetPlayerFacingAngle(playerid, _playerSpawn[0][3]);
						SetPlayerVirtualWorld(playerid, 0);
						SetPlayerInterior(playerid, 0);
						SetCameraBehindPlayer(playerid);
						_freezePlayerPickup(playerid);

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `accounts` WHERE `name` = '%s' AND `password` = '%s'", player_info[playerid][name], player_info[playerid][pass]);
						mysql_tquery(ConnectMysql, query, "PlayerLogin", "i", playerid);							
					}
					case 1:
					{
					
						if(player_info[playerid][member] == 0)
						{
							SPD(playerid, DLG_SPAWN, DSL, "{EDD682}Авторизация {FFFFFF}| Spawn", "{FFFFFF}1. Спавн на автовокзале\n2. Спавн в организации\n3. Спавн в собственном доме\n\
							4. Спавн в собственной квартире\n5. Спавн в гостинице\n6. Спавн на месте выхода", "Выбрать", "Отмена");	
							return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Вы не состоите в организации!");			
						}

						SetSpawnInfo(playerid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
						SpawnPlayer(playerid);
						_infoPlayer(playerid);						
						_fracSpawn(playerid);
						_freezePlayerPickup(playerid);

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `accounts` WHERE `name` = '%s' AND `password` = '%s'", player_info[playerid][name], player_info[playerid][pass]);
						mysql_tquery(ConnectMysql, query, "PlayerLogin", "i", playerid);					
					}
					case 2:
					{
						new i = player_info[playerid][keyh];
						if(player_info[playerid][keyh] == -1) 
						{	
							SPD(playerid, DLG_SPAWN, DSL, "{EDD682}Авторизация {FFFFFF}| Spawn", "{FFFFFF}1. Спавн на автовокзале\n2. Спавн в организации\n3. Спавн в собственном доме\n\
							4. Спавн в собственной квартире\n5. Спавн в гостинице\n6. Спавн на месте выхода", "Выбрать", "Отмена");							
							return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У вас нет дома!");
						}

						SetSpawnInfo(playerid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
						SpawnPlayer(playerid);
						_infoPlayer(playerid);

						SetPlayerPos(playerid,house_info[i][h_exit][0],house_info[i][h_exit][1],house_info[i][h_exit][2]);
						SetPlayerVirtualWorld(playerid,i+50);
						SetCameraBehindPlayer(playerid);
						_freezePlayerPickup(playerid);	

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `accounts` WHERE `name` = '%s' AND `password` = '%s'", player_info[playerid][name], player_info[playerid][pass]);
						mysql_tquery(ConnectMysql, query, "PlayerLogin", "i", playerid);							
						return 1;	
					}
					case 3:
					{
						new i = player_info[playerid][keya];
						if(player_info[playerid][keya] == -1) 
						{	
							SPD(playerid, DLG_SPAWN, DSL, "{EDD682}Авторизация {FFFFFF}| Spawn", "{FFFFFF}1. Спавн на автовокзале\n2. Спавн в организации\n3. Спавн в собственном доме\n\
							4. Спавн в собственной квартире\n5. Спавн в гостинице\n6. Спавн на месте выхода", "Выбрать", "Отмена");							
							return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У вас нет квартиры!");
						}

						SetSpawnInfo(playerid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
						SpawnPlayer(playerid);
						_infoPlayer(playerid);

						SetPlayerPos(playerid, apart_info[i][a_exit][0], apart_info[i][a_exit][1], apart_info[i][a_exit][2]);
						SetPlayerVirtualWorld(playerid,i+50);
						SetCameraBehindPlayer(playerid);
						_freezePlayerPickup(playerid);

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `accounts` WHERE `name` = '%s' AND `password` = '%s'", player_info[playerid][name], player_info[playerid][pass]);
						mysql_tquery(ConnectMysql, query, "PlayerLogin", "i", playerid);								
						return 1;	
					}
					case 4:
					{
						SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Этот пункт в разработке!");
						SPD(playerid, DLG_SPAWN, DSL, "{EDD682}Авторизация {FFFFFF}| Spawn", "{FFFFFF}1. Спавн на автовокзале\n2. Спавн в организации\n3. Спавн в собственном доме\n\
						4. Спавн в собственной квартире\n5. Спавн в гостинице\n6. Спавн на месте выхода", "Выбрать", "Отмена");	
						return 1;	
					}
					case 5:
					{

						SetSpawnInfo(playerid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
						SpawnPlayer(playerid);
						_infoPlayer(playerid);

						SetPlayerPos(playerid, player_info[playerid][exitx], player_info[playerid][exity], player_info[playerid][exitz]);
						SetPlayerFacingAngle(playerid, player_info[playerid][exitfa]);
						SetPlayerVirtualWorld(playerid, player_info[playerid][p_world]);
						SetPlayerInterior(playerid, player_info[playerid][p_interior]);
						SetCameraBehindPlayer(playerid);
						_freezePlayerPickup(playerid);

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `accounts` WHERE `name` = '%s' AND `password` = '%s'", player_info[playerid][name], player_info[playerid][pass]);
						mysql_tquery(ConnectMysql, query, "PlayerLogin", "i", playerid);																
					}																					
				}		
			}
			else
			{
      			SCM(playerid, COLOR_ERROR, "Используйте \"/q\", чтобы покинуть сервер.");
				return Kick(playerid);				
			}
		}
		case DLG_LOG:
		{
		    if(response)
		    {
		        if(!strlen(inputtext))
				{
				    _showLogin(playerid);
					return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Пожалуйста, введите ваш пароль в поле!");
		        }
		        new checkpass[65];
		        SHA256_PassHash(inputtext, player_info[playerid][salt], checkpass, 65);
				if(strcmp(player_info[playerid][pass], checkpass, false, 64) == 0)
				{
					SPD(playerid, DLG_SPAWN, DSL, "{EDD682}Авторизация {FFFFFF}| Spawn", "{FFFFFF}1. Спавн на автовокзале\n2. Спавн в организации\n3. Спавн в собственном доме\n\
					4. Спавн в собственной квартире\n5. Спавн в гостинице\n6. Спавн на месте выхода", "Выбрать", "Отмена");		
				}
				else
				{
				    new string[110];
					SetPVarInt(playerid, "ErrorPassword", GetPVarInt(playerid, "ErrorPassword")-1);
				    if(GetPVarInt(playerid, "ErrorPassword") > 0)
				    {
						format(string, sizeof(string), "{EDD682}[Ошибка]: {FFFFFF}Введённый вами пароль, неверен. Попыток входа осталось: %d.", GetPVarInt(playerid, "ErrorPassword"));
						SCM(playerid, COLOR_WHITE, string);
					}
					if(GetPVarInt(playerid, "ErrorPassword") == 0)
					{
					    SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Вы исчерпали лимит попыток входа и были отключены от сервера.");
					    return Kick(playerid);
					}
					_showLogin(playerid);
				}
		    }
		    else
		    {
      			SCM(playerid, COLOR_ERROR, "Используйте \"/q\", чтобы покинуть сервер.");
				return Kick(playerid);
		    }			
		}
		case DLG_ALOGIN_REG:
		{
			if(!response) return true;
			if(strlen(inputtext) < 6 || strlen(inputtext) > 15)
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Пароль должен быть длиной от 6 до 15 символов!");
				return SPD(playerid, DLG_ALOGIN_REG, DSP, "{EDD682}AP - Регистрация", "{FFFFFF}Для входа в центр администрирования, пожалуйста, зарегистрируйтесь:", "Ввод", "Отмена");
			}
			for(new i = 0; i < strlen(inputtext); i++)
			{
				switch(inputtext[i])
				{
					case 'А'..'Я', 'а'..'я', ' ':
					{
						SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Пароль содержит недопустимые символы!");
						return SPD(playerid, DLG_ALOGIN_REG, DSP, "{EDD682}AP - Регистрация", "{FFFFFF}Для входа в центр администрирования, пожалуйста, зарегистрируйтесь:", "Ввод", "Отмена");
					}
				}
			}
			format(admin_info[playerid][apassword], 15, "%s", inputtext);

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `admins` SET `password` = '%s' WHERE `name` = '%s'", admin_info[playerid][apassword], player_info[playerid][name]);
			mysql_query(ConnectMysql, query);

			SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы успешно зарегистрировались в панели администрирования!");
			SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Введите {EDD682}/alogin{FFFFFF}, чтобы пройти авторизацию!");
		}
		case DLG_ALOGIN:
		{
			if(!response) return true;
			if(strcmp(admin_info[playerid][apassword], inputtext) == 0)
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы успешно авторизовались в панели администрирования!");
				temp_info[playerid][pAdminStatus] = true;
			}
			else 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введённый вам пароль, неверен!");
				SPD(playerid, DLG_ALOGIN, DSP, "{EDD682}AP - Авторизация", "{FFFFFF}Для входа в центр администрирования, пожалуйста, авторизируйтесь:", "Ввод", "Отмена");
			}
		}
		case DLG_CREATEBANKPIN:
		{
			if(!response) return true;
			if(!strlen(inputtext))
			{
				SPD(playerid, DLG_CREATEBANKPIN, DSP, "{EDD682}Банк - {FFFFFF}Оформление счёта", 
				"{FFFFFF}Рады видеть вас в нашем банке!\n\
				Оформите банковский счёт, чтобы воспользоваться нашими услугами.\n\
				Придумайте будущий PIN-код и запишите его в поле ниже:\n\
				\n\
				{EDD682}(PIN-код должен состять из 4 символов и начинаться с 0! Пример: 1111)", "Оформить", "Закрыть");	
			}
			new regex:rg_secretbankpincheck = regex_new("^[1-9]{1}[0-9]{3}$");
			if(regex_check(inputtext, rg_secretbankpincheck))
			{
				player_info[playerid][bank_pin][0] = 1;
				player_info[playerid][bank_pin][1] = strval(inputtext);
				player_info[playerid][bank_check] = 100000 + random(999999);

				query[0] = EOS;
				mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_pin` = '%d,%d', `bank_check` = '%d' WHERE `name` = '%s'", player_info[playerid][bank_pin][0], player_info[playerid][bank_pin][1], player_info[playerid][bank_check], player_info[playerid][name]);
				mysql_query(ConnectMysql, query);

				new string[70+(-2+4)];
				format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Ваш PIN-код: {EDD682}%s", inputtext);
				SCM(playerid, COLOR_WHITE, string);
				SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Сделайте скриншот клавишей {EDD682}F8 {FFFFFF}или запишите ваш PIN-код.");
			}
			else
			{
				SPD(playerid, DLG_CREATEBANKPIN, DSP, "{EDD682}Банк - {FFFFFF}Оформление счёта", 
				"{FFFFFF}Рады видеть вас в нашем банке!\n\
				Оформите банковский счёт, чтобы воспользоваться нашими услугами.\n\
				Придумайте будущий PIN-код и запишите его в поле ниже:\n\
				\n\
				{EDD682}(PIN-код должен состять из 4 символов и начинаться с 0! Пример: 1111)", "Оформить", "Закрыть");	
				regex_delete(rg_secretbankpincheck);
				return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите корректно PIN-код.");
			}			
		}
		case DLG_LOGINBANK:
		{
			if(!response) return true;
			if(!strlen(inputtext))
			{
				SPD(playerid, DLG_LOGINBANK, DSP, "{EDD682}Банк - {FFFFFF}Идентификация", 
				"{FFFFFF}Введите ваш PIN-код от банковского счёта в поле ниже:\n\
				{EDD682}(Если вы забыли свой PIN-код, обратитесь к администрации проекта)", "Войти", "Закрыть");			
			}
			if(strval(inputtext) == player_info[playerid][bank_pin][1])
			{
				new string[270];
				format(string, sizeof(string), 
				"{FFFFFF}1. Положить деньги на счёт\n\
				2. Снять деньги со счёта\n\
				3. Перевести на другой счёт\n\
				4. Оплата налогов\n\
				5. Настройка счёта\n\
				\n\
				- Информация по счёту:\n\
				1. Номер счёта - {EDD682}(№%d){FFFFFF}\n\
				2. Состояние счёта - {EDD682}(%d руб.)", player_info[playerid][bank_check], player_info[playerid][bank_money]);
				SPD(playerid, DLG_BANKMENU, DSL, "{EDD682}Банк - {FFFFFF}Основное меню", string, "Выбрать", "Закрыть");	
			}
			else
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите корректно PIN-код.");
			}	
		}
		case DLG_BANKMENU:
		{
  			if(response)
		    {			
				switch(listitem)
				{
					case 0: SPD(playerid, DLG_GMONEYBANK, DSI, "{EDD682}Банк - {FFFFFF}Положить на банковский счёт", "{FFFFFF}Введите сумму, которую хотите положить на счёт в поле ниже:", "Положить", "Отмена");
					case 1: SPD(playerid, DLG_TMONEYBANK, DSI, "{EDD682}Банк - {FFFFFF}Снять с банковского счёта", "{FFFFFF}Введите сумму, которую хотите снять со счёта в поле ниже:", "Снять", "Отмена");
					case 2: SPD(playerid, DLG_TMONEY, DSI, "{EDD682}Банк - {FFFFFF}Перевод на другой счёт", "{FFFFFF}Введите номер счёта, на который хотите перевести сумму в поле ниже:", "Перевести", "Отмена");
					case 3: SPD(playerid, DLG_NALOGBANK, DSL, "{EDD682}Банк - {FFFFFF}Оплата налогов", "{FFFFFF}1. Оплатить кварплату дома\n2. Оплатить кварплату квартиры", "Выбрать", "Назад");
					case 4: SPD(playerid, DLG_SBANK, DSL, "{EDD682}Банк - {FFFFFF}Настройка счёта", "{FFFFFF}1. Изменить PIN-код счёта", "Выбрать", "Назад");	
				}
			}	
		}
		case DLG_NALOGBANK:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:	
					{
						if(player_info[playerid][keyh] == -1) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У вас нет дома!");
						SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты дома", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
					}	
					case 1:
					{
						if(player_info[playerid][keya] == -1) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У вас нет квартиры!");
						SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты квартиры", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
					}
				}
			}
			else
			{
				new string[270];
				format(string, sizeof(string), 
				"{FFFFFF}1. Положить деньги на счёт\n\
				2. Снять деньги со счёта\n\
				3. Перевести на другой счёт\n\
				4. Оплата налогов\n\
				5. Настройка счёта\n\
				\n\
				- Информация по счёту:\n\
				1. Номер счёта - {EDD682}(№%d){FFFFFF}\n\
				2. Состояние счёта - {EDD682}(%d руб.)", player_info[playerid][bank_check], player_info[playerid][bank_money]);
				SPD(playerid, DLG_BANKMENU, DSL, "{EDD682}Банк - {FFFFFF}Основное меню", string, "Выбрать", "Закрыть");					
			}
		}
		case DLG_APARTPAY:
		{
			if(response)
			{
				new i = player_info[playerid][keya];
				new dayh = strval(inputtext);
				new p = dayh + apart_info[i][a_rent];
				new string[110];
				if(!strlen(inputtext)) return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты квартиры", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
				if(!( 1 <= dayh <= 30)) return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты квартиры", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
				if(apart_info[i][a_rent] == 30)
				{
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Кварплата дома уже проплачена на 30 дней!");
					return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты квартиры", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
				}				
				if(p == 31)
				{
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Нельзя оплатить более, чем на 30 дней!");
					return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты квартиры", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
				}
				switch(apart_info[i][a_class])
				{
					case 1:
					{
						new total = 2000 * dayh;
						if(total > player_info[playerid][bank_money])
						{
							SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}На вашем счету в банке не хватает средств!");	
							return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты квартиры", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
						}

						apart_info[i][a_rent] += dayh;
						player_info[playerid][bank_money] -= total;

						format(string, sizeof(string), "{FFFFFF}Вы успешно оплатили вашу квартиру на {EDD682}%d {FFFFFF}дней. Остаток на счету: {EDD682}%d", dayh, player_info[playerid][bank_money]);
						SCM(playerid, COLOR_WHITE, string);	

						// Сохранение
						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `id` = '%d'",player_info[playerid][bank_money], player_info[playerid][id]);
						mysql_query(ConnectMysql, query);

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_rent` = `a_rent` + '%d' WHERE `aid` = '%d'", dayh, i);
						mysql_query(ConnectMysql, query);						

					}
					case 2:
					{
						new total = 3000 * dayh;
						if(total > player_info[playerid][bank_money])
						{
							SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}На вашем счету в банке не хватает средств!");	
							return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты квартиры", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
						}

						apart_info[i][a_rent] += dayh;
						player_info[playerid][bank_money] -= total;

						format(string, sizeof(string), "{FFFFFF}Вы успешно оплатили вашу квартиру на {EDD682}%d {FFFFFF}дней. Остаток на счету: {EDD682}%d", dayh, player_info[playerid][bank_money]);
						SCM(playerid, COLOR_WHITE, string);	

						// Сохранение
						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `id` = '%d'",player_info[playerid][bank_money], player_info[playerid][id]);
						mysql_query(ConnectMysql, query);

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_rent` = `a_rent` + '%d' WHERE `aid` = '%d'", dayh, i);
						mysql_query(ConnectMysql, query);	
					}
					case 3:
					{
						new total = 4000 * dayh;
						if(total > player_info[playerid][bank_money])
						{
							SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}На вашем счету в банке не хватает средств!");	
							return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты квартиры", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
						}

						apart_info[i][a_rent] += dayh;
						player_info[playerid][bank_money] -= total;

						format(string, sizeof(string), "{FFFFFF}Вы успешно оплатили вашу квартиру на {EDD682}%d {FFFFFF}дней. Остаток на счету: {EDD682}%d", dayh, player_info[playerid][bank_money]);
						SCM(playerid, COLOR_WHITE, string);	

						// Сохранение
						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `id` = '%d'",player_info[playerid][bank_money], player_info[playerid][id]);
						mysql_query(ConnectMysql, query);

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_rent` = `a_rent` + '%d' WHERE `aid` = '%d'", dayh, i);
						mysql_query(ConnectMysql, query);		
					}
				}
			}
			else SPD(playerid, DLG_NALOGBANK, DSL, "{EDD682}Банк - {FFFFFF}Оплата налогов", "{FFFFFF}1. Оплатить кварплату дома\n2. Оплатить кварплату квартиры", "Выбрать", "Назад");
		}		
		case DLG_HOMEPAY:
		{
			if(response)
			{
				new i = player_info[playerid][keyh];
				new dayh = strval(inputtext);
				new p = dayh + house_info[i][h_rent];
				new string[110];
				if(!strlen(inputtext)) return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты дома", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
				if(!( 1 <= dayh <= 30)) return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты дома", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
				if(house_info[i][h_rent] == 30)
				{
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Кварплата дома уже проплачена на 30 дней!");
					return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты дома", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
				}				
				if(p == 31)
				{
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Нельзя оплатить более, чем на 30 дней!");
					return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты дома", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
				}
				switch(house_info[i][h_class])
				{
					case 1:
					{
						new total = 2000 * dayh;
						if(total > player_info[playerid][bank_money])
						{
							SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}На вашем счету в банке не хватает средств!");	
							return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты дома", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
						}

						house_info[i][h_rent] += dayh;
						player_info[playerid][bank_money] -= total;

						format(string, sizeof(string), "{FFFFFF}Вы успешно оплатили ваш дом на {EDD682}%d {FFFFFF}дней. Остаток на счету: {EDD682}%d", dayh, player_info[playerid][bank_money]);
						SCM(playerid, COLOR_WHITE, string);	

						// Сохранение
						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `id` = '%d'",player_info[playerid][bank_money], player_info[playerid][id]);
						mysql_query(ConnectMysql, query);

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_rent` = `h_rent` + '%d' WHERE `hid` = '%d'", dayh, i);
						mysql_query(ConnectMysql, query);						

					}
					case 2:
					{
						new total = 3000 * dayh;
						if(total > player_info[playerid][bank_money])
						{
							SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}На вашем счету в банке не хватает средств!");	
							return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты дома", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
						}

						house_info[i][h_rent] += dayh;
						player_info[playerid][bank_money] -= total;

						format(string, sizeof(string), "{FFFFFF}Вы успешно оплатили ваш дом на {EDD682}%d {FFFFFF}дней. Остаток на счету: {EDD682}%d", dayh, player_info[playerid][bank_money]);
						SCM(playerid, COLOR_WHITE, string);	

						// Сохранение
						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `id` = '%d'",player_info[playerid][bank_money], player_info[playerid][id]);
						mysql_query(ConnectMysql, query);

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_rent` = `h_rent` + '%d' WHERE `hid` = '%d'", dayh, i);
						mysql_query(ConnectMysql, query);	
					}
					case 3:
					{
						new total = 4000 * dayh;
						if(total > player_info[playerid][bank_money])
						{
							SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}На вашем счету в банке не хватает средств!");	
							return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}Банк - {FFFFFF}Оплата кварплаты дома", "{FFFFFF}Введите количество дней, на сколько хотите внести платёж (от 1 до 30)", "Оплатить", "Отмена");
						}

						house_info[i][h_rent] += dayh;
						player_info[playerid][bank_money] -= total;

						format(string, sizeof(string), "{FFFFFF}Вы успешно оплатили ваш дом на {EDD682}%d {FFFFFF}дней. Остаток на счету: {EDD682}%d", dayh, player_info[playerid][bank_money]);
						SCM(playerid, COLOR_WHITE, string);	

						// Сохранение
						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `id` = '%d'",player_info[playerid][bank_money], player_info[playerid][id]);
						mysql_query(ConnectMysql, query);

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_rent` = `h_rent` + '%d' WHERE `hid` = '%d'", dayh, i);
						mysql_query(ConnectMysql, query);	
					}
				}
			}
			else SPD(playerid, DLG_NALOGBANK, DSL, "{EDD682}Банк - {FFFFFF}Оплата налогов", "{FFFFFF}1. Оплатить кварплату дома\n2. Оплатить кварплату квартиры", "Выбрать", "Назад");
		}
		case DLG_BANKNEWPIN:
		{
			if(response)
			{
				if(!strlen(inputtext)) 
				{
					SPD(playerid, DLG_BANKNEWPIN, DSI, "{EDD682}Банк - {FFFFFF}Изменение PIN-код`а", "{FFFFFF}Введите новый PIN-код в поле ниже:\n\
					{EDD682}(PIN-код должен состять из 4 символов и начинаться с 0! Пример: 1111)", "Изменить", "Назад");
					return 1;
				}	
				new regex:rg_secretbankpincheck = regex_new("^[1-9]{1}[0-9]{3}$");
				if(regex_check(inputtext, rg_secretbankpincheck))
				{
					player_info[playerid][bank_pin][1] = strval(inputtext);

					query[0] = EOS;
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_pin` = '%d,%d' WHERE `name` = '%s'", 1, player_info[playerid][bank_pin][1], player_info[playerid][name]);
					mysql_query(ConnectMysql, query);

					new string[70+(-2+4)];
					format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Ваш PIN-код: {EDD682}%s", inputtext);
					SCM(playerid, COLOR_WHITE, string);
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Сделайте скриншот клавишей {EDD682}F8 {FFFFFF}или запишите ваш PIN-код.");
				}
				else
				{
					SPD(playerid, DLG_BANKNEWPIN, DSI, "{EDD682}Банк - {FFFFFF}Изменение PIN-код`а", "{FFFFFF}Введите новый PIN-код в поле ниже:\n\
					{EDD682}(PIN-код должен состять из 4 символов и начинаться с 0! Пример: 1111)", "Изменить", "Назад");
					regex_delete(rg_secretbankpincheck);
					return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите корректно PIN-код.");
				}	
			}
			else SPD(playerid, DLG_SBANK, DSL, "{EDD682}Банк - {FFFFFF}Настройка счёта", "{FFFFFF}1. Изменить PIN-код счёта", "Выбрать", "Назад");	
		}
		case DLG_SBANK:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: 
					{
						SPD(playerid, DLG_BANKNEWPIN, DSI, "{EDD682}Банк - {FFFFFF}Изменение PIN-код`а", "{FFFFFF}Введите новый PIN-код в поле ниже:\n\
						{EDD682}(PIN-код должен состять из 4 символов и начинаться с 0! Пример: 1111)", "Изменить", "Назад");
					}	
				}
			}
			else
			{
				new string[270];
				format(string, sizeof(string), 
				"{FFFFFF}1. Положить деньги на счёт\n\
				2. Снять деньги со счёта\n\
				3. Перевести на другой счёт\n\
				4. Оплата налогов\n\
				5. Настройка счёта\n\
				\n\
				- Информация по счёту:\n\
				1. Номер счёта - {EDD682}(№%d){FFFFFF}\n\
				2. Состояние счёта - {EDD682}(%d руб.)", player_info[playerid][bank_check], player_info[playerid][bank_money]);
				SPD(playerid, DLG_BANKMENU, DSL, "{EDD682}Банк - {FFFFFF}Основное меню", string, "Выбрать", "Закрыть");					
			}

		}
		case DLG_TMONEYBANK:
		{
			if(!response) return true;
			new string[140];
			if(!strlen(inputtext)) return SPD(playerid, DLG_TMONEYBANK, DSI, "{EDD682}Банк - {FFFFFF}Снять с банковского счёта", "{FFFFFF}Введите сумму, которую хотите снять со счёта в поле ниже:", "Снять", "Отмена");
			if(strval(inputtext) < 1 || strval(inputtext) > 10000000)
			{
				SPD(playerid, DLG_TMONEYBANK, DSI, "{EDD682}Банк - {FFFFFF}Снять с банковского счёта", "{FFFFFF}Введите сумму, которую хотите снять со счёта в поле ниже:", "Снять", "Отмена");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Нельзя снять менее 1 рубля или более 10.000.000 рублей.");				
			}
			if(player_info[playerid][bank_money] < strval(inputtext))
			{
				SPD(playerid, DLG_TMONEYBANK, DSI, "{EDD682}Банк - {FFFFFF}Снять с банковского счёта", "{FFFFFF}Введите сумму, которую хотите снять со счёта в поле ниже:", "Снять", "Отмена");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У вас нет столько денег.");
			}
			_giveMoney(playerid, strval(inputtext));
			player_info[playerid][bank_money] -= strval(inputtext);
			format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Вы сняли {EDD682}%d рублей {FFFFFF}со своего счёта. Баланс: {EDD682}%d рублей.", strval(inputtext), player_info[playerid][bank_money]);
			SCM(playerid, COLOR_WHITE, string);

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `id` = '%d'", player_info[playerid][bank_money], player_info[playerid][id]);
			mysql_query(ConnectMysql, query);					
		}
		case DLG_GMONEYBANK:
		{
			if(!response) return true;
			new string[140];
			if(!strlen(inputtext)) return SPD(playerid, DLG_GMONEYBANK, DSI, "{EDD682}Банк - {FFFFFF}Положить на банковский счёт", "{FFFFFF}Введите сумму, которую хотите положить на счёт в поле ниже:", "Положить", "Отмена");
			if(strval(inputtext) < 1 || strval(inputtext) > 10000000)
			{
				SPD(playerid, DLG_GMONEYBANK, DSI, "{EDD682}Банк - {FFFFFF}Положить на банковский счёт", "{FFFFFF}Введите сумму, которую хотите положить на счёт в поле ниже:", "Положить", "Отмена");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Нельзя положить менее 1 рубля или более 10.000.000 рублей.");				
			}
			if(player_info[playerid][money] < strval(inputtext))
			{
				SPD(playerid, DLG_GMONEYBANK, DSI, "{EDD682}Банк - {FFFFFF}Положить на банковский счёт", "{FFFFFF}Введите сумму, которую хотите положить на счёт в поле ниже:", "Положить", "Отмена");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У вас нет столько денег.");
			}
			_giveMoney(playerid, -strval(inputtext));
			player_info[playerid][bank_money] += strval(inputtext);
			format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Вы положили {EDD682}%d рублей {FFFFFF}на свой счёт. Баланс: {EDD682}%d рублей.", strval(inputtext), player_info[playerid][bank_money]);
			SCM(playerid, COLOR_WHITE, string);

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `id` = '%d'", player_info[playerid][bank_money], player_info[playerid][id]);
			mysql_query(ConnectMysql, query);			
		}
		case DLG_BANKINFO: SPD(playerid, DLG_BANKMENU, DSL, "{EDD682}Банк - {FFFFFF}Основное меню", "1. Информация по счёту.\n2. Перевести на другой счёт.\n3. Оплата налогов.\n4. Настройка счёта.", "Выбрать", "Закрыть");
		case DLG_TMONEY:
		{
			if(!response) return true;
			new transfer;
			if(sscanf(inputtext, "i", transfer)) return SPD(playerid, DLG_TMONEY, DSI, "{EDD682}Банк - {FFFFFF}Перевод на другой счёт", "{FFFFFF}Введите номер счёта, на который хотите перевести сумму в поле ниже:", "Перевести", "Отмена");
			if(transfer == player_info[playerid][bank_check]) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите корректный номер счёта!");
				return SPD(playerid, DLG_TMONEY, DSI, "{EDD682}Банк - {FFFFFF}Перевод на другой счёт", "{FFFFFF}Введите номер счёта, на который хотите перевести сумму в поле ниже:", "Перевести", "Отмена");	
			}		

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `accounts` WHERE `bank_check` = '%d'", transfer);
			mysql_tquery(ConnectMysql, query, "TransferMoney", "dd", playerid, transfer);		
		}
		case DLG_TRANSFERBANK:
		{
			if(!response)
			{
				DeletePVar(playerid, "moddedtransfer");
				return SPD(playerid, DLG_TMONEY, DSI, "{EDD682}Банк - {FFFFFF}Перевод на другой счёт", "{FFFFFF}Введите номер счёта, на который хотите перевести сумму в поле ниже:", "Перевести", "Отмена");
			}
			new moneybank;
			new string[200];
			new transfer = GetPVarInt(playerid, "moddedtransfer");
			sscanf(inputtext, "d", moneybank);
			if(moneybank < 1000 || moneybank > 10000000)
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Нельзя перевести менее 1000 рубля или более 10.000.000 рублей.");	
				format(string, sizeof(string), "{FFFFFF}Вы выполняете перевод на счёт {EDD682}(№%d)\n\n{FFFFFF}Если данные правильные, введите сумму, которую Вы хотите перевести на этот банковский счёт в поле ниже:",
				transfer, player_info[playerid][bank_check]);
				return ShowPlayerDialog(playerid, DLG_TRANSFERBANK, DSI, "{EDD682}Банк - {FFFFFF}Перевод на другой счёт", string, "Перевести", "Назад");				
			}
			if(player_info[playerid][bank_money] < moneybank)
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У вас нет столько денег.");
				format(string, sizeof(string), "{FFFFFF}Вы выполняете перевод на счёт {EDD682}(№%d)\n\n{FFFFFF}Если данные правильные, введите сумму, которую Вы хотите перевести на этот банковский счётв поле ниже:",
				transfer, player_info[playerid][bank_check]);
				return ShowPlayerDialog(playerid, DLG_TRANSFERBANK, DSI, "{EDD682}Банк - {FFFFFF}Перевод на другой счёт", string, "Перевести", "Назад");			
			}	
			player_info[playerid][bank_money] -= moneybank;

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `bank_check` = '%d'", player_info[playerid][bank_money], player_info[playerid][bank_check]);
			mysql_query(ConnectMysql, query);

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = `bank_money` + '%d' WHERE `bank_check` = '%d'", moneybank, transfer);
			mysql_query(ConnectMysql, query);		

			format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Вы перевели {EDD682}%d рублей {FFFFFF}на счёт {EDD682}(№%d).", moneybank, transfer);
			SCM(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Баланс вашего счёта: {EDD682}%d рублей.", player_info[playerid][bank_money]);
			SCM(playerid, COLOR_WHITE, string);

			foreach(new i:Player)
			{  
				if(!IsPlayerConnected(i)) continue;
				if(transfer == player_info[i][bank_check])
				{
					new mes[220];
					player_info[i][bank_money] += moneybank;
					format(mes, sizeof(mes), "{EDD682}[Уведомление]: {FFFFFF}Игрок {EDD682}%s {FFFFFF}перевёл деньги на ваш банковский счёт {EDD682}(№%d).", player_info[playerid][name] ,player_info[i][bank_check]);
					SCM(i, COLOR_WHITE, mes);
					format(mes, sizeof(mes), "{EDD682}[Уведомление]: {FFFFFF}Баланс вышего счёта: {EDD682}%d рублей.", player_info[i][bank_money]);
					SCM(i, COLOR_WHITE, mes);
				}

			}		
		}
		case DLG_MENU:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: _statsPlayer(playerid);
					case 1: {}
					case 2: {}
					case 3: {}
					case 4: {}
					case 5: callcmd::need(playerid);
					case 6: {}
					case 7: _rulesPlayer(playerid);
					case 8: {}
				}
			}
		}
		case DLG_STATS: callcmd::menu(playerid);
		case DLG_NEED: callcmd::menu(playerid);
		case DLG_SETLEADER:
		{
			if(!response) return true;
			new string[214];
			new actplayerid = GetPVarInt(playerid, "_isLeader");
			if(listitem == 0)
			{
				format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Вы сняли с поста: {EDD682}%s {FFFFFF}игрока {EDD682}%s[%d].", _fracName(actplayerid), player_info[actplayerid][name], actplayerid);
				SendClientMessage(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Администратор {EDD682}%s[%d] {FFFFFF}снял вас с поста: {EDD682}%s.", player_info[playerid][name], playerid, _fracName(actplayerid));
				SendClientMessage(actplayerid, COLOR_WHITE, string);
				player_info[actplayerid][leader] = 0;
				player_info[actplayerid][member] = 0;
				player_info[actplayerid][rang] = 0;
				player_info[actplayerid][fskin] = 0;
				SetPlayerSkin(actplayerid, player_info[actplayerid][skin]);
				SpawnPlayer(actplayerid);

				SetPlayerPos(actplayerid, _playerSpawn[0][0], _playerSpawn[0][1], _playerSpawn[0][2]);
				SetPlayerFacingAngle(actplayerid, _playerSpawn[0][3]);
				SetPlayerVirtualWorld(actplayerid, 0);
				SetPlayerInterior(actplayerid, 0);
				SetCameraBehindPlayer(actplayerid);

				query[0] = EOS;
				mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `leader` = '%d', `member` = '%d', `rang` = '%d'  WHERE `name` = '%s'", player_info[actplayerid][leader], listitem, 
				player_info[actplayerid][rang], player_info[actplayerid][name]);
				mysql_tquery(ConnectMysql, query);									
				return 1;
			}
			player_info[actplayerid][leader] = 1;
			player_info[actplayerid][member] = listitem;
			player_info[actplayerid][rang] = FactionMaxRanks[listitem];

			format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Администратор {EDD682}%s[%d] {FFFFFF}назначил Вас лидером на пост: {EDD682}%s.", player_info[playerid][name], playerid, _fracName(actplayerid));
			SendClientMessage(actplayerid, COLOR_WHITE, string);
			SendClientMessage(actplayerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Используйте {EDD682}'/changeskin'{FFFFFF}, чтобы сменить внешность персонажа!");
			format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Вы назначили %s[%d] на пост лидера: %s.", player_info[actplayerid][name], actplayerid, _fracName(actplayerid));
			SendClientMessage(playerid, COLOR_WHITE, string);

			format(string, sizeof(string), "Администратор %s[%d] назначил %s[%d] лидером на пост: %s.", 
			player_info[playerid][name], playerid, player_info[actplayerid][name], actplayerid, _fracName(actplayerid));
			SAM(COLOR_SRED, string, 1);

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `leader` = '%d', `member` = '%d', `rang` = '%d'  WHERE `name` = '%s'", player_info[actplayerid][leader], listitem, 
			player_info[actplayerid][rang], player_info[actplayerid][name]);
			mysql_tquery(ConnectMysql, query);			

			_fracSkin(actplayerid);	
            _fracSpawn(actplayerid);			
		}
		case DLG_CHANGESKIN:
		{
	        if(!response) return 1;
	        new actplayerid = GetPVarInt(playerid, "actplayerid");
	        new fractionid = player_info[playerid][member];
	        new skinid = FractionSkin[fractionid][listitem];
	        new mes[128];
			format(mes,sizeof(mes), "{EDD682}[Уведомление]: {EDD682}%s {FFFFFF}выдал Вам новую фракционную одежду.", player_info[playerid][name]);
			SendClientMessage(actplayerid, COLOR_WHITE, mes);
			format(mes,sizeof(mes), "{EDD682}[Уведомление]: {EDD682}%s {FFFFFF}получил новую фракционную одежду.", player_info[actplayerid][name]);
			SendClientMessage(playerid, COLOR_WHITE, mes);
	        player_info[actplayerid][fskin] = skinid;
	        SetPlayerSkin(actplayerid, skinid);
			DeletePVar(playerid, "actplayerid");			
		}
		case DLG_EDA:
		{
			if(!response) return true;
			switch(listitem)
			{
				case 0:
				{
					if(player_info[playerid][eat] == 100) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Ваш персонаж не голоден!");
					player_info[playerid][eat] += 30;
					ApplyAnimation(playerid, "FOOD", "EAT_PIZZA", 4.0, 0, 0, 0, 0, 0,1);
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы съели кусок пиццы, потребности еды восполнились на 30 единиц");
					if(player_info[playerid][eat] > 100) return player_info[playerid][eat] = 100;
				}
				case 1:
				{
					if(player_info[playerid][thirst] == 100) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Ваш персонаж не хочет пить!");
					player_info[playerid][thirst] += 30;
					ApplyAnimation(playerid, "VENDING", "VEND_DRINK_P", 4.0, 0, 0, 0, 0, 0,1);
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы выпили стакан воды, потребности жажды восполнились на 30 единиц");
					if(player_info[playerid][thirst] > 100) return player_info[playerid][thirst] = 100;					
				}				
			}
		}
		case DLG_HOME:
		{
			if(!response) return true;
			for(new h = 1; h <= totalhouse; h++)
			{
				if(house_info[h][h_lock] == 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Двери этого дома закрыты!");	
				if(IsPlayerInRangeOfPoint(playerid, 1.0, house_info[h][h_enter][0], house_info[h][h_enter][1], house_info[h][h_enter][2]))
				{
					SetPlayerPos(playerid,house_info[h][h_exit][0],house_info[h][h_exit][1],house_info[h][h_exit][2]);
					SetPlayerVirtualWorld(playerid,h+50);
					SetCameraBehindPlayer(playerid);
					_freezePlayerPickup(playerid);					
				}				
			}				
		}
		case DLG_APART:
		{
			if(!response) return true;
			for(new a = 1; a <= totalapart; a++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0, apart_info[a][a_enter][0], apart_info[a][a_enter][1], apart_info[a][a_enter][2]) && GetPlayerVirtualWorld(playerid) == apart_info[a][a_world])
				{
					if(apart_info[a][a_lock] == 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Двери этой квартиры закрыты!");
					SetPlayerPos(playerid, apart_info[a][a_exit][0], apart_info[a][a_exit][1], apart_info[a][a_exit][2]);
					SetPlayerVirtualWorld(playerid, a+50);
					SetCameraBehindPlayer(playerid);
					_freezePlayerPickup(playerid);					
				}				
			}				
		}
		case DLG_APARTBUY:
		{
			if(!response) return true;
			new string[256];
			for(new a = 1; a <= totalapart; a++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0, apart_info[a][a_enter][0], apart_info[a][a_enter][1], apart_info[a][a_enter][2]) && GetPlayerVirtualWorld(playerid) == apart_info[a][a_world])
				{
					if(player_info[playerid][keya] != -1) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы не можете купить вторую квартиру!");
					if(player_info[playerid][money] < apart_info[a][a_money]) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}У вас недостаточно средств, чтобы приобрести эту квартиру!");
					player_info[playerid][keya] = a;
					apart_info[a][a_owned] = 1;
					apart_info[a][a_rent] = 3;
					_giveMoney(playerid, -apart_info[a][a_money]);

					strmid(apart_info[a][a_owner], player_info[playerid][name], 0, strlen(player_info[playerid][name]), 255);
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keya` = '%d' WHERE `id` = '%d'", player_info[playerid][keya], player_info[playerid][id]);
					mysql_query(ConnectMysql, query);	

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_owned` = '%d', `a_owner` = '%s', `a_rent` = '%d' WHERE `aid` = '%d'", apart_info[a][a_owned], player_info[playerid][name], apart_info[a][a_rent], a);
					mysql_query(ConnectMysql, query);

					SetPlayerPos(playerid, apart_info[a][a_exit][0], apart_info[a][a_exit][1], apart_info[a][a_exit][2]);
					SetPlayerVirtualWorld(playerid, a+50);
					SetCameraBehindPlayer(playerid);
					_freezePlayerPickup(playerid);

					format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Вы приобрели квартиру (№%d) за %d рублей! Оплачено дней: %d.", a, apart_info[a][a_money], apart_info[a][a_rent]);
					SCM(playerid, COLOR_WHITE, string);

					Delete3DTextLabel(apart_info[a][a_text]);
					apart_info[a][a_text] = Create3DTextLabel("{FFFFFF}Квартира не продаётся.\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[a][a_enter][0], apart_info[a][a_enter][1], apart_info[a][a_enter][2], 20.0, apart_info[a][a_world], 1);												
				}	
			}
		}				
		case DLG_HOMEBUY:
		{
			if(!response) return true;
			new string[256];
			for(new h = 1; h <= totalhouse; h++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0, house_info[h][h_enter][0], house_info[h][h_enter][1], house_info[h][h_enter][2]))
				{
					if(player_info[playerid][keyh] != -1) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы не можете купить второй дом!");
					if(player_info[playerid][money] < house_info[h][h_money]) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}У вас недостаточно средств, чтобы приобрести этот дом!");
					player_info[playerid][keyh] = h;
					house_info[h][h_owned] = 1;
					house_info[h][h_rent] = 3;
					_giveMoney(playerid, -house_info[h][h_money]);

					strmid(house_info[h][h_owner], player_info[playerid][name], 0, strlen(player_info[playerid][name]), 255);
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keyh` = '%d' WHERE `id` = '%d'", player_info[playerid][keyh], player_info[playerid][id]);
					mysql_query(ConnectMysql, query);	

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_owned` = '%d', `h_owner` = '%s', `h_rent` = '%d' WHERE `hid` = '%d'", house_info[h][h_owned], player_info[playerid][name], house_info[h][h_rent], house_info[h][hid]);
					mysql_query(ConnectMysql, query);

					SetPlayerPos(playerid, house_info[h][h_exit][0], house_info[h][h_exit][1], house_info[h][h_exit][2]);
					SetPlayerVirtualWorld(playerid, h+50);
					SetCameraBehindPlayer(playerid);
					_freezePlayerPickup(playerid);

					format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Вы приобрели дом (№%d) за %d рублей! Оплачено дней: %d.", h, house_info[h][h_money], house_info[h][h_rent]);
					SCM(playerid, COLOR_WHITE, string);

					_updatehouse(h);												
				}	
			}
		}
		case DLG_HOMEMENU:
		{
			if(!response) return true;
			switch(listitem)
			{
				case 0: _infoHome(playerid);
				case 1: SPD(playerid, DLG_SELLHOMEG, DSM, "{EDD682}Продажа дома государству", "{FFFFFF}Вы действительно желаете продать дом государству?", "Да", "Нет");
				case 2: SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}Продажа дома игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать дом:", "Далее", "Закрыть");
			}
		}
		case DLG_APARTMENU:
		{
			if(!response) return true;
			switch(listitem)
			{
				case 0: _infoApart(playerid);
				case 1: SPD(playerid, DLG_SELLAPARTG, DSM, "{EDD682}Продажа квартиры государству", "{FFFFFF}Вы действительно желаете продать квартиру государству?", "Да", "Нет");
				case 2: SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}Продажа квартиры игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать квартиру:", "Далее", "Закрыть");
			}
		}
		case DLG_INFOAPART: 
		{
			SPD(playerid, DLG_APARTMENU, DSL, "{EDD682}Управление квартирой", 
			"{EDD682}[1]{FFFFFF} - Информация о квартире\n\
			{EDD682}[2]{FFFFFF} - Продать квартиру государству\n\
			{EDD682}[3]{FFFFFF} - Продать квартиру игроку", "Далее", "Закрыть");		
		}			
		case DLG_INFOHOME: 
		{
			SPD(playerid, DLG_HOMEMENU, DSL, "{EDD682}Управление домом", 
			"{EDD682}[1]{FFFFFF} - Информация о доме\n\
			{EDD682}[2]{FFFFFF} - Продать дом государству\n\
			{EDD682}[3]{FFFFFF} - Продать дом игроку", "Далее", "Закрыть");			
		}
		case DLG_SELLAPARTG:
		{
			if(!response) return true;
			new i = player_info[playerid][keya], string[60];
			apart_info[i][a_owned] = 0;
			_giveMoney(playerid, apart_info[i][a_money]);
			strmid(apart_info[i][a_owner], "Государство", 0, strlen("Государство"), 255);

			SetPlayerPos(playerid, apart_info[i][a_enter][0], apart_info[i][a_enter][1], apart_info[i][a_enter][2]);
			SetPlayerVirtualWorld(playerid, apart_info[i][a_world]);		

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_owned` = '0', `a_owner` = 'пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ' WHERE `aid` = '%d'", i);
			mysql_query(ConnectMysql, query);

			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keya` = '-1' WHERE `id` = '%d'", player_info[playerid][id]);
			mysql_query(ConnectMysql, query);

			SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы успешно продали квартиру государству!");
			format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~g~+%d PYЂ", apart_info[i][a_money]);
			PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
			GameTextForPlayer(playerid, string, 1000, 3);

			Delete3DTextLabel(apart_info[i][a_text]);
			apart_info[i][a_text] = Create3DTextLabel("{FFFFFF}Квартира продаётся.\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[i][a_enter][0], apart_info[i][a_enter][1], apart_info[i][a_enter][2], 20.0, apart_info[i][a_world], 1);
			player_info[playerid][keya] = -1;							
		}			
		case DLG_SELLHOMEG:
		{
			if(!response) return true;
			new i = player_info[playerid][keyh], string[60];
			house_info[i][h_owned] = 0;
			_giveMoney(playerid, house_info[i][h_money]);
			strmid(house_info[i][h_owner], "Государство", 0, strlen("Государство"), 255);

			SetPlayerPos(playerid, house_info[i][h_enter][0], house_info[i][h_enter][1], house_info[i][h_enter][2]);
			SetPlayerVirtualWorld(playerid, 0);		

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_owned` = '0', `h_owner` = 'пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ' WHERE `hid` = '%d'", i);
			mysql_query(ConnectMysql, query);

			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keyh` = '-1' WHERE `id` = '%d'", player_info[playerid][id]);
			mysql_query(ConnectMysql, query);

			SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы успешно продали дом государству!");
			format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~g~+%d PYЂ", house_info[i][h_money]);
			PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
			GameTextForPlayer(playerid, string, 1000, 3);
			_updatehouse(i);
			player_info[playerid][keyh] = -1;				
		}
		case DLG_SELLAPARTP:
		{
			if(!response) return true;
			new Float:x[3], params[2], string[250];
			GetPlayerPos(playerid, x[0], x[1], x[2]);
			if(sscanf(inputtext, "p<,>dd", params[0], params[1])) return SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}Продажа квартиры игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать квартиру:", "Далее", "Закрыть");
			if(params[0] == playerid) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Нельзя продавать самому себе!");
				return SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}Продажа квартиры игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать квартиру:", "Далее", "Закрыть");
			}
			if(player_info[params[0]][keya] != -1) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У игрока уже есть квартира!");
				return SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}Продажа квартиры игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать квартиру:", "Далее", "Закрыть");
			}			
			if(GetPVarInt(playerid,"apartpokup") == 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Вы уже сделали предложение!");
			if(!strlen(inputtext)) return SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}Продажа квартиры игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать квартиру:", "Далее", "Закрыть");
			
			if(!IsPlayerConnected(params[0])) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Указанный вами игрок не в сети!");
				return SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}Продажа квартиры игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать квартиру:", "Далее", "Закрыть");
			}
			if(!IsPlayerInRangeOfPoint(params[0], 2.0, x[0], x[1], x[2])) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Указанный вами игрок должен находиться рядом с вами!");
				return SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}Продажа квартиры игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать квартиру:", "Далее", "Закрыть");			
			}
			SetPVarInt(params[0],"ApartOffer", playerid);
			SetPVarInt(params[0],"ApartPrice", params[1]);
			SetPVarInt(playerid,"apartpokup",1);

			format(string, sizeof(string), "{FFFFFF}Игрок {EDD682}%s {FFFFFF}предлагает вам купить квартиру {EDD682}(№%d) {FFFFFF}за {EDD682}%d {FFFFFF}рублей", player_info[playerid][name], player_info[playerid][keya], params[1]);	
			SPD(params[0], DLG_SELLAPARTP2, DSM, "{EDD682}Покупка квартиры", string, "Купить", "Отмена");
		}
		case DLG_SELLAPARTP2:
		{
			if(response)
			{
				if(GetPVarInt(playerid, "ApartOffer") != 60635)
				{
					new h = player_info[GetPVarInt(playerid, "ApartOffer")][keya];
					if(player_info[playerid][money] < GetPVarInt(playerid, "ApartPrice"))return SendClientMessage(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У вас нет столько денег на руках!");
					player_info[playerid][keya] = player_info[GetPVarInt(playerid, "ApartOffer")][keya];
					player_info[GetPVarInt(playerid, "ApartOffer")][keya] = -1;
					_giveMoney(playerid, -GetPVarInt(playerid, "ApartPrice"));
					_giveMoney(GetPVarInt(playerid, "ApartOffer"), GetPVarInt(playerid, "ApartPrice"));
					strmid(apart_info[h][a_owner], player_info[playerid][name], 0, strlen(player_info[playerid][name]), 255);

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keya` = '%d' WHERE `id` = '%d'", player_info[playerid][keya], player_info[playerid][id]);
					mysql_query(ConnectMysql, query);

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keya` = '%d' WHERE `id` = '%d'", player_info[GetPVarInt(playerid, "ApartOffer")][keya], player_info[GetPVarInt(playerid, "ApartOffer")][id]);
					mysql_query(ConnectMysql, query);		

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_owned` = '%d', `a_owner` = '%s' WHERE `aid` = '%d'", apart_info[h][a_owned], player_info[playerid][name], apart_info[h][aid]);
					mysql_query(ConnectMysql, query);

					SCM(GetPVarInt(playerid, "ApartOffer"), COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы успешно продали квартиру!");
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Поздравляем с покупкой квартиры!");

					SetPVarInt(GetPVarInt(playerid, "ApartOffer"),"apartpokup",0);
					SetPVarInt(playerid,"ApartOffer", 60635);
					SetPVarInt(GetPVarInt(playerid, "ApartOffer"),"ApartOffer", 60635);
					return SetPVarInt(playerid,"ApartPrice", 0);						
				}
			}
			else
			{
					SCM(GetPVarInt(playerid, "ApartOffer"), COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Игрок отказался покупать квартиру!");
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы отменили покупку!");

					SetPVarInt(playerid,"apartpokup",0);
					SetPVarInt(GetPVarInt(playerid, "ApartOffer"),"apartpokup",0);				
			}
		}							
		case DLG_SELLHOMEP:
		{
			if(!response) return true;
			new Float:x[3], params[2], string[250];
			GetPlayerPos(playerid, x[0], x[1], x[2]);
			if(sscanf(inputtext, "p<,>dd", params[0], params[1])) return SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}Продажа дома игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать дом:", "Далее", "Закрыть");
			if(params[0] == playerid) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Нельзя продавать самому себе!");
				return SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}Продажа дома игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать дом:", "Далее", "Закрыть");
			}
			if(player_info[params[0]][keyh] != -1) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У игрока уже есть дом!");
				return SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}Продажа дома игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать дом:", "Далее", "Закрыть");
			}		
			if(GetPVarInt(playerid,"housepokup") == 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Вы уже сделали предложение!");
			if(!strlen(inputtext)) return SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}Продажа дома игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать дом:", "Далее", "Закрыть");
			
			if(!IsPlayerConnected(params[0]) || params[0] == INVALID_PLAYER_ID) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Указанный вами игрок не в сети!");
				return SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}Продажа дома игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать дом:", "Далее", "Закрыть");
			}
			if(!IsPlayerInRangeOfPoint(params[0], 2.0, x[0], x[1], x[2])) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Указанный вами игрок должен находиться рядом с вами!");
				return SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}Продажа дома игроку", "{FFFFFF}Введите (id игрока) и сумму за которую хотите продать дом:", "Далее", "Закрыть");				
			}
			SetPVarInt(params[0],"HouseOffer", playerid);
			SetPVarInt(params[0],"HousePrice", params[1]);
			SetPVarInt(playerid,"housepokup",1);

			format(string, sizeof(string), "{FFFFFF}Игрок {EDD682}%s {FFFFFF}предлагает вам купить дом {EDD682}(№%d) {FFFFFF}за {EDD682}%d {FFFFFF}рублей", player_info[playerid][name], player_info[playerid][keyh], params[1]);	
			SPD(params[0], DLG_SELLHOMEP2, DSM, "{EDD682}Покупка дома", string, "Купить", "Отмена");
		}
		case DLG_SELLHOMEP2:
		{
			if(response)
			{
				if(GetPVarInt(playerid, "HouseOffer") != 60635)
				{
					new h = player_info[GetPVarInt(playerid, "HouseOffer")][keyh];
					if(player_info[playerid][money] < GetPVarInt(playerid, "HousePrice"))return SendClientMessage(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У вас нет столько денег на руках!");
					player_info[playerid][keyh] = player_info[GetPVarInt(playerid, "HouseOffer")][keyh];
					player_info[GetPVarInt(playerid, "HouseOffer")][keyh] = -1;
					_giveMoney(playerid, -GetPVarInt(playerid, "HousePrice"));
					_giveMoney(GetPVarInt(playerid, "HouseOffer"), GetPVarInt(playerid, "HousePrice"));
					strmid(house_info[h][h_owner], player_info[playerid][name], 0, strlen(player_info[playerid][name]), 255);

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keyh` = '%d' WHERE `id` = '%d'", player_info[playerid][keyh], player_info[playerid][id]);
					mysql_query(ConnectMysql, query);

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keyh` = '%d' WHERE `id` = '%d'", player_info[GetPVarInt(playerid, "HouseOffer")][keyh], player_info[GetPVarInt(playerid, "HouseOffer")][id]);
					mysql_query(ConnectMysql, query);		

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_owned` = '%d', `h_owner` = '%s' WHERE `hid` = '%d'", house_info[h][h_owned], player_info[playerid][name], house_info[h][hid]);
					mysql_query(ConnectMysql, query);

					SCM(GetPVarInt(playerid, "HouseOffer"), COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы успешно продали дом!");
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Поздравляем с покупкой дома!");


					SetPVarInt(GetPVarInt(playerid, "HouseOffer"),"housepokup",0);
					SetPVarInt(playerid, "HouseOffer", 60635);
					SetPVarInt(GetPVarInt(playerid, "HouseOffer"), "HouseOffer", 60635);
					return SetPVarInt(playerid,"HousePrice", 0);						
				}
			}
			else
			{
					SCM(GetPVarInt(playerid, "HouseOffer"), COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Игрок отказался покупать дом!");
					SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы отменили покупку!");

					SetPVarInt(playerid,"housepokup",0);
					SetPVarInt(GetPVarInt(playerid, "HouseOffer"),"housepokup",0);				
			}
		}	
		case DLG_CREATE:
		{
			if(!response) return true;
			switch(listitem)
			{
				case 0: 
				{
					SPD(playerid, DLG_CREATEHOUSE, DSI, "{EDD682}Создание нового дома", 
					"{FFFFFF}Введите через запятую цену будущего дома и его класс\n\
					1 - Эконом класс, 2 - Средний класс, 3 - Высокий класс", "Создать", "Отмена");	
				}
				case 1: SPD(playerid, DLG_CREATEPORCH, DSM, "{EDD682}Создание нового подъезда", "{FFFFFF}Вы действительно хотите создать новый подъезд?", "Да", "Нет");
				case 2: 
				{
					SPD(playerid, DLG_CREATEAPART, DSI, "{EDD682}Создание новоой квартиры", 
					"{FFFFFF}Введите через запятую цену будущей квартиры и её класс\n\
					1 - Эконом класс, 2 - Средний класс, 3 - Высокий класс", "Создать", "Отмена");	
				}				
			}				
		}
		case DLG_CREATEPORCH:
		{
			if(!response) return true;
			new string[110], Float:x, Float:y, Float:z;
			totalporch++;
			GetPlayerPos(playerid, x, y, z);
			porch_info[totalporch][pid] = totalporch;
			porch_info[totalporch][p_enter][0] = x;
			porch_info[totalporch][p_enter][1] = y;
			porch_info[totalporch][p_enter][2] = z;
			porch_info[totalporch][p_exit][0] = 887.49;
			porch_info[totalporch][p_exit][1] = 2142.17;
			porch_info[totalporch][p_exit][2] = 2002.42;

			// Создание таблицы
			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "INSERT INTO `porch` (`pid`, `p_enterx`, `p_entery`, `p_enterz`, `p_exitx`, `p_exity`, `p_exitz`) VALUES ('%d', '%f', '%f', '%f', '%f', '%f','%f')", 
			totalporch, porch_info[totalporch][p_enter][0], porch_info[totalporch][p_enter][1], porch_info[totalporch][p_enter][2], porch_info[totalporch][p_exit][0], porch_info[totalporch][p_exit][1], porch_info[totalporch][p_exit][2]);
			mysql_query(ConnectMysql, query);

			format(string, sizeof(string), "{FFFFFF}Вы успешно создали подъезд(№%d)!", totalporch);
			SCM(playerid, COLOR_WHITE, string);	

			format(string, sizeof(string), "{FFFFFF}Подъезд (№%d).\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", totalporch);
			porch_info[totalporch][p_pickup] = CreateDynamicPickup(19132, 23, porch_info[totalporch][p_enter][0], porch_info[totalporch][p_enter][1], porch_info[totalporch][p_enter][2],0, 0, -1);
			porch_info[totalporch][p_text] = Create3DTextLabel(string, COLOR_WHITE, porch_info[totalporch][p_enter][0], porch_info[totalporch][p_enter][1], porch_info[totalporch][p_enter][2], 20.0, 0, 1);
			porch_info[totalporch][p_texit] = Create3DTextLabel("{FFFFFF}Чтобы выйти, нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, porch_info[totalporch][p_exit][0], porch_info[totalporch][p_exit][1], porch_info[totalporch][p_exit][2], 20.0, totalporch+50, 1);
			porch_info[totalporch][p_floor1] = Create3DTextLabel("{FFFFFF}Чтобы подняться на этаж выше, нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, 884.0126, 2125.7830, 2002.4259, 20.0, totalporch+50, 1);
			porch_info[totalporch][p_floor2] = Create3DTextLabel("{FFFFFF}Чтобы спуститься на этаж ниже, нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, 884.0977, 2125.9177, 2006.2959, 20.0, totalporch+50, 1);								

		}
		case DLG_CREATEAPART:
		{
			if(!response) return true;
			new string[110], Float:x, Float:y, Float:z, params[2];
			if(sscanf(inputtext, "p<,>dd", params[0], params[1]))
			{
				SPD(playerid, DLG_CREATEAPART, DSI, "{EDD682}Создание новоой квартиры", 
				"{FFFFFF}Введите через запятую цену будущей квартиры и её класс\n\
				1 - Эконом класс, 2 - Средний класс, 3 - Высокий класс", "Создать", "Отмена");	
				return true;					
			}
			totalapart++;
			GetPlayerPos(playerid, x, y, z);
			apart_info[totalapart][aid] = totalapart;
			apart_info[totalapart][a_enter][0] = x;
			apart_info[totalapart][a_enter][1] = y;
			apart_info[totalapart][a_enter][2] = z;
			apart_info[totalapart][a_exit][0] = 395.2721;
			apart_info[totalapart][a_exit][1] = 2115.9849;
			apart_info[totalapart][a_exit][2] = -7.0600;
			apart_info[totalapart][a_money] = params[0];
			apart_info[totalapart][a_class] = params[1];
			apart_info[totalapart][a_world] = GetPlayerVirtualWorld(playerid);

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "INSERT INTO `apartament` (`aid`, `a_owned`, `a_owner`, `a_enterx`, `a_entery`, `a_enterz`, `a_exitx`, `a_exity`, `a_exitz`, `a_money`, `a_class`, `a_world`) VALUES ('%d', '0', 'пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ', '%f', '%f', '%f', '%f', '%f','%f', '%d', '%d', '%d')",
			totalapart, apart_info[totalapart][a_enter][0], apart_info[totalapart][a_enter][1], apart_info[totalapart][a_enter][2], apart_info[totalapart][a_exit][0], apart_info[totalapart][a_exit][1], apart_info[totalapart][a_exit][2],
			params[0], params[1], apart_info[totalapart][a_world]);
			mysql_query(ConnectMysql, query);

			format(string, sizeof(string), "{FFFFFF}Вы успешно создали квартиру(№%d)!", totalapart);
			SCM(playerid, COLOR_WHITE, string);
			apart_info[totalapart][a_text] = Create3DTextLabel("{FFFFFF}Квартира продаётся.\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[totalapart][a_enter][0], apart_info[totalapart][a_enter][1], apart_info[totalapart][a_enter][2], 20.0, apart_info[totalapart][a_world], 1);
			apart_info[totalapart][a_texit] = Create3DTextLabel("{FFFFFF}Чтобы выйти, нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[totalapart][a_exit][0], apart_info[totalapart][a_exit][1], apart_info[totalapart][a_exit][2], 20.0, totalapart+50, 1);																
		}
		case DLG_CREATEHOUSE:
		{
			if(!response) return true;
			new string[110], Float:x, Float:y, Float:z, params[2];
			if(sscanf(inputtext, "p<,>dd", params[0], params[1]))
			{
				SPD(playerid, DLG_CREATEHOUSE, DSI, "{EDD682}Создание нового дома", 
				"{FFFFFF}Введите через запятую цену будущего дома и его класс\n\
				1 - Эконом класс, 2 - Средний класс, 3 - Высокий класс", "Создать", "Отмена");
				return true;					
			}
			totalhouse++;
			GetPlayerPos(playerid, x, y, z);
			house_info[totalhouse][hid] = totalhouse;
			house_info[totalhouse][h_enter][0] = x;
			house_info[totalhouse][h_enter][1] = y;
			house_info[totalhouse][h_enter][2] = z;
			house_info[totalhouse][h_exit][0] = 195.9931;
			house_info[totalhouse][h_exit][1] = 87.9117;
			house_info[totalhouse][h_exit][2] = 1009.5609;
			house_info[totalhouse][h_money] = params[0];
			house_info[totalhouse][h_class] = params[1];					

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "INSERT INTO `house` (`hid`, `h_owned`, `h_owner`, `h_enterx`, `h_entery`, `h_enterz`, `h_exitx`, `h_exity`, `h_exitz`, `h_money`, `h_class`) VALUES ('%d', '0', 'пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ', '%f', '%f', '%f', '%f', '%f','%f', '%d', '%d')", 
			totalhouse, house_info[totalhouse][h_enter][0], house_info[totalhouse][h_enter][1], house_info[totalhouse][h_enter][2], house_info[totalhouse][h_exit][0], house_info[totalhouse][h_exit][1], house_info[totalhouse][h_exit][2],
			params[0], params[1]);
			mysql_query(ConnectMysql, query);

			format(string, sizeof(string), "{FFFFFF}Вы успешно создали дом(№%d)!", totalhouse);
			SCM(playerid, COLOR_WHITE, string);

			house_info[totalhouse][h_icon] = CreateDynamicMapIcon(house_info[totalhouse][h_enter][0], house_info[totalhouse][h_enter][1], house_info[totalhouse][h_enter][2], 31, -1, 0, -1, -1, 400.0);
			house_info[totalhouse][h_pickup] = CreateDynamicPickup(1273, 23, house_info[totalhouse][h_enter][0], house_info[totalhouse][h_enter][1], house_info[totalhouse][h_enter][2],0, 0, -1);
			house_info[totalhouse][h_text] = Create3DTextLabel("{FFFFFF}Дом продаётся.\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[totalhouse][h_enter][0], house_info[totalhouse][h_enter][1], house_info[totalhouse][h_enter][2], 20.0, 0, 1);
			house_info[totalhouse][h_texit] = Create3DTextLabel("{FFFFFF}Чтобы выйти, нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[totalhouse][h_exit][0], house_info[totalhouse][h_exit][1], house_info[totalhouse][h_exit][2], 20.0, totalhouse+50, 1);																
		}
		case DLG_APANEL:
		{
			if(!response) return true;
			switch(listitem)
			{
				case 0: _aCommands(playerid);
			}
		}
		case DLG_ACOMMAND:
		{
			if(!response) return SPD(playerid, DLG_APANEL, DSL, "{EDD682}AP - Панель администратора", "{FFFFFF}1. Команды администратора", "Выбрать", "Отмена");
			switch(listitem)
			{
				case 0: 
				{
					SPD(playerid, DLG_ACONE, DSL, "{EDD682}AP - Администратор 1-го уровня", 
					"{FFFFFF}/alogin - Авторизация в (AP)\n\
					/apanel - Панель администратора\n\
					/a - Чат администраторов\n\
					/world - Узнать виртуальный мир (свой)\n\
					/sethp - Установить кол-во здоровья\n\
					/setarm - Установить кол-во брони\n\
					/seteat - Установить кол-во еды\n\
					/setwater - Установить кол-во воды\n\
					/tpcoord - Телепорт по координатам(x,y,z)\n\
					/slap - Подкинуть игрока\n\
					/for - Подвинуть игрока\n\
					/freeze - Заморозить игрока", "Назад", "");										
				}
				case 1: 
				{
					SPD(playerid, DLG_ACTWO, DSL, "{EDD682}AP - Администратор 2-го уровня", 
					"{FFFFFF}/gethere - Телепортировать игрока к себе\n\
					/goto - Телепортироваться к игроку\n\
					/veh - Создать автомобиль администратора\n\
					/hpcar - Установить кол-во здоровья машине\n\
					/sefuel - Установить кол-во топлива в машине\n\
					/dellveh - Удалить созданную машину\n\
					/dellvehr - Удалить созданные машины в радиусе\n\
					/setskin - Установить временную внешность игроку\n\
					/givegun - Выдать оружие игроку\n\
					/kick - Кикнуть игрока с сервера\n\
					/skick - Тихо кикнуть игрока с сервера\n\
					/mute - Заблокировать чат игроку\n\
					/unmute - Разблокировать чат игроку", "Назад", "");									
				}
				case 2: 
				{
					SPD(playerid, DLG_ACTHREE, DSL, "{EDD682}AP - Администратор 3-го уровня", 
					"{FFFFFF}/clearchat - Очистить чат всем игрокам\n\
					/setweather - Установить погоду на сервере", "Назад", "");					
				}
				case 3: 
				{
					SPD(playerid, DLG_ACFOUR, DSL, "{EDD682}AP - Администратор 4-го уровня", 
					"{FFFFFF}/set_lvl - Изменить уровень игроку\n\
					/set_leader - Выдать права лидерства игроку", "Назад", "");						
				}
				case 4: 
				{
					if(admin_info[playerid][alevel] < 5) return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Доступ запрещён!");	
					SPD(playerid, DLG_ACFIVE, DSL, "{EDD682}AP - Администратор 5-го уровня", 
					"{FFFFFF}/set_admin - Выдать права администратора игроку\n\
					/set_money - Выдать деньги игроку\n\
					/create - Меню создания (домов, квартир и т.д.)\n\
					/payday - Вызвать PayDay всем игрокам", "Назад", "");						
				}				
			}
		}
		case DLG_ACONE..DLG_ACFIVE: _aCommands(playerid);
		case DLG_BUYCAR:
		{
			if(!response) return RemovePlayerFromVehicle(playerid);
			{
				new string[144], color = random(127);
				if(player_info[playerid][p_model] != 0) 
				{
					SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У вас уже имеется автомобиль!");
					return RemovePlayerFromVehicle(playerid);
				}
				if(player_info[playerid][money] < _priceCar(GetPlayerVehicleID(playerid)))
				{
					SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}У вас не хватате денег для покупки этого автомобиля!");
					return RemovePlayerFromVehicle(playerid);
				}
				player_info[playerid][p_model] = GetVehicleModel(GetPlayerVehicleID(playerid));
				player_info[playerid][p_color1] = color;
				player_info[playerid][p_color1] = color;
				player_info[playerid][p_posx] = 306.9107; 
				player_info[playerid][p_posy] = 1766.6956; 
				player_info[playerid][p_posz] = 11.6933;
				player_info[playerid][p_posfa] = 266.0667;
				_giveMoney(playerid, -_priceCar(GetPlayerVehicleID(playerid)));
				format(string, sizeof(string), "{EDD682}[Уведомление]: {FFFFFF}Поздравляем, Вы приобрели автомобиль {EDD682}%s {FFFFFF}за {EDD682}%d {FFFFFF}рублей.", VehicleNames[player_info[playerid][p_model]-400], _priceCar(GetPlayerVehicleID(playerid)));
				SCM(playerid, COLOR_WHITE, string);

				mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `p_model` = '%d', `p_posx` = '%f', `p_posy` = '%f', `p_posz` = '%f', `p_posfa` = '%f', `p_color1` = '%d', `p_color1` = '%d' WHERE `id` = '%d'", 
				player_info[playerid][p_model], player_info[playerid][p_posx], player_info[playerid][p_posy], player_info[playerid][p_posz], player_info[playerid][p_posfa], player_info[playerid][p_color1], player_info[playerid][p_color2], player_info[playerid][id]);
				mysql_query(ConnectMysql, query);

				/*mysql_format(ConnectMysql, query, sizeof(query), "INSERT INTO `player_vehicle` (`id`,`v_model`, `v_owner`, `v_posx`, `v_posy`, `v_posz`, `v_posfa`, `v_color01`, `v_color02`, `v_money`, `v_world`, `v_interior`, `v_plate`, `v_fuel`, `v_millage`, `v_health`, `v_if_buy`) VALUES \n\
				('%d', '%d', '%s', '%f', '%f', '%f', '%f','%d', '%d', '%d', '%d', '%d','%d', '%f', '%f', '%f', '%d')", v,vehicle_info[vehicleid][v_model], player_info[playerid][name], vehicle_info[vehicleid][v_posx], vehicle_info[vehicleid][v_posy], vehicle_info[vehicleid][v_posz], vehicle_info[vehicleid][v_posfa],
				vehicle_info[vehicleid][v_color01], vehicle_info[vehicleid][v_color02], vehicle_info[vehicleid][v_money], vehicle_info[vehicleid][v_world], vehicle_info[vehicleid][v_interior], vehicle_info[vehicleid][v_plate], vehicle_info[vehicleid][v_fuel], vehicle_info[vehicleid][v_millage], vehicle_info[vehicleid][v_health], vehicle_info[vehicleid][v_if_buy]);
				mysql_query(ConnectMysql, query);*/

				RemovePlayerFromVehicle(playerid);

			}
		}
		case DLG_PRULES_ONE:
		{
			if(response)
			{
				SPD(playerid, DLG_PRULES_TWO, DSM, 
				"{EDD682}Правила игрока", 
				"{FFFFFF}Администратор — должностное лицо на сервере, корректирующее и следящее за соблюдением правил от игроков\n\
				Хелпер — должностное лицо на сервере, наделенное правом помощи в решении вопросов по игровому процессу\n\
				Slap (пинок) — возможное наказание, используется в виде предупреждения\n\
				Kick (кик) — наказание за нарушение правил от администрации сервера, которое единоразово прерывает текущую игровую сессию\n\
				Mute (затычка/блокировка чата) — наказание за нарушение правил сервера, ограничивающее написание сообщений в чат и отправку некоторых команд на определенный срок\n\
				Voice Mute (затычка голосового чата) — наказание за нарушение правил сервера, ограничивающее использование голосового чата\n\
				Деморган — наказание за нарушение правил сервера от администрации; место, в котором определенное количество времени сидит нарушивший правила сервера игрок\n\
				Warn (предупреждение) — наказание за нарушение правил сервера, которое ограничивает вступление во фракцию на определенный срок\n\
				Ban (блокировка) — наказание за нарушение правил сервера, которое ограничивает вход в игру на определенный срок\n\
				Деактивация аккаунта — наказание за грубое нарушение правил сервера, которое может быть выдано или аннулировано только специальной администрацией или разработчиками",
				"Далее", "Назад");									
			}
			else
			{
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
			}
		}
		case DLG_PRULES_TWO:
		{
			if(!response) return _rulesPlayer(playerid);
			SPD(playerid, DLG_PRULES_THREE, DSM, 
			"{EDD682}Правила игрока", 
			"{FFFFFF}Away From Keyboard (AFK) — время, когда кто—либо уходит от своего игрового места и оставляет персонажа в бездействии\n\
			Флуд — частая отправка одинакового, либо не отличающегося по смыслу текста\n\
			Оффтоп — сообщения не по теме\n\
			Caps Lock — сообщения, написанные с помощью верхнего регистра, например «ПРИВЕТ»\n\
			Spawn — место появления игрового персонажа\n\
			Провокация на нарушение — подстрекательство другого игрока к совершению нарушения правил(а) проекта или сервер",
			"Назад", "");				
		}
		case DLG_PRULES_THREE:
		{
			SPD(playerid, DLG_PRULES_TWO, DSM, 
			"{EDD682}Правила игрока", 
			"{FFFFFF}Администратор — должностное лицо на сервере, корректирующее и следящее за соблюдением правил от игроков\n\
			Хелпер — должностное лицо на сервере, наделенное правом помощи в решении вопросов по игровому процессу\n\
			Slap (пинок) — возможное наказание, используется в виде предупреждения\n\
			Kick (кик) — наказание за нарушение правил от администрации сервера, которое единоразово прерывает текущую игровую сессию\n\
			Mute (затычка/блокировка чата) — наказание за нарушение правил сервера, ограничивающее написание сообщений в чат и отправку некоторых команд на определенный срок\n\
			Voice Mute (затычка голосового чата) — наказание за нарушение правил сервера, ограничивающее использование голосового чата\n\
			Деморган — наказание за нарушение правил сервера от администрации; место, в котором определенное количество времени сидит нарушивший правила сервера игрок\n\
			Warn (предупреждение) — наказание за нарушение правил сервера, которое ограничивает вступление во фракцию на определенный срок\n\
			Ban (блокировка) — наказание за нарушение правил сервера, которое ограничивает вход в игру на определенный срок\n\
			Деактивация аккаунта — наказание за грубое нарушение правил сервера, которое может быть выдано или аннулировано только специальной администрацией или разработчиками",
			"Далее", "Назад");				
		}	
		case DLG_INVITE:
		{
			new string[105];
			new actplayerid = GetPVarInt(playerid, "_invitePlayer");
			if(response)
			{
				player_info[playerid][member] = player_info[actplayerid][member];
				player_info[playerid][rang] = 1;

				format(string, sizeof(string), "{EDD682}[Уведомление] {FFFFFF}Вы успешно присоединилсь к %s", _fracName(playerid));
				SCM(playerid, COLOR_WHITE, string);

				format(string, sizeof(string), "{EDD682}[Уведомление] {FFFFFF}Игрок %s[%d] принял ваше пригашение!", player_info[playerid][name], playerid);
				SCM(actplayerid, COLOR_WHITE, string);
				SCM(actplayerid, COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Не забудьте выдать одежду новому сотруднику - {EDD682}'/changeskin'{FFFFFF}!");
				
				DeletePVar(playerid, "_inviteGo");
				DeletePVar(actplayerid, "_invitePlayer");
			}
			else
			{
				format(string, sizeof(string), "{EDD682}[Уведомление] {FFFFFF}Игрок %s[%d] отказался от вашего пригашение!", player_info[playerid][name], playerid);
				SCM(actplayerid, COLOR_WHITE, string);	

				SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Вы отказались от приглашения!");

				DeletePVar(playerid, "_inviteGo");
				DeletePVar(actplayerid, "_invitePlayer");			
			}
		}
		case DLG_LPANEL:
		{
			if(!response) return true;
			switch(listitem)
			{
				case 0:
				{
					query[0] = EOS;
					mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `accounts` WHERE `member` = '%d'", player_info[playerid][member]);
					mysql_tquery(ConnectMysql, query, "AllMembersFraction", "d", playerid);						
				}
				case 1:
				{
					SCM(playerid, COLOR_WHITE, "В разработке");					
				}				
			}
		}
	}		
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(admin_info[playerid][alevel] >= 1)
	{
		SetPlayerPos(playerid, fX, fY, fZ);
		return 1;
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		if(GetPVarInt(playerid, "ignore_invalid_td") == 1)
		{
			DeletePVar(playerid, "ignore_invalid_td");
		}
		else
		{
			SelectTextDraw(playerid, 0xF7EDBCFF);
		}
		return 1;
	}	
    if(clickedid == skinTextDraw[4])//стрелка в право
	{
		if(player_info[playerid][sex] == 1)
		{
		    SetPVarInt(playerid, "@clothes", GetPVarInt(playerid, "@clothes") +1);
			if(GetPVarInt(playerid, "@clothes") >= 3) SetPVarInt(playerid, "@clothes",0);
			SetPlayerSkin(playerid, skinRegister[GetPVarInt(playerid, "@clothes")][0]);		
		}
		else
		{
			SetPVarInt(playerid, "@clothes", GetPVarInt(playerid, "@clothes") +1);
			if(GetPVarInt(playerid, "@clothes") >= 6) SetPVarInt(playerid, "@clothes",3);
			SetPlayerSkin(playerid, skinRegister[GetPVarInt(playerid, "@clothes")][0]);			
		}
	}
    if(clickedid == skinTextDraw[3])//стрелка влево
	{
		if(player_info[playerid][sex] == 1)
		{		
			SetPVarInt(playerid, "@clothes", GetPVarInt(playerid, "@clothes") -1);
			if(GetPVarInt(playerid, "@clothes") < 0) SetPVarInt(playerid, "@clothes", 3-1);
			SetPlayerSkin(playerid, skinRegister[GetPVarInt(playerid, "@clothes")][0]);
		}
		else
		{
			SetPVarInt(playerid, "@clothes", GetPVarInt(playerid, "@clothes") -1);
			if(GetPVarInt(playerid, "@clothes") < 3) SetPVarInt(playerid, "@clothes", 6-1);
			SetPlayerSkin(playerid, skinRegister[GetPVarInt(playerid, "@clothes")][0]);			
		}	
	}
	if(clickedid == skinTextDraw[2])//Играть
	{
		for(new i; i < 6 ; i ++) TextDrawHideForPlayer(playerid,skinTextDraw[i]);
		CancelSelectTextDraw(playerid);
		player_info[playerid][skin] = GetPlayerSkin(playerid);
		DeletePVar(playerid, "@skin_reg");
		DeletePVar(playerid, "@clothes");
		SetPlayerCameraPos(playerid, 56.0581, -2009.6455, 29.1218);
		SetPlayerCameraLookAt(playerid, 56.9952, -2009.2853, 29.0568);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);

		new Year, Month, Day;
		getdate(Year, Month, Day);
		new regdate[13];
		format(regdate, sizeof(regdate), "%02d.%02d.%d", Day, Month, Year);
		new ip[16];
		GetPlayerIp(playerid, ip, sizeof(ip));

		query[0] = EOS;
		mysql_format(ConnectMysql, query, sizeof(query), "INSERT INTO `accounts` (`name`, `password`, `salt`, `email`, `ref`, `sex`, `age`, `skin`, `regdata`, `logindata`, `regip`) VALUES ('%s', '%s', '%s', '%s', '%d', '%d', '%d', '%d', '%s', '%s', '%s')", player_info[playerid][name], player_info[playerid][pass], player_info[playerid][salt], player_info[playerid][email], player_info[playerid][ref], player_info[playerid][sex], player_info[playerid][age], player_info[playerid][skin], regdate, regdate, ip);
		mysql_query(ConnectMysql, query);
		
		query[0] = EOS;
		mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `accounts` WHERE `name` = '%s' AND `password` = '%s'", player_info[playerid][name], player_info[playerid][pass]);
		mysql_tquery(ConnectMysql, query, "PlayerLogin", "i", playerid);

		SCM(playerid, COLOR_WHITE, !"Вы успешно зарегистрировались на проекте {EDD682}Russian History | CR Multiplayer! {FFFFFF}Удачной игры!");

		SetSpawnInfo(playerid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);	
		SpawnPlayer(playerid);	

		SetPlayerPos(playerid, _playerSpawn[0][0], _playerSpawn[0][1], _playerSpawn[0][2]);
		SetPlayerFacingAngle(playerid, _playerSpawn[0][3]);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetCameraBehindPlayer(playerid);
		_infoPlayer(playerid);

		SetPVarInt(playerid, "ignore_invalid_td", 1);
	}
	return 0;
}

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
#include <mdialog>

#include "../library/a_define.inc"			// --------- [������������ �������]       
#include "../library/a_array.inc"			// --------- [���������� ����������]
#include "../library/a_publics.inc"			// --------- [�������� ��������]
#include "../library/a_stocks.inc"			// --------- [�������� ������]
#include "../library/a_admincmd.inc"		// --------- [������� ��������������]
#include "../library/a_playercmd.inc"		// --------- [������� ������]


main()	{	print("** Successful launch of the Russian Role Play server! **\n");	
			print("** >>> �������� �����������:\n");
		}


public OnGameModeInit()
{
	#include "../library/objects/a_allobject.inc"		// --------- [�������� ���������� ��������]
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

	//�������
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
	_vorotafrac();
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


	static animlibs[131][] = // ���������� ������� ��� ������ ��� ��������, ��� ���������� ���������� ����� � ����������
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

	#include "../library/objects/a_remove-objects.inc"		// --------- [�������� ��������� ��������]
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(pCarID[playerid] != INVALID_VEHICLE_ID)
	{
		DestroyVehicle(pCarID[playerid]);
		pCarID[playerid] = INVALID_VEHICLE_ID;
	}
    // ���������, ��������� �� ����� ���������
    if(_carRented[playerid])
    {
		// ������� ���������� ������
		SetVehicleToRespawn(_rentedCarID[playerid]);
		// �������� ������ �� ������
        _carRented[playerid] = false;
        _rentedCarID[playerid] = -1; // -1 ��������, ��� ���������� �� ���������
		KillTimer(_arendaTimer[playerid]);
		timeLeft[playerid] = TIMEARENDA;
    }	
	GetPlayerArmour(playerid, player_info[playerid][armor]);
	GetPlayerHealth(playerid, player_info[playerid][health]);
	GetPlayerPos(playerid, player_info[playerid][exitx], player_info[playerid][exity], player_info[playerid][exitz]);
	GetPlayerFacingAngle(playerid, player_info[playerid][exitfa]);
	player_info[playerid][p_world] = GetPlayerVirtualWorld(playerid);
	player_info[playerid][p_interior] = GetPlayerInterior(playerid);
	_savePlayerAccount(playerid);
	KillTimer(mute_timer[playerid]);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(temp_info[playerid][pLoginStatus] != true)
	{
        SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}��� ���� �� ������� ���������� ��������������.");
        return 0;
	}
   	if(GetPVarInt(playerid, "@skin_reg") == 1)
    {
 		SetPlayerPos(playerid, 201.97289, -128.07918, 1003.51062);//������� ������
    	SetPlayerFacingAngle(playerid, 180.00000);//�������
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 3);
    	SetPlayerCameraPos(playerid, 201.6538, -133.1275, 1004.1354);//������� ������
    	SetPlayerCameraLookAt(playerid, 201.6471, -132.1290, 1003.9761);//������� ������
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

	// ���������� ������

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
        SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}���������������, ����� ������������ ���.");
        return 0;
	}
	if(IsPlayerMuted(playerid)) return 0;
	new string[144];
	if(strlen(text) < 113)
	{
		format(string, sizeof(string), "%s[%d] �������: %s", player_info[playerid][name], playerid, text);
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
	    SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}��������� ������� �������!");
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
	if(vehicleid >= _carArenda[0] && vehicleid <= _carArenda[1])
	{	
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(_rentedCarID[i] == vehicleid && i != playerid && ispassenger == 0)
			{
				SendClientMessage(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}���� ���������� ��������� ������ �������!");
				ClearAnimations(playerid, true);
				return 0;
			}
		}
	}	
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(vehicleid >= _carArenda[0] && vehicleid <= _carArenda[1])
	{
		if(_carRented[playerid])
		{
			_arendaTimer[playerid] = SetTimerEx("_arendaPlayerTimer", 1000, true, "i", playerid);
			SCM(playerid, COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}� ��� ���� 10 �����, ����� �������� � ���������!");
			return 1;
		}
	}
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
				SCM(playerid, COLOR_WHITE, "{EDD682}[���c�����]: {FFFFFF}����� ������� ��������� ������� �� {EDD682}\"LCTRL\"{FFFFFF}, �������� ���� {EDD682}\"LALT\".");
				TextDrawShowForPlayer(playerid, SPEEDTD);
				for(new i; i < 6; i++) PlayerTextDrawShow(playerid, SPEEDPTD[i][playerid]);
				speedtimer[playerid] = SetTimerEx("TransportUpdate", 300, true, "i", playerid);
				speedtimertwo[playerid] = SetTimerEx("TransportUpdateTwo", 50, true, "i", playerid);
				VehicleDriverID[vehicleid] = playerid;
				PlayerVehicleID[playerid] = vehicleid;		
			}
			if(vehicleid >= lead_one[0] && vehicleid <= lead_one[1])
			{
				if(player_info[playerid][leader] != 1 || player_info[playerid][member] != 1)
				{
				    SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� ��� ������ �� ����� ����������!");
					RemovePlayerFromVehicle(playerid);
				}
				return true;
			}
			if(vehicleid >= _ppsCar[0] && vehicleid <= _ppsCar[1])
			{
				if(player_info[playerid][leader] != 1 || player_info[playerid][member] != 2)
				{
				    SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� ��� ������ �� ����� ����������!");
					RemovePlayerFromVehicle(playerid);
				}
				return true;
			}						
			/*if(GetPlayerVehicleID(playerid) >= _carsBuyEconomy[0] && GetPlayerVehicleID(playerid) <= _carsBuyEconomy[1])
			{
				new string[174];
				format(string, sizeof(string), "{FFFFFF}����� ����������: %s\n��������� ����������: %d", VehicleNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400], _priceCar(GetPlayerVehicleID(playerid)));
				SPD(playerid, DLG_BUYCAR, DSM, "{EDD682}��������� ������ ������", string, "����������", "�����");
			}	*/	
			if(_heliCar(GetPlayerVehicleID(playerid)) && player_info[playerid][lic][1] < 1)
				return SendClientMessage(playerid, COLOR_WHITEOR, "{EDD682}[������]: {FFFFFF}��� �������� �� ����� ��������� ���������/����������!"), RemovePlayerFromVehicle(playerid);
			else if(_shipCar(GetPlayerVehicleID(playerid)) && player_info[playerid][lic][2] < 1)
				return SCM(playerid, COLOR_WHITEOR, "{EDD682}[������]: {FFFFFF}��� �������� �� ����� ��������� ������!"), RemovePlayerFromVehicle(playerid);
			else
			{
				if(player_info[playerid][lic][0] < 1)
					return SCM(playerid, COLOR_WHITEOR, "{EDD682}[������]: {FFFFFF}��� ���������� �������� ���������, ����� ������ �� ���� ����������!"), RemovePlayerFromVehicle(playerid);
			}
			if(vehicleid >= _carArenda[0] && vehicleid <= _carArenda[1])
			{
				if(_carRented[playerid] && _rentedCarID[playerid] != vehicleid)
				{
					SendClientMessage(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}�� ��� ��������� ���� �� �����������!");
					RemovePlayerFromVehicle(playerid);
					return 0;
				}			
				else if(!_carRented[playerid])
				{
					// ���� ����� ��� �� ��������� ����������, ���������� ���������� ���� ������
					new text[190];
					format(text, sizeof(text), "{FFFFFF}���������� �������� ������ ����������\n�����: {EDD682}%s\n{FFFFFF}���� ������: {EDD682}5000 ���.������\n{FFFFFF}���� ������: {EDD682}�������������", VehicleNames[GetVehicleModel(vehicleid) - 400]);
					SPD(playerid, DLG_ARENDACAR, DSM, "{EDD682}������ ����������", text, "����������", "������");
					return 1;
				}
				KillTimer(_arendaTimer[playerid]);
				timeLeft[playerid] = TIMEARENDA;	
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
	if(pickupid == bank[0]) // - ���� � ����
	{
		SetPlayerPos(playerid, 2375.7273, -1907.8339, 1126.9100);
		SetPlayerFacingAngle(playerid, 356.9003);
		SetPlayerVirtualWorld(playerid, 1);
		SetPlayerInterior(playerid, 0);
		_freezePlayerPickup(playerid);
		SetCameraBehindPlayer(playerid);
		SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� �������� ����������� ���� �.�����.");		
	}
	if(pickupid == bank[1]) // - ����� � �����
	{
		SetPlayerPos(playerid, 2376.4312, -2142.4109, 21.9582);
		SetPlayerFacingAngle(playerid, 175.1358);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetCameraBehindPlayer(playerid);
		_freezePlayerPickup(playerid);
	}
	if(pickupid == hospital[0]) // ���� � �������� �.�����
	{
		SetPlayerPos(playerid, 367.2120, 127.5249, 1003.8500);
		SetPlayerFacingAngle(playerid, 4.7312);
		SetPlayerVirtualWorld(playerid, 2);
		SetPlayerInterior(playerid, 10);
		_freezePlayerPickup(playerid);
		SetCameraBehindPlayer(playerid);
	}
	if(pickupid == hospital[1]) // ����� � �������� �.�����
	{
		if(player_info[playerid][hospitaltime] > 0) return SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}���� ������� �� �����������! �����!");
		SetPlayerPos(playerid, 2113.8765, -2389.9683, 22.6821);
		SetPlayerFacingAngle(playerid, 358.3461);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetCameraBehindPlayer(playerid);
		_freezePlayerPickup(playerid);
	}	
	if(pickupid >= eda[0] && pickupid <= eda[1])
	{
		if(player_info[playerid][lvl] > 2) return SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� �� ������ ��������������� ���� �������!");
		SPD(playerid, DLG_EDA, DSL, "{EDD682}����������� - {FFFFFF}������ �����������", 
		"{EDD682}[1]{FFFFFF} - ������ ����� �����\n\
		 {EDD682}[2]{FFFFFF} - ������ ������ ����", "�������", "�������");
	}
	if(pickupid == _pickupm[0]) // ���� � ������������� ���.��������
	{
		SetPlayerPos(playerid, 1581.9480, -773.9850, 1114.7073);
		SetPlayerFacingAngle(playerid, 91.3615);
		SetPlayerVirtualWorld(playerid, 1);
		SetPlayerInterior(playerid, 3);
		SetCameraBehindPlayer(playerid);
		_freezePlayerPickup(playerid);
	}
	if(pickupid == _pickupm[1]) // ����� �� ������������� ���.��������
	{
		SetPlayerPos(playerid, 1819.6837, 2095.8936, 16.1631);
		SetPlayerFacingAngle(playerid, 268.4799);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetCameraBehindPlayer(playerid);
		_freezePlayerPickup(playerid);
	}
	if(pickupid == _pickupp[0]) // ������� ���� � ���
	{
		SetPlayerPos(playerid, 589.9663, 0.7244, 1022.9027);
		SetPlayerFacingAngle(playerid, 269.9388);
		SetPlayerVirtualWorld(playerid, 2);
		SetPlayerInterior(playerid, 2);
		SetCameraBehindPlayer(playerid);
		_freezePlayerPickup(playerid);
	}
	if(pickupid == _pickupp[1]) // ����� �� ������� ���� ���
	{
		SetPlayerPos(playerid, 1916.6981, 2183.4639, 15.7060);
		SetPlayerFacingAngle(playerid, 90.2773);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetCameraBehindPlayer(playerid);
		_freezePlayerPickup(playerid);
	}
	if(pickupid == _pickupp[2]) // ����� � ��� �� �����
	{
		SetPlayerPos(playerid, 593.1398, -20.2226, 1022.9027);
		SetPlayerFacingAngle(playerid, 356.0204);
		SetPlayerVirtualWorld(playerid, 2);
		SetPlayerInterior(playerid, 2);
		SetCameraBehindPlayer(playerid);
		_freezePlayerPickup(playerid);
	}
	if(pickupid == _pickupp[3]) // ����� �� ��� �� ����
	{
		SetPlayerPos(playerid, 1939.0422, 2160.8840, 15.6982);
		SetPlayerFacingAngle(playerid, 266.9760);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetCameraBehindPlayer(playerid);
		_freezePlayerPickup(playerid);
	}		
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == bank[2]) // - ���� � ����
	{
		if(player_info[playerid][bank_pin][0] == 0)
		{
			SPD(playerid, DLG_CREATEBANKPIN, DSP, "{EDD682}���� - {FFFFFF}���������� �����", 
			"{FFFFFF}���� ������ ��� � ����� �����!\n\
			�������� ���������� ����, ����� ��������������� ������ ��������.\n\
			���������� ������� PIN-��� � �������� ��� � ���� ����:\n\
			\n\
			{EDD682}(PIN-��� ������ ������� �� 4 �������� � ���������� � 0! ������: 1111)", "��������", "�������");	
		}
		else if(player_info[playerid][bank_pin][0] == 1)
		{
			SPD(playerid, DLG_LOGINBANK, DSP, "{EDD682}���� - {FFFFFF}�������������", 
			"{FFFFFF}������� ��� PIN-��� �� ����������� ����� � ���� ����:\n\
			{EDD682}(���� �� ������ ���� PIN-���, ���������� � ������������� �������)", "�����", "�������");			
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
					format(string, sizeof(string), "{FFFFFF}��������: %s\n����� ����: %d", house_info[h][h_owner], h);
					SPD(playerid, DLG_HOME, DSM, "��� �� ��������", string, "�����", "������");
				}
				else
				{
					switch(house_info[h][h_class])
					{
						case 1: text = "������ �����";
						case 2: text = "������� �����";
						case 3: text = "������� �����";
					}
					format(string, sizeof(string), "{FFFFFF}����� ����:\t%s\n����� ����:\t%d\n\n���������:\t%d", text, h, house_info[h][h_money]);
					SPD(playerid, DLG_HOMEBUY, DSM, "��� ��������", string, "������"," ������");
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
					format(string, sizeof(string), "{FFFFFF}��������: %s\n����� ��������: %d", apart_info[a][a_owner], a);
					SPD(playerid, DLG_APART, DSM, "�������� �� ��������", string, "�����", "������");
				}
				else
				{
					switch(apart_info[a][a_class])
					{
						case 1: text = "������ �����";
						case 2: text = "������� �����";
						case 3: text = "������� �����";
					}
					format(string, sizeof(string), "{FFFFFF}����� ��������:\t%s\n����� ��������:\t%d\n\n���������:\t%d", text, a, apart_info[a][a_money]);
					SPD(playerid, DLG_APARTBUY, DSM, "�������� ��������", string, "������"," ������");
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
	if(newkeys == 2 && IsPlayerInAnyVehicle(playerid) || newkeys == KEY_WALK && !IsPlayerInAnyVehicle(playerid))
	{
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1819.0574, 2129.1787, 15.8471)) return true;
		if(player_info[playerid][member] != 1) return true;
		if(GetPVarInt(playerid, "_gateopen") == 1) return true;
		SetPVarInt(playerid, "_gateopen", 1);
		MoveDynamicObject(_admopen, 1818.65, 2125.52, 15.63+0.004, 0.01, 0.00, 0.00, 90.00);
		SendClientMessage(playerid, COLOR_WHITE,"�������� ��������� ����� 7 ������!");
		SetTimerEx("_adMclose", 7000, false, "d", playerid);	
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
			format(string,sizeof(string),"{FFFFFF}����� ������ ���: {EDD682}%s", ConvertSeconds(temp_info[playerid][PlayerAFK]));  
			SendClientMessage(playerid, COLOR_WHITE, string);  
			SetPlayerChatBubble(playerid, "���: ���������", COLOR_WHITE, 10.0, 1); 
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
					return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� ������ � ���� ���� � ������� \"�����\".");
				}
				if(strlen(inputtext) < 8 || strlen(inputtext) > 32)
				{
					_showRegistration(playerid);
					return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����� ������ ������ ���� �� 8-�� �� 32-�� ��������.");
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
					regex_delete(rg_passwordcheck);
					SPD(playerid, DLG_REGEMAIL, DSI, "{EDD682}����������� {FFFFFF}| ���� Email",
					"{FFFFFF}���� �� ��������� ������ � ��������, �� ������� ������������ ��� ����� Email\n\
					������� ��� ��������� Email, ����� ������� �� ������ \"�����\"", "�����", "");
				}
				else
				{
					_showRegistration(playerid);
					regex_delete(rg_passwordcheck);
					return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������ ������ �������� ������ �� ���� � ��������� ��������.");
				}
			}
			else
			{
				SCM(playerid, COLOR_ERROR, "����������� \"/q\", ����� �������� ������.");
				return Kick(playerid);
			}
		}
		case DLG_REGEMAIL:
		{
			if(!strlen(inputtext))
			{
				SPD(playerid, DLG_REGEMAIL, DSI, "{EDD682}����������� {FFFFFF}| ���� Email",
				"{FFFFFF}���� �� ��������� ������ � ��������, �� ������� ������������ ��� ����� Email\n\
				������� ��� ��������� Email, ����� ������� �� ������ \"�����\"", "�����", "");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� Email � ���� ���� � ������� \"�����\".");
			}
			new regex:rg_emailcheck = regex_new("^([-A-Za-z0-9_]+\\.)*[-A-Za-z0-9_]+@([A-Za-z0-9][-A-Za-z0-9]*\\.)+[A-Za-z]{2,6}$");
			if(regex_check(inputtext, rg_emailcheck))
			{
				strmid(player_info[playerid][email], inputtext, 0, strlen(inputtext), 64);
				SPD(playerid, DLG_REGREF, DSI, "{EDD682}����������� {FFFFFF}| ���� �������������",
				"{FFFFFF}�� ������ ������� ��� ������������� ���� ��������\n\
				��� ����� ������ ������ ��� � ���� ����, ���� ����� �� ������ \"����������\"",
				"�����", "����������");
			}
			else
			{
				SPD(playerid, DLG_REGEMAIL, DSI, "{EDD682}����������� {FFFFFF}| ���� Email",
				"{FFFFFF}���� �� ��������� ������ � ��������, �� ������� ������������ ��� ����� Email\n\
				������� ��� ��������� Email, ����� ������� �� ������ \"�����\"", "�����", "");
				regex_delete(rg_emailcheck);
				return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������, ��������� ������� ��� Email � ������� \"�����\".");
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
				SPD(playerid, DLG_REGSEX, DSM, "{EDD682}����������� {FFFFFF}| ����� ����",
				"{FFFFFF}�������� ��� ������ �������� ���������",
				"�������", "�������");
			}
		}
		case DLG_REGSEX:
		{
			if(response) player_info[playerid][sex] = 1;
			else player_info[playerid][sex] = 2;
			SPD(playerid, DLG_REGAGE, DSI, "{EDD682}����������� {FFFFFF}| ����� �������� ���������",
			"{FFFFFF}������� ������� ������ �������� ���������\n\n\
			{EDD682}����������:\n\
			1. ������� ��������� ������ ���� �� 18-�� �� 30-�� ���",
			"�����", "");
		}
		case DLG_REGAGE:
		{
			if(!strlen(inputtext))
			{
				SPD(playerid, DLG_REGAGE, DSI, "{EDD682}����������� {FFFFFF}| ����� �������� ���������",
				"{FFFFFF}������� ������� ������ �������� ���������\n\n\
				{EDD682}����������:\n\
				1. ������� ��������� ������ ���� �� 18-�� �� 30-�� ���",
				"�����", "");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� ������� ������ �������� ��������� � ������� \"�����\".");
			}
			if(strval(inputtext) < 18 || strval(inputtext) > 30)
			{
				SPD(playerid, DLG_REGAGE, DSI, "{EDD682}����������� {FFFFFF}| ����� �������� ���������",
				"{FFFFFF}������� ������� ������ �������� ���������\n\n\
				{EDD682}����������:\n\
				1. ������� ��������� ������ ���� �� 18-�� �� 30-�� ���",
				"�����", "");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� ��������� ������ ���� �� 18-�� �� 30-�� ���.");
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
							SPD(playerid, DLG_SPAWN, DSL, "{EDD682}����������� {FFFFFF}| Spawn", "{FFFFFF}1. ����� �� �����������\n2. ����� � �����������\n3. ����� � ����������� ����\n\
							4. ����� � ����������� ��������\n5. ����� � ���������\n6. ����� �� ����� ������", "�������", "������");	
							return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}�� �� �������� � �����������!");			
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
							SPD(playerid, DLG_SPAWN, DSL, "{EDD682}����������� {FFFFFF}| Spawn", "{FFFFFF}1. ����� �� �����������\n2. ����� � �����������\n3. ����� � ����������� ����\n\
							4. ����� � ����������� ��������\n5. ����� � ���������\n6. ����� �� ����� ������", "�������", "������");							
							return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� ��� ����!");
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
							SPD(playerid, DLG_SPAWN, DSL, "{EDD682}����������� {FFFFFF}| Spawn", "{FFFFFF}1. ����� �� �����������\n2. ����� � �����������\n3. ����� � ����������� ����\n\
							4. ����� � ����������� ��������\n5. ����� � ���������\n6. ����� �� ����� ������", "�������", "������");							
							return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� ��� ��������!");
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
						SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}���� ����� � ����������!");
						SPD(playerid, DLG_SPAWN, DSL, "{EDD682}����������� {FFFFFF}| Spawn", "{FFFFFF}1. ����� �� �����������\n2. ����� � �����������\n3. ����� � ����������� ����\n\
						4. ����� � ����������� ��������\n5. ����� � ���������\n6. ����� �� ����� ������", "�������", "������");	
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
      			SCM(playerid, COLOR_ERROR, "����������� \"/q\", ����� �������� ������.");
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
					return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}����������, ������� ��� ������ � ����!");
		        }
		        new checkpass[65];
		        SHA256_PassHash(inputtext, player_info[playerid][salt], checkpass, 65);
				if(strcmp(player_info[playerid][pass], checkpass, false, 64) == 0)
				{
					SPD(playerid, DLG_SPAWN, DSL, "{EDD682}����������� {FFFFFF}| Spawn", "{FFFFFF}1. ����� �� �����������\n2. ����� � �����������\n3. ����� � ����������� ����\n\
					4. ����� � ����������� ��������\n5. ����� � ���������\n6. ����� �� ����� ������", "�������", "������");		
				}
				else
				{
				    new string[110];
					SetPVarInt(playerid, "ErrorPassword", GetPVarInt(playerid, "ErrorPassword")-1);
				    if(GetPVarInt(playerid, "ErrorPassword") > 0)
				    {
						format(string, sizeof(string), "{EDD682}[������]: {FFFFFF}�������� ���� ������, �������. ������� ����� ��������: %d.", GetPVarInt(playerid, "ErrorPassword"));
						SCM(playerid, COLOR_WHITE, string);
					}
					if(GetPVarInt(playerid, "ErrorPassword") == 0)
					{
					    SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}�� ��������� ����� ������� ����� � ���� ��������� �� �������.");
					    return Kick(playerid);
					}
					_showLogin(playerid);
				}
		    }
		    else
		    {
      			SCM(playerid, COLOR_ERROR, "����������� \"/q\", ����� �������� ������.");
				return Kick(playerid);
		    }			
		}
		case DLG_ALOGIN_REG:
		{
			if(!response) return true;
			if(strlen(inputtext) < 6 || strlen(inputtext) > 15)
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������ ������ ���� ������ �� 6 �� 15 ��������!");
				return SPD(playerid, DLG_ALOGIN_REG, DSP, "{EDD682}AP - �����������", "{FFFFFF}��� ����� � ����� �����������������, ����������, �����������������:", "����", "������");
			}
			for(new i = 0; i < strlen(inputtext); i++)
			{
				switch(inputtext[i])
				{
					case '�'..'�', '�'..'�', ' ':
					{
						SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������ �������� ������������ �������!");
						return SPD(playerid, DLG_ALOGIN_REG, DSP, "{EDD682}AP - �����������", "{FFFFFF}��� ����� � ����� �����������������, ����������, �����������������:", "����", "������");
					}
				}
			}
			format(admin_info[playerid][apassword], 15, "%s", inputtext);

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `admins` SET `password` = '%s' WHERE `name` = '%s'", admin_info[playerid][apassword], player_info[playerid][name]);
			mysql_query(ConnectMysql, query);

			SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ������� ������������������ � ������ �����������������!");
			SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}������� {EDD682}/alogin{FFFFFF}, ����� ������ �����������!");
		}
		case DLG_ALOGIN:
		{
			if(!response) return true;
			if(strcmp(admin_info[playerid][apassword], inputtext) == 0)
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ������� �������������� � ������ �����������������!");
				temp_info[playerid][pAdminStatus] = true;
			}
			else 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}�������� ��� ������, �������!");
				SPD(playerid, DLG_ALOGIN, DSP, "{EDD682}AP - �����������", "{FFFFFF}��� ����� � ����� �����������������, ����������, ���������������:", "����", "������");
			}
		}
		case DLG_CREATEBANKPIN:
		{
			if(!response) return true;
			if(!strlen(inputtext))
			{
				SPD(playerid, DLG_CREATEBANKPIN, DSP, "{EDD682}���� - {FFFFFF}���������� �����", 
				"{FFFFFF}���� ������ ��� � ����� �����!\n\
				�������� ���������� ����, ����� ��������������� ������ ��������.\n\
				���������� ������� PIN-��� � �������� ��� � ���� ����:\n\
				\n\
				{EDD682}(PIN-��� ������ ������� �� 4 �������� � ���������� � 0! ������: 1111)", "��������", "�������");	
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
				format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}��� PIN-���: {EDD682}%s", inputtext);
				SCM(playerid, COLOR_WHITE, string);
				SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�������� �������� �������� {EDD682}F8 {FFFFFF}��� �������� ��� PIN-���.");
			}
			else
			{
				SPD(playerid, DLG_CREATEBANKPIN, DSP, "{EDD682}���� - {FFFFFF}���������� �����", 
				"{FFFFFF}���� ������ ��� � ����� �����!\n\
				�������� ���������� ����, ����� ��������������� ������ ��������.\n\
				���������� ������� PIN-��� � �������� ��� � ���� ����:\n\
				\n\
				{EDD682}(PIN-��� ������ ������� �� 4 �������� � ���������� � 0! ������: 1111)", "��������", "�������");	
				regex_delete(rg_secretbankpincheck);
				return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� ��������� PIN-���.");
			}			
		}
		case DLG_LOGINBANK:
		{
			if(!response) return true;
			if(!strlen(inputtext))
			{
				SPD(playerid, DLG_LOGINBANK, DSP, "{EDD682}���� - {FFFFFF}�������������", 
				"{FFFFFF}������� ��� PIN-��� �� ����������� ����� � ���� ����:\n\
				{EDD682}(���� �� ������ ���� PIN-���, ���������� � ������������� �������)", "�����", "�������");			
			}
			if(strval(inputtext) == player_info[playerid][bank_pin][1])
			{
				new string[270];
				format(string, sizeof(string), 
				"{FFFFFF}1. �������� ������ �� ����\n\
				2. ����� ������ �� �����\n\
				3. ��������� �� ������ ����\n\
				4. ������ �������\n\
				5. ��������� �����\n\
				\n\
				- ���������� �� �����:\n\
				1. ����� ����� - {EDD682}(�%d){FFFFFF}\n\
				2. ��������� ����� - {EDD682}(%d ���.)", player_info[playerid][bank_check], player_info[playerid][bank_money]);
				SPD(playerid, DLG_BANKMENU, DSL, "{EDD682}���� - {FFFFFF}�������� ����", string, "�������", "�������");	
			}
			else
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� ��������� PIN-���.");
			}	
		}
		case DLG_BANKMENU:
		{
  			if(response)
		    {			
				switch(listitem)
				{
					case 0: SPD(playerid, DLG_GMONEYBANK, DSI, "{EDD682}���� - {FFFFFF}�������� �� ���������� ����", "{FFFFFF}������� �����, ������� ������ �������� �� ���� � ���� ����:", "��������", "������");
					case 1: SPD(playerid, DLG_TMONEYBANK, DSI, "{EDD682}���� - {FFFFFF}����� � ����������� �����", "{FFFFFF}������� �����, ������� ������ ����� �� ����� � ���� ����:", "�����", "������");
					case 2: SPD(playerid, DLG_TMONEY, DSI, "{EDD682}���� - {FFFFFF}������� �� ������ ����", "{FFFFFF}������� ����� �����, �� ������� ������ ��������� ����� � ���� ����:", "���������", "������");
					case 3: SPD(playerid, DLG_NALOGBANK, DSL, "{EDD682}���� - {FFFFFF}������ �������", "{FFFFFF}1. �������� ��������� ����\n2. �������� ��������� ��������", "�������", "�����");
					case 4: SPD(playerid, DLG_SBANK, DSL, "{EDD682}���� - {FFFFFF}��������� �����", "{FFFFFF}1. �������� PIN-��� �����", "�������", "�����");	
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
						if(player_info[playerid][keyh] == -1) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� ��� ����!");
						SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ����", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
					}	
					case 1:
					{
						if(player_info[playerid][keya] == -1) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� ��� ��������!");
						SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ��������", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
					}
				}
			}
			else
			{
				new string[270];
				format(string, sizeof(string), 
				"{FFFFFF}1. �������� ������ �� ����\n\
				2. ����� ������ �� �����\n\
				3. ��������� �� ������ ����\n\
				4. ������ �������\n\
				5. ��������� �����\n\
				\n\
				- ���������� �� �����:\n\
				1. ����� ����� - {EDD682}(�%d){FFFFFF}\n\
				2. ��������� ����� - {EDD682}(%d ���.)", player_info[playerid][bank_check], player_info[playerid][bank_money]);
				SPD(playerid, DLG_BANKMENU, DSL, "{EDD682}���� - {FFFFFF}�������� ����", string, "�������", "�������");					
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
				if(!strlen(inputtext)) return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ��������", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
				if(!( 1 <= dayh <= 30)) return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ��������", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
				if(apart_info[i][a_rent] == 30)
				{
					SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}��������� ���� ��� ���������� �� 30 ����!");
					return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ��������", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
				}				
				if(p == 31)
				{
					SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}������ �������� �����, ��� �� 30 ����!");
					return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ��������", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
				}
				switch(apart_info[i][a_class])
				{
					case 1:
					{
						new total = 2000 * dayh;
						if(total > player_info[playerid][bank_money])
						{
							SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ����� ����� � ����� �� ������� �������!");	
							return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ��������", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
						}

						apart_info[i][a_rent] += dayh;
						player_info[playerid][bank_money] -= total;

						format(string, sizeof(string), "{FFFFFF}�� ������� �������� ���� �������� �� {EDD682}%d {FFFFFF}����. ������� �� �����: {EDD682}%d", dayh, player_info[playerid][bank_money]);
						SCM(playerid, COLOR_WHITE, string);	

						// ����������
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
							SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ����� ����� � ����� �� ������� �������!");	
							return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ��������", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
						}

						apart_info[i][a_rent] += dayh;
						player_info[playerid][bank_money] -= total;

						format(string, sizeof(string), "{FFFFFF}�� ������� �������� ���� �������� �� {EDD682}%d {FFFFFF}����. ������� �� �����: {EDD682}%d", dayh, player_info[playerid][bank_money]);
						SCM(playerid, COLOR_WHITE, string);	

						// ����������
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
							SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ����� ����� � ����� �� ������� �������!");	
							return SPD(playerid, DLG_APARTPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ��������", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
						}

						apart_info[i][a_rent] += dayh;
						player_info[playerid][bank_money] -= total;

						format(string, sizeof(string), "{FFFFFF}�� ������� �������� ���� �������� �� {EDD682}%d {FFFFFF}����. ������� �� �����: {EDD682}%d", dayh, player_info[playerid][bank_money]);
						SCM(playerid, COLOR_WHITE, string);	

						// ����������
						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `id` = '%d'",player_info[playerid][bank_money], player_info[playerid][id]);
						mysql_query(ConnectMysql, query);

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_rent` = `a_rent` + '%d' WHERE `aid` = '%d'", dayh, i);
						mysql_query(ConnectMysql, query);		
					}
				}
			}
			else SPD(playerid, DLG_NALOGBANK, DSL, "{EDD682}���� - {FFFFFF}������ �������", "{FFFFFF}1. �������� ��������� ����\n2. �������� ��������� ��������", "�������", "�����");
		}		
		case DLG_HOMEPAY:
		{
			if(response)
			{
				new i = player_info[playerid][keyh];
				new dayh = strval(inputtext);
				new p = dayh + house_info[i][h_rent];
				new string[110];
				if(!strlen(inputtext)) return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ����", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
				if(!( 1 <= dayh <= 30)) return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ����", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
				if(house_info[i][h_rent] == 30)
				{
					SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}��������� ���� ��� ���������� �� 30 ����!");
					return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ����", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
				}				
				if(p == 31)
				{
					SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}������ �������� �����, ��� �� 30 ����!");
					return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ����", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
				}
				switch(house_info[i][h_class])
				{
					case 1:
					{
						new total = 2000 * dayh;
						if(total > player_info[playerid][bank_money])
						{
							SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ����� ����� � ����� �� ������� �������!");	
							return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ����", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
						}

						house_info[i][h_rent] += dayh;
						player_info[playerid][bank_money] -= total;

						format(string, sizeof(string), "{FFFFFF}�� ������� �������� ��� ��� �� {EDD682}%d {FFFFFF}����. ������� �� �����: {EDD682}%d", dayh, player_info[playerid][bank_money]);
						SCM(playerid, COLOR_WHITE, string);	

						// ����������
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
							SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ����� ����� � ����� �� ������� �������!");	
							return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ����", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
						}

						house_info[i][h_rent] += dayh;
						player_info[playerid][bank_money] -= total;

						format(string, sizeof(string), "{FFFFFF}�� ������� �������� ��� ��� �� {EDD682}%d {FFFFFF}����. ������� �� �����: {EDD682}%d", dayh, player_info[playerid][bank_money]);
						SCM(playerid, COLOR_WHITE, string);	

						// ����������
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
							SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ����� ����� � ����� �� ������� �������!");	
							return SPD(playerid, DLG_HOMEPAY, DSI, "{EDD682}���� - {FFFFFF}������ ��������� ����", "{FFFFFF}������� ���������� ����, �� ������� ������ ������ ����� (�� 1 �� 30)", "��������", "������");
						}

						house_info[i][h_rent] += dayh;
						player_info[playerid][bank_money] -= total;

						format(string, sizeof(string), "{FFFFFF}�� ������� �������� ��� ��� �� {EDD682}%d {FFFFFF}����. ������� �� �����: {EDD682}%d", dayh, player_info[playerid][bank_money]);
						SCM(playerid, COLOR_WHITE, string);	

						// ����������
						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `id` = '%d'",player_info[playerid][bank_money], player_info[playerid][id]);
						mysql_query(ConnectMysql, query);

						query[0] = EOS;
						mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_rent` = `h_rent` + '%d' WHERE `hid` = '%d'", dayh, i);
						mysql_query(ConnectMysql, query);	
					}
				}
			}
			else SPD(playerid, DLG_NALOGBANK, DSL, "{EDD682}���� - {FFFFFF}������ �������", "{FFFFFF}1. �������� ��������� ����\n2. �������� ��������� ��������", "�������", "�����");
		}
		case DLG_BANKNEWPIN:
		{
			if(response)
			{
				if(!strlen(inputtext)) 
				{
					SPD(playerid, DLG_BANKNEWPIN, DSI, "{EDD682}���� - {FFFFFF}��������� PIN-���`�", "{FFFFFF}������� ����� PIN-��� � ���� ����:\n\
					{EDD682}(PIN-��� ������ ������� �� 4 �������� � ���������� � 0! ������: 1111)", "��������", "�����");
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
					format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}��� PIN-���: {EDD682}%s", inputtext);
					SCM(playerid, COLOR_WHITE, string);
					SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�������� �������� �������� {EDD682}F8 {FFFFFF}��� �������� ��� PIN-���.");
				}
				else
				{
					SPD(playerid, DLG_BANKNEWPIN, DSI, "{EDD682}���� - {FFFFFF}��������� PIN-���`�", "{FFFFFF}������� ����� PIN-��� � ���� ����:\n\
					{EDD682}(PIN-��� ������ ������� �� 4 �������� � ���������� � 0! ������: 1111)", "��������", "�����");
					regex_delete(rg_secretbankpincheck);
					return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� ��������� PIN-���.");
				}	
			}
			else SPD(playerid, DLG_SBANK, DSL, "{EDD682}���� - {FFFFFF}��������� �����", "{FFFFFF}1. �������� PIN-��� �����", "�������", "�����");	
		}
		case DLG_SBANK:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: 
					{
						SPD(playerid, DLG_BANKNEWPIN, DSI, "{EDD682}���� - {FFFFFF}��������� PIN-���`�", "{FFFFFF}������� ����� PIN-��� � ���� ����:\n\
						{EDD682}(PIN-��� ������ ������� �� 4 �������� � ���������� � 0! ������: 1111)", "��������", "�����");
					}	
				}
			}
			else
			{
				new string[270];
				format(string, sizeof(string), 
				"{FFFFFF}1. �������� ������ �� ����\n\
				2. ����� ������ �� �����\n\
				3. ��������� �� ������ ����\n\
				4. ������ �������\n\
				5. ��������� �����\n\
				\n\
				- ���������� �� �����:\n\
				1. ����� ����� - {EDD682}(�%d){FFFFFF}\n\
				2. ��������� ����� - {EDD682}(%d ���.)", player_info[playerid][bank_check], player_info[playerid][bank_money]);
				SPD(playerid, DLG_BANKMENU, DSL, "{EDD682}���� - {FFFFFF}�������� ����", string, "�������", "�������");					
			}

		}
		case DLG_TMONEYBANK:
		{
			if(!response) return true;
			new string[140];
			if(!strlen(inputtext)) return SPD(playerid, DLG_TMONEYBANK, DSI, "{EDD682}���� - {FFFFFF}����� � ����������� �����", "{FFFFFF}������� �����, ������� ������ ����� �� ����� � ���� ����:", "�����", "������");
			if(strval(inputtext) < 1 || strval(inputtext) > 10000000)
			{
				SPD(playerid, DLG_TMONEYBANK, DSI, "{EDD682}���� - {FFFFFF}����� � ����������� �����", "{FFFFFF}������� �����, ������� ������ ����� �� ����� � ���� ����:", "�����", "������");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������ ����� ����� 1 ����� ��� ����� 10.000.000 ������.");				
			}
			if(player_info[playerid][bank_money] < strval(inputtext))
			{
				SPD(playerid, DLG_TMONEYBANK, DSI, "{EDD682}���� - {FFFFFF}����� � ����������� �����", "{FFFFFF}������� �����, ������� ������ ����� �� ����� � ���� ����:", "�����", "������");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� ��� ������� �����.");
			}
			_giveMoney(playerid, strval(inputtext));
			player_info[playerid][bank_money] -= strval(inputtext);
			format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}�� ����� {EDD682}%d ������ {FFFFFF}�� ������ �����. ������: {EDD682}%d ������.", strval(inputtext), player_info[playerid][bank_money]);
			SCM(playerid, COLOR_WHITE, string);

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `id` = '%d'", player_info[playerid][bank_money], player_info[playerid][id]);
			mysql_query(ConnectMysql, query);					
		}
		case DLG_GMONEYBANK:
		{
			if(!response) return true;
			new string[140];
			if(!strlen(inputtext)) return SPD(playerid, DLG_GMONEYBANK, DSI, "{EDD682}���� - {FFFFFF}�������� �� ���������� ����", "{FFFFFF}������� �����, ������� ������ �������� �� ���� � ���� ����:", "��������", "������");
			if(strval(inputtext) < 1 || strval(inputtext) > 10000000)
			{
				SPD(playerid, DLG_GMONEYBANK, DSI, "{EDD682}���� - {FFFFFF}�������� �� ���������� ����", "{FFFFFF}������� �����, ������� ������ �������� �� ���� � ���� ����:", "��������", "������");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������ �������� ����� 1 ����� ��� ����� 10.000.000 ������.");				
			}
			if(player_info[playerid][money] < strval(inputtext))
			{
				SPD(playerid, DLG_GMONEYBANK, DSI, "{EDD682}���� - {FFFFFF}�������� �� ���������� ����", "{FFFFFF}������� �����, ������� ������ �������� �� ���� � ���� ����:", "��������", "������");
				return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� ��� ������� �����.");
			}
			_giveMoney(playerid, -strval(inputtext));
			player_info[playerid][bank_money] += strval(inputtext);
			format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}�� �������� {EDD682}%d ������ {FFFFFF}�� ���� ����. ������: {EDD682}%d ������.", strval(inputtext), player_info[playerid][bank_money]);
			SCM(playerid, COLOR_WHITE, string);

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `id` = '%d'", player_info[playerid][bank_money], player_info[playerid][id]);
			mysql_query(ConnectMysql, query);			
		}
		case DLG_BANKINFO: SPD(playerid, DLG_BANKMENU, DSL, "{EDD682}���� - {FFFFFF}�������� ����", "1. ���������� �� �����.\n2. ��������� �� ������ ����.\n3. ������ �������.\n4. ��������� �����.", "�������", "�������");
		case DLG_TMONEY:
		{
			if(!response) return true;
			new transfer;
			if(sscanf(inputtext, "i", transfer)) return SPD(playerid, DLG_TMONEY, DSI, "{EDD682}���� - {FFFFFF}������� �� ������ ����", "{FFFFFF}������� ����� �����, �� ������� ������ ��������� ����� � ���� ����:", "���������", "������");
			if(transfer == player_info[playerid][bank_check]) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������� ���������� ����� �����!");
				return SPD(playerid, DLG_TMONEY, DSI, "{EDD682}���� - {FFFFFF}������� �� ������ ����", "{FFFFFF}������� ����� �����, �� ������� ������ ��������� ����� � ���� ����:", "���������", "������");	
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
				return SPD(playerid, DLG_TMONEY, DSI, "{EDD682}���� - {FFFFFF}������� �� ������ ����", "{FFFFFF}������� ����� �����, �� ������� ������ ��������� ����� � ���� ����:", "���������", "������");
			}
			new moneybank;
			new string[200];
			new transfer = GetPVarInt(playerid, "moddedtransfer");
			sscanf(inputtext, "d", moneybank);
			if(moneybank < 1000 || moneybank > 10000000)
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������ ��������� ����� 1000 ����� ��� ����� 10.000.000 ������.");	
				format(string, sizeof(string), "{FFFFFF}�� ���������� ������� �� ���� {EDD682}(�%d)\n\n{FFFFFF}���� ������ ����������, ������� �����, ������� �� ������ ��������� �� ���� ���������� ���� � ���� ����:",
				transfer, player_info[playerid][bank_check]);
				return SPD(playerid, DLG_TRANSFERBANK, DSI, "{EDD682}���� - {FFFFFF}������� �� ������ ����", string, "���������", "�����");				
			}
			if(player_info[playerid][bank_money] < moneybank)
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� ��� ������� �����.");
				format(string, sizeof(string), "{FFFFFF}�� ���������� ������� �� ���� {EDD682}(�%d)\n\n{FFFFFF}���� ������ ����������, ������� �����, ������� �� ������ ��������� �� ���� ���������� ����� ���� ����:",
				transfer, player_info[playerid][bank_check]);
				return SPD(playerid, DLG_TRANSFERBANK, DSI, "{EDD682}���� - {FFFFFF}������� �� ������ ����", string, "���������", "�����");			
			}	
			player_info[playerid][bank_money] -= moneybank;

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = '%d' WHERE `bank_check` = '%d'", player_info[playerid][bank_money], player_info[playerid][bank_check]);
			mysql_query(ConnectMysql, query);

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `bank_money` = `bank_money` + '%d' WHERE `bank_check` = '%d'", moneybank, transfer);
			mysql_query(ConnectMysql, query);		

			format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}�� �������� {EDD682}%d ������ {FFFFFF}�� ���� {EDD682}(�%d).", moneybank, transfer);
			SCM(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}������ ������ �����: {EDD682}%d ������.", player_info[playerid][bank_money]);
			SCM(playerid, COLOR_WHITE, string);

			foreach(new i:Player)
			{  
				if(!IsPlayerConnected(i)) continue;
				if(transfer == player_info[i][bank_check])
				{
					new mes[220];
					player_info[i][bank_money] += moneybank;
					format(mes, sizeof(mes), "{EDD682}[�����������]: {FFFFFF}����� {EDD682}%s {FFFFFF}������ ������ �� ��� ���������� ���� {EDD682}(�%d).", player_info[playerid][name] ,player_info[i][bank_check]);
					SCM(i, COLOR_WHITE, mes);
					format(mes, sizeof(mes), "{EDD682}[�����������]: {FFFFFF}������ ������ �����: {EDD682}%d ������.", player_info[i][bank_money]);
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
				format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}�� ����� � �����: {EDD682}%s {FFFFFF}������ {EDD682}%s[%d].", _fracName(actplayerid), player_info[actplayerid][name], actplayerid);
				SendClientMessage(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}������������� {EDD682}%s[%d] {FFFFFF}���� ��� � �����: {EDD682}%s.", player_info[playerid][name], playerid, _fracName(actplayerid));
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

			format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}������������� {EDD682}%s[%d] {FFFFFF}�������� ��� ������� �� ����: {EDD682}%s.", player_info[playerid][name], playerid, _fracName(actplayerid));
			SendClientMessage(actplayerid, COLOR_WHITE, string);
			SendClientMessage(actplayerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}����������� {EDD682}'/changeskin'{FFFFFF}, ����� ������� ��������� ���������!");
			format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}�� ��������� %s[%d] �� ���� ������: %s.", player_info[actplayerid][name], actplayerid, _fracName(actplayerid));
			SendClientMessage(playerid, COLOR_WHITE, string);

			format(string, sizeof(string), "������������� %s[%d] �������� %s[%d] ������� �� ����: %s.", 
			player_info[playerid][name], playerid, player_info[actplayerid][name], actplayerid, _fracName(actplayerid));
			SAM(COLOR_SRED, string, 1);

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `leader` = '%d', `member` = '%d', `rang` = '%d'  WHERE `name` = '%s'", player_info[actplayerid][leader], listitem, 
			player_info[actplayerid][rang], player_info[actplayerid][name]);
			mysql_tquery(ConnectMysql, query);			

			_fracSkin(actplayerid);	
            _fracSpawn(actplayerid);
			_freezePlayerPickup(actplayerid);			
		}
		case DLG_CHANGESKIN:
		{
	        if(!response) return 1;
	        new actplayerid = GetPVarInt(playerid, "actplayerid");
	        new fractionid = player_info[playerid][member];
	        new skinid = FractionSkin[fractionid][listitem];
	        new mes[128];
			format(mes,sizeof(mes), "{EDD682}[�����������]: {EDD682}%s {FFFFFF}����� ��� ����� ����������� ������.", player_info[playerid][name]);
			SendClientMessage(actplayerid, COLOR_WHITE, mes);
			format(mes,sizeof(mes), "{EDD682}[�����������]: {EDD682}%s {FFFFFF}������� ����� ����������� ������.", player_info[actplayerid][name]);
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
					if(player_info[playerid][eat] == 100) return SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}��� �������� �� �������!");
					player_info[playerid][eat] += 30;
					ApplyAnimation(playerid, "FOOD", "EAT_PIZZA", 4.0, 0, 0, 0, 0, 0,1);
					SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ����� ����� �����, ����������� ��� ������������ �� 30 ������");
					if(player_info[playerid][eat] > 100) return player_info[playerid][eat] = 100;
				}
				case 1:
				{
					if(player_info[playerid][thirst] == 100) return SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}��� �������� �� ����� ����!");
					player_info[playerid][thirst] += 30;
					ApplyAnimation(playerid, "VENDING", "VEND_DRINK_P", 4.0, 0, 0, 0, 0, 0,1);
					SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ������ ������ ����, ����������� ����� ������������ �� 30 ������");
					if(player_info[playerid][thirst] > 100) return player_info[playerid][thirst] = 100;					
				}				
			}
		}
		case DLG_HOME:
		{
			if(!response) return true;
			for(new h = 1; h <= totalhouse; h++)
			{
				if(house_info[h][h_lock] == 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}����� ����� ���� �������!");	
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
					if(apart_info[a][a_lock] == 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}����� ���� �������� �������!");
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
					if(player_info[playerid][keya] != -1) return SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� �� ������ ������ ������ ��������!");
					if(player_info[playerid][money] < apart_info[a][a_money]) return SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}� ��� ������������ �������, ����� ���������� ��� ��������!");
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

					format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}�� ��������� �������� (�%d) �� %d ������! �������� ����: %d.", a, apart_info[a][a_money], apart_info[a][a_rent]);
					SCM(playerid, COLOR_WHITE, string);

					Delete3DTextLabel(apart_info[a][a_text]);
					apart_info[a][a_text] = Create3DTextLabel("{FFFFFF}�������� �� ��������.\n ��� �������������� ������� - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[a][a_enter][0], apart_info[a][a_enter][1], apart_info[a][a_enter][2], 20.0, apart_info[a][a_world], 1);												
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
					if(player_info[playerid][keyh] != -1) return SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� �� ������ ������ ������ ���!");
					if(player_info[playerid][money] < house_info[h][h_money]) return SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}� ��� ������������ �������, ����� ���������� ���� ���!");
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

					format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}�� ��������� ��� (�%d) �� %d ������! �������� ����: %d.", h, house_info[h][h_money], house_info[h][h_rent]);
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
				case 1: SPD(playerid, DLG_SELLHOMEG, DSM, "{EDD682}������� ���� �����������", "{FFFFFF}�� ������������� ������� ������� ��� �����������?", "��", "���");
				case 2: SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}������� ���� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ���:", "�����", "�������");
			}
		}
		case DLG_APARTMENU:
		{
			if(!response) return true;
			switch(listitem)
			{
				case 0: _infoApart(playerid);
				case 1: SPD(playerid, DLG_SELLAPARTG, DSM, "{EDD682}������� �������� �����������", "{FFFFFF}�� ������������� ������� ������� �������� �����������?", "��", "���");
				case 2: SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}������� �������� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ��������:", "�����", "�������");
			}
		}
		case DLG_INFOAPART: 
		{
			SPD(playerid, DLG_APARTMENU, DSL, "{EDD682}���������� ���������", 
			"{EDD682}[1]{FFFFFF} - ���������� � ��������\n\
			{EDD682}[2]{FFFFFF} - ������� �������� �����������\n\
			{EDD682}[3]{FFFFFF} - ������� �������� ������", "�����", "�������");		
		}			
		case DLG_INFOHOME: 
		{
			SPD(playerid, DLG_HOMEMENU, DSL, "{EDD682}���������� �����", 
			"{EDD682}[1]{FFFFFF} - ���������� � ����\n\
			{EDD682}[2]{FFFFFF} - ������� ��� �����������\n\
			{EDD682}[3]{FFFFFF} - ������� ��� ������", "�����", "�������");			
		}
		case DLG_SELLAPARTG:
		{
			if(!response) return true;
			new i = player_info[playerid][keya], string[60];
			apart_info[i][a_owned] = 0;
			_giveMoney(playerid, apart_info[i][a_money]);
			strmid(apart_info[i][a_owner], "�����������", 0, strlen("�����������"), 255);

			SetPlayerPos(playerid, apart_info[i][a_enter][0], apart_info[i][a_enter][1], apart_info[i][a_enter][2]);
			SetPlayerVirtualWorld(playerid, apart_info[i][a_world]);		

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_owned` = '0', `a_owner` = '�����������' WHERE `aid` = '%d'", i);
			mysql_query(ConnectMysql, query);

			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keya` = '-1' WHERE `id` = '%d'", player_info[playerid][id]);
			mysql_query(ConnectMysql, query);

			SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ������� ������� �������� �����������!");
			format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~g~+%d PY�", apart_info[i][a_money]);
			PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
			GameTextForPlayer(playerid, string, 1000, 3);

			Delete3DTextLabel(apart_info[i][a_text]);
			apart_info[i][a_text] = Create3DTextLabel("{FFFFFF}�������� ��������.\n ��� �������������� ������� - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[i][a_enter][0], apart_info[i][a_enter][1], apart_info[i][a_enter][2], 20.0, apart_info[i][a_world], 1);
			player_info[playerid][keya] = -1;							
		}			
		case DLG_SELLHOMEG:
		{
			if(!response) return true;
			new i = player_info[playerid][keyh], string[60];
			house_info[i][h_owned] = 0;
			_giveMoney(playerid, house_info[i][h_money]);
			strmid(house_info[i][h_owner], "�����������", 0, strlen("�����������"), 255);

			SetPlayerPos(playerid, house_info[i][h_enter][0], house_info[i][h_enter][1], house_info[i][h_enter][2]);
			SetPlayerVirtualWorld(playerid, 0);		

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_owned` = '0', `h_owner` = '�����������' WHERE `hid` = '%d'", i);
			mysql_query(ConnectMysql, query);

			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keyh` = '-1' WHERE `id` = '%d'", player_info[playerid][id]);
			mysql_query(ConnectMysql, query);

			SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ������� ������� ��� �����������!");
			format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~g~+%d PY�", house_info[i][h_money]);
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
			if(sscanf(inputtext, "p<,>dd", params[0], params[1])) return SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}������� �������� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ��������:", "�����", "�������");
			if(params[0] == playerid) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������ ��������� ������ ����!");
				return SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}������� �������� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ��������:", "�����", "�������");
			}
			if(player_info[params[0]][keya] != -1) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ������ ��� ���� ��������!");
				return SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}������� �������� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ��������:", "�����", "�������");
			}			
			if(GetPVarInt(playerid,"apartpokup") == 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}�� ��� ������� �����������!");
			if(!strlen(inputtext)) return SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}������� �������� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ��������:", "�����", "�������");
			
			if(!IsPlayerConnected(params[0])) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}��������� ���� ����� �� � ����!");
				return SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}������� �������� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ��������:", "�����", "�������");
			}
			if(!IsPlayerInRangeOfPoint(params[0], 2.0, x[0], x[1], x[2])) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}��������� ���� ����� ������ ���������� ����� � ����!");
				return SPD(playerid, DLG_SELLAPARTP, DSI, "{EDD682}������� �������� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ��������:", "�����", "�������");			
			}
			SetPVarInt(params[0],"ApartOffer", playerid);
			SetPVarInt(params[0],"ApartPrice", params[1]);
			SetPVarInt(playerid,"apartpokup",1);

			format(string, sizeof(string), "{FFFFFF}����� {EDD682}%s {FFFFFF}���������� ��� ������ �������� {EDD682}(�%d) {FFFFFF}�� {EDD682}%d {FFFFFF}������", player_info[playerid][name], player_info[playerid][keya], params[1]);	
			SPD(params[0], DLG_SELLAPARTP2, DSM, "{EDD682}������� ��������", string, "������", "������");
		}
		case DLG_SELLAPARTP2:
		{
			if(response)
			{
				if(GetPVarInt(playerid, "ApartOffer") != 60635)
				{
					new h = player_info[GetPVarInt(playerid, "ApartOffer")][keya];
					if(player_info[playerid][money] < GetPVarInt(playerid, "ApartPrice"))return SendClientMessage(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� ��� ������� ����� �� �����!");
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

					SCM(GetPVarInt(playerid, "ApartOffer"), COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ������� ������� ��������!");
					SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}����������� � �������� ��������!");

					SetPVarInt(GetPVarInt(playerid, "ApartOffer"),"apartpokup",0);
					SetPVarInt(playerid,"ApartOffer", 60635);
					SetPVarInt(GetPVarInt(playerid, "ApartOffer"),"ApartOffer", 60635);
					return SetPVarInt(playerid,"ApartPrice", 0);						
				}
			}
			else
			{
					SCM(GetPVarInt(playerid, "ApartOffer"), COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}����� ��������� �������� ��������!");
					SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� �������� �������!");

					SetPVarInt(playerid,"apartpokup",0);
					SetPVarInt(GetPVarInt(playerid, "ApartOffer"),"apartpokup",0);				
			}
		}							
		case DLG_SELLHOMEP:
		{
			if(!response) return true;
			new Float:x[3], params[2], string[250];
			GetPlayerPos(playerid, x[0], x[1], x[2]);
			if(sscanf(inputtext, "p<,>dd", params[0], params[1])) return SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}������� ���� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ���:", "�����", "�������");
			if(params[0] == playerid) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������ ��������� ������ ����!");
				return SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}������� ���� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ���:", "�����", "�������");
			}
			if(player_info[params[0]][keyh] != -1) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ������ ��� ���� ���!");
				return SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}������� ���� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ���:", "�����", "�������");
			}		
			if(GetPVarInt(playerid,"housepokup") == 1) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}�� ��� ������� �����������!");
			if(!strlen(inputtext)) return SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}������� ���� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ���:", "�����", "�������");
			
			if(!IsPlayerConnected(params[0]) || params[0] == INVALID_PLAYER_ID) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}��������� ���� ����� �� � ����!");
				return SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}������� ���� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ���:", "�����", "�������");
			}
			if(!IsPlayerInRangeOfPoint(params[0], 2.0, x[0], x[1], x[2])) 
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}��������� ���� ����� ������ ���������� ����� � ����!");
				return SPD(playerid, DLG_SELLHOMEP, DSI, "{EDD682}������� ���� ������", "{FFFFFF}������� (id ������) � ����� �� ������� ������ ������� ���:", "�����", "�������");				
			}
			SetPVarInt(params[0],"HouseOffer", playerid);
			SetPVarInt(params[0],"HousePrice", params[1]);
			SetPVarInt(playerid,"housepokup",1);

			format(string, sizeof(string), "{FFFFFF}����� {EDD682}%s {FFFFFF}���������� ��� ������ ��� {EDD682}(�%d) {FFFFFF}�� {EDD682}%d {FFFFFF}������", player_info[playerid][name], player_info[playerid][keyh], params[1]);	
			SPD(params[0], DLG_SELLHOMEP2, DSM, "{EDD682}������� ����", string, "������", "������");
		}
		case DLG_SELLHOMEP2:
		{
			if(response)
			{
				if(GetPVarInt(playerid, "HouseOffer") != 60635)
				{
					new h = player_info[GetPVarInt(playerid, "HouseOffer")][keyh];
					if(player_info[playerid][money] < GetPVarInt(playerid, "HousePrice"))return SendClientMessage(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� ��� ������� ����� �� �����!");
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

					SCM(GetPVarInt(playerid, "HouseOffer"), COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ������� ������� ���!");
					SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}����������� � �������� ����!");


					SetPVarInt(GetPVarInt(playerid, "HouseOffer"),"housepokup",0);
					SetPVarInt(playerid, "HouseOffer", 60635);
					SetPVarInt(GetPVarInt(playerid, "HouseOffer"), "HouseOffer", 60635);
					return SetPVarInt(playerid,"HousePrice", 0);						
				}
			}
			else
			{
					SCM(GetPVarInt(playerid, "HouseOffer"), COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}����� ��������� �������� ���!");
					SCM(playerid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� �������� �������!");

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
					SPD(playerid, DLG_CREATEHOUSE, DSI, "{EDD682}�������� ������ ����", 
					"{FFFFFF}������� ����� ������� ���� �������� ���� � ��� �����\n\
					1 - ������ �����, 2 - ������� �����, 3 - ������� �����", "�������", "������");	
				}
				case 1: SPD(playerid, DLG_CREATEPORCH, DSM, "{EDD682}�������� ������ ��������", "{FFFFFF}�� ������������� ������ ������� ����� �������?", "��", "���");
				case 2: 
				{
					SPD(playerid, DLG_CREATEAPART, DSI, "{EDD682}�������� ������ ��������", 
					"{FFFFFF}������� ����� ������� ���� ������� �������� � � �����\n\
					1 - ������ �����, 2 - ������� �����, 3 - ������� �����", "�������", "������");	
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

			// �������� �������
			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "INSERT INTO `porch` (`pid`, `p_enterx`, `p_entery`, `p_enterz`, `p_exitx`, `p_exity`, `p_exitz`) VALUES ('%d', '%f', '%f', '%f', '%f', '%f','%f')", 
			totalporch, porch_info[totalporch][p_enter][0], porch_info[totalporch][p_enter][1], porch_info[totalporch][p_enter][2], porch_info[totalporch][p_exit][0], porch_info[totalporch][p_exit][1], porch_info[totalporch][p_exit][2]);
			mysql_query(ConnectMysql, query);

			format(string, sizeof(string), "{FFFFFF}�� ������� ������� �������(�%d)!", totalporch);
			SCM(playerid, COLOR_WHITE, string);	

			format(string, sizeof(string), "{FFFFFF}������� (�%d).\n ��� �������������� ������� - {EDD682}'L.ALT'.", totalporch);
			porch_info[totalporch][p_pickup] = CreateDynamicPickup(19132, 23, porch_info[totalporch][p_enter][0], porch_info[totalporch][p_enter][1], porch_info[totalporch][p_enter][2],0, 0, -1);
			porch_info[totalporch][p_text] = Create3DTextLabel(string, COLOR_WHITE, porch_info[totalporch][p_enter][0], porch_info[totalporch][p_enter][1], porch_info[totalporch][p_enter][2], 20.0, 0, 1);
			porch_info[totalporch][p_texit] = Create3DTextLabel("{FFFFFF}����� �����, ������� - {EDD682}'L.ALT'.", COLOR_WHITE, porch_info[totalporch][p_exit][0], porch_info[totalporch][p_exit][1], porch_info[totalporch][p_exit][2], 20.0, totalporch+50, 1);
			porch_info[totalporch][p_floor1] = Create3DTextLabel("{FFFFFF}����� ��������� �� ���� ����, ������� - {EDD682}'L.ALT'.", COLOR_WHITE, 884.0126, 2125.7830, 2002.4259, 20.0, totalporch+50, 1);
			porch_info[totalporch][p_floor2] = Create3DTextLabel("{FFFFFF}����� ���������� �� ���� ����, ������� - {EDD682}'L.ALT'.", COLOR_WHITE, 884.0977, 2125.9177, 2006.2959, 20.0, totalporch+50, 1);								

		}
		case DLG_CREATEAPART:
		{
			if(!response) return true;
			new string[110], Float:x, Float:y, Float:z, params[2];
			if(sscanf(inputtext, "p<,>dd", params[0], params[1]))
			{
				SPD(playerid, DLG_CREATEAPART, DSI, "{EDD682}�������� ������ ��������", 
				"{FFFFFF}������� ����� ������� ���� ������� �������� � � �����\n\
				1 - ������ �����, 2 - ������� �����, 3 - ������� �����", "�������", "������");	
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
			mysql_format(ConnectMysql, query, sizeof(query), "INSERT INTO `apartament` (`aid`, `a_owned`, `a_owner`, `a_enterx`, `a_entery`, `a_enterz`, `a_exitx`, `a_exity`, `a_exitz`, `a_money`, `a_class`, `a_world`) VALUES ('%d', '0', '�����������', '%f', '%f', '%f', '%f', '%f','%f', '%d', '%d', '%d')",
			totalapart, apart_info[totalapart][a_enter][0], apart_info[totalapart][a_enter][1], apart_info[totalapart][a_enter][2], apart_info[totalapart][a_exit][0], apart_info[totalapart][a_exit][1], apart_info[totalapart][a_exit][2],
			params[0], params[1], apart_info[totalapart][a_world]);
			mysql_query(ConnectMysql, query);

			format(string, sizeof(string), "{FFFFFF}�� ������� ������� ��������(�%d)!", totalapart);
			SCM(playerid, COLOR_WHITE, string);
			apart_info[totalapart][a_text] = Create3DTextLabel("{FFFFFF}�������� ��������.\n ��� �������������� ������� - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[totalapart][a_enter][0], apart_info[totalapart][a_enter][1], apart_info[totalapart][a_enter][2], 20.0, apart_info[totalapart][a_world], 1);
			apart_info[totalapart][a_texit] = Create3DTextLabel("{FFFFFF}����� �����, ������� - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[totalapart][a_exit][0], apart_info[totalapart][a_exit][1], apart_info[totalapart][a_exit][2], 20.0, totalapart+50, 1);																
		}
		case DLG_CREATEHOUSE:
		{
			if(!response) return true;
			new string[110], Float:x, Float:y, Float:z, params[2];
			if(sscanf(inputtext, "p<,>dd", params[0], params[1]))
			{
				SPD(playerid, DLG_CREATEHOUSE, DSI, "{EDD682}�������� ������ ����", 
				"{FFFFFF}������� ����� ������� ���� �������� ���� � ��� �����\n\
				1 - ������ �����, 2 - ������� �����, 3 - ������� �����", "�������", "������");
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
			mysql_format(ConnectMysql, query, sizeof(query), "INSERT INTO `house` (`hid`, `h_owned`, `h_owner`, `h_enterx`, `h_entery`, `h_enterz`, `h_exitx`, `h_exity`, `h_exitz`, `h_money`, `h_class`) VALUES ('%d', '0', '�����������', '%f', '%f', '%f', '%f', '%f','%f', '%d', '%d')", 
			totalhouse, house_info[totalhouse][h_enter][0], house_info[totalhouse][h_enter][1], house_info[totalhouse][h_enter][2], house_info[totalhouse][h_exit][0], house_info[totalhouse][h_exit][1], house_info[totalhouse][h_exit][2],
			params[0], params[1]);
			mysql_query(ConnectMysql, query);

			format(string, sizeof(string), "{FFFFFF}�� ������� ������� ���(�%d)!", totalhouse);
			SCM(playerid, COLOR_WHITE, string);

			house_info[totalhouse][h_icon] = CreateDynamicMapIcon(house_info[totalhouse][h_enter][0], house_info[totalhouse][h_enter][1], house_info[totalhouse][h_enter][2], 31, -1, 0, -1, -1, 400.0);
			house_info[totalhouse][h_pickup] = CreateDynamicPickup(1273, 23, house_info[totalhouse][h_enter][0], house_info[totalhouse][h_enter][1], house_info[totalhouse][h_enter][2],0, 0, -1);
			house_info[totalhouse][h_text] = Create3DTextLabel("{FFFFFF}��� ��������.\n ��� �������������� ������� - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[totalhouse][h_enter][0], house_info[totalhouse][h_enter][1], house_info[totalhouse][h_enter][2], 20.0, 0, 1);
			house_info[totalhouse][h_texit] = Create3DTextLabel("{FFFFFF}����� �����, ������� - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[totalhouse][h_exit][0], house_info[totalhouse][h_exit][1], house_info[totalhouse][h_exit][2], 20.0, totalhouse+50, 1);																
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
			if(!response) return SPD(playerid, DLG_APANEL, DSL, "{EDD682}AP - ������ ��������������", "{FFFFFF}1. ������� ��������������", "�������", "������");
			switch(listitem)
			{
				case 0: 
				{
					SPD(playerid, DLG_ACONE, DSL, "{EDD682}AP - ������������� 1-�� ������", 
					"{FFFFFF}/alogin - ����������� � (AP)\n\
					/apanel - ������ ��������������\n\
					/a - ��� ���������������\n\
					/world - ������ ����������� ��� (����)\n\
					/sethp - ���������� ���-�� ��������\n\
					/setarm - ���������� ���-�� �����\n\
					/seteat - ���������� ���-�� ���\n\
					/setwater - ���������� ���-�� ����\n\
					/tpcoord - �������� �� �����������(x,y,z)\n\
					/slap - ��������� ������\n\
					/for - ��������� ������\n\
					/freeze - ���������� ������", "�����", "");										
				}
				case 1: 
				{
					SPD(playerid, DLG_ACTWO, DSL, "{EDD682}AP - ������������� 2-�� ������", 
					"{FFFFFF}/gethere - ��������������� ������ � ����\n\
					/goto - ����������������� � ������\n\
					/veh - ������� ���������� ��������������\n\
					/hpcar - ���������� ���-�� �������� ������\n\
					/sefuel - ���������� ���-�� ������� � ������\n\
					/dellveh - ������� ��������� ������\n\
					/dellvehr - ������� ��������� ������ � �������\n\
					/setskin - ���������� ��������� ��������� ������\n\
					/givegun - ������ ������ ������\n\
					/kick - ������� ������ � �������\n\
					/skick - ���� ������� ������ � �������\n\
					/mute - ������������� ��� ������\n\
					/unmute - �������������� ��� ������", "�����", "");									
				}
				case 2: 
				{
					SPD(playerid, DLG_ACTHREE, DSL, "{EDD682}AP - ������������� 3-�� ������", 
					"{FFFFFF}/clearchat - �������� ��� ���� �������\n\
					/setweather - ���������� ������ �� �������", "�����", "");					
				}
				case 3: 
				{
					SPD(playerid, DLG_ACFOUR, DSL, "{EDD682}AP - ������������� 4-�� ������", 
					"{FFFFFF}/set_lvl - �������� ������� ������\n\
					/set_leader - ������ ����� ��������� ������", "�����", "");						
				}
				case 4: 
				{
					if(admin_info[playerid][alevel] < 5) return SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������ ��������!");	
					SPD(playerid, DLG_ACFIVE, DSL, "{EDD682}AP - ������������� 5-�� ������", 
					"{FFFFFF}/set_admin - ������ ����� �������������� ������\n\
					/set_money - ������ ������ ������\n\
					/create - ���� �������� (�����, ������� � �.�.)\n\
					/payday - ������� PayDay ���� �������", "�����", "");						
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
					SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� ��� ������� ����������!");
					return RemovePlayerFromVehicle(playerid);
				}
				if(player_info[playerid][money] < _priceCar(GetPlayerVehicleID(playerid)))
				{
					SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}� ��� �� ������� ����� ��� ������� ����� ����������!");
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
				format(string, sizeof(string), "{EDD682}[�����������]: {FFFFFF}�����������, �� ��������� ���������� {EDD682}%s {FFFFFF}�� {EDD682}%d {FFFFFF}������.", VehicleNames[player_info[playerid][p_model]-400], _priceCar(GetPlayerVehicleID(playerid)));
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
				"{EDD682}������� ������", 
				"{FFFFFF}������������� � ����������� ���� �� �������, �������������� � �������� �� ����������� ������ �� �������\n\
				������ � ����������� ���� �� �������, ���������� ������ ������ � ������� �������� �� �������� ��������\n\
				Slap (�����) � ��������� ���������, ������������ � ���� ��������������\n\
				Kick (���) � ��������� �� ��������� ������ �� ������������� �������, ������� ����������� ��������� ������� ������� ������\n\
				Mute (�������/���������� ����) � ��������� �� ��������� ������ �������, �������������� ��������� ��������� � ��� � �������� ��������� ������ �� ������������ ����\n\
				Voice Mute (������� ���������� ����) � ��������� �� ��������� ������ �������, �������������� ������������� ���������� ����\n\
				�������� � ��������� �� ��������� ������ ������� �� �������������; �����, � ������� ������������ ���������� ������� ����� ���������� ������� ������� �����\n\
				Warn (��������������) � ��������� �� ��������� ������ �������, ������� ������������ ���������� �� ������� �� ������������ ����\n\
				Ban (����������) � ��������� �� ��������� ������ �������, ������� ������������ ���� � ���� �� ������������ ����\n\
				����������� �������� � ��������� �� ������ ��������� ������ �������, ������� ����� ���� ������ ��� ������������ ������ ����������� �������������� ��� ��������������",
				"�����", "�����");									
			}
			else
			{
				SPD(playerid, DLG_MENU, DSL, "{EDD682}���� ���������", 
				"{EDD682}[1]{FFFFFF} - ���������� ���������\n\
				{EDD682}[2]{FFFFFF} - ������� �������\n\
				{EDD682}[3]{FFFFFF} - ��������� ����������\n\
				{EDD682}[4]{FFFFFF} - ��������� ������������\n\
				{EDD682}[5]{FFFFFF} - ����� � ��������������\n\
				{EDD682}[6]{FFFFFF} - ����������� ���������\n\
				{EDD682}[7]{FFFFFF} - ��������� �������\n\
				{EDD682}[8]{FFFFFF} - ������� �������\n\
				{EDD682}[9]{FFFFFF} - ����� ������", 
				"�������", "�������");								
			}
		}
		case DLG_PRULES_TWO:
		{
			if(!response) return _rulesPlayer(playerid);
			SPD(playerid, DLG_PRULES_THREE, DSM, 
			"{EDD682}������� ������", 
			"{FFFFFF}Away From Keyboard (AFK) � �����, ����� ������� ������ �� ������ �������� ����� � ��������� ��������� � �����������\n\
			���� � ������ �������� �����������, ���� �� ������������� �� ������ ������\n\
			������ � ��������� �� �� ����\n\
			Caps Lock � ���������, ���������� � ������� �������� ��������, �������� ������һ\n\
			Spawn � ����� ��������� �������� ���������\n\
			���������� �� ��������� � ����������������� ������� ������ � ���������� ��������� ������(�) ������� ��� ������",
			"�����", "");				
		}
		case DLG_PRULES_THREE:
		{
			SPD(playerid, DLG_PRULES_TWO, DSM, 
			"{EDD682}������� ������", 
			"{FFFFFF}������������� � ����������� ���� �� �������, �������������� � �������� �� ����������� ������ �� �������\n\
			������ � ����������� ���� �� �������, ���������� ������ ������ � ������� �������� �� �������� ��������\n\
			Slap (�����) � ��������� ���������, ������������ � ���� ��������������\n\
			Kick (���) � ��������� �� ��������� ������ �� ������������� �������, ������� ����������� ��������� ������� ������� ������\n\
			Mute (�������/���������� ����) � ��������� �� ��������� ������ �������, �������������� ��������� ��������� � ��� � �������� ��������� ������ �� ������������ ����\n\
			Voice Mute (������� ���������� ����) � ��������� �� ��������� ������ �������, �������������� ������������� ���������� ����\n\
			�������� � ��������� �� ��������� ������ ������� �� �������������; �����, � ������� ������������ ���������� ������� ����� ���������� ������� ������� �����\n\
			Warn (��������������) � ��������� �� ��������� ������ �������, ������� ������������ ���������� �� ������� �� ������������ ����\n\
			Ban (����������) � ��������� �� ��������� ������ �������, ������� ������������ ���� � ���� �� ������������ ����\n\
			����������� �������� � ��������� �� ������ ��������� ������ �������, ������� ����� ���� ������ ��� ������������ ������ ����������� �������������� ��� ��������������",
			"�����", "�����");				
		}	
		case DLG_INVITE:
		{
			new string[105];
			new actplayerid = GetPVarInt(playerid, "_invitePlayer");
			if(response)
			{
				player_info[playerid][member] = player_info[actplayerid][member];
				player_info[playerid][rang] = 1;

				format(string, sizeof(string), "{EDD682}[�����������] {FFFFFF}�� ������� ������������� � %s", _fracName(playerid));
				SCM(playerid, COLOR_WHITE, string);

				format(string, sizeof(string), "{EDD682}[�����������] {FFFFFF}����� %s[%d] ������ ���� ����������!", player_info[playerid][name], playerid);
				SCM(actplayerid, COLOR_WHITE, string);
				SCM(actplayerid, COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}�� �������� ������ ������ ������ ���������� - {EDD682}'/changeskin'{FFFFFF}!");
				
				DeletePVar(playerid, "_inviteGo");
				DeletePVar(actplayerid, "_invitePlayer");
			}
			else
			{
				format(string, sizeof(string), "{EDD682}[�����������] {FFFFFF}����� %s[%d] ��������� �� ������ ����������!", player_info[playerid][name], playerid);
				SCM(actplayerid, COLOR_WHITE, string);	

				SCM(playerid, COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}�� ���������� �� �����������!");

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
					SCM(playerid, COLOR_WHITE, "� ����������");					
				}				
			}
		}
		case DLG_ARENDACAR:
		{
			if(!response) return RemovePlayerFromVehicle(playerid);
			new vehicleid = GetPlayerVehicleID(playerid);
			if(player_info[playerid][lvl] < 2)
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}�� �� ������ ���������� ����������!");
				return RemovePlayerFromVehicle(playerid);
			}
			if(player_info[playerid][money] >= 5000)
			{
				_carRented[playerid] = true; // ��������, ��� ����� ��������� ����������
				_rentedCarID[playerid] = vehicleid; // ��������� ID ������������� ����������
				player_info[playerid][money] -= 5000;
				SCM(playerid, COLOR_WHITE, "{EDD682}[�����������] {FFFFFF}�� ������� ���������� ����������.");	
			}
			else
			{
				SCM(playerid, COLOR_WHITE, "{EDD682}[������]: {FFFFFF}������������ �������!");
				return RemovePlayerFromVehicle(playerid);
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
    if(clickedid == skinTextDraw[4])//������� � �����
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
    if(clickedid == skinTextDraw[3])//������� �����
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
	if(clickedid == skinTextDraw[2])//������
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

		SCM(playerid, COLOR_WHITE, !"�� ������� ������������������ �� ������� {EDD682}Russian History | CR Multiplayer! {FFFFFF}������� ����!");

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

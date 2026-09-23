/*==============================================================================
SAMP ELITE
���� �����, �������, �������� � ����� ��� ����� � SAMP (PAWN)
������ �� ������: https://vk.com/samp_elitka
����: https://www.youtube.com/c/INCEGAME

��������:
	- ������� � ������� ����������
	- ����������� ���������� ���� ����� ����������� ������������ �����
	- ���������� �������
	- ����� ������ ����������
	- �������/������� ����������
	- �������� ���. �����
	- ������������ ����������
	- ������� ���� ������.

�������:
	/carhelp   - ������ ��������� ������
	/park      - ���������� ������� ���� � �������
	/clock     - �������/������� �����
	/findcar   - ����� ������ ����
	/nomer     - ���������� ����� �� ���� �� 8 ��������
	/sellcar   - ������� ���� �� ������� �� ���������
	/mysellcar - ������� ���� ������
	/asave - ��������� ���� �� �������
	/fpa - ��� ������� ���� ��� ��� ����� �� �������(���� ���� ����� ������)
==============================================================================*/
#include <a_samp>
#include "../library/mdialog_legacy.inc"

#define COLOR_PURPLE												  0xDD90FFFF
#define TEAM_HIT_COLOR                                                0xFFFFFF00
#define COLOR_3DTEXT                                                   0x4CD10FF
#define COLOR_GREY 													  0xAFAFAFAA
#define COLOR_WHITE 												  0xFFFFFFAA
#define COLOR_GRAD2                                                   0xBFC0C2FF
#define COLOR_YELLOW 												  0xFFFF00AA
#define COLOR_LIGHTBLUE 											  0x33CCFFAA
#define TEAM_ORANGE_COLOR                                             0xFF830000

#define DIALOG_PLATE                                                         664
#define DIALOG_BUYVEH                                                        665
#define DIALOG_SELLVEH                                                       666
#define CHECKPOINT_FINDCAR 													 667
#define CHECKPOINT_NONE 													   0

new CarName[][] =
{
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
	"Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
	"Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection",
	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
	"Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
	"Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
	"Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van",
	"Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale",
	"Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
	"Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
	"Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
	"Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
	"Blista Compact", "Maverick", "Boxvillde", "Benson", "Mesa", "RC Goblin",
	"Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
	"Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt",
	"Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
	"FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
	"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
	"Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
	"Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
	"Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
	"Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratium",
	"Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
	"Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper",
	"Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
	"News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car",
	"Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha",
	"Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville",
	"Tiller", "Utility Trailer"
};

new CommandMas[256];
new gPlayerCheckpointStatus[MAX_PLAYERS];
new gCarLock[MAX_VEHICLES+1];
new engine,lights,alarm,doors,bonnet,boot,objective;
new PlayerBuyCar[MAX_PLAYERS][2];
forward DateProp(playerid);
forward Checkprop();
#define MAX_AUTO 3//������ ���������� ����������� ����
enum vInfo
{
	vOwned,
	vCoast,
	VehId,
    Float:vx,
    Float:vy,
    Float:vz,
    Float:vang,
	vColor1,
	vColor2,
	OwnerName[MAX_PLAYERS],
	vPlate[9],
	vLock,
	vRealID,
	vPjob,
	vWheel,
	vSpoiler,
	vHood,
	vRoof,
	vSideskirt,
	vLamps,
	vNitro,
	vExhaust,
	vStereo,
	vHydraulics,
	vFrontbumper,
	vRearbumper,
	vVentright,
	vVentleft,
	vDate
};
new VehicleInfo[MAX_AUTO][vInfo];
//==============================================================================
new CarOffered[MAX_PLAYERS];
new Text3D:info3d[sizeof(VehicleInfo)];
//==============================================================================
new Float:VehicleShopSpawn[sizeof(VehicleInfo)][4] = { // ����� ���� ����� ������� "/sellcar"
	{1630.187744,-1098.269653,23.577175,269.739959}, // 518(3000)
	{1630.537719,-1093.708862,23.571521,268.639099}, // 589(1000)
	{1630.737426,-1089.568725,24.026412,270.418823} // 482(100)
};
//==============================================================================
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Loading A�������� by SAMP ELITE (v0.3");
	print("--------------------------------------\n");
	LoadParkingSystem();//�������� ����
    for(new v = 0; v < sizeof(VehicleInfo); v++)
	{
		VehicleInfo[v][vRealID]=AddStaticVehicleEx(VehicleInfo[v][VehId], VehicleInfo[v][vx], VehicleInfo[v][vy], VehicleInfo[v][vz], VehicleInfo[v][vang], VehicleInfo[v][vColor1], VehicleInfo[v][vColor2],600000);
		info3d[v] = Create3DTextLabel( "_", TEAM_HIT_COLOR, 7.77, 7.77, 7.77, 10.0, 0, 1 );
		Attach3DTextLabelToVehicle(info3d[v], VehicleInfo[v][vRealID], 0.0, 0.0, 0.0 );
		SetVehicleNumberPlate(VehicleInfo[v][vRealID], VehicleInfo[v][vPlate]);
		SetVehicleToRespawn(VehicleInfo[v][vRealID]);
		if(VehicleInfo[v][vOwned]==1)
		{
			gCarLock[VehicleInfo[v][vRealID]] = 1;
		}
		new string[252];
 		new string_mlen = sizeof(string);
	 	if(VehicleInfo[v][vOwned]==0)
		{
			format(string,string_mlen,"{ffa500}[���� ���������� ��������]\n[�����: {FFFFFF}%s{ffa500}]\n[���������: {FFFFFF}%s{ffa500}]\n[�����������: {FFFFFF}%s{ffa500}]\n[���������: {FFFFFF}%d ${ffa500}]",CarName[GetVehicleModel(VehicleInfo[v][vRealID])-400],GetVehicleCategoryName(GetVehicleModel(VehicleInfo[v][vRealID])),GetVehicleModificationsName(GetVehicleModel(VehicleInfo[v][vRealID])),VehicleInfo[v][vCoast]);
			Update3DTextLabelText(info3d[v], COLOR_3DTEXT, string);
		}
		if(VehicleInfo[v][vOwned]==1)
		{
		    SetVehicleNumberPlate(VehicleInfo[v][vRealID], VehicleInfo[v][vPlate]);
			if(VehicleInfo[v][vPjob] != -1) ChangeVehiclePaintjob(VehicleInfo[v][vRealID],VehicleInfo[v][vPjob]);
			ChangeVehicleColor(VehicleInfo[v][vRealID],VehicleInfo[v][vColor1],VehicleInfo[v][vColor2]);
			if(VehicleInfo[v][vWheel] != 0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vWheel]);
			if(VehicleInfo[v][vSpoiler] != 0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vSpoiler]);
			if(VehicleInfo[v][vHood] != 0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vHood]);
		    if(VehicleInfo[v][vRoof] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vRoof]);
	        if(VehicleInfo[v][vSideskirt] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vSideskirt]);
		    if(VehicleInfo[v][vLamps] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vLamps]);
		    if(VehicleInfo[v][vNitro] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vNitro]);
		    if(VehicleInfo[v][vExhaust] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vExhaust]);
	        if(VehicleInfo[v][vStereo] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vStereo]);
	        if(VehicleInfo[v][vHydraulics] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vHydraulics]);
	        if(VehicleInfo[v][vFrontbumper] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vFrontbumper]);
		    if(VehicleInfo[v][vRearbumper] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vRearbumper]);
	        if(VehicleInfo[v][vVentright] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vVentright]);
      		if(VehicleInfo[v][vVentleft] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vVentleft]);
		}
	}
	SetTimer("SyncTime", 60000, true);
	return 1;
}
stock SyncTime()
{
	new string[64];
	new tmphour;
	new tmpminute;
	new tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	FixHour(tmphour);
	tmphour = shifthour;
	if ((tmphour > ghour) || (tmphour == 0 && ghour == 23))
	{
		format(string, sizeof(string), "[RP]Auto[RUS] ������ %d:00 ����(��)",tmphour);
		BroadCast(COLOR_WHITE,string);
		ghour = tmphour;
		sPayDays();
		if (realtime)
		{
			SetWorldTime(tmphour);
		}
	}
}
sPayDays()
{
	Checkprop();
	return true;
}
public OnPlayerConnect(playerid)
{
    DateProp(playerid);
    return 1;
}
stock UnLockCar(carid)
{
	Doors(carid,false);
	gCarLock[carid]=0;
}
stock LockCar(carid)
{
	Doors(carid,true);
	gCarLock[carid]=1;
}
stock Doors(vehicleid,bool:status)
{
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return status ? SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective) : SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_OFF, bonnet, boot, objective);
}
public OnVehicleStreamIn(vehicleid, forplayerid)
{
	//VehicleInfo[vehicleid][vLock] = 1;
	if(gCarLock[vehicleid]==1)
	{
		LockCar(vehicleid);
	}
	else
	{
	    UnLockCar(vehicleid);
	}
	return true;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
    new idx;
    new cmd[256];
	new tmp[256];
    cmd = strtok(cmdtext, idx);
    if(strcmp(cmd, "/carhelp", true) == 0 || strcmp(cmd, "/ch", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
	    {
		    SendClientMessage(playerid, COLOR_LIGHTBLUE,"{FFFFFF}[ /sellcar ] {F0DC82}- ������� ����������");
		    SendClientMessage(playerid, COLOR_LIGHTBLUE,"{FFFFFF}[ /mysellcar ] {F0DC82}- ������� ���������� ������");
		    SendClientMessage(playerid, COLOR_LIGHTBLUE,"{FFFFFF}[ /park ] {F0DC82}- �������� ����������");
		    SendClientMessage(playerid, COLOR_LIGHTBLUE,"{FFFFFF}[ /nomer ] {F0DC82}- �������� �����");
		    SendClientMessage(playerid, COLOR_LIGHTBLUE,"{FFFFFF}[ /findcar ] {F0DC82}- ����� ������ ����");
		    SendClientMessage(playerid, COLOR_LIGHTBLUE,"{FFFFFF}[ /clock ] {F0DC82}- �������/������� ����������");
		}
		return true;
	}
    if(strcmp("/clock", cmdtext, true, 6) == 0)
	{
	    new carid;
        if(IsCarOwner(playerid)) carid = GetPlayerOwnedCarID(playerid);
	    if( carid ){
	        new Float:Car_X,Float:Car_Y,Float:Car_Z;
	        GetVehiclePos(carid, Car_X, Car_Y, Car_Z);
	        if( PlayerToPoint(15.0, playerid, Car_X, Car_Y, Car_Z) )
			{
		        if(gCarLock[carid] == 0){
					GameTextForPlayer(playerid, "~w~Vehicle ~r~close", 5000, 6);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					LockCar(carid);
				}
				else{
					GameTextForPlayer(playerid, "~w~Vehicle ~g~open", 5000, 6);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					UnLockCar(carid);
				}
			}
			return true;
		}
		return true;
	}
	if(strcmp("/park", cmdtext, true, 6) == 0)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			for(new v = 0; v < sizeof(VehicleInfo); v++)
			{
	   			if(strcmp(VehicleInfo[v][OwnerName],PlayerName(playerid), true) == 0 && strlen(VehicleInfo[v][OwnerName]) == strlen(PlayerName(playerid)) )
				{
					if(GetPlayerVehicleID(playerid) == VehicleInfo[v][vRealID])
					{
					    new Float:vheal;
      					new panels,doorss,lightss,tires;
			            GetVehicleHealth(GetPlayerVehicleID(playerid),vheal);
			            GetVehicleDamageStatus(GetPlayerVehicleID(playerid),panels,doorss,lightss,tires);
						new vehid = VehicleInfo[v][vRealID];
						GetVehiclePos(vehid,VehicleInfo[v][vx],VehicleInfo[v][vy],VehicleInfo[v][vz]);
						GetVehicleZAngle(vehid,VehicleInfo[v][vang]);
						SaveParkingSystem();
						DestroyVehicle(VehicleInfo[v][vRealID]);
						VehicleInfo[v][vRealID]=CreateVehicle(VehicleInfo[v][VehId], VehicleInfo[v][vx], VehicleInfo[v][vy], VehicleInfo[v][vz], VehicleInfo[v][vang], VehicleInfo[v][vColor1], VehicleInfo[v][vColor2],600000);
						SetVehicleToRespawn(vehid);
						PutPlayerInVehicle(playerid,vehid,0);
						SendClientMessage(playerid, COLOR_GREY, "�� ������������ ���� ����������");
			            SetVehicleHealth(GetPlayerVehicleID(playerid),vheal);
            			UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doorss, lightss, tires);
					}
					else
					{
						SendClientMessage(playerid,COLOR_WHITE,"��� �� ��� ����������");
					}
				}
			}
		}
		return true;
	}
	if(strcmp("/findcar", cmdtext, true, 6) == 0)
	{
		for(new v = 0; v < sizeof(VehicleInfo); v++)
		{
   			if(strcmp(VehicleInfo[v][OwnerName],PlayerName(playerid), true) == 0 && strlen(VehicleInfo[v][OwnerName]) == strlen(PlayerName(playerid)) )
			{
				new Float:X,Float:Y,Float:Z;
				GetVehiclePos(VehicleInfo[v][vRealID],X,Y,Z);
				SetPlayerCheckpoint(playerid, X,Y,Z, 6);
				gPlayerCheckpointStatus[playerid] = CHECKPOINT_FINDCAR;
				GameTextForPlayer(playerid, "~w~Waypoint set ~r~Cars", 5000, 1);
			}
		}
		return true;
	}
	if(strcmp("/fpa", cmdtext, true, 6) == 0)
	{
	    for(new i=0; i<MAX_PLAYERS; i++)
		{
		    Checkprop();
		}
		sPayDays();
		return true;
	}
 	if(strcmp("/mysellcar", cmdtext, true, 6) == 0)
    {
        new giveplayerid;
        if(!IsCarOwner(playerid)) return SendClientMessage(playerid,COLOR_GREY,"� ��� ��� ������!");
        tmp = strtok(cmdtext, idx);
        if(!strlen(tmp)) return SendClientMessage(playerid,COLOR_GREY,"/mysellcar [ ID ������ ] [ ���� ]");
        giveplayerid = strval(tmp);
        if(!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, COLOR_GREY, "��� ������ ������.");
        if(!IsPlayerConnected(giveplayerid) || giveplayerid == playerid) return SendClientMessage(playerid,COLOR_GREY,"�� �� ������ ������� ������ ������ ����");
        tmp = strtok(cmdtext, idx);
        if(!strlen(tmp)) return SendClientMessage(playerid,COLOR_GREY,"/mysellcar [ ID ������ ] [ ���� ]");
        new sellcarprice = strval(tmp);
        if(IsCarOwner(giveplayerid)) return SendClientMessage(playerid, COLOR_GREY, "� ������ ��� ���� ������.");
        if(GetPlayerMoney(giveplayerid) < sellcarprice) return SendClientMessage(playerid,COLOR_GREY,"�� �� ������ ������� ������ ������ ����");
        PlayerBuyCar[giveplayerid][0] = playerid;
        PlayerBuyCar[giveplayerid][1] = sellcarprice;
		format(CommandMas,80,"�� ���������� %s'� ������ ������ �� $%d", PlayerName(playerid),PlayerBuyCar[giveplayerid][1]), SendClientMessage(playerid,0x6495EDFF, CommandMas);
        format(CommandMas, 80, "����� %s ���������� ��� ������ ������ �� $%d", PlayerName(playerid), PlayerBuyCar[giveplayerid][1]);
		ShowPlayerDialog(giveplayerid, DIALOG_SELLVEH, 0, "{FF6F00}������� ����", CommandMas, "��", "���");
        return true;
    }
  	if(strcmp("/sellcar", cmdtext, true, 6) == 0)
	{
	    new string[128];
		new carid;
		if(IsCarOwner(playerid)) carid = GetPlayerOwnedCarID(playerid);
		UnLockCar(carid);
  		for(new v = 0; v < sizeof(VehicleInfo); v++)
		{
   			if(strcmp(VehicleInfo[v][OwnerName],PlayerName(playerid), true) == 0 && strlen(VehicleInfo[v][OwnerName]) == strlen(PlayerName(playerid)) )
			{
				VehicleInfo[v][vOwned] = 0;
				VehicleInfo[v][vx] = VehicleShopSpawn[v][0];
				VehicleInfo[v][vy] = VehicleShopSpawn[v][1];
				VehicleInfo[v][vz] = VehicleShopSpawn[v][2];
				VehicleInfo[v][vang] = VehicleShopSpawn[v][3];
				VehicleInfo[v][vLock] = 0;
				strmid(VehicleInfo[v][OwnerName], "The State", 0, strlen("The State"), MAX_PLAYER_NAME);
				strmid(VehicleInfo[v][vPlate], "nomer", 0, strlen("nomer"), 9);
				VehicleInfo[v][vPjob] = -1;
				VehicleInfo[v][vWheel] = 0;
				VehicleInfo[v][vSpoiler] = 0;
				VehicleInfo[v][vHood] = 0;
			    VehicleInfo[v][vRoof] = 0;
		        VehicleInfo[v][vSideskirt] = 0;
			    VehicleInfo[v][vLamps] = 0;
			    VehicleInfo[v][vNitro] = 0;
			    VehicleInfo[v][vExhaust] = 0;
		        VehicleInfo[v][vStereo] = 0;
		        VehicleInfo[v][vHydraulics] = 0;
		        VehicleInfo[v][vFrontbumper] = 0;
			    VehicleInfo[v][vRearbumper] = 0;
		        VehicleInfo[v][vVentright] = 0;
       			VehicleInfo[v][vVentleft] = 0;
			    VehicleInfo[v][vDate] = 0;
				GivePlayerMoney(playerid,VehicleInfo[v][vCoast]/2);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				format(string, sizeof(string), "~w~You have sold your car for: ~n~~g~$%d", VehicleInfo[v][vCoast]/2);
				GameTextForPlayer(playerid, string, 10000, 3);
				RemovePlayerFromVehicle(playerid);
				TogglePlayerControllable(playerid, 1);
				SaveParkingSystem();
				DestroyVehicle(VehicleInfo[v][vRealID]);
                VehicleInfo[v][vRealID]=CreateVehicle(VehicleInfo[v][VehId], VehicleInfo[v][vx], VehicleInfo[v][vy], VehicleInfo[v][vz], VehicleInfo[v][vang], VehicleInfo[v][vColor1], VehicleInfo[v][vColor2],600000);
				updateVehicleInfo();
			}
		}
	    return true;
	}
 	if(strcmp(cmd, "/asave", true) == 0)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			tmp = strtok(cmdtext, idx);
			new coast = strval(tmp);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, "�����������: /asave [���������]");
				return true;
			}
			new File:VehicleFile, Line[128];
			new Float:vX, Float:vY, Float:vZ, Float:vA;
			new vModel = GetVehicleModel(GetPlayerVehicleID(playerid));
			GetVehiclePos(GetPlayerVehicleID(playerid), vX, vY, vZ);
			GetVehicleZAngle(GetPlayerVehicleID(playerid), vA);
			format(Line, sizeof(Line), "0|%d|%d|%f|%f|%f|%f|%d|%d|The State|nomer|0|-1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0\r\n", coast, vModel, vX, vY, vZ, vA, random(126), random(126));
			VehicleFile = fopen("auto/parking.cfg", io_append);
			fwrite(VehicleFile, Line);
			fclose(VehicleFile);
			format(Line, sizeof(Line), "{%f,%f,%f,%f}, // %d(%d)\r\n", vX, vY, vZ, vA, vModel, coast);
			VehicleFile = fopen("auto/parking.txt", io_append);
			fwrite(VehicleFile, Line);
			fclose(VehicleFile);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "������: ����� ���� �� ������� ���������");
		}
		else
		{
			SendClientMessage(playerid, COLOR_YELLOW, "�� ������ ���� � ���� !");
		}
		return true;
	}
	if(strcmp("/nomer", cmdtext, true, 6) == 0)
	{
  		for(new v = 0; v < sizeof(VehicleInfo); v++)
		{
			if(strcmp(VehicleInfo[v][OwnerName],PlayerName(playerid), true) == 0 && strlen(VehicleInfo[v][OwnerName]) == strlen(PlayerName(playerid)) )
			if(IsPlayerInAnyVehicle(playerid))
			{
			    ShowPlayerDialog(playerid,DIALOG_PLATE,DIALOG_STYLE_INPUT,"��������� ������:","������� ��� ����� ����� � ���� ����.","�������","������");
			}
			else
			{
			    SendClientMessage(playerid, COLOR_GREY, "�� ������ ���� � ���� ����������!");
			}
		}
	    return true;
	}
	return 0;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
    	for(new v = 0; v < sizeof(VehicleInfo); v++)
	    {
         	new newcar = GetPlayerVehicleID(playerid);
        	if(newcar == VehicleInfo[v][vRealID])
			{
			    if(VehicleInfo[v][vOwned]==0)
			    {
					CarOffered[playerid]=1;
					new str[512];
					format(str,sizeof(str),"{ffffff}���� ���������� ��������\n�����: %s\n���������: %s\n�����������: %s\n���������: %d$\n��� ������� ������� '������'\n���� �� �� ������ �������� ���� ������� '�����'",CarName[GetVehicleModel(VehicleInfo[v][vRealID])-400],GetVehicleCategoryName(GetVehicleModel(VehicleInfo[v][vRealID])),GetVehicleModificationsName(GetVehicleModel(VehicleInfo[v][vRealID])),VehicleInfo[v][vCoast]);
					ShowPlayerDialog(playerid,DIALOG_BUYVEH,DIALOG_STYLE_MSGBOX,"������� ����:",str,"������","�����");
					break;
				}
			}
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    switch (gPlayerCheckpointStatus[playerid])
	{
		case CHECKPOINT_FINDCAR:
		{
			PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
			DisablePlayerCheckpoint(playerid);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
			GameTextForPlayer(playerid, "~w~You are~n~~y~Cars", 5000, 1);
		}
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
    for(new v = 0; v < sizeof(VehicleInfo); v++)
	{
		if(VehicleInfo[v][vOwned]==1)
		{
			if(vehicleid == VehicleInfo[v][vRealID])
			{
			    SetVehicleNumberPlate(VehicleInfo[v][vRealID], VehicleInfo[v][vPlate]);
				if(VehicleInfo[v][vPjob] != -1) ChangeVehiclePaintjob(VehicleInfo[v][vRealID],VehicleInfo[v][vPjob]);
				ChangeVehicleColor(VehicleInfo[v][vRealID],VehicleInfo[v][vColor1],VehicleInfo[v][vColor2]);
				if(VehicleInfo[v][vWheel] != 0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vWheel]);
				if(VehicleInfo[v][vSpoiler] != 0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vSpoiler]);
				if(VehicleInfo[v][vHood] != 0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vHood]);
			    if(VehicleInfo[v][vRoof] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vRoof]);
		        if(VehicleInfo[v][vSideskirt] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vSideskirt]);
			    if(VehicleInfo[v][vLamps] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vLamps]);
			    if(VehicleInfo[v][vNitro] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vNitro]);
			    if(VehicleInfo[v][vExhaust] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vExhaust]);
		        if(VehicleInfo[v][vStereo] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vStereo]);
		        if(VehicleInfo[v][vHydraulics] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vHydraulics]);
		        if(VehicleInfo[v][vFrontbumper] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vFrontbumper]);
			    if(VehicleInfo[v][vRearbumper] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vRearbumper]);
		        if(VehicleInfo[v][vVentright] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vVentright]);
       			if(VehicleInfo[v][vVentleft] !=0) AddVehicleComponent(VehicleInfo[v][vRealID],VehicleInfo[v][vVentleft]);
			}
		}
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
    for(new v = 0; v < sizeof(VehicleInfo); v++)
	{
		if(VehicleInfo[v][vOwned]==1)
		{
		  	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && vehicleid == VehicleInfo[v][vRealID])
			{
				VehicleInfo[v][vSpoiler]      = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_SPOILER);
				VehicleInfo[v][vWheel]      = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_WHEELS);
				VehicleInfo[v][vHood]     = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_HOOD);
				VehicleInfo[v][vRoof]        = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_ROOF);
				VehicleInfo[v][vSideskirt]        = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_SIDESKIRT);
				VehicleInfo[v][vLamps]    = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_LAMPS);
				VehicleInfo[v][vNitro]    = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_NITRO);
				VehicleInfo[v][vStereo]    = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_STEREO);
				VehicleInfo[v][vHydraulics]    = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_HYDRAULICS);
				VehicleInfo[v][vFrontbumper]    = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_FRONT_BUMPER);
				VehicleInfo[v][vRearbumper]    = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_REAR_BUMPER);
				VehicleInfo[v][vVentright]    = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_VENT_RIGHT);
				VehicleInfo[v][vVentleft]    = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_VENT_LEFT);
				VehicleInfo[v][vExhaust]    = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_EXHAUST);
				//SaveParkingSystem();
			}
		}
	}
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    for(new v = 0; v < sizeof(VehicleInfo); v++)
	{
		if(VehicleInfo[v][vOwned]==1)
		{
			if(vehicleid == VehicleInfo[v][vRealID])
			{
				VehicleInfo[v][vPjob] = paintjobid;
				//SaveParkingSystem();
			}
		}
	}
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    for(new v = 0; v < sizeof(VehicleInfo); v++)
	{
		if(VehicleInfo[v][vOwned]==1)
		{
		    if(vehicleid == VehicleInfo[v][vRealID])
			{
				VehicleInfo[v][vColor1] = color1;
				VehicleInfo[v][vColor2] = color2;
				//SaveParkingSystem();
			}
		}
	}
	return 1;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	SetVehicleParamsForPlayer(vehicleid, playerid, 0, gCarLock[vehicleid]);
    return 1;
}
IsCarOwner(playerid)
{
	for(new i=0;i<sizeof(VehicleInfo);i++)
	{
	 	if(strcmp(VehicleInfo[i][OwnerName],PlayerName(playerid), true) == 0 && strlen(VehicleInfo[i][OwnerName]) == strlen(PlayerName(playerid)) ){
	  	return 1;
   		}
	}
	return 0;
}
ReNameOwner(playerid, NewName[])
{
	for(new i=0;i<sizeof(VehicleInfo);i++)
	{
	 	if(strcmp(VehicleInfo[i][OwnerName],PlayerName(playerid), true) == 0 && strlen(VehicleInfo[i][OwnerName]) == strlen(PlayerName(playerid)) ){
            format(VehicleInfo[i][OwnerName], MAX_PLAYER_NAME, NewName);
            SaveParkingSystem();
            return 1;
        }
    }
    return 0;
}
GetPlayerOwnedCarID(playerid)
{
	for(new i=0;i<sizeof(VehicleInfo);i++)
	{
	 	if(strcmp(VehicleInfo[i][OwnerName],PlayerName(playerid), true) == 0 && strlen(VehicleInfo[i][OwnerName]) == strlen(PlayerName(playerid)) ){
	        return VehicleInfo[i][vRealID];
	    }
	}
	return -1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_BUYVEH)
    {
		if(!response) return RemovePlayerFromVehicle(playerid);
		else
		{
		    if(IsCarOwner(playerid))
		    {
				SendClientMessage(playerid,COLOR_GREY,"�������� ����������: � ��� ��� ���� ������");
				TogglePlayerControllable(playerid,1);
				RemovePlayerFromVehicle(playerid);
				return 1;
		    }
		    if(IsPlayerConnected(playerid))
		    {
          		for(new v = 0; v < sizeof(VehicleInfo); v++)
		        {
					if(VehicleInfo[v][vRealID] == GetPlayerVehicleID(playerid))
					{
						if(VehicleInfo[v][vOwned]==1)
						{
						    SendClientMessage(playerid, COLOR_GREY, "���� ���������� �� ��������");
							CarOffered[playerid]=0;
	        				RemovePlayerFromVehicle(playerid);
	        				TogglePlayerControllable(playerid, 1);
						    return true;
						}
						else if(GetPlayerMoney(playerid) >= VehicleInfo[v][vCoast])
						{
							VehicleInfo[v][vOwned] = 1;
							CarOffered[playerid]=0;
							strmid(VehicleInfo[v][OwnerName], PlayerName(playerid), 0, strlen(PlayerName(playerid)), MAX_PLAYER_NAME);
							GivePlayerMoney(playerid,-VehicleInfo[v][vCoast]);
							SendClientMessage(playerid, COLOR_GRAD2, "�� ������ ���� ���������� � ��� � ��� � ����������!");
							SendClientMessage(playerid, COLOR_GRAD2, "��� ������ ������� /carhelp!");
							TogglePlayerControllable(playerid, 1);
							SaveParkingSystem();
							DateProp(playerid);
							updateVehicleInfo();
							return true;
						}
						else
						{
							SendClientMessage(playerid, COLOR_GREY, "� ��� ���� ����� ��� ������� ����� ����������!");
							CarOffered[playerid]=0;
	        				RemovePlayerFromVehicle(playerid);
	        				TogglePlayerControllable(playerid, 1);
							return true;
						}
					}
				}
			}
		}
	}
	else if(dialogid == DIALOG_PLATE)
	{
		if(!response)
		{
			return true;
		}
		else
		{
  			if(strlen(inputtext)>8)
		    {
		        SendClientMessage(playerid,COLOR_WHITE,"� ������ ����� ������������ �������� 8 ��������");
		        return true;
		    }
	  		for(new v = 0; v < sizeof(VehicleInfo); v++)
			{
			    if(strcmp(VehicleInfo[v][OwnerName],PlayerName(playerid), true) == 0 && strlen(VehicleInfo[v][OwnerName]) == strlen(PlayerName(playerid)) )
				{
					if(GetPlayerVehicleID(playerid) == VehicleInfo[v][vRealID])
					{
					    new Float:vheal;
      					new panels,doorss,lightss,tires;
			            GetVehicleHealth(GetPlayerVehicleID(playerid),vheal);
			            GetVehicleDamageStatus(GetPlayerVehicleID(playerid),panels,doorss,lightss,tires);
					    new vehid = VehicleInfo[v][vRealID];
			            new Float:x,Float:y,Float:z,Float:ang;
			            SetVehicleNumberPlate(vehid, inputtext);
			            strmid(VehicleInfo[v][vPlate], inputtext, 0, strlen(inputtext), 9);
						GetVehiclePos(vehid,x,y,z);
						GetVehicleZAngle(vehid,ang);
						SetVehicleToRespawn(vehid);
						SetVehiclePos(vehid,x,y,z);
						PutPlayerInVehicle(playerid,vehid,0);
						SetVehicleZAngle(vehid,ang);
						SendClientMessage(playerid, COLOR_GREY, "�� �������� ����� ������ ����������!");
						SaveParkingSystem();
						SetVehicleHealth(GetPlayerVehicleID(playerid),vheal);
            			UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doorss, lightss, tires);
					}
				}
			}
  		}
  	}
  	else if(dialogid == DIALOG_SELLVEH)
	{
		if(response)
		{
			if(!IsPlayerConnected(PlayerBuyCar[playerid][0]))
	        {
	            SendClientMessage(playerid,COLOR_GREY,"��� ����� �� ��������� ������ ������.");
	            PlayerBuyCar[playerid][0] = INVALID_PLAYER_ID;
	            PlayerBuyCar[playerid][1] = 0;
	            return 1;
	        }
	        GivePlayerMoney(playerid,-PlayerBuyCar[playerid][1]);
	        GivePlayerMoney(PlayerBuyCar[playerid][0], PlayerBuyCar[playerid][1]);
	        ReNameOwner(PlayerBuyCar[playerid][0], PlayerName(playerid));
	        SendClientMessage(playerid,COLOR_GREY,"����������� � ����� ��������!");
	        SendClientMessage(PlayerBuyCar[playerid][0], COLOR_YELLOW, "������ ������� �������!");
	        PlayerBuyCar[playerid][0] = INVALID_PLAYER_ID;
	        PlayerBuyCar[playerid][1] = 0;
		}
		else SendClientMessage(PlayerBuyCar[playerid][0],0x6495EDFF,"���������� ��������� �� ������� ����� ������!");
		return true;
	}
	return 1;
}

stock updateVehicleInfo()
{
	new string[252];
 	new string_mlen = sizeof(string);
    for(new v = 0; v < sizeof(VehicleInfo); v++)
 	{
		if(VehicleInfo[v][vOwned]==0)
		{
			format(string,string_mlen,"{ffa500}[���� ���������� ��������]\n[�����: {FFFFFF}%s{ffa500}]\n[���������: {FFFFFF}%s{ffa500}]\n[�����������: {FFFFFF}%s{ffa500}]\n[���������: {FFFFFF}%d ${ffa500}]",CarName[GetVehicleModel(VehicleInfo[v][vRealID])-400],GetVehicleCategoryName(GetVehicleModel(VehicleInfo[v][vRealID])),GetVehicleModificationsName(GetVehicleModel(VehicleInfo[v][vRealID])),VehicleInfo[v][vCoast]);
			Update3DTextLabelText(info3d[v], COLOR_3DTEXT, string);
		}
		else
		{
			Update3DTextLabelText(info3d[v], TEAM_HIT_COLOR, "_");
		}
	}
	return true;
}

public DateProp(playerid)
{
	new curdate = getdate();
	new year,month,day;
	getdate(year, month, day);
    for(new v = 0; v < sizeof(VehicleInfo); v++)
	{
		if(strcmp(PlayerName(playerid), VehicleInfo[v][OwnerName], true) == 0)
		{
			VehicleInfo[v][vDate] = curdate;
			SaveParkingSystem();
		}
	}
	return true;
}

public Checkprop()
{
	new string[112];
	new olddate;
	new curdate = getdate();
	new year,month,day;
	getdate(year, month, day);
    for(new v = 0; v < sizeof(VehicleInfo); v++)
	{
	    if(VehicleInfo[v][vOwned]==1)
		{
			if(VehicleInfo[v][vOwned] == 1 && VehicleInfo[v][vDate] > 3)
			{
				olddate = VehicleInfo[v][vDate];
				if(curdate-olddate >= 3)
				{
					VehicleInfo[v][vOwned] = 0;
					VehicleInfo[v][vx] = VehicleShopSpawn[v][0];
					VehicleInfo[v][vy] = VehicleShopSpawn[v][1];
					VehicleInfo[v][vz] = VehicleShopSpawn[v][2];
					VehicleInfo[v][vang] = VehicleShopSpawn[v][3];
					VehicleInfo[v][vLock] = 0;
					strmid(VehicleInfo[v][OwnerName], "The State", 0, strlen("The State"), MAX_PLAYER_NAME);
					strmid(VehicleInfo[v][vPlate], "nomer", 0, strlen("nomer"), 9);
					VehicleInfo[v][vPjob] = -1;
					VehicleInfo[v][vWheel] = 0;
					VehicleInfo[v][vSpoiler] = 0;
					VehicleInfo[v][vHood] = 0;
					VehicleInfo[v][vRoof] = 0;
					VehicleInfo[v][vSideskirt] = 0;
					VehicleInfo[v][vLamps] = 0;
					VehicleInfo[v][vNitro] = 0;
					VehicleInfo[v][vExhaust] = 0;
					VehicleInfo[v][vStereo] = 0;
					VehicleInfo[v][vHydraulics] = 0;
					VehicleInfo[v][vFrontbumper] = 0;
					VehicleInfo[v][vRearbumper] = 0;
					VehicleInfo[v][vVentright] = 0;
					VehicleInfo[v][vVentleft] = 0;
					VehicleInfo[v][vDate] = 0;
                    SaveParkingSystem();
					DestroyVehicle(VehicleInfo[v][vRealID]);
	                VehicleInfo[v][vRealID]=CreateVehicle(VehicleInfo[v][VehId], VehicleInfo[v][vx], VehicleInfo[v][vy], VehicleInfo[v][vz], VehicleInfo[v][vang], VehicleInfo[v][vColor1], VehicleInfo[v][vColor2],600000);
					updateVehicleInfo();
					if(VehicleInfo[v][vOwned]==0)
					{
						gCarLock[VehicleInfo[v][vRealID]] = 0;
					}
					format(string, sizeof(string), "������� ����-�������: ���������� %s'� (%d ��) ��� ��������� �� ������� �� %d $", VehicleInfo[v][OwnerName], v, VehicleInfo[v][vCoast]);
					SendClientMessageToAll(TEAM_ORANGE_COLOR, string);
				}
			}
		}
	}
	return true;
}
stock LoadParkingSystem()
{
	new arrCoords[29][64];
	new strFromFile2[256];
	new File: file = fopen("auto/parking.cfg", io_read);
	if(file)
	{
		new idx;
		while (idx < sizeof(VehicleInfo))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			VehicleInfo[idx][vOwned] = strval(arrCoords[0]);
			VehicleInfo[idx][vCoast] = strval(arrCoords[1]);
			VehicleInfo[idx][VehId] = strval(arrCoords[2]);
			VehicleInfo[idx][vx] = floatstr(arrCoords[3]);
			VehicleInfo[idx][vy] = floatstr(arrCoords[4]);
			VehicleInfo[idx][vz] = floatstr(arrCoords[5]);
			VehicleInfo[idx][vang] = floatstr(arrCoords[6]);
			VehicleInfo[idx][vColor1] = strval(arrCoords[7]);
			VehicleInfo[idx][vColor2] = strval(arrCoords[8]);
			strmid(VehicleInfo[idx][OwnerName], arrCoords[9], 0, strlen(arrCoords[9]), MAX_PLAYER_NAME);
			strmid(VehicleInfo[idx][vPlate], arrCoords[10], 0, strlen(arrCoords[10]), 9);
			VehicleInfo[idx][vLock] = strval(arrCoords[11]);
			VehicleInfo[idx][vPjob] = strval(arrCoords[12]);
			VehicleInfo[idx][vWheel] = strval(arrCoords[13]);
			VehicleInfo[idx][vSpoiler] = strval(arrCoords[14]);
			VehicleInfo[idx][vHood] = strval(arrCoords[15]);
			VehicleInfo[idx][vRoof] = strval(arrCoords[16]);
			VehicleInfo[idx][vSideskirt] = strval(arrCoords[17]);
			VehicleInfo[idx][vLamps] = strval(arrCoords[18]);
			VehicleInfo[idx][vNitro] = strval(arrCoords[19]);
			VehicleInfo[idx][vExhaust] = strval(arrCoords[20]);
			VehicleInfo[idx][vStereo] = strval(arrCoords[21]);
			VehicleInfo[idx][vHydraulics] = strval(arrCoords[22]);
			VehicleInfo[idx][vFrontbumper] = strval(arrCoords[23]);
			VehicleInfo[idx][vRearbumper] = strval(arrCoords[24]);
			VehicleInfo[idx][vVentright] = strval(arrCoords[25]);
			VehicleInfo[idx][vVentleft] = strval(arrCoords[26]);
			VehicleInfo[idx][vDate] = strval(arrCoords[27]);
			idx++;
		}
		fclose(file);
	}
	return true;
}

stock SaveParkingSystem()
{
	new idx;
	new File: file2;
	while (idx < sizeof(VehicleInfo))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%d|%d|%d|%f|%f|%f|%f|%d|%d|%s|%s|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d\n",
		VehicleInfo[idx][vOwned],
		VehicleInfo[idx][vCoast],
		VehicleInfo[idx][VehId],
		VehicleInfo[idx][vx],
		VehicleInfo[idx][vy],
		VehicleInfo[idx][vz],
		VehicleInfo[idx][vang],
		VehicleInfo[idx][vColor1],
		VehicleInfo[idx][vColor2],
		VehicleInfo[idx][OwnerName],
		VehicleInfo[idx][vPlate],
		VehicleInfo[idx][vLock],
		VehicleInfo[idx][vPjob],
		VehicleInfo[idx][vWheel],
		VehicleInfo[idx][vSpoiler],
		VehicleInfo[idx][vHood],
		VehicleInfo[idx][vRoof],
		VehicleInfo[idx][vSideskirt],
		VehicleInfo[idx][vLamps],
		VehicleInfo[idx][vNitro],
		VehicleInfo[idx][vExhaust],
		VehicleInfo[idx][vStereo],
		VehicleInfo[idx][vHydraulics],
		VehicleInfo[idx][vFrontbumper],
		VehicleInfo[idx][vRearbumper],
		VehicleInfo[idx][vVentright],
		VehicleInfo[idx][vVentleft],
		VehicleInfo[idx][vDate]);

		if(idx == 0)
		{
			file2 = fopen("auto/parking.cfg", io_write);
		}
		else
		{
			file2 = fopen("auto/parking.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return true;
}
stock PlayerName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	return name;
}
stock GetVehicleCategoryName(model) //
{
	new vcname[32];
	switch(model)
	{
	case 400, 424, 444, 470, 489, 495, 500, 505, 556, 557, 568 ,573 ,579: vcname="Off Road";
	case 445, 504, 401, 518, 527, 542, 507, 562, 585, 419, 526, 604, 466, 492, 474, 546, 517, 410, 551, 516, 467, 426, 436, 547, 405, 580, 560, 550, 549, 540, 491, 529, 421: vcname="Saloons";
	case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513: vcname="Airplanes";
	case 548, 425, 417, 487, 488, 497, 563, 447, 469: vcname="Helicopters";
	case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: vcname="Bikes";
	case 480, 533, 439, 555: vcname="Convertibles";
	case 499, 422, 482, 498, 609, 524, 578, 455, 414, 403, 582, 443, 514, 600, 413, 515, 440, 543, 605, 459, 531, 408, 552, 478, 456, 554: vcname="Industrial";
	case 536, 575, 534, 567, 535, 566, 576, 412: vcname="Lowriders";
	case 416, 433, 431, 438, 437, 427, 490, 528, 407, 544, 596, 597, 598, 599, 432, 601, 420: vcname="void Service";
	case 602, 429, 496, 402, 541, 415, 589, 587, 565, 494, 502, 503, 411, 559, 603, 475, 506, 451, 558, 477: vcname="Sport Vehicles";
	case 418, 404, 479, 458, 561: vcname="Station Wagons";
	case 472, 473, 493, 595, 484, 430, 453, 452, 446, 454: vcname="Boats";
	case 485, 538, 457, 483, 508, 434, 545, 588, 571, 572, 532, 486, 406, 530, 537, 423, 442, 428, 409, 574, 449, 525, 583, 539: vcname="Unique Vehicles";
	case 441, 464, 465, 501, 564, 594: vcname="RC Vehicles";
	case 435, 450, 591, 606, 607, 610, 569, 590, 584, 570, 608, 611: vcname="Trailers";
	default: vcname = "None";
	}
	return vcname;
}
stock GetVehicleModificationsName(model) //
{
	new vmname[32];
	switch(model)
	{
	case 400..402, 404, 405, 409..411, 415, 418..422, 424, 426, 429, 436, 438, 439, 442, 445, 451, 458, 466, 467, 474, 475, 477..480, 489: vmname="Transfender";
	case 496, 500, 505..507, 516..518, 526, 527, 529, 533, 540..542, 545..547, 549..551, 555, 579, 580, 585, 587, 600, 602, 603, 491, 492: vmname="Transfender";
	case 412, 534..536, 566, 567, 576: vmname="Loco Low Co";
	case 558..562, 565: vmname="Wheel Arch Angels";
	default: vmname = "None";
	}
	return vmname;
}
stock SetVehiclePosition(vehicleid, Float:X, Float:Y, Float:Z)
{
    SetVehiclePos(vehicleid ,X,Y,Z);
}
stock split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
		if(strsrc[i]==delimiter || i==strlen(strsrc)){
			len = strmid(strdest[aNum], strsrc, li, i, 128);
			strdest[aNum][len] = 0;
			li = i+1;
			aNum++;
		}
		i++;
	}
	return true;
}
strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
stock PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}

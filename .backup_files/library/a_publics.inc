// publics`s
publics: CheckAccount(playerid)
{
	new rows;
	cache_get_row_count(rows);
 	if(rows)
 	{
		cache_get_value_name(0, "password", player_info[playerid][pass], 65);
		cache_get_value_name(0, "salt", player_info[playerid][salt], 11);
		cache_get_value_name_int(0, "baninfo", player_info[playerid][baninfo]);
		cache_get_value_name_int(0, "member", player_info[playerid][member]);
		cache_get_value_name_int(0, "keyh", player_info[playerid][keyh]);
		cache_get_value_name_int(0, "keya", player_info[playerid][keya]);
		cache_get_value_name_float(0, "exitx", player_info[playerid][exitx]);
		cache_get_value_name_float(0, "exity", player_info[playerid][exity]);
		cache_get_value_name_float(0, "exitz", player_info[playerid][exitz]);
		cache_get_value_name_float(0, "exitfa", player_info[playerid][exitfa]);
		cache_get_value_name_int(0, "p_world", player_info[playerid][p_world]);
		cache_get_value_name_int(0, "p_interior", player_info[playerid][p_interior]);						
		if(player_info[playerid][baninfo] != 0)
		{
			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `ban_accounts` WHERE `name` = '%s'", player_info[playerid][name]);
			mysql_tquery(ConnectMysql, query, "CheckAccountsBan", "i", playerid);		
		}
		else _showLogin(playerid);	
 	}
	else _showRegistration(playerid);
}

publics: CheckAccountsBan(playerid)
{
	new rows;
	cache_get_row_count(rows);
 	if(rows)
	{
		new string[256];
		new year, month, day, hour, minute, second;
		cache_get_value_name(0, "aname", banned_info[playerid][aname], 25);
		cache_get_value_name(0, "whendate", banned_info[playerid][whendate], 28);
		cache_get_value_name_int(0, "enddate", banned_info[playerid][enddate]);
		cache_get_value_name(0, "reason", banned_info[playerid][banreason], 129);
		gmtime(banned_info[playerid][enddate], year, month, day, hour, minute, second);
		if(banned_info[playerid][enddate] > gettime())
		{
			format(string, sizeof(string), 
			"{FFFFFF}Заблокировал : %s\n\
			Дата блокировки: %s\n\
			Дата разблокировки: %02d-%02d-%04d %02d:%02d:%02d\n\
			Причина: %s\n\
			Вы сможете оспорить решение администратора, подав жалобу на форум!",
			banned_info[playerid][aname], banned_info[playerid][whendate], day, month, year, hour+3, minute, second, banned_info[playerid][banreason]);
			SPD(playerid, 0, DSM, "{9D2D30}Аккаунт заблокирован", string, "Закрыть", "");
			Kick(playerid);
			mktime(year, month, day, hour, minute, second);
		}
		else
		{
			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "DELETE FROM `ban_accounts` WHERE `name` = '%s'", player_info[playerid][name]);
			mysql_tquery(ConnectMysql, query);

			query[0] = EOS;
			mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `baninfo` = '%d'  WHERE `name` = '%s'", 0, player_info[playerid][name]);
			mysql_tquery(ConnectMysql, query);
			_showLogin(playerid);
		}
	}	
}

publics: UnBanAccount(playerid, params[])
{
	new rows;
	cache_get_row_count(rows);
 	if(rows)
	{
		new string[55+(-2+11)+(-2+MAX_PLAYER_NAME)+(-2+1)+(-2+MAX_PLAYER_NAME)];
		format(string, sizeof(string), "Администратор %d уровня %s[%d] разблокировал аккаунт игроку %s.", admin_info[playerid][alevel], player_info[playerid][name], playerid, params);
		SAM(COLOR_SRED, string, 1);

		format(string, sizeof(string), "Администратор %s[%d] разблокировал аккаунт игроку %s.", player_info[playerid][name], playerid, params);
		SCMTA(COLOR_SRED, string);		

		query[0] = EOS;
		mysql_format(ConnectMysql, query, sizeof(query), "DELETE FROM `ban_accounts` WHERE `name` = '%s'", params);
		mysql_tquery(ConnectMysql, query);

		query[0] = EOS;
		mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `baninfo` = '%d'  WHERE `name` = '%s'", 0, params);
		mysql_tquery(ConnectMysql, query);	
	}
	else 
	{
		SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Указанный вами аккаунт не заблокирован на проекте!");		
	}
}

publics: OffBanAccount(playerid, params[], dayb, reason[])
{
	new rows, string[131+(-2+MAX_PLAYER_NAME)+(-2+1)+(-2+MAX_PLAYER_NAME)+(-2+31)];
	cache_get_row_count(rows);
 	if(rows)
	{
		cache_get_value_name_int(0, "baninfo", player_info[params[0]][baninfo]);
		if(player_info[params[0]][baninfo] == 1)
		{
			format(string, sizeof(string), "{EDD682}[Ошибка]: {FFFFFF}Аккаунт %s уже заблокирован", params);
			return SCM(playerid, COLOR_WHITE, string);			
		}
		new time = gettime();
		new end = time + (dayb * 3600 * 24);
		new hour, minute, second, day, month, year, timeban[28]; 
		gettime(hour, minute, second);
		getdate(year, month, day);	
		format(timeban, sizeof(timeban), "%02d:%02d:%d %02d:%02d:%02d", day, month, year, hour, minute, second);

		query[0] = EOS;
		mysql_format(ConnectMysql, query, sizeof(query), "INSERT INTO `ban_accounts`(`aname`, `name`, `whendate`, `enddate`, `dayban`, `reason`) VALUES ('%s','%s','%s','%d','%d','%s')", 
		player_info[playerid][name], params, timeban, end, dayb, reason);
		mysql_query(ConnectMysql, query);

		query[0] = EOS;
		mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `baninfo` = '%d'  WHERE `name` = '%s'", 1, params);
		mysql_tquery(ConnectMysql, query);	

		format(string, sizeof(string), "Администратор %s[%d] заблокировал игрока в оффлайне %s на %d дней. Причина: %s.", player_info[playerid][name], playerid, params, dayb, reason);
		SCMTA(COLOR_SRED, string);
	}
	else
	{
		format(string, sizeof(string), "{EDD682}[Ошибка]: {FFFFFF}Аккаунт %s не существует", params);
		SCM(playerid, COLOR_WHITE, string);
	}
	return 1;	
}

publics: CheckReferal(playerid, referal[])
{
	new rows;
	cache_get_row_count(rows);
 	if(rows)
 	{
		cache_get_value_name_int(0, "id", player_info[playerid][ref]);
  		SPD(playerid, DLG_REGSEX, DSM, "{EDD682}Регистрация {FFFFFF}| Выбор пола",
		"{FFFFFF}Выберите пол вашего будущего персонажа",
		"Мужской", "Женский");
 	}
	else
	{
		SPD(playerid, DLG_REGREF, DSI, "{EDD682}Регистрация {FFFFFF}| Ввод пригласившего",
		"{FFFFFF}Ты можешь указать имя пригласившего тебя человека\n\
		Для этого просто запиши имя в поле ниже, либо нажми на кнопку \"Пропустить\"",
		"Далее", "Пропустить");
		return SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Аккаунта с таким именем не существует.");
	}
	return 1;
}

publics: PlayerLogin(playerid)
{
	new rows;
	cache_get_row_count(rows);
 	if(rows)
 	{
 	    cache_get_value_name_int(0, "id", player_info[playerid][id]);
 	    cache_get_value_name(0, "email", player_info[playerid][email], 64);
 	    cache_get_value_name_int(0, "ref", player_info[playerid][ref]);
 	    cache_get_value_name_int(0, "sex", player_info[playerid][sex]);
 	    cache_get_value_name_int(0, "age", player_info[playerid][age]);
 	    cache_get_value_name_int(0, "skin", player_info[playerid][skin]);
 	    cache_get_value_name(0, "regdata", player_info[playerid][regdata], 13);
		cache_get_value_name(0, "logindata", player_info[playerid][logindata], 13);
 	    cache_get_value_name(0, "regip", player_info[playerid][regip], 16);
		cache_get_value_name_int(0, "lvl", player_info[playerid][lvl]);	
		cache_get_value_name_int(0, "exp", player_info[playerid][exp]);
		cache_get_value_name_int(0, "money", player_info[playerid][money]);	
		cache_get_value_name_float(0, "health", player_info[playerid][health]);	
		cache_get_value_name_float(0, "armor", player_info[playerid][armor]);
		cache_get_value_name_int(0, "thirst", player_info[playerid][thirst]);	
		cache_get_value_name_int(0, "eat", player_info[playerid][eat]);
		new buffer[32];
		cache_get_value_name(0, "bank_pin", buffer, 16);
		sscanf(buffer, "p<,>a<i>[2]", player_info[playerid][bank_pin]);	
		new buffer_two[32];
		cache_get_value_name(0, "lic", buffer_two, 16);
		sscanf(buffer_two, "p<,>a<i>[6]", player_info[playerid][lic]);
		new buffer_three[32];
		cache_get_value_name(0, "quest", buffer_three, 16);
		sscanf(buffer_three, "p<,>a<i>[4]", player_info[playerid][quest]);						
		cache_get_value_name_int(0, "bank_money", player_info[playerid][bank_money]);
		cache_get_value_name_int(0, "bank_check", player_info[playerid][bank_check]);
		cache_get_value_name_int(0, "leader", player_info[playerid][leader]);
		cache_get_value_name_int(0, "rang", player_info[playerid][rang]);
		cache_get_value_name_int(0, "fskin", player_info[playerid][fskin]);		
		cache_get_value_name_int(0, "hospitaltime", player_info[playerid][hospitaltime]);
		cache_get_value_name_int(0, "mutetime", player_info[playerid][mutetime]);
		cache_get_value_name_int(0, "p_model", player_info[playerid][p_model]);
		cache_get_value_name_float(0, "p_posx", player_info[playerid][p_posx]);
		cache_get_value_name_float(0, "p_posy", player_info[playerid][p_posy]);
		cache_get_value_name_float(0, "p_posz", player_info[playerid][p_posz]);
		cache_get_value_name_float(0, "p_posfa", player_info[playerid][p_posfa]);
		cache_get_value_name_int(0, "p_color1", player_info[playerid][p_color1]);
		cache_get_value_name_int(0, "p_color2", player_info[playerid][p_color2]);
		temp_info[playerid][pLoginStatus] = true;
		SetPlayerHealth(playerid, player_info[playerid][health]);
		SetPlayerArmour(playerid, player_info[playerid][armor]);

		new Year, Month, Day;
		getdate(Year, Month, Day);
		new _logindata[13];
		format(_logindata, sizeof(_logindata), "%02d.%02d.%d", Day, Month, Year);

		query[0] = EOS;
		mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `logindata` = '%s' WHERE `name` = '%s'", _logindata, player_info[playerid][name]);
		mysql_query(ConnectMysql, query);	

		mute_timer[playerid] = SetTimerEx("PlayerMuteTimer", 1000, true, "d", playerid);
		new string[31+MAX_PLAYER_NAME];
		format(string, sizeof(string), "Добро пожаловать на проект, %s!", player_info[playerid][name]);
		SCM(playerid, COLOR_WHITE, string);
 	}
	return 1;
}

publics: PlayerMuteTimer(playerid) 
{
	if(player_info[playerid][mutetime] > 0) player_info[playerid][mutetime]--;
	return 1;
}

publics: MinuteUpdate(playerid)
{
	_needPlayer(playerid);
}

publics: OneSecondUpdate()  
{
	new string[255];
	new hour, minute, second;
	gettime(hour, minute, second);
	if(minute == 0 && second == 0) PayDay();

	foreach(new i:Player)
	{  
		if(IsPlayerConnected(i))  
		{  
			temp_info[i][PlayerAFK] ++; 
			if(temp_info[i][PlayerAFK] > 3)  
			{   
				if(temp_info[i][pLoginStatus] != true) return true;
				temp_info[i][AFK] = 1;
				format(string, sizeof(string), "АФК: %s", ConvertSeconds(temp_info[i][PlayerAFK]));  
				SetPlayerChatBubble(i, string, COLOR_WHITE, 20, 1050);  
			}
		}  
		if(player_info[i][hospitaltime] > 0)
		{
			player_info[i][hospitaltime]--;
			player_info[i][health]++;
			SetPlayerHealth(i, player_info[i][health]);
			if(player_info[i][hospitaltime] <= 0)
			{
				SCM(i, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы полностью здоровы и выписаны с больницы!");
			}
		}		
	}
	return 1; 
}

publics: StopAnimChat(playerid)
{
    ApplyAnimation(playerid, "PED", "facanger", 4.1, 0, 1, 1, 1, 1);
	return 1;
}

publics: Hours()
{
	new hour, minute, second;
	gettime(hour, minute, second);
	SetWorldTime(hour);
}

publics: LoadAdminInfo(playerid)
{
	new rows;
	cache_get_row_count(rows);
 	if(rows)
 	{
 	    cache_get_value_name(0, "password", admin_info[playerid][apassword], 16);
 	    cache_get_value_name_int(0, "alevel", admin_info[playerid][alevel]);
 	}
	return 1;
}

publics: FreezePlayerTimer(playerid) TogglePlayerControllable(playerid, 1);

publics: TransferMoney(playerid, transfer)
{
	new rows;
	cache_get_row_count(rows);	
	if(!rows) 
	{
		SCM(playerid, COLOR_WHITE, "{EDD682}[Ошибка]: {FFFFFF}Введите корректный номер счёта!");
		return SPD(playerid, DLG_TMONEY, DSI, "{EDD682}Банк - {FFFFFF}Перевод на другой счёт", "{FFFFFF}Введите номер счёта, на который хотите перевести сумму в поле ниже:", "Перевести", "Отмена");
	}
	new string[200];
	format(string, sizeof(string), "{FFFFFF}Вы выполняете перевод на счёт {EDD682}(№%d)\n\n{FFFFFF}Если данные правильные, введите сумму, которую Вы хотите перевести на этот банковский счёт в поле ниже:",
	transfer, player_info[playerid][bank_check]);
	ShowPlayerDialog(playerid, DLG_TRANSFERBANK, DSI, "{EDD682}Банк - {FFFFFF}Перевод на другой счёт", string, "Перевести", "Назад");
	SetPVarInt(playerid, "moddedtransfer", transfer);
	return 1;
}

// Транспорт 
publics: VehicleEngineTimer(playerid, vehicleid)
{
	SetVehicleEngine(vehicleid, 1);
	callcmd::me(playerid, "завёл двигатель");
	StartEngine[playerid] = false;
	return 1;
}

publics: VehicleStaticTimer(vehicleid)
{
	vehicle_info[vehicleid][v_fuel] -= 0.05;
	new playerid = VehicleDriverID[vehicleid];
	if(playerid != -1)
	{
		new string[26];
		format(string, sizeof(string), "%.1f", vehicle_info[vehicleid][v_fuel]);
		PlayerTextDrawSetString(playerid, SPEEDPTD[1][playerid], string);
	}
	if(vehicle_info[vehicleid][v_fuel] <= 0.1 && !IsABMX(vehicleid)) SetVehicleEngine(vehicleid, 0);
	return 1;
}

publics: VehicleDynamicTimer(vehicleid)
{
	new Float:x , Float:y, Float:z;
	GetVehiclePos(vehicleid, x, y, z);
	if(DistancePointToPoint(x, y, z, vehicle_info[vehicleid][v_posx], vehicle_info[vehicleid][v_posy], vehicle_info[vehicleid][v_posz]) > 20)
	{
		vehicle_info[vehicleid][v_fuel] -= 0.01;
		new playerid = VehicleDriverID[vehicleid];
		if(playerid != -1)
		{
			new string[26];
			format(string, sizeof(string), "%.1f", vehicle_info[vehicleid][v_fuel]);
			PlayerTextDrawSetString(playerid, SPEEDPTD[1][playerid], string);
		}
		if(vehicle_info[vehicleid][v_fuel] <= 0.1 && !IsABMX(vehicleid)) SetVehicleEngine(vehicleid, 0);
		vehicle_info[vehicleid][v_posx] = x;
		vehicle_info[vehicleid][v_posy] = y;
		vehicle_info[vehicleid][v_posz] = z;				
	}
	return 1;
}

publics: TransportUpdate(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new Float:speed = GetVehicleSpeed(vehicleid);
	new string[120];
	new Float:mileage;
	mileage = (speed/4.4)/1000;
	vehicle_info[vehicleid][v_millage] += mileage;
	format(string, sizeof(string), "%.1f", vehicle_info[vehicleid][v_fuel]);
	PlayerTextDrawSetString(playerid, SPEEDPTD[1][playerid], string);
	format(string, sizeof(string), "%.1f", vehicle_info[vehicleid][v_millage]);
	PlayerTextDrawSetString(playerid, SPEEDPTD[2][playerid], string);
	GetVehicleHealth(vehicleid, vehicle_info[vehicleid][v_health]);
	if(vehicle_info[vehicleid][v_health] <= 350) SetVehicleEngine(vehicleid, 0);	
	return 1;
}

publics: TransportUpdateTwo(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new string[20];
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		format(string, sizeof(string), "%03d", GetVehicleSpeed(vehicleid));
		PlayerTextDrawSetString(playerid, SPEEDPTD[0][playerid], string);	
	}
	return 1;
}

publics: IsABMX(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	if(model == 481 || model == 510 || model == 509)
	{
		return 1;
	}
	return 0;
}

publics: LoadHouse()
{
 	new time = GetTickCount();
    new rows;
	cache_get_row_count(rows);
    if(rows)
    {
		for(new idx = 1; idx <= rows; idx++)
		{
	        cache_get_value_name_int(idx-1, "hid", house_info[idx][hid]);
	        cache_get_value_name_float(idx-1, "h_enterx", house_info[idx][h_enter][0]);
	        cache_get_value_name_float(idx-1, "h_entery", house_info[idx][h_enter][1]);
         	cache_get_value_name_float(idx-1, "h_enterz", house_info[idx][h_enter][2]);
	        cache_get_value_name_float(idx-1, "h_exitx", house_info[idx][h_exit][0]);
	        cache_get_value_name_float(idx-1, "h_exity", house_info[idx][h_exit][1]);
	        cache_get_value_name_float(idx-1, "h_exitz", house_info[idx][h_exit][2]);
	        cache_get_value_name(idx-1,"h_owner", house_info[idx][h_owner], 25);
			cache_get_value_name_int(idx-1, "h_owned", house_info[idx][h_owned]);
	        cache_get_value_name_int(idx-1, "h_money", house_info[idx][h_money]);
	        cache_get_value_name_int(idx-1, "h_class", house_info[idx][h_class]);
			cache_get_value_name_int(idx-1, "h_rent", house_info[idx][h_rent]);
			cache_get_value_name_int(idx-1, "h_lock", house_info[idx][h_lock]);
			if(house_info[idx][h_owned] == 0) 
			{
				house_info[idx][h_icon] = CreateDynamicMapIcon(house_info[idx][h_enter][0], house_info[idx][h_enter][1], house_info[idx][h_enter][2], 31, -1, 0, -1, -1, 400.0);
				house_info[idx][h_pickup] = CreateDynamicPickup(1273, 23, house_info[idx][h_enter][0], house_info[idx][h_enter][1], house_info[idx][h_enter][2],0, 0, -1);
				house_info[idx][h_text] = Create3DTextLabel("{FFFFFF}Дом продаётся.\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[idx][h_enter][0], house_info[idx][h_enter][1], house_info[idx][h_enter][2], 20.0, 0, 1);				
			}
			else
			{
				house_info[idx][h_icon] = CreateDynamicMapIcon(house_info[idx][h_enter][0], house_info[idx][h_enter][1], house_info[idx][h_enter][2], 32, -1, 0, -1, -1, 400.0);
				house_info[idx][h_pickup] = CreateDynamicPickup(19522, 23, house_info[idx][h_enter][0], house_info[idx][h_enter][1], house_info[idx][h_enter][2],0, 0, -1);
				house_info[idx][h_text] = Create3DTextLabel("{FFFFFF}Дом не продаётся.\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[idx][h_enter][0], house_info[idx][h_enter][1], house_info[idx][h_enter][2], 20.0, 0, 1);	
			}
			house_info[idx][h_texit] = Create3DTextLabel("{FFFFFF}Чтобы выйти, нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[idx][h_exit][0], house_info[idx][h_exit][1], house_info[idx][h_exit][2], 20.0, idx+50, 1);	
			totalhouse = rows;
		}
	}
 	printf("Домов загружено: %d за %i мс", totalhouse, GetTickCount()-time);
    return true;
}

publics: LoadPorch()
{
 	new time = GetTickCount();
    new rows;
	new string[110];
	cache_get_row_count(rows);
    if(rows)
    {
		for(new idx = 1; idx <= rows; idx++)
		{
	        cache_get_value_name_int(idx-1, "pid", porch_info[idx][pid]);
	        cache_get_value_name_float(idx-1, "p_enterx", porch_info[idx][p_enter][0]);
	        cache_get_value_name_float(idx-1, "p_entery", porch_info[idx][p_enter][1]);
         	cache_get_value_name_float(idx-1, "p_enterz", porch_info[idx][p_enter][2]);
	        cache_get_value_name_float(idx-1, "p_exitx", porch_info[idx][p_exit][0]);
	        cache_get_value_name_float(idx-1, "p_exity", porch_info[idx][p_exit][1]);
	        cache_get_value_name_float(idx-1, "p_exitz", porch_info[idx][p_exit][2]);


			format(string, sizeof(string), "{FFFFFF}Подъезд (№%d).\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", idx);
			porch_info[idx][p_pickup] = CreateDynamicPickup(19132, 23, porch_info[idx][p_enter][0], porch_info[idx][p_enter][1], porch_info[idx][p_enter][2],0, 0, -1);
			porch_info[idx][p_text] = Create3DTextLabel(string, COLOR_WHITE, porch_info[idx][p_enter][0], porch_info[idx][p_enter][1], porch_info[idx][p_enter][2], 20.0, 0, 1);
			porch_info[idx][p_texit] = Create3DTextLabel("{FFFFFF}Чтобы выйти, нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, porch_info[idx][p_exit][0], porch_info[idx][p_exit][1], porch_info[idx][p_exit][2], 20.0, idx+50, 1);
			porch_info[idx][p_floor1] = Create3DTextLabel("{FFFFFF}Чтобы подняться на этаж выше, нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, 884.0126, 2125.7830, 2002.4259, 20.0, idx+50, 1);
			porch_info[idx][p_floor2] = Create3DTextLabel("{FFFFFF}Чтобы спуститься на этаж ниже, нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, 884.0977, 2125.9177, 2006.2959, 20.0, idx+50, 1);				
			totalporch = rows;
		}
	}
	printf("Подъездов загружено: %d за %i мс", totalporch, GetTickCount()-time);	
	return true;
}

publics: LoadApart()
{
 	new time = GetTickCount();
    new rows;
	cache_get_row_count(rows);
    if(rows)
    {
		for(new idx = 1; idx <= rows; idx++)
		{
	        cache_get_value_name_int(idx-1, "aid", apart_info[idx][aid]);
	        cache_get_value_name_float(idx-1, "a_enterx", apart_info[idx][a_enter][0]);
	        cache_get_value_name_float(idx-1, "a_entery", apart_info[idx][a_enter][1]);
         	cache_get_value_name_float(idx-1, "a_enterz", apart_info[idx][a_enter][2]);
	        cache_get_value_name_float(idx-1, "a_exitx", apart_info[idx][a_exit][0]);
	        cache_get_value_name_float(idx-1, "a_exity", apart_info[idx][a_exit][1]);
	        cache_get_value_name_float(idx-1, "a_exitz", apart_info[idx][a_exit][2]);
	        cache_get_value_name(idx-1,"a_owner", apart_info[idx][a_owner], 25);
			cache_get_value_name_int(idx-1, "a_owned", apart_info[idx][a_owned]);
	        cache_get_value_name_int(idx-1, "a_money", apart_info[idx][a_money]);
	        cache_get_value_name_int(idx-1, "a_class", apart_info[idx][a_class]);
			cache_get_value_name_int(idx-1, "a_rent", apart_info[idx][a_rent]);
			cache_get_value_name_int(idx-1, "a_world", apart_info[idx][a_world]);
			cache_get_value_name_int(idx-1, "a_lock", apart_info[idx][a_lock]);
			if(apart_info[idx][a_owned] == 0) apart_info[idx][a_text] = Create3DTextLabel("{FFFFFF}Квартира продаётся.\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[idx][a_enter][0], apart_info[idx][a_enter][1], apart_info[idx][a_enter][2], 20.0, apart_info[idx][a_world], 1);
			else apart_info[idx][a_text] = Create3DTextLabel("{FFFFFF}Квартира не продаётся.\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[idx][a_enter][0], apart_info[idx][a_enter][1], apart_info[idx][a_enter][2], 20.0, apart_info[idx][a_world], 1);

			apart_info[idx][a_texit] = Create3DTextLabel("{FFFFFF}Чтобы выйти, нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[idx][a_exit][0], apart_info[idx][a_exit][1], apart_info[idx][a_exit][2], 20.0, idx+50, 1);	
			totalapart = rows;
		}
	}
 	printf("Квартир загружено: %d за %i мс", totalapart, GetTickCount()-time);
    return true;
}

publics: LoadPlayerCars()
{
 	new time = GetTickCount();
    new rows;
	cache_get_row_count(rows);
    if(rows)
    {
		for(new idx = 1; idx <= rows; idx++)
		{
			cache_get_value_name_int(idx-1, "id", vehicle_info[idx][v_id]);
			cache_get_value_name_int(idx-1, "v_model", vehicle_info[idx][v_model]);
			cache_get_value_name(idx-1, "v_owner", vehicle_info[idx][v_owner]);
			cache_get_value_name_float(idx-1, "v_posx", vehicle_info[idx][v_posx]);
			cache_get_value_name_float(idx-1, "v_posy", vehicle_info[idx][v_posy]);
			cache_get_value_name_float(idx-1, "v_posz", vehicle_info[idx][v_posz]);
			cache_get_value_name_float(idx-1, "v_posfa", vehicle_info[idx][v_posfa]);
			cache_get_value_name_int(idx-1, "v_color01", vehicle_info[idx][v_color01]);
			cache_get_value_name_int(idx-1, "v_color02", vehicle_info[idx][v_color02]);
			cache_get_value_name_int(idx-1, "v_money", vehicle_info[idx][v_money]);
			cache_get_value_name_int(idx-1, "v_world", vehicle_info[idx][v_world]);
			cache_get_value_name_int(idx-1, "v_interior", vehicle_info[idx][v_interior]);
			cache_get_value_name_int(idx-1, "v_plate", vehicle_info[idx][v_plate]);
			cache_get_value_name_int(idx-1, "v_lock", vehicle_info[idx][v_lock]);
			cache_get_value_name_float(idx-1, "v_fuel", vehicle_info[idx][v_fuel]);
			cache_get_value_name_float(idx-1, "v_millage", vehicle_info[idx][v_millage]);
			cache_get_value_name_float(idx-1, "v_health", vehicle_info[idx][v_health]);
			cache_get_value_name_int(idx-1, "v_if_buy", vehicle_info[idx][v_if_buy]);	
			idx = CreateVehicle(vehicle_info[idx][v_model], vehicle_info[idx][v_posx], vehicle_info[idx][v_posy], vehicle_info[idx][v_posz], vehicle_info[idx][v_posfa],vehicle_info[idx][v_color01], vehicle_info[idx][v_color02], -1);
			totalcars = rows;					
		}
	}
 	printf("Автомобилей загружено: %d за %i мс", totalcars, GetTickCount()-time);
    return true;		
}

publics: AllMembersFraction(playerid)
{
	// -- имя - должность - последний заход
	new rows, names[MAX_PLAYER_NAME], irang, lastdate[13], string[190];
	cache_get_row_count(rows);
	if(!rows) return SCM(playerid, COLOR_WHITE, "{EDD682}[Уведомление] {FFFFFF}Список вашей организации пуст!");
	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name(i, "name", names, MAX_PLAYER_NAME);
		cache_get_value_name(i, "logindata", lastdate, 13);
		cache_get_value_name_int(i, "rang", irang);		
		format(string, sizeof(string), "{9CF390}Имя: %s || Должность: %s[%d] || Заходил: %s || Статус: %s",  
		names, FractionName[player_info[playerid][member]][irang], irang, lastdate, (IsPlayerConnected(i))?("Онлайн"):("{FC4560}Офлайн"));
		SCM(playerid, COLOR_WHITE, string);
	}
	return 1;
}

publics: OnlineMembersFraction(playerid)
{
	// -- имя - должность - последний заход
	new rows, names[MAX_PLAYER_NAME], irang, string[190];
	cache_get_row_count(rows);
	if(!rows) return SCM(playerid, COLOR_WHITE, "Пусто");
	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name(i, "name", names, MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "rang", irang);		
		if(!IsPlayerConnected(i)) continue;
		format(string, sizeof(string), "{9CF390}Имя: %s || Должность: %s[%d]", names, FractionName[player_info[playerid][member]][irang], irang);
		SCM(playerid, COLOR_WHITE, string);
	}
	return 1;
}


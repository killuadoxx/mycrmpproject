// Stock`s
stock _connectMySQL()
{
	ConnectMysql = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_BASE);
	switch(mysql_errno())
	{
	    case 0: print("** Successful connection to the database! **");
		default: print("** Error connecting to MySQL! Check the data in the database! **");
	}
	mysql_log(ERROR | WARNING);
	mysql_set_charset("cp1251");
}

stock _showLogin(playerid)
{
	// -- >> Load`s camera player
	InterpolateCameraPos(playerid, 1162.057495, -2056.761962, 145.196578, 733.830261, -1829.818603, 59.506294, 50000);
	InterpolateCameraLookAt(playerid, 1157.692749, -2054.479736, 144.336334, 729.435729, -1827.449096, 59.235237, 5000);

	new string[190+(-2+MAX_PLAYER_NAME)];
	format(string, sizeof(string),
	"{FFFFFF}�� ���� ����� �������������� ���� �� ������� {EDD682}Russian History | CR Multiplayer{FFFFFF}!\n\
	������� � ������ {EDD682}%s{FFFFFF} ���������������.\n\
	\n\
	������� ������ �� �������� � ���� ����:", player_info[playerid][name]);
	SPD(playerid, DLG_LOG, DSP, "{EDD682}����������� {FFFFFF}| ���� ������", string, "�����", "�����");
	return 1;
}

stock _showRegistration(playerid)
{
	new string[594+(-2+MAX_PLAYER_NAME)];
	format(string, sizeof(string),
	"{FFFFFF}������ {EDD682}Russian History | CR Multiplayer {FFFFFF}- ����������� ��� ������, � ������� �� �� �����������!\n\
	������������� ������� ������ �� �����, ������������� � ��� � ������ � ����� ������!\n\
	��� ���������� ����, ����������, ��������������� �������.\n\
	\n\
	������� � ������ {EDD682}%s {FFFFFF}�� ���������������\n\
	���������� ������ � �������� ��� � ���� ����\n\
	\n\
	{EDD682}����������:\n\
	1. ������ ������ ��������� �� 8-�� �� 32-�� ��������\n\
	2. ������ ������ �������� ������ �� ���� � ��������� ��������", player_info[playerid][name]);
	SPD(playerid, DLG_REG, DSI, "{EDD682}����������� {FFFFFF}| ���� ������", string, "�����", "�����");	
	return 1;
}

stock _globalTextDraws()
{
	// appearance
	skinTextDraw[0] = TextDrawCreate(277.333374, 324.800018, "LD_SPAC:white");
	TextDrawLetterSize(skinTextDraw[0], 0.000000, 0.000000);
	TextDrawTextSize(skinTextDraw[0], 81.666656, 27.792572);
	TextDrawAlignment(skinTextDraw[0], 1);
	TextDrawColor(skinTextDraw[0], 640034559);
	TextDrawSetShadow(skinTextDraw[0], 0);
	TextDrawSetOutline(skinTextDraw[0], 0);
	TextDrawFont(skinTextDraw[0], 4);

	skinTextDraw[1] = TextDrawCreate(278.000000, 325.629638, "LD_SPAC:white");
	TextDrawLetterSize(skinTextDraw[1], 0.000000, 0.000000);
	TextDrawTextSize(skinTextDraw[1], 80.666641, 2.488882);
	TextDrawAlignment(skinTextDraw[1], 1);
	TextDrawColor(skinTextDraw[1], -5963521);
	TextDrawSetShadow(skinTextDraw[1], 0);
	TextDrawSetOutline(skinTextDraw[1], 0);
	TextDrawFont(skinTextDraw[1], 4);

	skinTextDraw[2] = TextDrawCreate(290.333251, 329.363006, "SELECT");
	TextDrawLetterSize(skinTextDraw[2], 0.380999, 1.915259);
	TextDrawTextSize(skinTextDraw[2], 347.000061, 19.496292);
	TextDrawAlignment(skinTextDraw[2], 1);
	TextDrawColor(skinTextDraw[2], -1);
	TextDrawUseBox(skinTextDraw[2], true);
	TextDrawBoxColor(skinTextDraw[2], 0xFFFFFF00);
	TextDrawSetShadow(skinTextDraw[2], 0);
	TextDrawSetOutline(skinTextDraw[2], 0);
	TextDrawBackgroundColor(skinTextDraw[2], 51);
	TextDrawFont(skinTextDraw[2], 2);
	TextDrawSetProportional(skinTextDraw[2], 1);
	TextDrawSetSelectable(skinTextDraw[2], true);

	skinTextDraw[3] = TextDrawCreate(228.000061, 328.533416, "<<");
	TextDrawLetterSize(skinTextDraw[3], 0.481999, 2.272000);
	TextDrawTextSize(skinTextDraw[3], 254.999984, 21.570367);
	TextDrawAlignment(skinTextDraw[3], 1);
	TextDrawColor(skinTextDraw[3], -1);
	TextDrawUseBox(skinTextDraw[3], true);
	TextDrawBoxColor(skinTextDraw[3], 0xFFFFFF00);
	TextDrawSetShadow(skinTextDraw[3], -1);
	TextDrawSetOutline(skinTextDraw[3], 0);
	TextDrawBackgroundColor(skinTextDraw[3], 51);
	TextDrawFont(skinTextDraw[3], 2);
	TextDrawSetProportional(skinTextDraw[3], 1);
	TextDrawSetSelectable(skinTextDraw[3], true);

	skinTextDraw[4] = TextDrawCreate(379.333343, 329.118621, ">>");
	TextDrawLetterSize(skinTextDraw[4], 0.481999, 2.272000);
	TextDrawTextSize(skinTextDraw[4], 406.333251, 22.814804);
	TextDrawAlignment(skinTextDraw[4], 1);
	TextDrawColor(skinTextDraw[4], -1);
	TextDrawUseBox(skinTextDraw[4], true);
	TextDrawBoxColor(skinTextDraw[4], 0xFFFFFF00);
	TextDrawSetShadow(skinTextDraw[4], -1);
	TextDrawSetOutline(skinTextDraw[4], 0);
	TextDrawBackgroundColor(skinTextDraw[4], 51);
	TextDrawFont(skinTextDraw[4], 2);
	TextDrawSetProportional(skinTextDraw[4], 1);
	TextDrawSetSelectable(skinTextDraw[4], true);

	skinTextDraw[5] = TextDrawCreate(347.666900, 319.407379, "hud:radar_tshirt");
	TextDrawLetterSize(skinTextDraw[5], 0.000000, 0.000000);
	TextDrawTextSize(skinTextDraw[5], 10.333341, 12.029640);
	TextDrawAlignment(skinTextDraw[5], 1);
	TextDrawColor(skinTextDraw[5], -1);
	TextDrawSetShadow(skinTextDraw[5], 0);
	TextDrawSetOutline(skinTextDraw[5], 0);
	TextDrawFont(skinTextDraw[5], 4);

	// ���������
	SPEEDTD = TextDrawCreate(491.000061, 276.681518, "interface:speedometr");
	TextDrawLetterSize(SPEEDTD, 0.000000, 0.000000);
	TextDrawTextSize(SPEEDTD, 159.666671, 209.896377);
	TextDrawAlignment(SPEEDTD, 1);
	TextDrawColor(SPEEDTD, -1);
	TextDrawSetShadow(SPEEDTD, 0);
	TextDrawSetOutline(SPEEDTD, 0);
	TextDrawFont(SPEEDTD, 4);
	return 1;		
}

stock _playerTextDraw(playerid)
{
	// Logotype
	logo[playerid] = CreatePlayerTextDraw(playerid, 36.333354, 427.259307, "RUSSIAN-RP.RU");
	PlayerTextDrawLetterSize(playerid, logo[playerid], 0.290666, 1.641481);
	PlayerTextDrawAlignment(playerid, logo[playerid], 1);
	PlayerTextDrawColor(playerid, logo[playerid], -1);
	PlayerTextDrawSetShadow(playerid, logo[playerid], 0);
	PlayerTextDrawSetOutline(playerid, logo[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, logo[playerid], 51);
	PlayerTextDrawFont(playerid, logo[playerid], 2);
	PlayerTextDrawSetProportional(playerid, logo[playerid], 1);

	// ����������� ���������

	_tdSatiety[0][playerid] = CreatePlayerTextDraw(playerid, 607.999816, 111.011131, "usebox");
	PlayerTextDrawLetterSize(playerid, _tdSatiety[0][playerid], 0.000000, 0.835596);
	PlayerTextDrawTextSize(playerid, _tdSatiety[0][playerid], 535.666503, 0.000000);
	PlayerTextDrawAlignment(playerid, _tdSatiety[0][playerid], 1);
	PlayerTextDrawColor(playerid, _tdSatiety[0][playerid], 0);
	PlayerTextDrawUseBox(playerid, _tdSatiety[0][playerid], true);
	PlayerTextDrawBoxColor(playerid, _tdSatiety[0][playerid], 102);
	PlayerTextDrawSetShadow(playerid, _tdSatiety[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid, _tdSatiety[0][playerid], 0);
	PlayerTextDrawFont(playerid, _tdSatiety[0][playerid], 0);

	_tdSatiety[1][playerid] = CreatePlayerTextDraw(playerid, 537.333435, 109.925926, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, _tdSatiety[1][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, _tdSatiety[1][playerid], 69.000000, 9.955562);
	PlayerTextDrawAlignment(playerid, _tdSatiety[1][playerid], 1);
	PlayerTextDrawColor(playerid, _tdSatiety[1][playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, _tdSatiety[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, _tdSatiety[1][playerid], 0);
	PlayerTextDrawFont(playerid, _tdSatiety[1][playerid], 4);

	_tdSatiety[2][playerid] = CreatePlayerTextDraw(playerid, 607.999938, 127.188888, "usebox");
	PlayerTextDrawLetterSize(playerid, _tdSatiety[2][playerid], 0.000000, 0.789505);
	PlayerTextDrawTextSize(playerid, _tdSatiety[2][playerid], 535.666625, 0.000000);
	PlayerTextDrawAlignment(playerid, _tdSatiety[2][playerid], 1);
	PlayerTextDrawColor(playerid, _tdSatiety[2][playerid], 0);
	PlayerTextDrawUseBox(playerid, _tdSatiety[2][playerid], true);
	PlayerTextDrawBoxColor(playerid, _tdSatiety[2][playerid], 102);
	PlayerTextDrawSetShadow(playerid, _tdSatiety[2][playerid], 0);
	PlayerTextDrawSetOutline(playerid, _tdSatiety[2][playerid], 0);
	PlayerTextDrawFont(playerid, _tdSatiety[2][playerid], 0);

	_tdSatiety[3][playerid] = CreatePlayerTextDraw(playerid, 537.333312, 126.103706, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, _tdSatiety[3][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, _tdSatiety[3][playerid], 69.000022, 9.540740);
	PlayerTextDrawAlignment(playerid, _tdSatiety[3][playerid], 1);
	PlayerTextDrawColor(playerid, _tdSatiety[3][playerid], -1378294017);
	PlayerTextDrawSetShadow(playerid, _tdSatiety[3][playerid], 0);
	PlayerTextDrawSetOutline(playerid, _tdSatiety[3][playerid], 0);
	PlayerTextDrawFont(playerid, _tdSatiety[3][playerid], 4);

	_tdSatiety[4][playerid] = CreatePlayerTextDraw(playerid, 609.000183, 108.266685, "hud:radar_dateFood");
	PlayerTextDrawLetterSize(playerid, _tdSatiety[4][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, _tdSatiety[4][playerid], 11.999968, 12.859253);
	PlayerTextDrawAlignment(playerid, _tdSatiety[4][playerid], 1);
	PlayerTextDrawColor(playerid, _tdSatiety[4][playerid], -1);
	PlayerTextDrawSetShadow(playerid, _tdSatiety[4][playerid], 0);
	PlayerTextDrawSetOutline(playerid, _tdSatiety[4][playerid], 0);
	PlayerTextDrawFont(playerid, _tdSatiety[4][playerid], 4);

	_tdSatiety[5][playerid] = CreatePlayerTextDraw(playerid, 609.333496, 122.955566, "hud:radar_diner");
	PlayerTextDrawLetterSize(playerid, _tdSatiety[5][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, _tdSatiety[5][playerid], 11.999968, 12.859253);
	PlayerTextDrawAlignment(playerid, _tdSatiety[5][playerid], 1);
	PlayerTextDrawColor(playerid, _tdSatiety[5][playerid], -1);
	PlayerTextDrawSetShadow(playerid, _tdSatiety[5][playerid], 0);
	PlayerTextDrawSetOutline(playerid, _tdSatiety[5][playerid], 0);
	PlayerTextDrawFont(playerid, _tdSatiety[5][playerid], 4);

	// ���������
    SPEEDOPTD[0][playerid] = CreatePlayerTextDraw(playerid, 469.333312, 262.992492, "interface:engine_on");
    PlayerTextDrawLetterSize(playerid, SPEEDOPTD[0][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, SPEEDOPTD[0][playerid], 206.666595, 232.296356);
    PlayerTextDrawAlignment(playerid, SPEEDOPTD[0][playerid], 1);
    PlayerTextDrawColor(playerid, SPEEDOPTD[0][playerid], -1);
    PlayerTextDrawSetShadow(playerid, SPEEDOPTD[0][playerid], 0);
    PlayerTextDrawSetOutline(playerid, SPEEDOPTD[0][playerid], 0);
    PlayerTextDrawFont(playerid, SPEEDOPTD[0][playerid], 4);

    SPEEDOPTD[1][playerid] = CreatePlayerTextDraw(playerid, 474.000061, 259.259307, "interface:doors_on");
    PlayerTextDrawLetterSize(playerid, SPEEDOPTD[1][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, SPEEDOPTD[1][playerid], 196.333404, 237.688949);
    PlayerTextDrawAlignment(playerid, SPEEDOPTD[1][playerid], 1);
    PlayerTextDrawColor(playerid, SPEEDOPTD[1][playerid], -1);
    PlayerTextDrawSetShadow(playerid, SPEEDOPTD[1][playerid], 0);
    PlayerTextDrawSetOutline(playerid, SPEEDOPTD[1][playerid], 0);
    PlayerTextDrawFont(playerid, SPEEDOPTD[1][playerid], 4);

    SPEEDOPTD[2][playerid] = CreatePlayerTextDraw(playerid, 489.666748, 260.918609, "interface:lights_on");
    PlayerTextDrawLetterSize(playerid, SPEEDOPTD[2][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, SPEEDOPTD[2][playerid], 165.333343, 234.785034);
    PlayerTextDrawAlignment(playerid, SPEEDOPTD[2][playerid], 1);
    PlayerTextDrawColor(playerid, SPEEDOPTD[2][playerid], -1);
    PlayerTextDrawSetShadow(playerid, SPEEDOPTD[2][playerid], 0);
    PlayerTextDrawSetOutline(playerid, SPEEDOPTD[2][playerid], 0);
    PlayerTextDrawFont(playerid, SPEEDOPTD[2][playerid], 4);

    SPEEDPTD[0][playerid] = CreatePlayerTextDraw(playerid, 554.666564, 347.614807, "000");
    PlayerTextDrawLetterSize(playerid, SPEEDPTD[0][playerid], 0.637999, 2.985482);
    PlayerTextDrawAlignment(playerid, SPEEDPTD[0][playerid], 1);
    PlayerTextDrawColor(playerid, SPEEDPTD[0][playerid], -1);
    PlayerTextDrawSetShadow(playerid, SPEEDPTD[0][playerid], 0);
    PlayerTextDrawSetOutline(playerid, SPEEDPTD[0][playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, SPEEDPTD[0][playerid], 51);
    PlayerTextDrawFont(playerid, SPEEDPTD[0][playerid], 1);
    PlayerTextDrawSetProportional(playerid, SPEEDPTD[0][playerid], 1);

    SPEEDPTD[1][playerid] = CreatePlayerTextDraw(playerid, 591.333496, 388.266510, "100");
    PlayerTextDrawLetterSize(playerid, SPEEDPTD[1][playerid], 0.329666, 1.496296);
    PlayerTextDrawAlignment(playerid, SPEEDPTD[1][playerid], 1);
    PlayerTextDrawColor(playerid, SPEEDPTD[1][playerid], -1);
    PlayerTextDrawSetShadow(playerid, SPEEDPTD[1][playerid], 0);
    PlayerTextDrawSetOutline(playerid, SPEEDPTD[1][playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, SPEEDPTD[1][playerid], 51);
    PlayerTextDrawFont(playerid, SPEEDPTD[1][playerid], 1);
    PlayerTextDrawSetProportional(playerid, SPEEDPTD[1][playerid], 1);

    SPEEDPTD[2][playerid] = CreatePlayerTextDraw(playerid, 555.333007, 420.207458, "10000");
    PlayerTextDrawLetterSize(playerid, SPEEDPTD[2][playerid], 0.364999, 1.413334);
    PlayerTextDrawAlignment(playerid, SPEEDPTD[2][playerid], 1);
    PlayerTextDrawColor(playerid, SPEEDPTD[2][playerid], -1);
    PlayerTextDrawSetShadow(playerid, SPEEDPTD[2][playerid], 0);
    PlayerTextDrawSetOutline(playerid, SPEEDPTD[2][playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, SPEEDPTD[2][playerid], 51);
    PlayerTextDrawFont(playerid, SPEEDPTD[2][playerid], 1);
    PlayerTextDrawSetProportional(playerid, SPEEDPTD[2][playerid], 1);

    SPEEDPTD[3][playerid] = CreatePlayerTextDraw(playerid, 469.333312, 262.992492, "interface:engine_off");
    PlayerTextDrawLetterSize(playerid, SPEEDPTD[3][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, SPEEDPTD[3][playerid], 206.666595, 232.296356);
    PlayerTextDrawAlignment(playerid, SPEEDPTD[3][playerid], 1);
    PlayerTextDrawColor(playerid, SPEEDPTD[3][playerid], -1);
    PlayerTextDrawSetShadow(playerid, SPEEDPTD[3][playerid], 0);
    PlayerTextDrawSetOutline(playerid, SPEEDPTD[3][playerid], 0);
    PlayerTextDrawFont(playerid, SPEEDPTD[3][playerid], 4);

    SPEEDPTD[4][playerid] = CreatePlayerTextDraw(playerid, 474.000061, 259.259307, "interface:doors_off");
    PlayerTextDrawLetterSize(playerid, SPEEDPTD[4][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, SPEEDPTD[4][playerid], 196.333404, 237.688949);
    PlayerTextDrawAlignment(playerid, SPEEDPTD[4][playerid], 1);
    PlayerTextDrawColor(playerid, SPEEDPTD[4][playerid], -1);
    PlayerTextDrawSetShadow(playerid, SPEEDPTD[4][playerid], 0);
    PlayerTextDrawSetOutline(playerid, SPEEDPTD[4][playerid], 0);
    PlayerTextDrawFont(playerid, SPEEDPTD[4][playerid], 4);

    SPEEDPTD[5][playerid] = CreatePlayerTextDraw(playerid, 489.666748, 260.918609, "interface:lights_off");
    PlayerTextDrawLetterSize(playerid, SPEEDPTD[5][playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, SPEEDPTD[5][playerid], 165.333343, 234.785034);
    PlayerTextDrawAlignment(playerid, SPEEDPTD[5][playerid], 1);
    PlayerTextDrawColor(playerid, SPEEDPTD[5][playerid], -1);
    PlayerTextDrawSetShadow(playerid, SPEEDPTD[5][playerid], 0);
    PlayerTextDrawSetOutline(playerid, SPEEDPTD[5][playerid], 0);
    PlayerTextDrawFont(playerid, SPEEDPTD[5][playerid], 4);		
	return 1;
}

stock _giveMoney(playerid, summa)
{
	player_info[playerid][money] += summa;
	query[0] = EOS;
	mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `money` = '%d' WHERE `id` = '%d'", player_info[playerid][money], player_info[playerid][id]);
	mysql_query(ConnectMysql, query);
    GivePlayerMoney(playerid, summa);
}

stock _updateTDSatietyWater(playerid)
{
	if(player_info[playerid][thirst] <= 30)
	{
		PlayerTextDrawDestroy(playerid, _tdSatiety[3][playerid]);

		_tdSatiety[3][playerid] = CreatePlayerTextDraw(playerid, 537.333312, 126.103706, "LD_SPAC:white");
		PlayerTextDrawLetterSize(playerid, _tdSatiety[3][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, _tdSatiety[3][playerid], 9.000000 , 9.540740);
		PlayerTextDrawAlignment(playerid, _tdSatiety[3][playerid], 1);
		PlayerTextDrawColor(playerid, _tdSatiety[3][playerid], 0xF95656FF);
		PlayerTextDrawSetShadow(playerid, _tdSatiety[3][playerid], 0);
		PlayerTextDrawSetOutline(playerid, _tdSatiety[3][playerid], 0);
		PlayerTextDrawFont(playerid, _tdSatiety[3][playerid], 4);

		PlayerTextDrawShow(playerid, _tdSatiety[3][playerid]);	
	}
	else
	{
		PlayerTextDrawDestroy(playerid, _tdSatiety[3][playerid]);

		// ����
		_tdSatiety[3][playerid] = CreatePlayerTextDraw(playerid, 537.333312, 126.103706, "LD_SPAC:white");
		PlayerTextDrawLetterSize(playerid, _tdSatiety[3][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, _tdSatiety[3][playerid], 0.000000 + (0.69 * player_info[playerid][thirst]), 9.540740);
		PlayerTextDrawAlignment(playerid, _tdSatiety[3][playerid], 1);
		PlayerTextDrawColor(playerid, _tdSatiety[3][playerid], -1378294017);
		PlayerTextDrawSetShadow(playerid, _tdSatiety[3][playerid], 0);
		PlayerTextDrawSetOutline(playerid, _tdSatiety[3][playerid], 0);
		PlayerTextDrawFont(playerid, _tdSatiety[3][playerid], 4);

		PlayerTextDrawShow(playerid, _tdSatiety[3][playerid]);	
	}	
	return 1;
}

stock _updateTDSatietyEat(playerid)
{
	if(player_info[playerid][eat] <= 30)
	{
		PlayerTextDrawDestroy(playerid, _tdSatiety[1][playerid]);

		_tdSatiety[1][playerid] = CreatePlayerTextDraw(playerid, 537.333435, 109.925926, "LD_SPAC:white");
		PlayerTextDrawLetterSize(playerid, _tdSatiety[1][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, _tdSatiety[1][playerid], 9.000000, 9.955562);
		PlayerTextDrawAlignment(playerid, _tdSatiety[1][playerid], 1);
		PlayerTextDrawColor(playerid, _tdSatiety[1][playerid], 0xF95656FF);
		PlayerTextDrawSetShadow(playerid, _tdSatiety[1][playerid], 0);
		PlayerTextDrawSetOutline(playerid, _tdSatiety[1][playerid], 0);
		PlayerTextDrawFont(playerid, _tdSatiety[1][playerid], 4);

		PlayerTextDrawShow(playerid, _tdSatiety[1][playerid]);	
	}
	else
	{
		PlayerTextDrawDestroy(playerid, _tdSatiety[1][playerid]);

		// ���
		_tdSatiety[1][playerid] = CreatePlayerTextDraw(playerid, 537.333435, 109.925926, "LD_SPAC:white");
		PlayerTextDrawLetterSize(playerid, _tdSatiety[1][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, _tdSatiety[1][playerid], 0.000000 + (0.69 * player_info[playerid][eat]), 9.955562);
		PlayerTextDrawAlignment(playerid, _tdSatiety[1][playerid], 1);
		PlayerTextDrawColor(playerid, _tdSatiety[1][playerid], -5963521);
		PlayerTextDrawSetShadow(playerid, _tdSatiety[1][playerid], 0);
		PlayerTextDrawSetOutline(playerid, _tdSatiety[1][playerid], 0);
		PlayerTextDrawFont(playerid, _tdSatiety[1][playerid], 4);

		PlayerTextDrawShow(playerid, _tdSatiety[1][playerid]);	
	}
	return 1;
}

stock _needPlayer(playerid)
{
	if(temp_info[playerid][pLoginStatus] != true) return true;
	if(player_info[playerid][eat] <= 0) player_info[playerid][eat] = 0;
	if(player_info[playerid][thirst] <= 0) player_info[playerid][thirst] = 0;
	if(player_info[playerid][eat] > 0) 
	{
		player_info[playerid][eat]--;
		_updateTDSatietyEat(playerid);
	}
	if(player_info[playerid][thirst] > 0) 
	{
		player_info[playerid][thirst]--;
		_updateTDSatietyWater(playerid);
	}
	switch(player_info[playerid][eat])
	{
		case 1..30:
		{
			player_info[playerid][health] -= 3.1;
			SetPlayerHealth(playerid, player_info[playerid][health]);
		}
		case 50: SCM(playerid, COLOR_WHITEOR, "[�����������]: {FFFFFF}��� �������� ������������, �������� ��������� ���������!");
	}
	switch(player_info[playerid][thirst])
	{
		case 1..30:
		{
			player_info[playerid][health] -= 3.1;
			SetPlayerHealth(playerid, player_info[playerid][health]);
		}
		case 50: SCM(playerid, COLOR_WHITEOR, "[�����������]: {FFFFFF}��� �������� ����� ����, �������� ��������� ���������!");
	}
	return 1;
}

stock ConvertSeconds(time)  
{  
	new string[128];  
	if(time < 60) format(string, sizeof(string), "%d ���.", time);  
	else if(time == 60) string = "1 ������";  
	else if(time > 60 && time < 3600)  
	{  
		new Float: minutes;  
		new seconds;  
		minutes = time / 60;  
		seconds = time % 60;  
		format(string, sizeof(string), "%.0f ���. � %d ���.", minutes, seconds);  
	}  
	else if(time == 3600) string = "1 ���";  
	else if(time > 3600)  
	{  
		new Float: hours;  
		new minutes_int;  
		new Float: minutes;  
		new seconds;  
		hours = time / 3600;  
		minutes_int = time % 3600;  
		minutes = minutes_int / 60;  
		seconds = minutes_int % 60;  
		format(string, sizeof(string), "%.0f:%.0f:%d", hours, minutes, seconds);  
	}  
	return string;  
}  

stock ProxDetector(Float:radi, playerid, const string[], col1, col2, col3, col4, col5)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx;new Float:posy;new Float:posz;new Float:oldposx;new Float:oldposy;new Float:oldposz;new Float:tempposx;new Float:tempposy;new Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		foreach(new i: Player)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
				{
					GetPlayerPos(i, posx, posy, posz);
					tempposx = (oldposx -posx);
					tempposy = (oldposy -posy);
					tempposz = (oldposz -posz);
					if(((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16))) SCM(i, col1, string);
					else if(((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8))) SCM(i, col2, string);
					else if(((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4))) SCM(i, col3, string);
					else if(((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2))) SCM(i, col4, string);
					else if(((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) SCM(i, col5, string);
				}
			}
		}
	}
	return 1;
}

stock SetTimeForServer()
{
	new hour, minute, second;
	gettime(hour, minute, second);
	SetWorldTime(hour);
	SetTimer("Hours", 60*1000, true); 
	return true;
}

stock GetPlayerID(const playername[])
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i) || temp_info[i][pLoginStatus] == false) continue;
		if(strcmp(player_info[i][name], playername, true) == 0) return i;
	}
	return INVALID_PLAYER_ID;
}

stock PayDay()
{
	new hour, targetid;
	gettime(hour);
	if(hour == 7)
	{
		for(new h = 1; h <= totalhouse; h++)
		{
			if(house_info[h][h_owned] == 0) continue;
			house_info[h][h_rent] --;
			if(house_info[h][h_rent] <= 0)
			{
				targetid = GetPlayerID(house_info[h][h_owner]);
				if(targetid != INVALID_PLAYER_ID)
				{
					SendClientMessage(targetid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ���� �������� �� ���� �� ��������!");
					new i = player_info[targetid][keyh];
					strmid(house_info[i][h_owner], "�����������", 0, strlen("�����������"), 255);
					house_info[i][h_owned] = 0;
					player_info[targetid][keyh] = -1;
					player_info[targetid][bank_money] += house_info[i][h_money];

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_owned` = '%d', `h_owner` = '�����������', `h_rent` = '%d' WHERE `hid` = '%d'", house_info[i][h_owned], house_info[i][h_rent], house_info[i][hid]);
					mysql_query(ConnectMysql, query);

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keyh` = '-1', `bank_money` = `bank_money` + '%d' WHERE `id` = '%d'", player_info[targetid][bank_money], player_info[targetid][id]);
					mysql_query(ConnectMysql, query);
				}
				else
				{
					house_info[h][h_owned] = 0;
					query[0] = EOS;
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keyh` = '-1', `bank_money` = `bank_money` + '%d' WHERE `name` = '%s'", house_info[h][h_money], house_info[h][h_owner]);
					mysql_query(ConnectMysql, query);

					strmid(house_info[h][h_owner], "�����������", 0, strlen("�����������"), 255);

					query[0] = EOS;
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_owned` = '0', `h_owner` = '�����������', `h_rent` = '0' WHERE `hid` = '%d'", house_info[h][hid]);
					mysql_query(ConnectMysql, query);
				}
				_updatehouse(h);									
			}
		}
		for(new a = 1; a <= totalapart; a++)
		{
			if(apart_info[a][a_owned] == 0) continue;
			apart_info[a][a_rent] --;
			if(apart_info[a][a_rent] <= 0)
			{
				targetid = GetPlayerID(apart_info[a][a_owner]);
				if(targetid != INVALID_PLAYER_ID)
				{
					SendClientMessage(targetid, COLOR_WHITE, "{EDD682}[�����������]: {FFFFFF}�� ���� �������� �� �������� �� ��������!");
					new i = player_info[targetid][keya];
					strmid(apart_info[i][a_owner], "�����������", 0, strlen("�����������"), 255);
					apart_info[i][a_owned] = 0;
					player_info[targetid][keya] = -1;
					player_info[targetid][bank_money] += apart_info[i][a_money];

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_owned` = '%d', `a_owner` = '�����������', `a_rent` = '%d' WHERE `aid` = '%d'", apart_info[i][a_owned], apart_info[i][a_rent], apart_info[i][aid]);
					mysql_query(ConnectMysql, query);

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keya` = '-1', `bank_money` = `bank_money` + '%d' WHERE `id` = '%d'", player_info[targetid][bank_money], player_info[targetid][id]);
					mysql_query(ConnectMysql, query);
				}
				else
				{
					apart_info[a][a_owned] = 0;

					query[0] = EOS;
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `accounts` SET `keya` = '-1', `bank_money` = `bank_money` + '%d' WHERE `name` = '%s'", apart_info[a][a_money], apart_info[a][a_owner]);
					mysql_query(ConnectMysql, query);

					strmid(apart_info[a][a_owner], "�����������", 0, strlen("�����������"), 255);

					query[0] = EOS;
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_owned` = '0', `a_owner` = '�����������', `a_rent` = '0' WHERE `aid` = '%d'", apart_info[a][aid]);
					mysql_query(ConnectMysql, query);
				}
				Delete3DTextLabel(apart_info[a][a_text]);
				apart_info[a][a_text] = Create3DTextLabel("{FFFFFF}�������� ��������.\n ��� �������������� ������� - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[a][a_enter][0], apart_info[a][a_enter][1], apart_info[a][a_enter][2], 20.0, apart_info[a][a_world], 1);									
			}
		}		
	}
	foreach(new i:Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(temp_info[i][pLoginStatus] != true) return SCM(i, COLOR_WHITEOR, "[�����������]: �� ���������� PayDay!");
		if(temp_info[i][PlayerAFK] > 3) return SCM(i, COLOR_WHITEOR, "[�����������]: �� ���������� PayDay!");
		player_info[i][exp]++;
		if(player_info[i][exp] >= _getMaxPlayerExpLevel(player_info[i][lvl]))
		{
			player_info[i][exp] = 0;
			player_info[i][lvl]++;
			player_info[i][age]++;
			SetPlayerScore(i, player_info[i][lvl]);
			SCM(i, COLOR_WHITEOR, "[�����������]: {FFFFFF}��� ������� ������� ���������!");	
		}
		SCM(i, COLOR_WHITEOR, "GIVE PAYDAY");

		if(player_info[i][eat] <= 30) SCM(i, COLOR_WHITEOR, "[�����������]: {FFFFFF}��� �������� ����� ������ ������������, �������� ��������� ���������!");
		if(player_info[i][thirst] <= 30) SCM(i, COLOR_WHITEOR, "[�����������]: {FFFFFF}��� �������� ����� ������ ����� ����, �������� ��������� ���������!");
	}
	return 1;
}

stock _getMaxPlayerExpLevel(level)
{
	return 3 + (level *3);
}

stock SetPlayerParam(playerid, param, value)
{
	if(!IsPlayerConnected(playerid) || player_info[playerid][id] <= 0) return 0;

	new field[16];
	switch(param)
	{
		case PLAYER_PARAM_MONEY: { player_info[playerid][money] = value; field = "money"; }
		case PLAYER_PARAM_LEVEL: { player_info[playerid][lvl] = value; field = "lvl"; }
		case PLAYER_PARAM_EXP: { player_info[playerid][exp] = value; field = "exp"; }
		case PLAYER_PARAM_AGE: { player_info[playerid][age] = value; field = "age"; }
		case PLAYER_PARAM_EAT: { player_info[playerid][eat] = value; field = "eat"; }
		case PLAYER_PARAM_THIRST: { player_info[playerid][thirst] = value; field = "thirst"; }
		case PLAYER_PARAM_MEMBER: { player_info[playerid][member] = value; field = "member"; }
		case PLAYER_PARAM_RANG: { player_info[playerid][rang] = value; field = "rang"; }
		case PLAYER_PARAM_FSKIN: { player_info[playerid][fskin] = value; field = "fskin"; }
		case PLAYER_PARAM_MUTETIME: { player_info[playerid][mutetime] = value; field = "mutetime"; }
		default: return 0;
	}

	mysql_format(ConnectMysql, query, sizeof(query),
		"UPDATE `accounts` SET `%s` = '%d' WHERE `id` = '%d'",
		field, value, player_info[playerid][id]);
	mysql_tquery(ConnectMysql, query);
	return 1;
}

stock SetPlayerParamFloat(playerid, param, Float:value)
{
	if(!IsPlayerConnected(playerid) || player_info[playerid][id] <= 0) return 0;

	new field[8];
	switch(param)
	{
		case 0: { player_info[playerid][health] = value; field = "health"; }
		case 1: { player_info[playerid][armor] = value; field = "armor"; }
		default: return 0;
	}

	mysql_format(ConnectMysql, query, sizeof(query),
		"UPDATE `accounts` SET `%s` = '%f' WHERE `id` = '%d'",
		field, value, player_info[playerid][id]);
	mysql_tquery(ConnectMysql, query);
	return 1;
}

stock _savePlayerAccount(playerid)
{
	mysql_format(ConnectMysql, query, sizeof(query), "\
	UPDATE `accounts` SET `health` = '%f', `armor` = '%f', `lvl` = '%d', `exp` = '%d', `age` = '%d', `eat` = '%d', `thirst` = '%d', `money` = '%d', `leader` = '%d',\n\
	`member` = '%d', `rang` = '%d', `fskin` = '%d', `exitx` = '%f', `exity` = '%f', `exitz` = '%f', `exitfa` = '%f', `p_world` = '%d', `p_interior` = '%d', `hospitaltime` = '%d',\n\
	`mutetime` = '%d', `lic` = '%d, %d, %d, %d, %d, %d' WHERE `id` = '%d'", 
	player_info[playerid][health], 
	player_info[playerid][armor], 
	player_info[playerid][lvl],
	player_info[playerid][exp], 
	player_info[playerid][age], 
	player_info[playerid][eat], 
	player_info[playerid][thirst], 
	player_info[playerid][money], 
	player_info[playerid][leader], 
	player_info[playerid][member], 
	player_info[playerid][rang], 
	player_info[playerid][fskin], 
	player_info[playerid][exitx], 
	player_info[playerid][exity], 
	player_info[playerid][exitz], 
	player_info[playerid][exitfa],
	player_info[playerid][p_world],
	player_info[playerid][p_interior], 
	player_info[playerid][hospitaltime], 
	player_info[playerid][mutetime], 
	player_info[playerid][lic][0], 
	player_info[playerid][lic][1], 
	player_info[playerid][lic][2], 
	player_info[playerid][lic][3], 
	player_info[playerid][lic][4], 
	player_info[playerid][lic][5], player_info[playerid][id]);
	mysql_query(ConnectMysql, query);	
	return 1;
}

stock LoadAdminData(playerid)
{
	query[0] = EOS;
	mysql_format(ConnectMysql, query, sizeof(query), "SELECT * FROM `admins` WHERE `name` = '%s'", player_info[playerid][name]);
	mysql_tquery(ConnectMysql, query, "LoadAdminInfo", "i", playerid);			
	return 1;
}

stock SAM(color,const string[],level)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{		
			if(admin_info[i][alevel] >= level)
			{
				if(temp_info[i][pAdminStatus] != false)
				{					
					SendClientMessage(i, color, string);
				}	
			}
		}
	}
	return true;
}

stock _loadPickup()
{
	bank[0] = CreatePickup(1318, 23, 2376.7192, -2139.2600, 22.0776, 0); // - ���� � ����
	bank[1] = CreatePickup(1318, 23, 2375.6055, -1910.1226, 1126.9100, 1); // - ����� � �����
	bank[2] = CreateDynamicPickup(1514, 2, 2370.7439, -1904.0571, 1126.9100, 1, 0);

	hospital[0] = CreatePickup(1318, 23, 2112.7124, -2392.8530, 23.0883, 0); // - ���� � �������� �.�����
	hospital[1] = CreatePickup(1318, 23, 366.9555, 124.9833, 1003.8500, 2); // - ����� � �������� �.�����

	_pickupm[0] = CreatePickup(1318, 23, 1818.2975, 2095.8008, 16.1631, 0); // - ���� � ������������� ���.��������
	_pickupm[1] = CreatePickup(1318, 23, 1583.7637, -774.3833, 1114.7073, 1); // - ����� �� ������������� ���.��������

	_pickupp[0] = CreatePickup(1318, 23, 1919.2798, 2183.4026, 15.6982, 0); // - ���� � ���
	_pickupp[1] = CreatePickup(1318, 23, 588.1068, 0.9593, 1022.9027, 2); // - ����� �� ���
	_pickupp[2] = CreatePickup(1318, 23, 1937.3793, 2160.8184, 15.6621, 0); // - ���� � ��� (����)
	_pickupp[3] = CreatePickup(1318, 23, 593.2096, -22.2770, 1022.9027, 2); // - ����� �� ��� (�� ����)

	eda[0] = CreatePickup(1582, 2, 2520.0564, -2116.4204, 22.0360, 0);
	CreatePickup(1582, 2, 2551.5525, -2207.5952, 22.5228, 0);
	eda[1] = CreatePickup(1582, 2, 356.7856, 128.0119, 1003.8500, 2);
	return 1;
}

stock _freezePlayerPickup(playerid)
{
	TogglePlayerControllable(playerid, 0);
	SetTimerEx("FreezePlayerTimer", 2000, false, "d", playerid);
	return 1;
}

stock _infoHome(playerid)
{
	new string[256], text[25];
	new i = player_info[playerid][keyh];
	switch(house_info[i][h_class])
	{
		case 1: text = "������ �����";
		case 2: text = "������� �����";
		case 3: text = "������� �����";
	}
	format(string, sizeof(string),
	"{FFFFFF}����� ����:\t %d\n\
	{FFFFFF}����� ����:\t %s\n\
	{FFFFFF}���.����:\t %d\n\
	{FFFFFF}�������� ����:\t %d",
	i, text, house_info[i][h_money], house_info[i][h_rent]);
	SPD(playerid, DLG_INFOHOME, DSM, "{EDD682}���������� � ����", string, "�����", "");
	return 1;
}

stock _infoApart(playerid)
{
	new string[256], text[25];
	new i = player_info[playerid][keya];
	switch(apart_info[i][a_class])
	{
		case 1: text = "������ �����";
		case 2: text = "������� �����";
		case 3: text = "������� �����";
	}
	format(string, sizeof(string),
	"{FFFFFF}����� ��������:\t %d\n\
	{FFFFFF}����� ��������:\t %s\n\
	{FFFFFF}���.����:\t %d\n\
	{FFFFFF}�������� ����:\t %d",
	i, text, apart_info[i][a_money], apart_info[i][a_rent]);
	SPD(playerid, DLG_INFOAPART, DSM, "{EDD682}���������� � ��������", string, "�����", "");
	return 1;
}

stock _statsPlayer(playerid)
{
	new string[256];
	new l = player_info[playerid][lvl];
	format(string, sizeof(string),
	"{FFFFFF}��� ���������:\t %s\n\
	������� ���������:\t %d\n\
	������� ���������:\t %d\n\
	���� ���������:\t %d/%d\n\
	��� ���������:\t %s\n\
	���� �����������:\t %s\n\
	�����������:\t\t %s\n\
	����:\t\t\t %s [%d]",
	player_info[playerid][name], player_info[playerid][age], l, player_info[playerid][exp], _getMaxPlayerExpLevel(l), 
	(player_info[playerid][sex] == 1) ? ("�������") : ("�������"), player_info[playerid][regdata], _fracName(playerid), 
	FractionName[player_info[playerid][member]][player_info[playerid][rang]], player_info[playerid][rang]);
	SPD(playerid, DLG_STATS, DSL, "{EDD682}���������� ���������", string, "�����", "");
	return 1;
}

stock _questPlayer(playerid)
{
	new string[256];
	format(string, sizeof(string),
	"1. ����� ����������.\t\t\t %s", (player_info[playerid][quest][0] == 1) ? ("{EDD682}��������") : ("{EDD682}�� ��������"));
	SPD(playerid, DLG_QUEST, DSL, "{EDD682}��������� �������", string, "�������", "�������");
	return 1;
}

stock _fracName(playerid)
{
	new fname[72];
	if(player_info[playerid][member] == 0) fname =  "�����������";
 	if(player_info[playerid][member] == 1) fname =  "������������� �������";
 	if(player_info[playerid][member] == 2) fname =  "���";
 	if(player_info[playerid][member] == 3) fname =  "�����";
 	if(player_info[playerid][member] == 4) fname =  "������������ �������";
 	if(player_info[playerid][member] == 5) fname =  "����������� ������ ������������";
 	if(player_info[playerid][member] == 6) fname =  "������������ ���������������";
 	if(player_info[playerid][member] == 7) fname =  "�������� �������� ����������";
 	if(player_info[playerid][member] == 8) fname =  "����������� ������";
 	if(player_info[playerid][member] == 9) fname =  "����� ������";
 	return fname;
}

stock _fracSpawn(playerid)
{
    SetPlayerInterior(playerid,spawnFrac[player_info[playerid][member]-1][in]);
	SetPlayerVirtualWorld(playerid,spawnFrac[player_info[playerid][member]-1][vw]);
	SetPlayerPos(playerid,spawnFrac[player_info[playerid][member]-1][f_x],spawnFrac[player_info[playerid][member]-1][f_y],spawnFrac[player_info[playerid][member]-1][f_z]);
	SetPlayerFacingAngle(playerid,spawnFrac[player_info[playerid][member]-1][f_a]);
	SetCameraBehindPlayer(playerid);
	return 1;
}

stock _fracSkin(playerid)
{
	switch(player_info[playerid][member])
	{
		case 1: player_info[playerid][fskin] = 187;
		case 2: player_info[playerid][fskin] = 288;
		case 3: player_info[playerid][fskin] = 283;
		case 4: player_info[playerid][fskin] = 61;
		case 5: player_info[playerid][fskin] = 294;
		case 6: player_info[playerid][fskin] = 70;
		case 7: player_info[playerid][fskin] = 261;
		case 8: player_info[playerid][fskin] = 113;
		case 9: player_info[playerid][fskin] = 126;
	}
	return 1;
}

stock IsSpecificConditionMet(playerid, param) 
{
    // ���������, ������������� �� ����� ����������� ������� � �����
    if(player_info[playerid][member] == 1 && player_info[playerid][rang] == 12 && param > 11) {
        return true; // ������� ���������
    }
    return false; // ������� �� ���������
}

stock _infoPlayer(playerid)
{
	SCM(playerid, COLOR_WHITE, !"{EDD682}>>> {FFFFFF}���� � ��� ��������� �������, ����������� � ����� �������������: {EDD682}(������� 'H' -> ����� � ��������������)");
	SCM(playerid, COLOR_WHITE, !"{EDD682}>>> {FFFFFF}������ ��� ��������� ������� �������, ������ ������������ � ����: {EDD682}(������� 'H' -> ������� �������)");
	SCM(playerid, COLOR_WHITE, !"{EDD682}>>> {FFFFFF}������� �� ������������ ������������ ������ ���������: {EDD682}(������� 'H' -> ����������� ���������)");
	return 1;
}

// ��������� 
stock SetVehicleEngine(vehicleid, status)
{
	if(status)
	{
		if(vehicle_info[vehicleid][v_engine] == false)
		{
			vehicle_info[vehicleid][STATICTIMER] = SetTimerEx("VehicleStaticTimer", 2000, true, "d", vehicleid);
			vehicle_info[vehicleid][DYNAMICTIMER] = SetTimerEx("VehicleDynamicTimer", 500, true, "d", vehicleid);
			new Float:x , Float:y, Float:z;
			GetVehiclePos(vehicle, x, y, z);
			vehicle_info[vehicleid][v_posx] = x;
			vehicle_info[vehicleid][v_posy] = y;
			vehicle_info[vehicleid][v_posz] = z;
			vehicle_info[vehicleid][v_engine] = true;
			SetVehicleParamsEx(vehicleid, vehicle_info[vehicleid][v_engine], false, false, false, false, false, false);

		}
	}
	else
	{
		if(vehicle_info[vehicleid][v_engine] == true)
		{
			KillTimer(vehicle_info[vehicleid][STATICTIMER]);
			KillTimer(vehicle_info[vehicleid][DYNAMICTIMER]);
			vehicle_info[vehicleid][v_engine] = false;
			SetVehicleParamsEx(vehicleid, vehicle_info[vehicleid][v_engine], false, false, false, false, false, false);
		}
	}
	new playerid = VehicleDriverID[vehicleid];
	if(playerid != -1)
	{
		if(status == 0)
		{
			PlayerTextDrawHide(playerid, SPEEDPTD[3][playerid]);
			PlayerTextDrawShow(playerid, SPEEDOPTD[0][playerid]);
		}
		else
		{
			PlayerTextDrawHide(playerid, SPEEDOPTD[0][playerid]);
			PlayerTextDrawShow(playerid, SPEEDPTD[3][playerid]);			
		}
	}		
	return 1;
}

stock SetVehicleLight(vehicleid, status)
{
	if(status)
	{
		if(vehicle_info[vehicleid][v_lights] == false)
		{
			vehicle_info[vehicleid][v_lights] = true;
			SetVehicleParamsEx(vehicleid, vehicle_info[vehicleid][v_engine], vehicle_info[vehicleid][v_lights], false, false, false, false, false);
		}
	}
	else
	{
		if(vehicle_info[vehicleid][v_lights] == true)
		{
			vehicle_info[vehicleid][v_lights] = false;
			SetVehicleParamsEx(vehicleid, vehicle_info[vehicleid][v_engine], vehicle_info[vehicleid][v_lights], false, false, false, false, false);
		}
	}
	new playerid = VehicleDriverID[vehicleid];
	if(playerid != -1)
	{
		if(status == 1)
		{
			PlayerTextDrawHide(playerid, SPEEDPTD[5][playerid]);
			PlayerTextDrawShow(playerid, SPEEDOPTD[2][playerid]);
		}
		else
		{
			PlayerTextDrawHide(playerid, SPEEDOPTD[2][playerid]);
			PlayerTextDrawShow(playerid, SPEEDPTD[5][playerid]);			
		}
	}
	return 1;
}

stock SetVehicleDoors(vehicleid, status)
{
	if(status)
	{
		if(vehicle_info[vehicleid][v_lock] == false)
		{
			vehicle_info[vehicleid][v_lock] = true;
			SetVehicleParamsEx(vehicleid, vehicle_info[vehicleid][v_engine], vehicle_info[vehicleid][v_lights], false, vehicle_info[vehicleid][v_lock], false, false, false);
		}
	}
	else
	{
		if(vehicle_info[vehicleid][v_lock] == true)
		{
			vehicle_info[vehicleid][v_lock] = false;
			SetVehicleParamsEx(vehicleid, vehicle_info[vehicleid][v_engine], vehicle_info[vehicleid][v_lights], false, vehicle_info[vehicleid][v_lock], false, false, false);
		}
	}
	new playerid = VehicleDriverID[vehicleid];
	if(playerid != -1)
	{
		if(status == 1)
		{
			PlayerTextDrawHide(playerid, SPEEDPTD[4][playerid]);
			PlayerTextDrawShow(playerid, SPEEDOPTD[1][playerid]);
		}
		else
		{
			PlayerTextDrawHide(playerid, SPEEDOPTD[1][playerid]);
			PlayerTextDrawShow(playerid, SPEEDPTD[4][playerid]);			
		}		
	}	
	return 1;
}

stock DistancePointToPoint(Float:x, Float:y, Float:z, Float:fx, Float:fy, Float:fz)
{
	x = floatpower(fx - x, 2);
	y = floatpower(fy - y, 2);
	z = floatpower(fz - z, 2);
	return floatround(floatsqroot(x + y + z));
}

stock GetVehicleSpeed(vehicleid)
{
	new Float:x, Float:y, Float:z;
	GetVehicleVelocity(vehicleid, x, y, z);
	return floatround(floatsqroot(x*x+y*y+z*z)*195);
}

stock SFM(family, color, const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(player_info[i][member] == family) SendClientMessage(i, color, string);
		}
	}
	return 1;
}

stock _gosFrac(playerid)
{
	switch(player_info[playerid][member])
	{
		case 1..7: return 1; 
	}
	return 0;
}

stock _updatehouse(houseid)
{
	DestroyDynamicMapIcon(house_info[houseid][h_icon]);
	DestroyDynamicPickup(house_info[houseid][h_pickup]);
	Delete3DTextLabel(house_info[houseid][h_text]);
	if(house_info[houseid][h_owned] == 0)
	{
		house_info[houseid][h_icon] = CreateDynamicMapIcon(house_info[houseid][h_enter][0], house_info[houseid][h_enter][1], house_info[houseid][h_enter][2], 31, -1, 0, -1, -1, 90.0);
		house_info[houseid][h_pickup] = CreateDynamicPickup(1273, 23, house_info[houseid][h_enter][0], house_info[houseid][h_enter][1], house_info[houseid][h_enter][2],0, 0, -1);
		house_info[houseid][h_text] = Create3DTextLabel("{FFFFFF}��� ��������.\n ��� �������������� ������� - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[houseid][h_enter][0], house_info[houseid][h_enter][1], house_info[houseid][h_enter][2], 20.0, 0, 1);
	}
	if(house_info[houseid][h_owned] == 1)
	{
		house_info[houseid][h_icon] = CreateDynamicMapIcon(house_info[houseid][h_enter][0], house_info[houseid][h_enter][1], house_info[houseid][h_enter][2], 32, -1, 0, -1, -1, 90.0);
		house_info[houseid][h_pickup] = CreateDynamicPickup(19522, 23, house_info[houseid][h_enter][0], house_info[houseid][h_enter][1], house_info[houseid][h_enter][2],0, 0, -1);
		house_info[houseid][h_text] = Create3DTextLabel("{FFFFFF}��� �� ��������.\n ��� �������������� ������� - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[houseid][h_enter][0], house_info[houseid][h_enter][1], house_info[houseid][h_enter][2], 20.0,0,1);
	}
	house_info[houseid][h_texit] = Create3DTextLabel("{FFFFFF}����� �����, ������� - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[houseid][h_exit][0], house_info[houseid][h_exit][1], house_info[houseid][h_exit][2], 20.0, houseid+50, 1);	
	return 1;
}

stock IsPlayerInRangeOfVehicle(playerid,Float:range,vehicleid)
{
    new Float:x,Float:y,Float:z;
    GetVehiclePos(vehicleid,x,y,z);
    return IsPlayerInRangeOfPoint(playerid,range,x,y,z);
}

stock IsPlayerMuted(playerid)
{
	if(player_info[playerid][mutetime] > 0)
	{
		new time = player_info[playerid][mutetime];
		if(time <= 60)
		{
			SCM(playerid, COLOR_WHITE, "��� ������������! �� ������������� �������� �������� ������.");
		}
		else
		{
			new string[80];
			format(string, sizeof(string), "��� ������������! �� ������������� �������� {EDD682}%d {FFFFFF}���.", floatround(time / 60));
			SCM(playerid, COLOR_WHITE, string);
		}
		return 1;
	}
	return 0;
}

stock _aCommands(playerid)
{
	SPD(playerid, DLG_ACOMMAND, DSL, "{EDD682}AP - ������� ��������������", 
	"{FFFFFF}1. ������������� 1-�� ������\n\
	2. ������������� 2-�� ������\n\
	3. ������������� 3-�� ������\n\
	4. ������������� 4-�� ������\n\
	5. ������������� 5-�� ������", "�������", "�����");
	return 1;
}

stock _loadCars()
{
	/*new color = random(127);
	_carsBuyEconomy[0] = CreateVehicle(404, 297.9168, 1758.6201, 11.6933, 353.8830, color, color, -1);
	CreateVehicle(492, 294.5790, 1758.8252, 11.6935, 354.3413, color, color, -1);
	CreateVehicle(516, 291.3473, 1758.9950, 11.6943, 354.5314, color, color, -1);
	CreateVehicle(551, 288.1519, 1758.9640, 11.7005, 354.5923, color, color, -1);
	_carsBuyEconomy[1] = CreateVehicle(542, 284.9243, 1759.1064, 11.6934, 354.7780, color, color, -1);*/

	// -- ������ ����������� (��������)
	_carArenda[0] = CreateVehicle(402, 1863.1904, 2275.8230, 14.9138, 181.4986, random(120), random(120), -1); // ���� 1
	CreateVehicle(405, 1866.7483, 2275.7024, 14.9128, 180.8363, random(120), random(120), -1); // ���� 2
	CreateVehicle(410, 1872.3132, 2270.4944, 14.9069, 89.3294, random(120), random(120), -1); // ���� 3
	CreateVehicle(529, 1872.4268, 2266.2603, 14.9055, 88.5174, random(120), random(120), -1); // ���� 4
	_carArenda[1] = CreateVehicle(529, 1872.4697, 2261.6064, 14.9057, 89.2770, random(120), 1, -1); // ���� 5

	// -- �������������
	lead_one[0] = CreateVehicle(579, 1796.6405, 2103.8577, 15.8021, 47.3617, 0, 0, -1, 1);
	CreateVehicle(579, 1796.5394, 2098.5908, 15.7924, 47.2896, 0, 0, -1, 1); 
	CreateVehicle(579, 1796.5885, 2092.9919, 15.8009, 46.6637, 0, 0, -1, 1);
	CreateVehicle(579, 1796.5522, 2087.4802, 15.7924, 47.2119, 0, 0, -1, 1); 
	lead_one[1] = CreateVehicle(409, 1786.7676, 2096.4993, 15.8472, 1.8860, 0, 0, -1, 1);

	// ���
	_ppsCar[0] = CreateVehicle(599, 1948.2906, 2167.8162, 15.9144, 90.8144, 1, 1, -1, 1);
	CreateVehicle(599, 1948.3303, 2164.2256, 15.9145, 90.5238, 1, 1, -1, 1);
	CreateVehicle(599, 1948.3079, 2160.3047, 15.9155, 89.6124, 1, 1, -1, 1);
	CreateVehicle(599, 1948.3525, 2156.8008, 15.9137, 89.8553, 1, 1, -1, 1);
	CreateVehicle(597, 1931.8295, 2170.7087, 15.3484, 270.3431, 1, 1, -1, 1);
	CreateVehicle(597, 1931.8551, 2174.0293, 15.3483, 269.0104, 1, 1, -1, 1);
	_ppsCar[1] = CreateVehicle(427, 1952.8138, 2172.8870, 16.1855, 91.2898, 1, 1, -1, 1);
	return 1;
}

stock _rulesPlayer(playerid)
{
	SPD(playerid, DLG_PRULES_ONE, DSM, 
	"{EDD682}������� ������", 
	"{FFFFFF}������ �� ������� ������, �� ���������� ������ �������\n\
	�������� ������ �� ����������� �� ���������������\n\
	������������ ������� ������� �� RolePlay ��������\n\
	Role Play (RP) � ���� ����������� �� �����, ����������� � �������� �����\n\
	Non RolePlay (NonRP) � �������� ���������, ������� �� �� �� ������ � �������� �����\n\
	Spawn Kill (SK) � ���������� ������ �������� �������� ��������� ��� ������� ������� ������� �� ���������� ���� �����������, ��� �� ���������� ��� ����� � ����\n\
	Team Kill (TK) � ���������� ������ �������� ����� ����� ������� ��� ������� �� �� ������� �������\n\
	Bunny Hop (BH) � ��� � ���������� �������������� ������� ��� �������\n\
	Drive By (DB) � ���������� ������ �������� � ������ ���������\n\
	Power Gaming (PG) � ������������� ������������ ������ ���������\n\
	Revenge Kill (RVK) � ���������� ������ �������� �������� ��������� � ��������, ������� ����� ��� ����\n\
	Repeat Kill (RPK) � ���������� ��������� �������� ������ � ���� �� ������, �������� �� ��� ����� �����\n\
	Out Of Character (OOC) � ���������� ����������, �� ���� ������ �� ������ ��������� ����\n\
	In Character (IC) � ������� ����������, �� ���� ������ �� �������� ����\n\
	Meta Gaming (MG) � ���������� ������� � ���������� ����������\n\
	Death Match (DM) � ���������� ������ �������� �������� ��������� ��� ������� �� �� ������� �������, ���� ������������ ��������/�����/������",
	"�����", "�����");
	return 1;
}

stock _priceCar(vehicleid)
{
	new buycena;
	switch(GetVehicleModel(vehicleid))
	{
		case  466: buycena = 16600; case  542: buycena = 15100; case  492: buycena = 19000;
		case  517: buycena = 18600; case  516: buycena = 20350; case  467: buycena = 22300;
		case  600: buycena = 19500; case  549: buycena = 21000; case  529: buycena = 25000;
		case  404: buycena = 13400; case 474: buycena = 16500; case  410: buycena = 20410;
		case  422: buycena = 19900; case  439: buycena = 31400; case  479: buycena = 27000;
		case  535: buycena = 28900; case  543: buycena = 14500; case  575: buycena = 27400;
		case  545: buycena = 23900; case  411: buycena = 848000; case  560: buycena = 356400;
		case  562: buycena = 212300; case  579: buycena = 311900; case  429: buycena = 549300;
		case  415: buycena = 600100; case  559: buycena = 289000; case  581: buycena = 113000;
		case  506: buycena = 431000; case  402: buycena = 234900; case  541: buycena = 705000;
		case  522: buycena = 560400; case  481: buycena = 12600; case  510: buycena = 15600; case  463: buycena = 39700;
		case  551: buycena = 72000; case  468: buycena = 51000; case  451: buycena = 790000;  case  521: buycena = 152400;
	}
	return buycena;
}

stock _load3Dtext()
{
	Create3DTextLabel(!"{FFFFFF}NPC: {EDD682}����. \n {FFFFFF}��� �������������� ������� - {EDD682}'L.ALT'.", COLOR_WHITE, 1797.1179, 2509.8589, 16.2770, 20.0, 0, 1);
	Create3DTextLabel(!"{FFFFFF}NPC: {EDD682}����. \n {FFFFFF}������������ � ��������� - {EDD682}'L.ALT'.", COLOR_WHITE, 1808.1010, 2506.8914, 15.8725, 20.0, 0, 1);
	Create3DTextLabel(!"{FFFFFF}������ ���������� \n ������ ��� ��������!", COLOR_WHITE, 1775.4690, -1904.4019, 13.3860, 20.0, 0, 1);
	return 1;
}

stock _vorotafrac()
{
	_admopen = CreateDynamicObject(968, 1818.65, 2125.52, 15.63, 0.00, 90.00, 90.00);
	CreateDynamicObject(966, 1818.64, 2125.73, 14.80,   0.00, 0.00, -90.00);

	
	return 1;
}

stock _loadActor()
{
	npcRepa = CreateActor(5, 1797.1179, 2509.8589, 16.2770, 307.9350);
	ApplyActorAnimation(npcRepa, !"CRACK", !"crckidle2", 4.1, 1, 0, 0, 0, 0);

	npcIvan = CreateActor(101, 1808.1010, 2506.8914, 15.8725, 133.7199);
	ApplyActorAnimation(npcIvan, !"BD_FIRE", !"M_SMKLEAN_LOOP", 4.1, 1, 0, 0, 0, 0);
	return 1;
}

stock _heliCar(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 417, 425, 447, 460, 469, 476, 487, 488, 497, 511..513, 519, 520, 548, 553, 563, 577, 592, 593: return true;
		default: return false;
	}
	return false;
}

stock _shipCar(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 430, 446, 452..454, 472, 473, 484, 493, 539, 595: return true;
		default: return false;
	}
	return false;
}

stock _loadCefPlayer(playerid)
{
	cef_create_browser(playerid, 0x12346, "wh17754.web1.maze-host.ru", false, false);
	return 1;
}
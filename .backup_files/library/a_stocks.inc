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
	"{FFFFFF}Мы рады снова приветствовать тебя на проекте {EDD682}Russian History | CR Multiplayer{FFFFFF}!\n\
	Аккаунт с именем {EDD682}%s{FFFFFF} зарегистрирован.\n\
	\n\
	Введите пароль от аккаунта в поле ниже:", player_info[playerid][name]);
	SPD(playerid, DLG_LOG, DSP, "{EDD682}Авторизация {FFFFFF}| Ввод пароля", string, "Далее", "Выход");
	return 1;
}

stock _showRegistration(playerid)
{
	new string[594+(-2+MAX_PLAYER_NAME)];
	format(string, sizeof(string),
	"{FFFFFF}Проект {EDD682}Russian History | CR Multiplayer {FFFFFF}- атмосферный мир России, в котором вы не соскучитесь!\n\
	Администрация проекта всегда на связи, присоединяйся к нам и хватай с собой друзей!\n\
	Для дальнейшей игры, пожалуйста, зарегистрируйте аккаунт.\n\
	\n\
	Аккаунт с именем {EDD682}%s {FFFFFF}не зарегистрирован\n\
	Придумайте пароль и запишите его в поле ниже\n\
	\n\
	{EDD682}Примечание:\n\
	1. Пароль должен содержать от 8-ми до 32-ух символов\n\
	2. Пароль должен состоять только из цифр и латинских символов", player_info[playerid][name]);
	SPD(playerid, DLG_REG, DSI, "{EDD682}Регистрация {FFFFFF}| Ввод пароля", string, "Далее", "Выход");	
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

	// Спидометр
	SPEEDTD = TextDrawCreate(491.000061, 276.681518, "interface:speedometr");
	TextDrawLetterSize(SPEEDTD, 0.000000, 0.000000);
	TextDrawTextSize(SPEEDTD, 159.666671, 209.896377);
	TextDrawAlignment(SPEEDTD, 1);
	TextDrawColor(SPEEDTD, -1);
	TextDrawSetShadow(SPEEDTD, 0);
	TextDrawSetOutline(SPEEDTD, 0);
	TextDrawFont(SPEEDTD, 4);

	// register
	_tdRegister[0] = TextDrawCreate(243.666641, 121.125900, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[0], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[0], 145.666656, 236.859268);
	TextDrawAlignment(_tdRegister[0], 1);
	TextDrawColor(_tdRegister[0], -304708865);
	TextDrawSetShadow(_tdRegister[0], 0);
	TextDrawSetOutline(_tdRegister[0], 0);
	TextDrawFont(_tdRegister[0], 4);

	_tdRegister[1] = TextDrawCreate(244.333328, 121.955558, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[1], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[1], 144.333312, 235.199996);
	TextDrawAlignment(_tdRegister[1], 1);
	TextDrawColor(_tdRegister[1], 303174399);
	TextDrawSetShadow(_tdRegister[1], 0);
	TextDrawSetOutline(_tdRegister[1], 0);
	TextDrawFont(_tdRegister[1], 4);

	_tdRegister[2] = TextDrawCreate(272.333648, 120.711059, "PE‚…CЏPA‰…•");
	TextDrawLetterSize(_tdRegister[2], 0.304333, 1.637333);
	TextDrawAlignment(_tdRegister[2], 1);
	TextDrawColor(_tdRegister[2], -1);
	TextDrawSetShadow(_tdRegister[2], 0);
	TextDrawSetOutline(_tdRegister[2], 0);
	TextDrawBackgroundColor(_tdRegister[2], 51);
	TextDrawFont(_tdRegister[2], 2);
	TextDrawSetProportional(_tdRegister[2], 1);

	_tdRegister[3] = TextDrawCreate(262.666748, 137.059265, "MOUNT ROLE PLAY");
	TextDrawLetterSize(_tdRegister[3], 0.304333, 1.637333);
	TextDrawAlignment(_tdRegister[3], 1);
	TextDrawColor(_tdRegister[3], -1);
	TextDrawSetShadow(_tdRegister[3], 0);
	TextDrawSetOutline(_tdRegister[3], 0);
	TextDrawBackgroundColor(_tdRegister[3], 51);
	TextDrawFont(_tdRegister[3], 2);
	TextDrawSetProportional(_tdRegister[3], 1);

	_tdRegister[4] = TextDrawCreate(295.333526, 128.348129, "-");
	TextDrawLetterSize(_tdRegister[4], 2.963666, 1.637332);
	TextDrawAlignment(_tdRegister[4], 1);
	TextDrawColor(_tdRegister[4], -304708865);
	TextDrawSetShadow(_tdRegister[4], 0);
	TextDrawSetOutline(_tdRegister[4], 0);
	TextDrawBackgroundColor(_tdRegister[4], 51);
	TextDrawFont(_tdRegister[4], 2);
	TextDrawSetProportional(_tdRegister[4], 1);

	_tdRegister[5] = TextDrawCreate(252.333404, 163.363082, "‹‹Eѓ…ЏE ‹AЋ ЊAPO‡’:");
	TextDrawLetterSize(_tdRegister[5], 0.130332, 1.114668);
	TextDrawAlignment(_tdRegister[5], 1);
	TextDrawColor(_tdRegister[5], -1);
	TextDrawSetShadow(_tdRegister[5], 0);
	TextDrawSetOutline(_tdRegister[5], 0);
	TextDrawBackgroundColor(_tdRegister[5], 51);
	TextDrawFont(_tdRegister[5], 2);
	TextDrawSetProportional(_tdRegister[5], 1);

	_tdRegister[6] = TextDrawCreate(252.333312, 176.296386, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[6], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[6], 58.666656, 11.200012);
	TextDrawAlignment(_tdRegister[6], 1);
	TextDrawColor(_tdRegister[6], 1835888127);
	TextDrawSetShadow(_tdRegister[6], 0);
	TextDrawSetOutline(_tdRegister[6], 0);
	TextDrawFont(_tdRegister[6], 4);

	_tdRegister[7] = TextDrawCreate(255.000442, 175.563049, "HA„AЏ’");
	TextDrawLetterSize(_tdRegister[7], 0.153332, 1.106373);
	TextDrawTextSize(_tdRegister[7], 279.666656, 13.688890);
	TextDrawAlignment(_tdRegister[7], 1);
	TextDrawColor(_tdRegister[7], -1);
	TextDrawUseBox(_tdRegister[7], true);
	TextDrawBoxColor(_tdRegister[7], 0xFFFFFF00);
	TextDrawSetShadow(_tdRegister[7], 0);
	TextDrawSetOutline(_tdRegister[7], 0);
	TextDrawBackgroundColor(_tdRegister[7], 51);
	TextDrawFont(_tdRegister[7], 2);
	TextDrawSetProportional(_tdRegister[7], 1);
	TextDrawSetSelectable(_tdRegister[7], true);

	_tdRegister[8] = TextDrawCreate(252.666717, 191.740859, "‹‹Eѓ…ЏE ‹AЋ EMAIL:");
	TextDrawLetterSize(_tdRegister[8], 0.130332, 1.114668);
	TextDrawAlignment(_tdRegister[8], 1);
	TextDrawColor(_tdRegister[8], -1);
	TextDrawSetShadow(_tdRegister[8], 0);
	TextDrawSetOutline(_tdRegister[8], 0);
	TextDrawBackgroundColor(_tdRegister[8], 51);
	TextDrawFont(_tdRegister[8], 2);
	TextDrawSetProportional(_tdRegister[8], 1);

	_tdRegister[9] = TextDrawCreate(252.666687, 203.844223, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[9], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[9], 58.666656, 11.200012);
	TextDrawAlignment(_tdRegister[9], 1);
	TextDrawColor(_tdRegister[9], 1835888127);
	TextDrawSetShadow(_tdRegister[9], 0);
	TextDrawSetOutline(_tdRegister[9], 0);
	TextDrawFont(_tdRegister[9], 4);

	_tdRegister[10] = TextDrawCreate(255.333755, 203.526000, "HA„AЏ’");
	TextDrawLetterSize(_tdRegister[10], 0.153332, 1.106373);
	TextDrawTextSize(_tdRegister[10], 280.999969, 14.933336);
	TextDrawAlignment(_tdRegister[10], 1);
	TextDrawColor(_tdRegister[10], -1);
	TextDrawUseBox(_tdRegister[10], true);
	TextDrawBoxColor(_tdRegister[10], 0xFFFFFF00);
	TextDrawSetShadow(_tdRegister[10], 0);
	TextDrawSetOutline(_tdRegister[10], 0);
	TextDrawBackgroundColor(_tdRegister[10], 51);
	TextDrawFont(_tdRegister[10], 2);
	TextDrawSetProportional(_tdRegister[10], 1);
	TextDrawSetSelectable(_tdRegister[10], true);

	_tdRegister[11] = TextDrawCreate(252.666732, 219.289001, "‹‹Eѓ…ЏE ЊP…‚‡AC…‹ЋE‚O:");
	TextDrawLetterSize(_tdRegister[11], 0.130332, 1.114668);
	TextDrawAlignment(_tdRegister[11], 1);
	TextDrawColor(_tdRegister[11], -1);
	TextDrawSetShadow(_tdRegister[11], 0);
	TextDrawSetOutline(_tdRegister[11], 0);
	TextDrawBackgroundColor(_tdRegister[11], 51);
	TextDrawFont(_tdRegister[11], 2);
	TextDrawSetProportional(_tdRegister[11], 1);

	_tdRegister[12] = TextDrawCreate(252.666717, 232.222015, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[12], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[12], 58.666656, 11.200012);
	TextDrawAlignment(_tdRegister[12], 1);
	TextDrawColor(_tdRegister[12], 1835888127);
	TextDrawSetShadow(_tdRegister[12], 0);
	TextDrawSetOutline(_tdRegister[12], 0);
	TextDrawFont(_tdRegister[12], 4);

	_tdRegister[13] = TextDrawCreate(255.333770, 231.903823, "HA„AЏ’");
	TextDrawLetterSize(_tdRegister[13], 0.153332, 1.106373);
	TextDrawTextSize(_tdRegister[13], 280.999969, 12.859261);
	TextDrawAlignment(_tdRegister[13], 1);
	TextDrawColor(_tdRegister[13], -1);
	TextDrawUseBox(_tdRegister[13], true);
	TextDrawBoxColor(_tdRegister[13], 0xFFFFFF00);
	TextDrawSetShadow(_tdRegister[13], 0);
	TextDrawSetOutline(_tdRegister[13], 0);
	TextDrawBackgroundColor(_tdRegister[13], 51);
	TextDrawFont(_tdRegister[13], 2);
	TextDrawSetProportional(_tdRegister[13], 1);
	TextDrawSetSelectable(_tdRegister[13], true);

	_tdRegister[14] = TextDrawCreate(252.666748, 247.251983, "‹‘ЂEP…ЏE ЊO‡ ЊEPCOHA„A:");
	TextDrawLetterSize(_tdRegister[14], 0.130332, 1.114668);
	TextDrawAlignment(_tdRegister[14], 1);
	TextDrawColor(_tdRegister[14], -1);
	TextDrawSetShadow(_tdRegister[14], 0);
	TextDrawSetOutline(_tdRegister[14], 0);
	TextDrawBackgroundColor(_tdRegister[14], 51);
	TextDrawFont(_tdRegister[14], 2);
	TextDrawSetProportional(_tdRegister[14], 1);

	_tdRegister[15] = TextDrawCreate(252.666717, 259.769958, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[15], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[15], 58.666656, 11.200012);
	TextDrawAlignment(_tdRegister[15], 1);
	TextDrawColor(_tdRegister[15], 1835888127);
	TextDrawSetShadow(_tdRegister[15], 0);
	TextDrawSetOutline(_tdRegister[15], 0);
	TextDrawFont(_tdRegister[15], 4);

	_tdRegister[16] = TextDrawCreate(255.333770, 259.866760, "HA„AЏ’");
	TextDrawLetterSize(_tdRegister[16], 0.153332, 1.106373);
	TextDrawTextSize(_tdRegister[16], 281.000152, 13.274075);
	TextDrawAlignment(_tdRegister[16], 1);
	TextDrawColor(_tdRegister[16], -1);
	TextDrawUseBox(_tdRegister[16], true);
	TextDrawBoxColor(_tdRegister[16], 0xFFFFFF00);
	TextDrawSetShadow(_tdRegister[16], 0);
	TextDrawSetOutline(_tdRegister[16], 0);
	TextDrawBackgroundColor(_tdRegister[16], 51);
	TextDrawFont(_tdRegister[16], 2);
	TextDrawSetProportional(_tdRegister[16], 1);
	TextDrawSetSelectable(_tdRegister[16], true);

	_tdRegister[17] = TextDrawCreate(252.666748, 274.385253, "‹‹Eѓ…ЏE ‹O3PACЏ ЊEPCOHA„A:");
	TextDrawLetterSize(_tdRegister[17], 0.130332, 1.114668);
	TextDrawAlignment(_tdRegister[17], 1);
	TextDrawColor(_tdRegister[17], -1);
	TextDrawSetShadow(_tdRegister[17], 0);
	TextDrawSetOutline(_tdRegister[17], 0);
	TextDrawBackgroundColor(_tdRegister[17], 51);
	TextDrawFont(_tdRegister[17], 2);
	TextDrawSetProportional(_tdRegister[17], 1);

	_tdRegister[18] = TextDrawCreate(253.000076, 287.733062, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[18], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[18], 58.666656, 11.200012);
	TextDrawAlignment(_tdRegister[18], 1);
	TextDrawColor(_tdRegister[18], 1835888127);
	TextDrawSetShadow(_tdRegister[18], 0);
	TextDrawSetOutline(_tdRegister[18], 0);
	TextDrawFont(_tdRegister[18], 4);

	_tdRegister[19] = TextDrawCreate(256.333770, 287.414855, "HA„AЏ’");
	TextDrawLetterSize(_tdRegister[19], 0.153332, 1.106373);
	TextDrawTextSize(_tdRegister[19], 282.333251, 12.859260);
	TextDrawAlignment(_tdRegister[19], 1);
	TextDrawColor(_tdRegister[19], -1);
	TextDrawUseBox(_tdRegister[19], true);
	TextDrawBoxColor(_tdRegister[19], 0xFFFFFF00);
	TextDrawSetShadow(_tdRegister[19], 0);
	TextDrawSetOutline(_tdRegister[19], 0);
	TextDrawBackgroundColor(_tdRegister[19], 51);
	TextDrawFont(_tdRegister[19], 2);
	TextDrawSetProportional(_tdRegister[19], 1);
	TextDrawSetSelectable(_tdRegister[19], true);

	_tdRegister[20] = TextDrawCreate(252.666763, 301.518707, "‹‘ЂEP…ЏE ‹HEЋHOCЏ’ ЊEPCOHA„A:");
	TextDrawLetterSize(_tdRegister[20], 0.130332, 1.114668);
	TextDrawAlignment(_tdRegister[20], 1);
	TextDrawColor(_tdRegister[20], -1);
	TextDrawSetShadow(_tdRegister[20], 0);
	TextDrawSetOutline(_tdRegister[20], 0);
	TextDrawBackgroundColor(_tdRegister[20], 51);
	TextDrawFont(_tdRegister[20], 2);
	TextDrawSetProportional(_tdRegister[20], 1);

	_tdRegister[21] = TextDrawCreate(253.333419, 314.451507, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[21], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[21], 58.666656, 11.200012);
	TextDrawAlignment(_tdRegister[21], 1);
	TextDrawColor(_tdRegister[21], 1835888127);
	TextDrawSetShadow(_tdRegister[21], 0);
	TextDrawSetOutline(_tdRegister[21], 0);
	TextDrawFont(_tdRegister[21], 4);

	_tdRegister[22] = TextDrawCreate(256.333801, 314.133331, "HA„AЏ’");
	TextDrawLetterSize(_tdRegister[22], 0.153332, 1.106373);
	TextDrawTextSize(_tdRegister[22], 281.666748, 13.274076);
	TextDrawAlignment(_tdRegister[22], 1);
	TextDrawColor(_tdRegister[22], -1);
	TextDrawUseBox(_tdRegister[22], true);
	TextDrawBoxColor(_tdRegister[22], 0xFFFFFF00);
	TextDrawSetShadow(_tdRegister[22], 0);
	TextDrawSetOutline(_tdRegister[22], 0);
	TextDrawBackgroundColor(_tdRegister[22], 51);
	TextDrawFont(_tdRegister[22], 2);
	TextDrawSetProportional(_tdRegister[22], 1);
	TextDrawSetSelectable(_tdRegister[22], true);

	_tdRegister[23] = TextDrawCreate(271.333404, 336.192260, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[23], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[23], 42.333316, 13.688901);
	TextDrawAlignment(_tdRegister[23], 1);
	TextDrawColor(_tdRegister[23], 1835888127);
	TextDrawSetShadow(_tdRegister[23], 0);
	TextDrawSetOutline(_tdRegister[23], 0);
	TextDrawFont(_tdRegister[23], 4);

	_tdRegister[24] = TextDrawCreate(282.333587, 335.289154, "‹O†Џ…");
	TextDrawLetterSize(_tdRegister[24], 0.158332, 1.517038);
	TextDrawTextSize(_tdRegister[24], 303.666687, 16.177780);
	TextDrawAlignment(_tdRegister[24], 1);
	TextDrawColor(_tdRegister[24], -1);
	TextDrawUseBox(_tdRegister[24], true);
	TextDrawBoxColor(_tdRegister[24], 0xFFFFFF00);
	TextDrawSetShadow(_tdRegister[24], 0);
	TextDrawSetOutline(_tdRegister[24], 0);
	TextDrawBackgroundColor(_tdRegister[24], 51);
	TextDrawFont(_tdRegister[24], 2);
	TextDrawSetProportional(_tdRegister[24], 1);
	TextDrawSetSelectable(_tdRegister[24], true);

	_tdRegister[25] = TextDrawCreate(323.000427, 336.362640, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[25], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[25], 42.333316, 13.688901);
	TextDrawAlignment(_tdRegister[25], 1);
	TextDrawColor(_tdRegister[25], 1835888127);
	TextDrawSetShadow(_tdRegister[25], 0);
	TextDrawSetOutline(_tdRegister[25], 0);
	TextDrawFont(_tdRegister[25], 4);

	_tdRegister[26] = TextDrawCreate(333.333465, 335.044677, "‹‘†Џ…");
	TextDrawLetterSize(_tdRegister[26], 0.158332, 1.517038);
	TextDrawTextSize(_tdRegister[26], 355.000091, 16.177782);
	TextDrawAlignment(_tdRegister[26], 1);
	TextDrawColor(_tdRegister[26], -1);
	TextDrawUseBox(_tdRegister[26], true);
	TextDrawBoxColor(_tdRegister[26], 0xFFFFFF00);
	TextDrawSetShadow(_tdRegister[26], 0);
	TextDrawSetOutline(_tdRegister[26], 0);
	TextDrawBackgroundColor(_tdRegister[26], 51);
	TextDrawFont(_tdRegister[26], 2);
	TextDrawSetProportional(_tdRegister[26], 1);
	TextDrawSetSelectable(_tdRegister[26], true);

	_tdRegister[27] = TextDrawCreate(249.333297, 177.540740, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[27], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[27], 1.333353, 8.296292);
	TextDrawAlignment(_tdRegister[27], 1);
	TextDrawColor(_tdRegister[27], -1523963137);
	TextDrawSetShadow(_tdRegister[27], 0);
	TextDrawSetOutline(_tdRegister[27], 0);
	TextDrawFont(_tdRegister[27], 4);

	_tdRegister[28] = TextDrawCreate(249.666610, 205.503692, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[28], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[28], 1.333353, 8.296292);
	TextDrawAlignment(_tdRegister[28], 1);
	TextDrawColor(_tdRegister[28], -1523963137);
	TextDrawSetShadow(_tdRegister[28], 0);
	TextDrawSetOutline(_tdRegister[28], 0);
	TextDrawFont(_tdRegister[28], 4);

	_tdRegister[29] = TextDrawCreate(249.999954, 233.881469, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[29], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[29], 1.333353, 8.296292);
	TextDrawAlignment(_tdRegister[29], 1);
	TextDrawColor(_tdRegister[29], -1523963137);
	TextDrawSetShadow(_tdRegister[29], 0);
	TextDrawSetOutline(_tdRegister[29], 0);
	TextDrawFont(_tdRegister[29], 4);

	_tdRegister[30] = TextDrawCreate(249.999954, 261.429595, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[30], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[30], 1.333353, 8.296292);
	TextDrawAlignment(_tdRegister[30], 1);
	TextDrawColor(_tdRegister[30], -1523963137);
	TextDrawSetShadow(_tdRegister[30], 0);
	TextDrawSetOutline(_tdRegister[30], 0);
	TextDrawFont(_tdRegister[30], 4);

	_tdRegister[31] = TextDrawCreate(250.333297, 289.392669, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[31], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[31], 1.333353, 8.296292);
	TextDrawAlignment(_tdRegister[31], 1);
	TextDrawColor(_tdRegister[31], -1523963137);
	TextDrawSetShadow(_tdRegister[31], 0);
	TextDrawSetOutline(_tdRegister[31], 0);
	TextDrawFont(_tdRegister[31], 4);

	_tdRegister[32] = TextDrawCreate(250.000000, 315.696350, "LD_SPAC:white");
	TextDrawLetterSize(_tdRegister[32], 0.000000, 0.000000);
	TextDrawTextSize(_tdRegister[32], 1.333353, 8.296292);
	TextDrawAlignment(_tdRegister[32], 1);
	TextDrawColor(_tdRegister[32], -1523963137);
	TextDrawSetShadow(_tdRegister[32], 0);
	TextDrawSetOutline(_tdRegister[32], 0);
	TextDrawFont(_tdRegister[32], 4);		

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

	// Потребности персонажа

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

	// Спидометр
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

		// Вода
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

		// Еда
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
		case 50: SCM(playerid, COLOR_WHITEOR, "[Уведомление]: {FFFFFF}Ваш персонаж проголодался, посетите ближайшее заведение!");
	}
	switch(player_info[playerid][thirst])
	{
		case 1..30:
		{
			player_info[playerid][health] -= 3.1;
			SetPlayerHealth(playerid, player_info[playerid][health]);
		}
		case 50: SCM(playerid, COLOR_WHITEOR, "[Уведомление]: {FFFFFF}Ваш персонаж хочет пить, посетите ближайшее заведение!");
	}
	return 1;
}

stock ConvertSeconds(time)  
{  
	new string[128];  
	if(time < 60) format(string, sizeof(string), "%d сек.", time);  
	else if(time == 60) string = "1 минуту";  
	else if(time > 60 && time < 3600)  
	{  
		new Float: minutes;  
		new seconds;  
		minutes = time / 60;  
		seconds = time % 60;  
		format(string, sizeof(string), "%.0f мин. и %d сек.", minutes, seconds);  
	}  
	else if(time == 3600) string = "1 час";  
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
					SendClientMessage(targetid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы были выселены из дома за неуплату!");
					new i = player_info[targetid][keyh];
					strmid(house_info[i][h_owner], "Государство", 0, strlen("Государство"), 255);
					house_info[i][h_owned] = 0;
					player_info[targetid][keyh] = -1;
					player_info[targetid][bank_money] += house_info[i][h_money];

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_owned` = '%d', `h_owner` = 'Государство', `h_rent` = '%d' WHERE `hid` = '%d'", house_info[i][h_owned], house_info[i][h_rent], house_info[i][hid]);
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

					strmid(house_info[h][h_owner], "Государство", 0, strlen("Государство"), 255);

					query[0] = EOS;
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `house` SET `h_owned` = '0', `h_owner` = 'Государство', `h_rent` = '0' WHERE `hid` = '%d'", house_info[h][hid]);
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
					SendClientMessage(targetid, COLOR_WHITE, "{EDD682}[Уведомление]: {FFFFFF}Вы были выселены из квартиры за неуплату!");
					new i = player_info[targetid][keya];
					strmid(apart_info[i][a_owner], "Государство", 0, strlen("Государство"), 255);
					apart_info[i][a_owned] = 0;
					player_info[targetid][keya] = -1;
					player_info[targetid][bank_money] += apart_info[i][a_money];

					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_owned` = '%d', `a_owner` = 'Государство', `a_rent` = '%d' WHERE `aid` = '%d'", apart_info[i][a_owned], apart_info[i][a_rent], apart_info[i][aid]);
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

					strmid(apart_info[a][a_owner], "Государство", 0, strlen("Государство"), 255);

					query[0] = EOS;
					mysql_format(ConnectMysql, query, sizeof(query), "UPDATE `apartament` SET `a_owned` = '0', `a_owner` = 'Государство', `a_rent` = '0' WHERE `aid` = '%d'", apart_info[a][aid]);
					mysql_query(ConnectMysql, query);
				}
				Delete3DTextLabel(apart_info[a][a_text]);
				apart_info[a][a_text] = Create3DTextLabel("{FFFFFF}Квартира продаётся.\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, apart_info[a][a_enter][0], apart_info[a][a_enter][1], apart_info[a][a_enter][2], 20.0, apart_info[a][a_world], 1);									
			}
		}		
	}
	foreach(new i:Player)
	{
		if(!IsPlayerConnected(i)) continue;
		if(temp_info[i][pLoginStatus] != true) return SCM(i, COLOR_WHITEOR, "[Уведомление]: Вы пропустили PayDay!");
		if(temp_info[i][PlayerAFK] > 3) return SCM(i, COLOR_WHITEOR, "[Уведомление]: Вы пропустили PayDay!");
		player_info[i][exp]++;
		if(player_info[i][exp] >= _getMaxPlayerExpLevel(player_info[i][lvl]))
		{
			player_info[i][exp] = 0;
			player_info[i][lvl]++;
			player_info[i][age]++;
			SetPlayerScore(i, player_info[i][lvl]);
			SCM(i, COLOR_WHITEOR, "[Уведомление]: {FFFFFF}Ваш игровой уровень повысился!");	
		}
		SCM(i, COLOR_WHITEOR, "GIVE PAYDAY");

		if(player_info[i][eat] <= 30) SCM(i, COLOR_WHITEOR, "[Уведомление]: {FFFFFF}Ваш персонаж очень сильно проголодался, посетите ближайшее заведение!");
		if(player_info[i][thirst] <= 30) SCM(i, COLOR_WHITEOR, "[Уведомление]: {FFFFFF}Ваш персонаж очень сильно хочет пить, посетите ближайшее заведение!");
	}
	return 1;
}

stock _getMaxPlayerExpLevel(level)
{
	return 3 + (level *3);
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
	bank[0] = CreatePickup(1318, 23, 2376.7192, -2139.2600, 22.0776, 0); // - Вход в банк
	bank[1] = CreatePickup(1318, 23, 2375.6055, -1910.1226, 1126.9100, 1); // - Выход с банка
	bank[2] = CreateDynamicPickup(1514, 2, 2370.7439, -1904.0571, 1126.9100, 1, 0);

	hospital[0] = CreatePickup(1318, 23, 2112.7124, -2392.8530, 23.0883, 0); // - Вход в больницу г.Южный
	hospital[1] = CreatePickup(1318, 23, 366.9555, 124.9833, 1003.8500, 2); // - Выход с больницы г.Южный

	_pickupm[0] = CreatePickup(1318, 23, 1481.0710, -1772.3121, 18.7958, 0); // - Вход в правительство Лос-Сантос
	_pickupm[1] = CreatePickup(1318, 23, 390.7689, 173.7262, 1008.3828, 1); // - Выход с правительства Лос-Сантос

	_arendBike[0] = CreatePickup(19134, 23, 1775.4690, -1904.4019, 13.3860, 0);

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
		case 1: text = "Эконом класс";
		case 2: text = "Средний класс";
		case 3: text = "Высокий класс";
	}
	format(string, sizeof(string),
	"{FFFFFF}Номер дома:\t %d\n\
	{FFFFFF}Класс дома:\t %s\n\
	{FFFFFF}Гос.цена:\t %d\n\
	{FFFFFF}Оплачено дней:\t %d",
	i, text, house_info[i][h_money], house_info[i][h_rent]);
	SPD(playerid, DLG_INFOHOME, DSM, "{EDD682}Информация о доме", string, "Назад", "");
	return 1;
}

stock _infoApart(playerid)
{
	new string[256], text[25];
	new i = player_info[playerid][keya];
	switch(apart_info[i][a_class])
	{
		case 1: text = "Эконом класс";
		case 2: text = "Средний класс";
		case 3: text = "Высокий класс";
	}
	format(string, sizeof(string),
	"{FFFFFF}Номер квартиры:\t %d\n\
	{FFFFFF}Класс квартиры:\t %s\n\
	{FFFFFF}Гос.цена:\t %d\n\
	{FFFFFF}Оплачено дней:\t %d",
	i, text, apart_info[i][a_money], apart_info[i][a_rent]);
	SPD(playerid, DLG_INFOAPART, DSM, "{EDD682}Информация о квартире", string, "Назад", "");
	return 1;
}

stock _statsPlayer(playerid)
{
	new string[256];
	new l = player_info[playerid][lvl];
	format(string, sizeof(string),
	"{FFFFFF}Имя персонажа:\t %s\n\
	Возраст персонажа:\t %d\n\
	Уровень персонажа:\t %d\n\
	Опыт персонажа:\t %d/%d\n\
	Пол персонажа:\t %s\n\
	Дата регистрации:\t %s\n\
	Организация:\t\t %s\n\
	Ранг:\t\t\t %s [%d]",
	player_info[playerid][name], player_info[playerid][age], l, player_info[playerid][exp], _getMaxPlayerExpLevel(l), 
	(player_info[playerid][sex] == 1) ? ("Мужской") : ("Женский"), player_info[playerid][regdata], _fracName(playerid), 
	FractionName[player_info[playerid][member]][player_info[playerid][rang]], player_info[playerid][rang]);
	SPD(playerid, DLG_STATS, DSL, "{EDD682}Статистика персонажа", string, "Назад", "");
	return 1;
}

stock _questPlayer(playerid)
{
	new string[256];
	format(string, sizeof(string),
	"1. Новое знакомство.\t\t\t %s", (player_info[playerid][quest][0] == 1) ? ("{EDD682}Выполнен") : ("{EDD682}Не выполнен"));
	SPD(playerid, DLG_QUEST, DSL, "{EDD682}Квестовые задания", string, "Выбрать", "Закрыть");
	return 1;
}

stock _fracName(playerid)
{
	new fname[72];
	if(player_info[playerid][member] == 0) fname =  "Гражданский";
 	if(player_info[playerid][member] == 1) fname =  "The Government of Los Santos";
 	if(player_info[playerid][member] == 2) fname =  "ППС";
 	if(player_info[playerid][member] == 3) fname =  "ГИБДД";
 	if(player_info[playerid][member] == 4) fname =  "Министерство обороны";
 	if(player_info[playerid][member] == 5) fname =  "Федеральная служба безопасности";
 	if(player_info[playerid][member] == 6) fname =  "Министерство здравоохранения";
 	if(player_info[playerid][member] == 7) fname =  "Средства массовой информации";
 	if(player_info[playerid][member] == 8) fname =  "Батыревская братва";
 	if(player_info[playerid][member] == 9) fname =  "Южная братва";
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
    // Проверяем, соответствует ли игрок определённой фракции и рангу
    if(player_info[playerid][member] == 1 && player_info[playerid][rang] == 12 && param > 11) {
        return true; // Условие выполнено
    }
    return false; // Условие не выполнено
}

stock _infoPlayer(playerid)
{
	SCM(playerid, COLOR_WHITE, !"{EDD682}>>> {FFFFFF}Если у Вас возникнут вопросы, обращайтесь к нашей администрации: {EDD682}(Клавиша 'H' -> Связь с администрацией)");
	SCM(playerid, COLOR_WHITE, !"{EDD682}>>> {FFFFFF}Просим Вас соблюдать правила проекта, можете ознакомиться с ними: {EDD682}(Клавиша 'H' -> Правила проекта)");
	SCM(playerid, COLOR_WHITE, !"{EDD682}>>> {FFFFFF}Следите за показателями потребностей Вашего персонажа: {EDD682}(Клавиша 'H' -> Потребности персонажа)");
	return 1;
}

// Транспорт 
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
		house_info[houseid][h_text] = Create3DTextLabel("{FFFFFF}Дом продаётся.\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[houseid][h_enter][0], house_info[houseid][h_enter][1], house_info[houseid][h_enter][2], 20.0, 0, 1);
	}
	if(house_info[houseid][h_owned] == 1)
	{
		house_info[houseid][h_icon] = CreateDynamicMapIcon(house_info[houseid][h_enter][0], house_info[houseid][h_enter][1], house_info[houseid][h_enter][2], 32, -1, 0, -1, -1, 90.0);
		house_info[houseid][h_pickup] = CreateDynamicPickup(19522, 23, house_info[houseid][h_enter][0], house_info[houseid][h_enter][1], house_info[houseid][h_enter][2],0, 0, -1);
		house_info[houseid][h_text] = Create3DTextLabel("{FFFFFF}Дом не продаётся.\n Для взаимодействия нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[houseid][h_enter][0], house_info[houseid][h_enter][1], house_info[houseid][h_enter][2], 20.0,0,1);
	}
	house_info[houseid][h_texit] = Create3DTextLabel("{FFFFFF}Чтобы выйти, нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, house_info[houseid][h_exit][0], house_info[houseid][h_exit][1], house_info[houseid][h_exit][2], 20.0, houseid+50, 1);	
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
			SCM(playerid, COLOR_WHITE, "Чат заблокирован! До разблокировки осталось примерно минута.");
		}
		else
		{
			new string[80];
			format(string, sizeof(string), "Чат заблокирован! До разблокировки осталось {EDD682}%d {FFFFFF}мин.", floatround(time / 60));
			SCM(playerid, COLOR_WHITE, string);
		}
		return 1;
	}
	return 0;
}

stock _aCommands(playerid)
{
	SPD(playerid, DLG_ACOMMAND, DSL, "{EDD682}AP - Команды администратора", 
	"{FFFFFF}1. Администратор 1-го уровня\n\
	2. Администратор 2-го уровня\n\
	3. Администратор 3-го уровня\n\
	4. Администратор 4-го уровня\n\
	5. Администратор 5-го уровня", "Выбрать", "Назад");
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

	// -- Правительство
	lead_one[0] = CreateVehicle(579, 1407.9590, -1807.8898, 13.4003, 359.5926, 0, 0, -1, 1);
	lead_one[1] = CreateVehicle(579, 1404.4962, -1808.0062, 13.4002, 0.6788, 0, 0, -1, 1); 
	lead_one[2] = CreateVehicle(579, 1403.6949, -1771.5060, 13.3999, 179.6300, 0, 0, -1, 1);
	lead_one[3] = CreateVehicle(579, 1407.0909, -1771.4348, 13.3781, 179.5764, 0, 0, -1, 1); 
	lead_one[4] = CreateVehicle(409, 1407.2323, -1789.4474, 13.2924, 359.3717, 0, 0, -1, 1);
	for(new i; i < 5; i++) SetVehicleNumberPlate(lead_one[i], "Government");

	return 1;
}

stock _rulesPlayer(playerid)
{
	SPD(playerid, DLG_PRULES_ONE, DSM, 
	"{EDD682}Правила игрока", 
	"{FFFFFF}Заходя на игровой сервер, Вы принимаете данные правила\n\
	Незнание правил не освобождает от ответственности\n\
	Общепринятые игровые термины на RolePlay серверах\n\
	Role Play (RP) — игра персонажами по ролям, приближённая к реальной жизни\n\
	Non RolePlay (NonRP) — действия персонажа, которые бы он не сделал в реальной жизни\n\
	Spawn Kill (SK) — причинение ущерба здоровью игрового персонажа без весомой игровой причины на территории базы организации, где он появляется при входе в игру\n\
	Team Kill (TK) — причинение ущерба здоровью члена своей фракции без весомой на то игровой причины\n\
	Bunny Hop (BH) — бег с постоянным использованием прыжков при игроках\n\
	Drive By (DB) — причинение ущерба здоровью с машины персонажу\n\
	Power Gaming (PG) — преувеличение возможностей своего персонажа\n\
	Revenge Kill (RVK) — причинение ущерба здоровью игровому персонажу в отместку, который ранее Вас убил\n\
	Repeat Kill (RPK) — намеренное повторное убийство одного и того же игрока, которого Вы уже убили ранее\n\
	Out Of Character (OOC) — внеигровая информация, то есть взятая из нашего реального мира\n\
	In Character (IC) — игровая информация, то есть взятая из игрового мира\n\
	Meta Gaming (MG) — смешивание игровой и внеигровой информации\n\
	Death Match (DM) — причинение ущерба здоровью игрового персонажа без весомой на то игровой причины, либо беспричинная стрельба/удары/аварии",
	"Далее", "Назад");
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
	Create3DTextLabel(!"{FFFFFF}NPC: {EDD682}Репа. \n {FFFFFF}Для взаимодействия нажмите - {EDD682}'L.ALT'.", COLOR_WHITE, 1797.1179, 2509.8589, 16.2770, 20.0, 0, 1);
	Create3DTextLabel(!"{FFFFFF}NPC: {EDD682}Иван. \n {FFFFFF}Ознакомиться с правилами - {EDD682}'L.ALT'.", COLOR_WHITE, 1808.1010, 2506.8914, 15.8725, 20.0, 0, 1);
	Create3DTextLabel(!"{FFFFFF}Аренда велосипеда \n Доступ для новечков!", COLOR_WHITE, 1775.4690, -1904.4019, 13.3860, 20.0, 0, 1);
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
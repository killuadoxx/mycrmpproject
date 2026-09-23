// Connect MySQL
new MySQL: ConnectMysql;
new query[600];

// Переменные игрока
enum player
{
	id,
	name[MAX_PLAYER_NAME],
	pass[65],
	salt[11],
	email[65],
	regdata[13],
	logindata[13],
	regip[16],	
	ref,
	sex,
	age,
	skin,
	lvl,
	exp,
	money,
	lic[6],
	quest[4],
	Float: health,
	Float: armor,
	thirst,
	eat,
	bank_pin[2],
	bank_money,
	bank_check,
	leader,
	member,
	rang,
	fskin,
	Float: exitx,	
	Float: exity,
	Float: exitz,
	Float: exitfa,
	p_world,
	p_interior,
	baninfo,
	hospitaltime,
	keyh,
	keya,
	mutetime,
	p_model,
	Float: p_posx,
	Float: p_posy,
	Float: p_posz,
	Float: p_posfa,
	p_color1,
	p_color2,
}
new player_info[MAX_PLAYERS][player];

enum banned
{
	aname[MAX_PLAYER_NAME],
	name[MAX_PLAYER_NAME],
	whendate[28],
	enddate,
	banreason[129],
}
new banned_info[MAX_PLAYERS][banned];

new mute_timer[MAX_PLAYERS];

enum admin
{
	apassword[16],
	alevel,
}
new admin_info[MAX_PLAYERS][admin];

// Home
enum house
{
	hid,
	Float: h_enter[3],
	Float: h_exit[3],
	h_owned,
	h_owner[MAX_PLAYER_NAME],
	h_money,
	h_class,
	h_rent,
	h_lock,
	h_icon,
	h_pickup,
	Text3D:h_text,
	Text3D:h_texit,
}
new house_info[MAX_HOUSES][house];
new totalhouse;

// Подъезд 
enum porch
{
	pid,
	Float:p_enter[3],
	Float:p_exit[3],
	p_pickup,
	Text3D:p_text,
	Text3D:p_texit,
	Text3D:p_floor1,
	Text3D:p_floor2,
}
new porch_info[MAX_PORCH][porch];
new totalporch;

// Квартира
enum apart
{
	aid,
	Float: a_enter[3],
	Float: a_exit[3],
	a_owned,
	a_owner[MAX_PLAYER_NAME],
	a_money,
	a_class,
	a_rent,
	a_lock,
	a_world,
	Text3D:a_text,
	Text3D:a_texit,
}	
new apart_info[MAX_APART][apart];
new totalapart;

new Float:_playerSpawn[1][4] = // Spawn игрока
{
    {1802.9122, 2505.6067, 15.8725, 303.3800}
};

new FractionSkin[10][10] = {
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},					  // Гражданский
	{59, 150, 147, 227, 295, 228, 187},      // The Government of Los Santos
	{265, 266, 267, 306, 285, 288}, // Полиция (ППС)
	{280, 281, 282, 284, 307, 283}, // Полиция (ГИБДД)
	{287, 191, 179, 73, 255, 61}, // Министерство обороны
	{163, 164, 165, 166, 141, 303, 294}, // Федеральная служба безопасности
	{274, 275, 276, 308, 70}, // Министерство здравоохранения
	{250, 217, 211, 261}, // Средства массовой информации
	{111, 112, 91, 98, 113}, // Батыревская братва
	{124, 125, 127, 55, 126} // Южная братва
};

new FractionName[10][14][30] = {
	{"Гражданский", "", "", "", "", "", "", "", "", "", "", "", "", ""}, // Гражданский
	{"", "Водитель", "Охранник", "Начальник охраны", "Секретарь", "Старший Секретарь", "Адвокат", "Прокурор", "Вице-мэр города", "Мэр города", "", "", "", ""}, // The Government of Los Santos
	{"", "Рядовой", "Мл.Сержант", "Сержант", "Ст.Сержант", "Прапорщик", "Капитан", "Майор", "Подполковник", "Полковник", "Генерал полиции", "", "", ""}, // Полиция (ППС)
	{"", "Рядовой", "Мл.Сержант", "Сержант", "Ст.Сержант", "Прапорщик", "Капитан", "Майор", "Подполковник", "Полковник", "Генерал полиции", "", "", ""}, // Полиция (ГИБДД)
	{"", "Рядовой", "Ефрейтор", "Мл.Сержант", "Сержант", "Ст.Сержант", "Прапорщик", "Майор", "Подполковник", "Полковник", "Генерал армии", "", "", ""}, // Министерство обороны
	{"", "Рядовой", "Ефрейтор", "Мл.Сержант", "Сержант", "Ст.Сержант", "Лейтенант", "Майор", "Подполковник", "Полковник", "Генерал ФСБ", "", "", ""}, // Федеральная служба безопасности
	{"", "Интерн", "Фельдшер", "Участковый врач", "Терапевт", "Проктолог", "Окулист", "Хирург", "Заведующий отделением", "Заместитель главного врача", "Главный врач", "", "", ""}, // Министерство здравоохранения
	{"", "Стажёр", "Помощник редакции", "Радиотехник", "Журналист", "Оператор", "Ведущий", "Помощник редактора", "Редактор", "Главный редактор", "Директор", "", "", ""}, // Средства массовой информации
	{"", "Шнырь", "Фраер", "Бык", "Барыга", "Блатной", "Свояк", "Браток", "Вор", "Вор в законе", "Авторитет", "", "", ""}, // Батыревская братва
	{"", "Шнырь", "Фраер", "Бык", "Барыга", "Блатной", "Свояк", "Браток", "Вор", "Вор в законе", "Авторитет", "", "", ""} // Южная братва
};

new const FactionMaxRanks[MAX_FRACTION] = {0, 13, /* и так далее для каждой фракции */};

// -- Pickup's организаций
new _pickupm[2]; // Вход и выход с мэрии

// -- Vehicle Fraction
new lead_one[5];

enum temp
{
	bool: pLoginStatus,
	bool: pAdminStatus,
	bool: pFreezeStatus,
	PlayerAFK,
	AFK,
}
new temp_info[MAX_PLAYERS][temp];


new PlayerText:_tdSatiety[6][MAX_PLAYERS];
new PlayerText:logo[MAX_PLAYERS];
new Text:skinTextDraw[6];
new Text:_tdRegister[33];
new skinRegister[6][1] = {
	{20},// мужские
	{21},
	{14},
	{12},// женские
	{13},
	{41}	
};

// Dialog`s
enum dialogs
{
	DLG_NONE,
	DLG_REG,
	DLG_LOG,
	DLG_REGEMAIL,
	DLG_REGREF,
	DLG_REGSEX,
	DLG_REGAGE,
	DLG_NEED,
	DLG_ALOGIN_REG,
	DLG_ALOGIN,
	DLG_AONLINE,
	DLG_CREATEBANKPIN,
	DLG_LOGINBANK,
	DLG_BANKMENU,
	DLG_BANKINFO,
	DLG_TMONEY,
	DLG_GMONEYBANK,
	DLG_TMONEYBANK,
	DLG_SBANK,
	DLG_BANKNEWPIN,
	DLG_MENU,
	DLG_STATS,
	DLG_SETLEADER,
	DLG_CHANGESKIN,
	DLG_TRANSFERBANK,
	DLG_SPAWN,
	DLG_EDA,
	DLG_HOME,
	DLG_HOMEBUY,
	DLG_INFOHOME,
	DLG_SELLHOMEG,
	DLG_HOMEMENU,
	DLG_SELLHOMEP,
	DLG_SELLHOMEP2,
	DLG_CREATE,
	DLG_CREATEHOUSE,
	DLG_NALOGBANK,
	DLG_HOMEPAY,
	DLG_APANEL,
	DLG_ACOMMAND,
	DLG_ACONE,
	DLG_ACTWO,
	DLG_ACTHREE,
	DLG_ACFOUR,
	DLG_ACFIVE,
	DLG_CREATEPORCH,
	DLG_CREATEAPART,
	DLG_APART,
	DLG_APARTBUY,
	DLG_APARTMENU,
	DLG_INFOAPART,
	DLG_SELLAPARTG,
	DLG_SELLAPARTP,
	DLG_SELLAPARTP2,
	DLG_APARTPAY,
	DLG_BUYCAR,	
	DLG_PRULES_ONE,
	DLG_PRULES_TWO,
	DLG_PRULES_THREE,
	DLG_QUEST,
	DLG_INVITE,
	DLG_LPANEL
}

new eda[2];
new bank[3]; // - Пикапы банка г.Южный
new hospital[2]; // - Пикапы больница г.Южный
new _arendBike[1];
new _playerBikeID[MAX_PLAYERS];

enum pos_frac
{
	Float: f_x,
	Float: f_y,
	Float: f_z,
	Float: f_a,
	in,
	vw
};
new Float:spawnFrac[14][pos_frac]=//x,y,z,fA, int,vw
{
	{369.1045, 198.0942, 1014.1875, 265.1525, 3, 1},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0},//lspd
	{1872.2419,-2235.0649,11.2510,183.9245,0,0}//lspd
};

// --- Транспорт
new Text:SPEEDTD;
new PlayerText:SPEEDOPTD[3][MAX_PLAYERS];
new PlayerText:SPEEDPTD[6][MAX_PLAYERS];
new speedtimer[MAX_PLAYERS];
new speedtimertwo[MAX_PLAYERS];
new PlayerVehicleID[MAX_PLAYERS];
new VehicleDriverID[MAX_VEHICLES];
//new VehEngine[MAX_VEHICLES char];
//new VehLights[MAX_VEHICLES char];
//new VehDoors[MAX_VEHICLES char];
new bool: StartEngine[MAX_PLAYERS];
new TOTALVEH;
new bool: CreateCar[MAX_VEHICLES];

enum vehicle
{
	v_id,
	v_model,
	v_owner[MAX_PLAYER_NAME],
	Float: v_posx,
	Float: v_posy,
	Float: v_posz,
	Float: v_posfa,
	v_color01,
	v_color02,
	v_money,
	v_world,
	v_interior,
	v_plate,
	bool:v_lock,
	bool:v_lights,
	bool:v_engine,
	Float: v_fuel,
	Float: v_millage,
	Float: v_health,
	v_if_buy,
	STATICTIMER,
	DYNAMICTIMER
}
new vehicle_info[MAX_VEHICLES][vehicle];
new totalcars;

new pCarID[MAX_PLAYERS];

new VehicleNames[212][32] = 
{
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Lada Priora", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana",
	"Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat",
	"Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife",
	"Trailer 1", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo",
	"Seasparrow", "Pizzaboy", "Tram", "Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
	"Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
	"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito",
	"Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "пїЅпїЅпїЅ 2105", "Jetmax", "Hotring",
	"Sandking", "Blista Compact", "Police Maverick", "Boxvillde", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B",
	"Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker",
	"Roadtrain", "пїЅпїЅпїЅ 21099", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
	"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak",
	"Vortex", "Vincent", "Bullet", "пїЅпїЅпїЅпїЅ", "Sadler", "Firetruck LA", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "пїЅпїЅпїЅпїЅпїЅ",
	"Utility", "Nevada", "Yosemite", "Windsor", "Monster A", "Monster B", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance",
	"RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway",
	"Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer 3", "Emperor", "Wayfarer", "Euros", "Hotdog",
	"Club", "Freight Carriage", "Trailer 4", "Andromeda", "Dodo", "RC Cam", "Launch", "Police Car", "Police Car",
	"Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer A",
	"Luggage Trailer B", "Stairs", "Boxville", "Tiller", "Utility Trailer" 
};

new _licensesName[6][20] =
{
	"Наземный транспорт", "Воздушный транспорт", "Водный транспорт", 
	"Оружие", "Рыболовство", "Владение бизнесом"
};

//new _carsBuyEconomy[2];

// Actor`s
new npcRepa; 	// -->>> Бот на спавне (лавочка)
new npcIvan;		// -->>> Бот на спавне (Правила)
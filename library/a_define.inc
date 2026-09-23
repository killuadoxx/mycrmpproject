#define 	     Pawn.RakNet
#define        SERVER_NAME     	"Russian History | CR Multiplayer!"
#define		SERVER_LANGUAGE 	"Russian"
#define		SERVER_GAMEMODE     "A-SA 0.2"
#define		SERVER_MAPNAME    	"Russian"
#define		SERVER_WEBURL       "vk.com/russian-rp"

#define		MYSQL_HOST 			"127.0.0.1"
#define		MYSQL_USER 			"root"
#define		MYSQL_PASS 			""
#define		MYSQL_BASE 			"samp"

#define     publics:%0(%1) forward %0(%1); public %0(%1)

#define		SCM       SendClientMessage
#define		SCMTA     SendClientMessageToAll
#define		SPMTP     SendPlayerMessageToPlayer
#define		SPMTA     SendPlayerMessageToAll

#define     SPD       MDialog_LegacyShowPlayerDialog
#define     DSM       DIALOG_STYLE_MSGBOX
#define     DSI       DIALOG_STYLE_INPUT
#define     DSL       DIALOG_STYLE_LIST
#define     DSP       DIALOG_STYLE_PASSWORD
#define     DST       DIALOG_STYLE_TABLIST
#define     DSTH      DIALOG_STYLE_TABLIST_HEADERS

new gLegacyDialog[MAX_PLAYERS];

forward MDialog_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#define        TIMEARENDA          600

#define        PLAYER_PARAM_MONEY      0
#define        PLAYER_PARAM_LEVEL      1
#define        PLAYER_PARAM_EXP        2
#define        PLAYER_PARAM_AGE        3
#define        PLAYER_PARAM_EAT        4
#define        PLAYER_PARAM_THIRST     5
#define        PLAYER_PARAM_MEMBER     6
#define        PLAYER_PARAM_RANG       7
#define        PLAYER_PARAM_FSKIN      8
#define        PLAYER_PARAM_MUTETIME   9

#define 	     MAX_HOUSES 		300
#define 	     MAX_PORCH 		500
#define		MAX_APART		     300
#define		MAX_FRACTION	     10

#define		COLOR_PROJECT	     0xEDD682FF
#define        COLOR_ERROR         0xCD5454FF
#define        COLOR_WHITE         0xFFFFFFFF
#define		COLOR_BUDDLE	     0xDE92FFFF
#define        COLOR_CLEAR         0xFFFFFF00
#define        COLOR_WHITEOR       0xEDD682FF
#define		COLOR_ACHAT 	     0xD4D239AA
#define        COLOR_SRED          0xFF6347AA
#define		COLOR_BLIM		0x70A7FFAA

#if !defined IsValidVehicle
     native IsValidVehicle(vehicleid);
#endif
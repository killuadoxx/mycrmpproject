#if defined _MDIALOG_LEGACY_INCLUDED
	#endinput
#endif
#define _MDIALOG_LEGACY_INCLUDED

#include <mdialog>

new gMDialogLegacyId[MAX_PLAYERS];

forward MDialog_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);

stock MDialog_LegacyShowPlayerDialog(playerid, dialogid, style, const caption[], const info[], const button1[], const button2[])
{
	if(dialogid == -1)
	{
		return Dialog_Close(playerid);
	}
	gMDialogLegacyId[playerid] = dialogid;
	return Dialog_Open(playerid, "Legacy", style, caption, info, button1, button2);
}

DialogResponse:Legacy(playerid, response, listitem, inputtext[])
{
	return MDialog_OnDialogResponse(playerid, gMDialogLegacyId[playerid], response, listitem, inputtext);
}

#if defined _ALS_ShowPlayerDialog
	#undef ShowPlayerDialog
#endif
#define ShowPlayerDialog MDialog_LegacyShowPlayerDialog

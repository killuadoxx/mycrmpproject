/*============================================================================*\
 *      Improved SetPlayerPos implementation v1.2                             *
 *          by Daniel_Cortez                                                  *
 *                                                                            *
 * http://pro-pawn.ru/showthread.php?6278-dc_spp                              *
 *                                                                            *
 * Copyright (c) 2013-2018 Stanislav Gromov                                   *
 *                                                                            *
 * This software is provided 'as-is', without any express or implied          *
 * warranty. In no event will the authors be held liable for any damages      *
 * arising from the use of this software.                                     *
 *                                                                            *
 * Permission is granted to anyone to use this software for  any purpose,     *
 * including commercial applications, and to alter it and redistribute it     *
 * freely, subject to the following restrictions:                             *
 *                                                                            *
 * 1. The origin of this software must not be misrepresented; you must not    *
 *    claim that you wrote the original software. If you use this software    *
 *    in a product, an acknowledgment in the product documentation would be   *
 *    appreciated but is not required.                                        *
 * 2. Altered source versions must be plainly marked as such, and must not be *
 *    misrepresented as being the original software.                          *
 * 3. This notice may not be removed or altered from any source distribution. *
\*============================================================================*/

#include <a_samp>
#tryinclude "../include/streamer.inc"
#if !defined Streamer_IncludeFileVersion
	#include <streamer>
#endif
#tryinclude "../include/foreach.inc"
#if !defined foreach
	#tryinclude <foreach>
#endif


#if !defined DC_SPP__FREEZE_TIME
	#define DC_SPP__FREEZE_TIME		500
#endif


static dc_spp__pvar_name[] = !"dc_spp__frozen";


@__dc_spp__unfreeze(playerid);
@__dc_spp__unfreeze(playerid)
{
	if (GetPVarInt(playerid, dc_spp__pvar_name) == 0)
		TogglePlayerControllable(playerid, 1);
	return Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_OBJECT, 1);
}


stock SetPlayerPosEx(
	playerid, Float:x, Float:y, Float:z, interior = -1, world = -1,
	bool:tpcar = true, bool:nopassengers = false, time = DC_SPP__FREEZE_TIME)
{
	if (Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_OBJECT, 0) == 0)
		return 0;
	TogglePlayerControllable(playerid, 0);
	SetTimerEx(!"@__dc_spp__unfreeze", time, 0, !"d", playerid);
	Streamer_UpdateEx(playerid, x, y, z, world, interior);
	if (tpcar == false || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		if (interior != -1)
			SetPlayerInterior(playerid, interior);
		if (world != -1)
			SetPlayerVirtualWorld(playerid, world);
		SetPlayerPos(playerid, x, y, z);
		return SetCameraBehindPlayer(playerid);
	}
	static veh;
	static Float:px, Float:py, Float:pz;
	veh = GetPlayerVehicleID(playerid);
	if (nopassengers)
	{
		GetVehiclePos(veh, px, py, pz);
		pz = pz + 1.0;
	}
	SetVehiclePos(veh, x, y, z);
	if (interior != -1)
		LinkVehicleToInterior(veh, interior);
	if (world != -1)
		SetVehicleVirtualWorld(veh, world);
#if defined foreach
	foreach(new i:Player)
#else
	static i;
	for (i = GetPlayerPoolSize() + 1; --i >= 0; )
#endif
	{
		if (GetPlayerVehicleID(i) != veh)
			continue;
		if (nopassengers && i != playerid)
		{
			SetPlayerPos(i, px, py, pz);
			continue;
		}
		if (interior != -1)
			SetPlayerInterior(i, interior);
		if (world != -1)
			SetPlayerVirtualWorld(i, world);
		SetCameraBehindPlayer(i);
	}
	return 1;
}


stock dc_spp__TogglePlayerControllabl(playerid, toggle)
{
	static level;
	level = GetPVarInt(playerid, dc_spp__pvar_name) + (1 - _:!!toggle * 2);
	SetPVarInt(playerid, dc_spp__pvar_name, (level < 0) ? 0 : level);
	return TogglePlayerControllable(playerid, toggle);
}
#if defined _ALS_TogglePlayerControllable
	#undef TogglePlayerControllable
#else
	#define _ALS_TogglePlayerControllable
#endif
#define TogglePlayerControllable dc_spp__TogglePlayerControllabl

public OnPlayerConnect(playerid)
{
#if defined dc_spp__OnPlayerConnect
	dc_spp__OnPlayerConnect(playerid);
#endif
	return 1;
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect dc_spp__OnPlayerConnect
#if defined dc_spp__OnPlayerConnect
	forward dc_spp__OnPlayerConnect(playerid);
#endif
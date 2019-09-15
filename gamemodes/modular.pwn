#include <a_samp>
#include <a_mysql>
#include <easyDialog>

native WP_Hash(buffer[], len, const str[]); //This is a Whirlpool function, we will need that to store the passwords.

new
	PlayerName[MAX_PLAYERS][30], // We will use this to store player's name
	PlayerIP[MAX_PLAYERS][17]	// We will use this to store a player's IP Address
;

#include "defines/connection.pwn"
#include "defines/color.pwn"
#include "defines/version.pwn"

#include "core/mysql.pwn"
#include "core/account.pwn"
#include "core/register.pwn"
#include "core/login.pwn"
#include "core/update.pwn"

main()
{

}

public OnGameModeInit() {
	SetGameModeText(SERVER_VERSION);
	print("Preparing the gamemode, please wait...");
	MySQLInit();
	return 1;
}

public OnGameModeExit() {
	print("Exiting the gamemode, please wait...");
	MySQLExit();
	return 1;
}

public OnPlayerConnect(playerid)
{
	new query[140];
	GetPlayerName(playerid, PlayerName[playerid], 30); // This will get the player's name
	GetPlayerIp(playerid, PlayerIP[playerid], 16); // This will get the player's IP Address
	mysql_format(gSQL, query, sizeof(query), "SELECT `Password`, `ID` FROM `users` WHERE `Username` = '%e' LIMIT 1", PlayerName[playerid]); // We are selecting the password and the ID from the player's name
	mysql_tquery(gSQL, query, "CheckPlayer", "i", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SavePlayer(playerid);
	return 1;
}

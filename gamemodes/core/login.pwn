Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Kick(playerid); // If the player has pressed exit, kick them.
	new password[129], query[100];
	WP_Hash(password, 129, inputtext); // We're going to hash the password the player has written in the login dialog
	if(!strcmp(password, PlayerInfo[playerid][Password])) // This will check if the password we used to register with matches
	{ // If it matches
		mysql_format(gSQL, query, sizeof(query), "SELECT * FROM `users` WHERE `Username` = '%e' LIMIT 0, 1", PlayerName[playerid]);
		mysql_tquery(gSQL, query, "LoadPlayer", "i", playerid); //Let's call LoadPlayer.
	}
	else // If the password doesn't match.
	{
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "{FF0000}Wrong Password!\n{FFFFFF}Type your correct password below to continue and sign in to your account", "Login", "Exit");
		// We will show this dialog to the player and tell them they have wrote an incorrect password.
	}
	return 1;
}

stock LoadPlayer(playerid)
{
	cache_get_value_name_int(0, "Cash", PlayerInfo[playerid][Cash]);
	cache_get_value_name_int(0, "Kills", PlayerInfo[playerid][Kills]);
	cache_get_value_name_int(0, "Deaths", PlayerInfo[playerid][Deaths]);
	GivePlayerMoney(playerid, PlayerInfo[playerid][Cash]); //Load the player's cash and give it to them.
	return 1;
}
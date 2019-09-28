#include <YSI_Coding\y_hooks>

forward OnPlayerDataLoad(playerid);
forward OnPlayerDataCheck(playerid);
forward OnPlayerRegister(playerid);

hook OnPlayerConnect(playerid)
{
	new query[140];
	GetPlayerName(playerid, PlayerName[playerid], 30); // This will get the player's name
	GetPlayerIp(playerid, PlayerIP[playerid], 16); // This will get the player's IP Address
	mysql_format(gSQL, query, sizeof(query), "SELECT `Password`, `ID` FROM `users` WHERE `Username` = '%e' LIMIT 1", PlayerName[playerid]); // We are selecting the password and the ID from the player's name
	mysql_tquery(gSQL, query, "OnPlayerDataCheck", "i", playerid);
	return 1;
}

public OnPlayerDataLoad(playerid)
{
	cache_get_value_name_int(0, "Cash", PlayerInfo[playerid][Cash]);
	cache_get_value_name_int(0, "Kills", PlayerInfo[playerid][Kills]);
	cache_get_value_name_int(0, "Deaths", PlayerInfo[playerid][Deaths]);
	GivePlayerMoney(playerid, PlayerInfo[playerid][Cash]);
	return 1;
}

public OnPlayerDataCheck(playerid)
{
	new rows, string[150];
	cache_get_row_count(rows);
	if(rows) // If row exists
	{
		cache_get_value_name(0, "Password", PlayerInfo[playerid][Password], 129); // Load the player's password
		cache_get_value_name_int(0, "ID", PlayerInfo[playerid][ID]); // Load the player's ID.
		format(string, sizeof(string), "Welcome back to the server.\nPlease type your password below to login to your account."); // A dialog will pop up telling the player to write they password below to login.
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", string, "Login", "Exit");
	}
	else // If there are no rows, we need to show the register dialog!
	{
		format(string, sizeof(string), "Welcome to our server.\nIf you want to play here, you must register an account. Type a strong password below to register."); // A dialog with this note will pop up telling the player to register his acocunt.
		Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", string, "Register", "Exit");
	}
	return 1;
}

public OnPlayerRegister(playerid)
{
	PlayerInfo[playerid][ID] = cache_insert_id();
	printf("A new account with the id of %d has been registered!", PlayerInfo[playerid][ID]); // You can remove this if you want, I just used it to debug.
	return 1;
}

Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Kick(playerid); // If the player has pressed exit, kick them.
	new password[129], query[100];
	WP_Hash(password, 129, inputtext); // We're going to hash the password the player has written in the login dialog
	if(!strcmp(password, PlayerInfo[playerid][Password])) // This will check if the password we used to register with matches
	{ // If it matches
		mysql_format(gSQL, query, sizeof(query), "SELECT * FROM `users` WHERE `Username` = '%e' LIMIT 0, 1", PlayerName[playerid]);
		mysql_tquery(gSQL, query, "OnPlayerDataLoad", "i", playerid); //Let's call LoadPlayer.
	}
	else // If the password doesn't match.
	{
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "{FF0000}Wrong Password!\n{FFFFFF}Type your correct password below to continue and sign in to your account", "Login", "Exit");
		// We will show this dialog to the player and tell them they have wrote an incorrect password.
	}
	return 1;
}

Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Kick(playerid);
	if(strlen(inputtext) < 3) return Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "{FF0000}Short Password!\n{FFFFFF}Type a 3+ characters password if you want to register and play on this server", "Register", "Exit");
	//If the password is less than 3 characters, show them a dialog telling them to input a 3+ characters password
	new query[300];
	WP_Hash(PlayerInfo[playerid][Password], 129, inputtext); // Hash the password the player has wrote to the register dialog using Whirlpool.
	mysql_format(gSQL, query, sizeof(query), "INSERT INTO `users` (`Username`, `Password`, `IP`, `Cash`, `Kills`, `Deaths`) VALUES ('%e', '%e', '%e', 0, 0, 0)", PlayerName[playerid], PlayerInfo[playerid][Password], PlayerIP[playerid]);
	// Insert player's information into the MySQL database so we can load it later.
	mysql_pquery(gSQL, query, "OnPlayerRegister", "i", playerid); // We'll call this as soon as the player successfully registers.

	format(query, sizeof(query), "Welcome back to the server.\nPlease type your password below to login to your account."); // A dialog will pop up telling the player to write they password below to login.
	Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", query, "Login", "Exit");
	return 1;
}
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
	mysql_pquery(gSQL, query, "RegisterPlayer", "i", playerid); // We'll call this as soon as the player successfully registers.
	return 1;
}

stock CheckPlayer(playerid)
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

stock RegisterPlayer(playerid)
{
	PlayerInfo[playerid][ID] = cache_insert_id();
	printf("A new account with the id of %d has been registered!", PlayerInfo[playerid][ID]); // You can remove this if you want, I just used it to debug.
	return 1;
}
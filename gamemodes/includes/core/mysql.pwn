new
	MySQL: gSQL;

MySQLInit() {
    new MySQLOpt: option_id = mysql_init_options();
	mysql_set_option(option_id, AUTO_RECONNECT, true); // it automatically reconnects when loosing connection to mysql server
	gSQL = mysql_connect(MYSQL_HOSTNAME, MYSQL_USERNAME, MYSQL_PASSWORD, MYSQL_DATABASE, option_id); // AUTO_RECONNECT is enabled for this connection handle only
	if (gSQL == MYSQL_INVALID_HANDLE || mysql_errno(gSQL) != 0)
	{
		print("MySQL connection failed. Server is shutting down."); // Read below
		SendRconCommand("exit"); // close the server if there is no connection
		return 1;
	}
	print("MySQL connection is successful."); // If the MySQL connection was successful, we'll print a debug!
    return 1;
}

MySQLExit()
{
	mysql_close(gSQL);
	return 1;
}
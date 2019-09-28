#include <a_samp>
#include <a_mysql>
#include <easyDialog>

native WP_Hash(buffer[], len, const str[]);

// defines
#include "includes/defines.pwn"

// includes
#include "includes/enums.pwn"
#include "includes/variable.pwn"

// core
#include "includes/core/mysql.pwn"
#include "includes/core/connect.pwn"
#include "includes/core/update.pwn"
#include "includes/core/spawn.pwn"

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

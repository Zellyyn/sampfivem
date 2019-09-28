#include <YSI_Coding\y_hooks>

hook OnPlayerSpawn(playerid) {
    SendClientMessage(playerid, COLOR_WHITE, "OnPlayerSpawn was called...");
    return 1;
}
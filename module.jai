SERVER_PORT :: 7777;
MAX_CLIENTS :: 8;

#import "Hash_Table";
#import "game_logic";


register_client_server_structs :: () {
    add_type(*types, Coop_Client_Update);
    add_type(*types, Infrequent_Client_Update);

    add_type(*types, Coop_Game_Update);
    add_type(*types, Infrequent_Coop_Game_Update);
}

Game_Mode :: enum {
    COOP;
    TEAMS;
    FREE_FOR_ALL;
}


Client_Update :: struct {
    mouse_grid_space_x : float32;
    mouse_grid_space_y : float32;

    open_cell_pressed : bool;
    open_all_adjacent_cells_pressed : bool;

    flag_cell_pressed : bool;
    flag_all_adjacent_cells_pressed : bool;
}

// this shouldn't exist here, but instead in the coordinator program that creates rooms.

Create_Room_Request :: struct {
    // extract this part out.
    max_players:  s32 = 4;
    game_mode:    Game_Mode;
    is_private:   bool = false;
    password:     [256] u8;
    password_len: s32 = 0;
}

Game_Setup :: struct {
    board_width:       s32 = 16;
    board_height:      s32 = 16;
    mine_percentage:   float32 = 20.0;
    no_guess_solvable: bool = false;
    timed:             bool = false;
    best_of_n:         s32 = 3;
}


Coop_Client_Update :: struct {
    using ci : Client_Update;
}


Infrequent_Client_Update :: struct {
    messages : [..] string;
}

Infrequent_Coop_Client_Update :: struct {
    using icu : Infrequent_Client_Update;
}

Player :: struct {
    mouse_grid_space_x : float32;
    mouse_grid_space_y : float32;
}

// this is probably what gets sent over when all players are ready, and the server sets up the thing
// then a countdown occurs and when it reaches zero then the server sends out the game states.
// and the game begins.
Coop_Game_Settings :: struct { // or Configure_Coop_Game?
    board_width:       s32 = 16;
    board_height:      s32 = 16;
    mine_percentage:   float32 = 20.0;
    no_guess_solvable: bool = false;
    timed:             bool = false;
    best_of_n:         s32 = 3;
}

Coop_Player :: struct {
    using #as ps : Player;
}

Coop_Configuration :: struct {
    board_width:       s32 = 16;
    board_height:      s32 = 16;
    mine_percentage:   float32 = 20.0;
    no_guess_solvable: bool = false;
}

Pregenerated_Board :: struct {
    width : s32;
    height : s32;
    safe_start_row : s32 = -1;
    safe_start_col : s32 = -1;
    cells : [..] Cell;
}


Coop_Game_Update :: struct {
    // we have to send this to update the mines that have been flagged or opened by other characters
    board : [..] Cell_State;
    client_id_to_player : Table(u32, Coop_Player);
}


Infrequent_Coop_Player :: struct {
    ready : bool;
    ping : u32;
}

Infrequent_Coop_Game_Update :: struct {
    client_id_to_player : Table(u32, Infrequent_Coop_Player);
}


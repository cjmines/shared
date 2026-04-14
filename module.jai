SERVER_PORT :: 7777;
MAX_CLIENTS :: 8;

#import "Hash_Table";
#import "game_logic";
#import "directory_packets";

#import "tbx/serialize";

register_client_server_structs :: () {
    add_type(*types, Coop_Client_Update);
    add_type(*types, Infrequent_Coop_Client_Update);

    add_type(*types, Coop_Game_Update);
    add_type(*types, Infrequent_Coop_Game_Update);

    add_type(*types, Client_Id_Response);

    add_type(*types, Pregenerated_Board);
}


Client_Update :: struct {
    mouse_grid_space_x : float32;
    mouse_grid_space_y : float32;

    open_cell_pressed : bool;

    flag_cell_pressed : bool;
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
    mine_count : s32;
    mine_percentage:   float32 = 20.0;
    no_guess_solvable: bool = false;
    timed:             bool = false;
    best_of_n:         s32 = 3;
}


Coop_Game_State :: enum {
    READY_UP;
    PRE_GAME; // 3 2 1 type thing.
    LIVE;
    WON;
    LOST;
}

Coop_Client_Update :: struct {
    using ci : Client_Update;
}

Client_Id_Response :: struct {
    client_id : u32;
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
    cell_states : [..] Cell_State;
    client_id_to_player : Table(u32, Coop_Player);
}


Infrequent_Coop_Player :: struct {
    username : string;
    initials : string;
    ready : bool;
    ping : u32;
}

Infrequent_Coop_Game_Update :: struct {
    game_state : Coop_Game_State;
    client_id_to_player : Table(u32, Infrequent_Coop_Player);
}


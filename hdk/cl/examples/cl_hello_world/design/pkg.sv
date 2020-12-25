package pkg ;

parameter OPC_SZ = 3;
parameter ID_SZ = 28;
parameter BUD_WID = 32;
parameter BRAM_DEP = 512;

typedef enum logic [2:0] {DEL = 0, ADD = 1, SET = 2, RDC = 3, SWP = 4, MSC = 7} opcode;
typedef enum logic [1:0] {EMPTY = 0, UNIT = 1, MULTI = 2, HEAD = 3} upstate;

endpackage
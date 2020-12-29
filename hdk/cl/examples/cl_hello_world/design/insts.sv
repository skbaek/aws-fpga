parameter SND_LEN = 15;

opcode opcs[SND_LEN-1:0];
logic modes[SND_LEN-1:0];
logic [ID_SZ-1:0] ids[SND_LEN-1:0];

assign opcs[0] = ADD;
assign modes[0] = 1;
assign ids[0] = 1;
assign opcs[1] = ADD;
assign modes[1] = 1;
assign ids[1] = 1;
assign opcs[2] = ADD;
assign modes[2] = 1;
assign ids[2] = 2;
assign opcs[3] = ADD;
assign modes[3] = 1;
assign ids[3] = 3;
assign opcs[4] = SET;
assign modes[4] = 0;
assign ids[4] = 1;
assign opcs[5] = SET;
assign modes[5] = 0;
assign ids[5] = 2;
assign opcs[6] = MSC;
assign modes[6] = 0;
assign ids[6] = 3;
assign opcs[7] = DEL;
assign modes[7] = 0;
assign ids[7] = 1;
assign opcs[8] = ADD;
assign modes[8] = 1;
assign ids[8] = 7;
assign opcs[9] = ADD;
assign modes[9] = 0;
assign ids[9] = 1;
assign opcs[10] = ADD;
assign modes[10] = 0;
assign ids[10] = 9;
assign opcs[11] = MSC;
assign modes[11] = 0;
assign ids[11] = 2;
assign opcs[12] = RDC;
assign modes[12] = 0;
assign ids[12] = 5;
assign opcs[13] = RDC;
assign modes[13] = 0;
assign ids[13] = 7;
assign opcs[14] = SET;
assign modes[14] = 1;
assign ids[14] = 9;

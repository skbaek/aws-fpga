
import pkg::*;

module snode (
  input  clk,
  input  rst,

  input  bgn_in,
  output fns_out,
  input  opcode opc_in,
  input  mode_in,
  input  [27:0] id_in,

  output bgn_out,
  input  fns_in,
  output opcode opc_out,
  output mode_out,
  output [27:0] id_out
);

// Extensions
localparam [27:0] FLL = 0; 
localparam [27:0] UNF = 1; 
localparam [27:0] ERR = 2; 

logic fns_snd;
logic bgn_snd;
opcode opc_snd;
logic mode_snd;
logic [27:0] id_snd;
opcode opc_buf;
logic mode_buf;
logic [27:0] id_buf;
upstate up; 
logic [27:0] cla;
logic [2:0] signs;
logic [2:0] live;
logic [27:0] abs[2:0];

wire [2:0] holds_abs;
wire [2:0] vacant;
wire [2:0] falsified;
wire [2:0] falsified_now;
wire upstream_empty;
wire upstream_unit;
wire local_empty;
wire local_pair;
wire local_unit;
wire buffer_full;

assign holds_abs[0] = |abs[0];
assign holds_abs[1] = |abs[1];
assign holds_abs[2] = |abs[2];
assign vacant = ~(holds_abs | signs); 
assign falsified[0] = (mode_in!= signs[0] && id_in == abs[0]);
assign falsified[1] = (mode_in!= signs[1] && id_in == abs[1]);
assign falsified[2] = (mode_in!= signs[2] && id_in == abs[2]);
assign falsified_now = live & falsified;
assign upstream_empty = (up == EMPTY || up == HEAD);
assign upstream_unit = (up == UNIT);
assign local_empty = (live == 0);
assign local_pair = (live == 3'b011 || live == 3'b101 || live == 3'b110);
assign local_unit = (live == 3'b001 || live == 3'b010 || live == 3'b100);
assign fns_out = fns_snd;
assign bgn_out = bgn_snd;
assign opc_out = opc_snd;
assign mode_out = mode_snd;
assign id_out = id_snd;
assign buffer_full = (|opc_buf) || id_buf || (|id_buf);

always @(posedge clk)
  if (fns_in) begin
    bgn_snd <= 0;
  end

always @(posedge clk)
  if (fns_out) begin
    fns_snd <= 0;
  end

always @(posedge clk)
  if (rst) begin 
    fns_snd <= 0;
    bgn_snd <= 0;
    opc_snd <= DEL;
    mode_snd <= 0;
    id_snd <= 0;
    opc_buf <= DEL;
    mode_buf <= 0;
    id_buf <= 0;
    up <= EMPTY;
    cla <= 0;
    signs <= 0;
    live <= 0;
    abs[0] <= 0;
    abs[1] <= 0;
    abs[2] <= 0;
  end else if (bgn_snd) begin
    // Do nothing if bgn_snd, since the send value should 
    // persist until the downstream node has consumed it
  end else if (buffer_full) begin
    opc_snd <= opc_buf;
    mode_snd <= mode_buf;
    id_snd <= id_buf;
    opc_buf <= DEL;
    mode_buf <= 0;
    id_buf <= 0;
    bgn_snd <= 1;
  end else if (fns_out) begin
    if (opc_in == DEL && id_in == cla) begin
      up <= EMPTY;
      cla <= 0;
      signs <= 0;
      live <= 0;
      abs[0] <= 0;
      abs[1] <= 0;
      abs[2] <= 0;
      opc_snd <= opc_in;
      mode_snd <= mode_in;
      id_snd <= id_in;
      bgn_snd <= 1;
    end else if (opc_in == SET) begin
      live <= live & (~falsified);
      if ((|falsified_now) && ((local_pair && upstream_empty) || (local_unit && upstream_unit))) begin
        opc_buf <= RDC;
        mode_buf <= 1;
        id_buf <= cla;
      end else if ((|falsified_now) && ((local_unit && upstream_empty) || (local_empty && upstream_unit))) begin
        opc_buf <= RDC;
        mode_buf <= 0;
        id_buf <= cla;
      end
      opc_snd <= opc_in;
      mode_snd <= mode_in;
      id_snd <= id_in;
      bgn_snd <= 1;
    end else if (opc_in == ADD && cla == 0) begin
      cla <= id_in;
      if (mode_in == 1) begin
        up <= HEAD;
      end else begin
        up <= MULTI;
      end
    end else if (opc_in == ADD && cla != 0 && vacant[0]) begin
      signs[0] <= mode_in;
      live[0] <= 1; 
      abs[0] <= id_in;
    end else if (opc_in == ADD && cla != 0 && !vacant[0] && vacant[1]) begin
      signs[1] <= mode_in;
      live[1] <= 1; 
      abs[1] <= id_in;
    end else if (opc_in == ADD && cla != 0 && !vacant[0] && !vacant[1] && vacant[2]) begin
      signs[2] <= mode_in;
      live[2] <= 1; 
      abs[2] <= id_in;
    end else if (opc_in == RDC && mode_in == 0 && id_in == cla) begin
      up <= EMPTY; 
      if (local_unit) begin
        opc_snd <= RDC;
        mode_snd <= 1;
        id_snd <= cla;
        bgn_snd <= 1;
      end else if (local_empty) begin
        opc_snd <= RDC;
        mode_snd <= 0;
        id_snd <= cla;
        bgn_snd <= 1;
      end 
    end else if (opc_in == RDC && mode_in == 1 && id_in == cla) begin
      up <= UNIT; 
      if (local_empty) begin
        opc_snd <= RDC;
        mode_snd <= 1;
        id_snd <= cla;
        bgn_snd <= 1;
      end 
    end else if (opc_in == MSC && id_in == UNF) begin
      if (up != HEAD) begin
        up <= MULTI;
      end  
      live <= holds_abs;
      opc_snd <= opc_in;
      mode_snd <= mode_in;
      id_snd <= id_in;
      bgn_snd <= 1;
    end else if (opc_in == MSC && id_in == FLL) begin
      if (vacant[2]) begin
        signs[2] <= 1;
        if (vacant[1]) begin
          signs[1] <= 1;
        end  
      end else begin  
        opc_snd <= opc_in;
        mode_snd <= mode_in;
        id_snd <= id_in;
        bgn_snd <= 1;
      end
    end else begin
      opc_snd <= opc_in;
      mode_snd <= mode_in;
      id_snd <= id_in;
      bgn_snd <= 1;
    end
  end else if (bgn_in) begin
    fns_snd <= 1;
  end

endmodule
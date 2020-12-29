import pkg::*;

module snode (
  input  clk,
  input  rst,

  input  wrm,
  output wrs,
  input  opcode wop,
  input  wmo,
  input  [27:0] wid,

  output rrs,
  input  rrm,
  output opcode rop,
  output rmo,
  output [27:0] rid
);

logic wrsl;
logic rrsl;
opcode ropl[1:0];
logic rmol[1:0];
logic [27:0] ridl[1:0];
upstate up; 
logic [27:0] cla;
logic [2:0] signs;
logic [2:0] live;
logic [27:0] abs[2:0];

assign wrs = wrsl;
assign rrs = rrsl;
assign rop = ropl[0];
assign rmo = rmol[0];
assign rid = ridl[0];

always @(posedge clk)
  if (rst) begin 
    wrsl <= 0;
    rrsl <= 0;
    ropl[1] <= DEL;
    ropl[0] <= DEL;
    rmol[1] <= 0;
    rmol[0] <= 0;
    ridl[1] <= 0;
    ridl[0] <= 0;
    up <= EMPTY;
    cla <= 0;
    signs <= 0;
    live <= 0;
    abs[0] <= 0;
    abs[1] <= 0;
    abs[2] <= 0;
  end 

wire [2:0] occupied;
wire [2:0] vacant;
wire [2:0] falsified;
wire [2:0] falsified_now;
wire upstream_empty;
wire upstream_unit;
wire local_empty;
wire local_pair;
wire local_unit;
wire global_pair;
wire global_unit;

assign occupied[0] = |abs[0];
assign occupied[1] = |abs[1];
assign occupied[2] = |abs[2];
assign vacant = ~(occupied | signs); 
assign falsified[0] = (wmo != signs[0] && wid == abs[0]);
assign falsified[1] = (wmo != signs[1] && wid == abs[1]);
assign falsified[2] = (wmo != signs[2] && wid == abs[2]);
assign falsified_now = live & falsified;
assign upstream_empty = (up == EMPTY || up == HEAD);
assign upstream_unit = (up == UNIT);
assign local_empty = (live == 0);
assign local_pair = (live == 3'b011 || live == 3'b101 || live == 3'b110);
assign local_unit = (live == 3'b001 || live == 3'b010 || live == 3'b100);
assign global_pair = (local_pair && upstream_empty) || (local_unit && upstream_unit);
assign global_unit = (local_unit && upstream_empty) || (local_empty && upstream_unit);

always @(posedge clk)
  if (!rst && rrm && rrs) begin
    ropl[0] <= ropl[1];
    ropl[1] <= DEL;
    rmol[0] <= rmol[1];
    rmol[1] <= 0;
    ridl[0] <= ridl[1];
    ridl[1] <= 0;
    if (ropl[1] != DEL || rmol[1] || (|ridl[1])) begin
      rrsl <= 1;
    end else begin
      rrsl <= 0;
      wrsl <= 1;
    end
  end

always @(posedge clk)
  if (!rst && !rrs && !wrs) begin
    wrsl <= 1;
  end

always @(posedge clk)
  if (!rst && wrm && wrs) begin

    // ADD, RDC, and MSC packets are special in that a node may 'consume' them on spot
    // and not send a copy of the packet downstream. This includes the possibility that 
    // the consuming node will send nothing at all, and will be immediately ready for a 
    // write operation at the next clock cycle. Therefore, the write-ready signals and
    // read values for ADD, RDC, and MSC packets should be handled in their respective 
    // case blocks. For all other packes, we can simply load a copy of the incoming 
    // packet for read value and turn off the write ready signal. 
    if (wop != ADD && wop != RDC && wop != MSC) begin
      ropl[0] <= wop;
      rmol[0] <= wmo;
      ridl[0] <= wid;
      wrsl <= 0;
      rrsl <= 1;
    end

    case (wop)

      DEL: begin
        up <= EMPTY;
        cla <= 0;
        signs <= 0;
        live <= 0;
        abs[0] <= 0;
        abs[1] <= 0;
        abs[2] <= 0;
      end

      ADD: begin
        if (cla == 0) begin
          cla <= wid;
          if (wmo == 1) begin
            up <= HEAD;
          end else begin
            up <= MULTI;
          end
        end else if (vacant[0]) begin
          signs[0] <= wmo;
          live[0] <= 1; 
          abs[0] <= wid;
        end else if (vacant[1]) begin
          signs[1] <= wmo;
          live[1] <= 1; 
          abs[1] <= wid;
        end else if (vacant[2]) begin
          signs[2] <= wmo;
          live[2] <= 1; 
          abs[2] <= wid;
        end else begin
          ropl[0] <= wop;
          rmol[0] <= wmo;
          ridl[0] <= wid;
          wrsl <= 0;
          rrsl <= 1;
        end
      end 

      SET: begin 
        live <= live & (~falsified);
        if ((|falsified_now) && global_pair) begin
          ropl[1] <= RDC;
          rmol[1] <= 1;
          ridl[1] <= cla;
        end else if ((|falsified_now) && global_unit) begin
          ropl[1] <= RDC;
          rmol[1] <= 0;
          ridl[1] <= cla;
        end
      end

      RDC: begin 
        // If a node receives an RDC packet for the current clause but 
        // the current clause is HEAD, it will assume that the latter is
        // incorrect and update the upstream status anyway. But this 
        // edge case should never occur in a correct implementation.
        if (wid == cla) begin
          // If upstream is unit
          if (wmo) begin
            up <= UNIT; 
            if (local_empty) begin
              ropl[0] <= RDC;
              rmol[0] <= 1;
              ridl[0] <= cla;
              wrsl <= 0;
              rrsl <= 1;
            end
          // If upstream is empty
          end else begin
            up <= EMPTY; 
            if (local_unit) begin
              ropl[0] <= RDC;
              rmol[0] <= 1;
              ridl[0] <= cla;
              wrsl <= 0;
              rrsl <= 1;
            end else if (local_empty) begin
              ropl[0] <= RDC;
              rmol[0] <= 0;
              ridl[0] <= cla;
              wrsl <= 0;
              rrsl <= 1;
            end 
          end
        end
      end

      MSC: begin 
        if (wid == FLL) begin
          if (vacant[2]) signs[2] <= 1;
          if (vacant[1]) signs[1] <= 1;
        end 
        if (wid == UNF) begin
          if (up != HEAD) up <= MULTI;
          live <= occupied;
          ropl[0] <= wop;
          rmol[0] <= wmo;
          ridl[0] <= wid;
          wrsl <= 0;
          rrsl <= 1;
        end
      end

    endcase
  end

endmodule
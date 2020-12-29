import pkg::*;

module writer 
(
  input  clk,
  input  rst,
  output wrm,
  input  wrs,
  output opcode wop,
  output wmo,
  output [ID_SZ-1:0] wid
);

`include "insts.sv"

reg wrml;
opcode wopl;
reg wmol;
reg [ID_SZ-1:0] widl;
reg [15:0] ctr;

assign wrm = wrml;
assign wop = wopl;
assign wmo = wmol;
assign wid = widl;

always @(posedge clk)
  if (rst) begin
    wopl <= DEL;
    wmol <= 0;
    widl <= 0;
    ctr <= 0;
    wrml <= 0;
  end 
  
always @(posedge clk)
  if (!rst && ctr == 0) begin
    ctr <= 1;
    wopl <= opcs[0];
    wmol <= modes[0];
    widl <= ids[0];
    wrml <= 1;
  end

always @(posedge clk)
  if (!rst && wrm && wrs) begin
    if (ctr < SND_LEN) begin
      ctr <= ctr + 1;
      wopl <= opcs[ctr];
      wmol <= modes[ctr];
      widl <= ids[ctr];
    end else begin
      wopl <= DEL;
      wmol <= 0;
      widl <= 0;
      wrml <= 0;
    end
  end

endmodule
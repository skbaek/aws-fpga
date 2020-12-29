
import pkg::*;

module snode_tb();
  
  logic clk;
  logic rst;

  logic wrm;
  logic wrs;
  opcode wop;
  logic wmo;
  logic [ID_SZ-1:0] wid;

  logic rrm;
  logic rrs;
  opcode rop;
  logic rmo;
  logic [ID_SZ-1:0] rid;

  snode DUT (
    .clk(clk),
    .rst(rst),

    .wrm(wrm),
    .wrs(wrs),
    .wop(wop),
    .wmo(wmo),
    .wid(wid),

    .rrm(rrm),
    .rrs(rrs),
    .rop(rop),
    .rmo(rmo),
    .rid(rid)
  );

  writer wtr (
    .clk(clk),
    .rst(rst),
    .wrm(wrm),
    .wrs(wrs),
    .wop(wop),
    .wmo(wmo),
    .wid(wid)
  );

  reader rdr (
    .clk(clk),
    .rst(rst),
    .rrm(rrm),
    .rrs(rrs)
  );

always 
  #10 
  clk =~ clk;

initial begin
clk = 1;
rst = 1;
#20
rst = 0;
#1250
$finish;
end
 
endmodule
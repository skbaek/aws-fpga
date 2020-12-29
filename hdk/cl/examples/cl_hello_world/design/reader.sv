module reader (
  input clk,
  input rst,
  input rrs,
  output rrm
);

reg rrml;

assign rrm = rrml;

always @(posedge clk)
  if (rst || rrm) begin
    rrml <= 0;
  end else if (rrs) begin
    rrml <= 1;
  end

endmodule

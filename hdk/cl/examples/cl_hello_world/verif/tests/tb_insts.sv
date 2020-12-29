tb.poke(.addr(`DEFAULT_REG_ADDR), .data(32'b00110000000000000000000000000001), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
tb.poke(.addr(`DEFAULT_REG_ADDR), .data(32'b00110000000000000000000000000001), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
tb.poke(.addr(`DEFAULT_REG_ADDR), .data(32'b00110000000000000000000000000010), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
tb.poke(.addr(`DEFAULT_REG_ADDR), .data(32'b00110000000000000000000000000011), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
tb.peek(.addr(`DEFAULT_REG_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
if (rdata == 32'b11100000000000000000000000000000) $display ("TEST PASSED"); else $error ("TEST FAILED, expected = 11100000000000000000000000000000, found = %x", rdata);
tb.poke(.addr(`DEFAULT_REG_ADDR), .data(32'b01000000000000000000000000000001), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
tb.peek(.addr(`DEFAULT_REG_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
if (rdata == 32'b01000000000000000000000000000001) $display ("TEST PASSED"); else $error ("TEST FAILED, expected = 01000000000000000000000000000001, found = %x", rdata);
tb.poke(.addr(`DEFAULT_REG_ADDR), .data(32'b01000000000000000000000000000010), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
tb.peek(.addr(`DEFAULT_REG_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
if (rdata == 32'b01000000000000000000000000000010) $display ("TEST PASSED"); else $error ("TEST FAILED, expected = 01000000000000000000000000000010, found = %x", rdata);
tb.peek(.addr(`DEFAULT_REG_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
if (rdata == 32'b01110000000000000000000000000001) $display ("TEST PASSED"); else $error ("TEST FAILED, expected = 01110000000000000000000000000001, found = %x", rdata);
tb.poke(.addr(`DEFAULT_REG_ADDR), .data(32'b01000000000000000000000000000011), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
tb.peek(.addr(`DEFAULT_REG_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
if (rdata == 32'b01000000000000000000000000000011) $display ("TEST PASSED"); else $error ("TEST FAILED, expected = 01000000000000000000000000000011, found = %x", rdata);
tb.peek(.addr(`DEFAULT_REG_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
if (rdata == 32'b01100000000000000000000000000001) $display ("TEST PASSED"); else $error ("TEST FAILED, expected = 01100000000000000000000000000001, found = %x", rdata);
tb.peek(.addr(`DEFAULT_REG_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); #20
if (rdata == 32'b11100000000000000000000000000000) $display ("TEST PASSED"); else $error ("TEST FAILED, expected = 11100000000000000000000000000000, found = %x", rdata);

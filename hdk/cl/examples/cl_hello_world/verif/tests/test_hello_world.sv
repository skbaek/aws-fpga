// Amazon FPGA Hardware Development Kit
//
// Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License"). You may not use
// this file except in compliance with the License. A copy of the License is
// located at
//
//    http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
// implied. See the License for the specific language governing permissions and
// limitations under the License.

//------------------------------------------------------------------------------
// Description: This test checks the byte swap feature of the hello_world CL. It also checks
// if the upper word of the CL register is written to Vdip
//-------------------------------------------------------------------------------

module test_hello_world();

import tb_type_defines_pkg::*;
//  `include "cl_common_defines.vh" // CL Defines with register addresses

// AXI ID
parameter [5:0] AXI_ID = 6'h0;

logic [31:0] rdata;
logic [15:0] vdip_value;
logic [15:0] vled_value;


initial begin
  
  tb.power_up();

  `include "tb_insts.sv"

  tb.kernel_reset();
  tb.power_down();
  $finish;
end

endmodule // test_hello_world

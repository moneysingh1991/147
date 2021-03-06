/*
 Name: proj_2_tb.v
 Module: DA_VINCI_TB

 Monitors:  DATA_W  : Data to be written at address ADDR_W
           . ADDR_W  : Address of the memory location to be written
           . ADDR_R1 : Address of the memory location to be read for DATA_R1
           . ADDR_R2 : Address of the memory location to be read for DATA_R2
           . READ    : Read signal
           . WRITE   : Write signal

 Input:  CLK     : Clock signal
         RST     : Reset signal
         DATA_R1 : Data at ADDR_R1 address
         DATA_R2 : Data at ADDR_R1 address

 Notes: - Testbench for register system

 Revision History:

 Version	Date		Who		email			note
------------------------------------------------------------------------------------------
  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
  2.0     Oct 29, 2014  David Thorpe    DE.Thorpe@gmail.com     Met output goals for DaVinci_TB
------------------------------------------------------------------------------------------
Write a testbench similar to memory (do not need to load the RF externally though like
the memory testing). Just write some data in all the register location, and read them
back.
*/
`include "prj_definition.v"
module REG_TB;
    // Storage list
    reg [`ADDRESS_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;
    // reset
    reg READ, WRITE, RST;
    // data register
    integer i; // index for memory operation
    integer no_of_test, no_of_pass;
    integer load_data;

    // wire lists
    wire CLK;
    wire [`DATA_INDEX_LIMIT:0] DATA_R1;
    wire [`DATA_INDEX_LIMIT:0] DATA_R2;

    // Clock generator instance
    CLK_GENERATOR clk_gen_inst(.CLK(CLK));

    // 64MB memory instance
    REGISTER_FILE_32x32 reg_inst(.DATA_R1(DATA_R1), .DATA_R2(DATA_R2), .ADDR_R1(ADDR_R1), .ADDR_R2(ADDR_R2),
                     .DATA_W(DATA_W), .ADDR_W(ADDR_W), .READ(READ), .WRITE(WRITE), .CLK(CLK), .RST(RST));

    initial begin
        RST=1'b1;
        READ=1'b0;
        WRITE=1'b0;
        no_of_test = 0;
        no_of_pass = 0;
        load_data = 'h00414020;

        /* Start the operation*/
        #10    RST=1'b0;
        #10    RST=1'b1;
        // Write cycle
        #10   READ=1'b0; WRITE=1'b0;
        #5    no_of_test = no_of_test + 1;
        if (DATA_R1 !== {`DATA_WIDTH{1'bz}})
            $write("[TEST] Read %1b, Write %1b, expecting 32'hzzzzzzzz, got %8h [FAILED]\n", READ, WRITE, DATA);
        else if (DATA_R2 !== {`DATA_WIDTH{1'bz}})
            $write("[TEST] Read %1b, Write %1b, expecting 32'hzzzzzzzz, got %8h [FAILED]\n", READ, WRITE, DATA);
        else 
            no_of_pass  = no_of_pass + 1;

        // test of write data
        for(i=0;i<10; i = i + 1) begin
            #5      READ=1'b1; WRITE=1'b0;
            #5      no_of_test = no_of_test + 1;
            if (DATA_R1 !== i)
                $write("[TEST] Read %1b, Write %1b, expecting %8h, got %8h [FAILED]\n", READ, WRITE, i, DATA_R1);
            else if (DATA_R1 !== i)
                $write("[TEST] Read %1b, Write %1b, expecting %8h, got %8h [FAILED]\n", READ, WRITE, i, DATA_R2);            else 
	        no_of_pass  = no_of_pass + 1;
        end
        $stop;
    end
endmodule


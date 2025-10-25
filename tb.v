//=====================================================
// Testbench for FPGA_Tile
// Vivado 2024.2 compatible
//=====================================================
`timescale 1ns/1ps
module tb_FPGA_Tile;

    reg         clk;
    reg  [3:0]  north_in, south_in, east_in, west_in;
    reg  [23:0] config_bits;
    reg         use_ff;
    wire [3:0]  north_out, south_out, east_out, west_out;

    // DUT
    FPGA_Tile dut (
        .clk(clk),
        .north_in(north_in),
        .south_in(south_in),
        .east_in(east_in),
        .west_in(west_in),
        .config_bits(config_bits),
        .use_ff(use_ff),
        .north_out(north_out),
        .south_out(south_out),
        .east_out(east_out),
        .west_out(west_out)
    );

    //--------------------------------------------------
    // Clock generation: 100 MHz
    //--------------------------------------------------
    initial clk = 1'b0;
    always #5 clk = ~clk;  // 10 ns period

    //--------------------------------------------------
    // Stimulus
    //--------------------------------------------------
    initial begin
        $display("=== Vivado 2024.2 FPGA Tile Simulation ===");

        // Optional dump for GTKWave (ignored by xsim if unsupported)
        if ($test$plusargs("dump")) begin
            $dumpfile("fpga_tile_tb.vcd");
            $dumpvars(0, tb_FPGA_Tile);
        end

        // Init
        north_in = 4'b0000;
        south_in = 4'b0000;
        east_in  = 4'b0000;
        west_in  = 4'b0000;
        use_ff   = 1'b0;
        config_bits = 24'd0;
        #20;

        //--------------------------------------------------
        // Configure Tile
        //--------------------------------------------------
        // Switch Matrix: all outputs ← north_in[0]
        config_bits[7:0] = 8'b00000000;

        // LUT: 4-input AND (only bit[15] = 1)
        config_bits[23:8] = 16'b1000_0000_0000_0000;
        #10;

        //--------------------------------------------------
        // Test combinational mode
        //--------------------------------------------------
        use_ff = 1'b0;
        north_in = 4'b1111;  // Expect output=1
        #20;
        north_in = 4'b1011;  // Expect output=0
        #20;
        north_in = 4'b0111;  // Expect output=0
        #20;
        north_in = 4'b1111;  // Expect output=1
        #20;

        //--------------------------------------------------
        // Test registered mode
        //--------------------------------------------------
        use_ff = 1'b1;
        north_in = 4'b1111;
        #20;
        north_in = 4'b0000;
        #40;

        $display("=== Simulation Done ===");
        $finish;
    end
endmodule

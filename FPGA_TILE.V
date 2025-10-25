//=====================================================
// FPGA_Tile : CLB + SwitchMatrix
// Vivado 2024.2 compatible
//=====================================================
`timescale 1ns/1ps
module FPGA_Tile (
    input  wire        clk,
    input  wire [3:0]  north_in,
    input  wire [3:0]  south_in,
    input  wire [3:0]  east_in,
    input  wire [3:0]  west_in,
    input  wire [23:0] config_bits,  // [23:8] LUT, [7:0] Switch
    input  wire        use_ff,
    output wire [3:0]  north_out,
    output wire [3:0]  south_out,
    output wire [3:0]  east_out,
    output wire [3:0]  west_out
);
    wire [3:0] switch_in;
    wire [3:0] switch_out;
    wire       clb_out;

    assign switch_in = {north_in[0], east_in[0], south_in[0], west_in[0]};

    SwitchMatrix u_switch (
        .in(switch_in),
        .config_bits(config_bits[7:0]),
        .out(switch_out)
    );

    CLB u_clb (
        .clk(clk),
        .in(switch_out),
        .use_ff(use_ff),
        .config_LUT(config_bits[23:8]),
        .out(clb_out)
    );

    // Broadcast CLB output to all four sides
    assign north_out = {4{clb_out}};
    assign south_out = {4{clb_out}};
    assign east_out  = {4{clb_out}};
    assign west_out  = {4{clb_out}};
endmodule

`timescale 1ns/1ps
module SwitchMatrix (
    input  wire [3:0] in,
    input  wire [7:0] config_bits,  // 2 bits per output
    output wire [3:0] out
);
    assign out[0] = in[config_bits[1:0]];
    assign out[1] = in[config_bits[3:2]];
    assign out[2] = in[config_bits[5:4]];
    assign out[3] = in[config_bits[7:6]];
endmodule

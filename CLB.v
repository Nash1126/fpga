module CLB (
    input  wire        clk,
    input  wire        rst,
    input  wire [3:0]  lut_in,
    input  wire [15:0] lut_mem,   // LUT configuration bits
    input  wire        sel_ff,     // 0: combinational, 1: registered
    output wire        clb_out
);

    // LUT implementation
    wire lut_out;
    assign lut_out = lut_mem[lut_in];

    // D Flip-Flop
    reg ff_q;
    always @(posedge clk or posedge rst) begin
        if (rst)
            ff_q <= 1'b0;
        else
            ff_q <= lut_out;
    end

    // Output select
    assign clb_out = sel_ff ? ff_q : lut_out;

endmodule

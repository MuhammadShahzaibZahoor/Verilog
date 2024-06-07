`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2024 01:01:25 AM
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module
(
    input clock,
    input reset,
    
    output hSync, 
    output vSync,
    
    //4 bit color signals
    output[3:0] vgaRed,
    output[3:0] vgaGreen,
    output[3:0] vgaBlue
);

wire clk_out_150M, clk_out_50M;
clk_wiz_0 instance_name
(
    // Clock out ports
    .clk_out_150M(clk_out_150M),     // output clk_out_150M
    .clk_out_50M(clk_out_50M),     // output clk_out_50M
    // Status and control signals
    .reset(reset), // input reset
    .locked(),       // output locked
    // Clock in ports
    .clk_in1(clock)
);      // input clk_in1

wire [9:0] hcount, vcount;
wire blank;

vga_sync_given M00
(
    .clk(clk_out_50M),
    .reset(reset),
    .hsync(hSync),
    .vsync(vSync),
    .hcount(hcount),
    .vcount(vcount),
    .pix_clk(),
    .blank(blank)
);

vga_disc M01
(
    .red(vgaRed),
    .green(vgaGreen),
    .blue(vgaBlue),
    .pos_h(hcount), 
    .pos_v(vcount),
    .blank(blank),
    .clk(clk_out_150M),
    .reset(reset)
);

endmodule

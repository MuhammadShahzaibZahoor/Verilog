`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2024 12:48:16 AM
// Design Name: 
// Module Name: vga_rectangle
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


module vga_rectangle
(
    output reg [3:0] red,green,blue,
    input [9:0] pos_h, pos_v,
    input blank,
    input clk,
    input reset
);

parameter WIDTH = 20;
parameter HEIGHT = 100;
parameter X_LEFT = 320;
parameter Y_BOTTOM = 240;

wire flag_on_rect;
wire [9:0] x,y;

assign x = pos_h;
assign y = 480 - pos_v;

assign flag_on_rect = (x >= X_LEFT) && (x < (X_LEFT + WIDTH)) && (y >= Y_BOTTOM) && (y < (Y_BOTTOM + HEIGHT));

wire red_v   = flag_on_rect &(~blank);
wire green_v = (~flag_on_rect) &(~blank);
wire blue_v  = flag_on_rect &(~blank);

always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        red <= 0; green <= 0; blue <= 0;
    end
    else
    begin
        red <= {red_v,red_v,red_v,red_v};
        green <= {green_v,green_v,green_v,green_v};
        blue <= {blue_v,blue_v,blue_v,blue_v};
    end
end
endmodule

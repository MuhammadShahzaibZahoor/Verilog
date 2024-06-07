`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2024 12:41:57 PM
// Design Name: 
// Module Name: vga_discs
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


module vga_disc
(
    output [3:0] red,green,blue,
    input [9:0] pos_h, pos_v,
    input blank,
    input clk,
    input reset
);

parameter center_x = 320;
parameter center_y = 240;

// DISC 1
parameter DISC1_CENTER_X = 320;
parameter DISC1_CENTER_Y = 290;
parameter DISC1_RADIUS = 142;

// DISC 2
parameter DISC2_CENTER_X = 240;
parameter DISC2_CENTER_Y = 160;
parameter DISC2_RADIUS = 25;

// DISC 3
parameter DISC3_CENTER_X = 400;
parameter DISC3_CENTER_Y = 160;
parameter DISC3_RADIUS = 25;
//

reg [2:0] state;
reg [23:0] disc1_xp2,disc1_yp2;
reg [23:0] disc2_xp2,disc2_yp2;
reg [23:0] disc3_xp2,disc3_yp2;
reg [23:0] disc1_r, disc2_r, disc3_r;

reg [23:0] disc1_p, disc2_p, disc3_p;

wire red_v;
wire green_v;
wire blue_v;

reg flag_on_rect;
always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
         state <= 0;
         flag_on_rect <= 0; 
         
         disc1_xp2 <= 0; disc1_yp2 <= 0;
         disc2_xp2 <= 0; disc2_yp2 <= 0;
         disc3_xp2 <= 0; disc3_yp2 <= 0;
         
         disc1_r <= 0; disc2_r <= 0; disc3_r <= 0;
         disc1_p <= 0; disc2_p <= 0; disc3_p <= 0;  
    end
    else
    begin
        case(state)
        0: 
        begin
        //DISC 1 x component square
            if(pos_h >= DISC1_CENTER_X)
                disc1_xp2 = (pos_h - DISC1_CENTER_X) * (pos_h - DISC1_CENTER_X);
            else
                disc1_xp2 = (DISC1_CENTER_X - pos_h) * (DISC1_CENTER_X - pos_h);
        // DISC 1 y component square    
            if(pos_v >= DISC1_CENTER_Y)
                disc1_yp2 = (pos_v - DISC1_CENTER_Y) * (pos_v - DISC1_CENTER_Y);
            else
                disc1_yp2 = (DISC1_CENTER_Y - pos_v) * (DISC1_CENTER_Y - pos_v);
            
        //DISC 2 x component square
            if(pos_h >= DISC2_CENTER_X)
                disc2_xp2 = (pos_h - DISC2_CENTER_X) * (pos_h - DISC2_CENTER_X);
            else
                disc2_xp2 = (DISC2_CENTER_X - pos_h) * (DISC2_CENTER_X - pos_h);
        // DISC 2 y component square    
            if(pos_v >= DISC2_CENTER_Y)
                disc2_yp2 = (pos_v - DISC2_CENTER_Y) * (pos_v - DISC2_CENTER_Y);
            else
                disc2_yp2 = (DISC2_CENTER_Y - pos_v) * (DISC2_CENTER_Y - pos_v); 
      
      //DISC 3 x component square
            if(pos_h >= DISC3_CENTER_X)
                disc3_xp2 = (pos_h - DISC3_CENTER_X) * (pos_h - DISC3_CENTER_X);
            else
                disc3_xp2 = (DISC3_CENTER_X - pos_h) * (DISC3_CENTER_X - pos_h);
        // DISC 2 y component square    
            if(pos_v >= DISC3_CENTER_Y)
                disc3_yp2 = (pos_v - DISC3_CENTER_Y) * (pos_v - DISC3_CENTER_Y);
            else
                disc3_yp2 = (DISC3_CENTER_Y - pos_v) * (DISC3_CENTER_Y - pos_v); 
                
          disc1_r = DISC1_RADIUS * DISC1_RADIUS;
          disc2_r = DISC2_RADIUS * DISC2_RADIUS;
          disc3_r = DISC3_RADIUS * DISC3_RADIUS; 
          
          state <= 1;                          
        end
        1:
        begin
            disc1_p <= disc1_xp2 + disc1_yp2;
            disc2_p <= disc2_xp2 + disc2_yp2;
            disc3_p <= disc3_xp2 + disc3_yp2; 
            state <= 2;            
        end
        
        2:
        begin
            if((disc1_p <= disc1_r) || (disc2_p <= disc2_r) || (disc3_p <= disc3_r))
                flag_on_rect <= 1;    
            else
                flag_on_rect <= 0;
                
                state <= 0;
        end
        default: state <= 0;
        endcase       
    end
end

assign red_v   = flag_on_rect &(~blank);
assign green_v =  ~flag_on_rect &(~blank);
assign blue_v  =  flag_on_rect &(~blank);


assign red = {red_v,red_v,red_v,red_v};
assign green = {green_v,green_v,green_v,green_v};
assign blue = {blue_v,blue_v,blue_v,blue_v};

endmodule

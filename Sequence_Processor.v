`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2024 02:37:54 AM
// Design Name: 
// Module Name: Sequence_Processor
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


module Sequence_Processor
(
    input I_CLOCK,
    input I_RESET,
    input I_START,
    
    input [15:0] I_ADD, // STARTING ADDRESS
    input [9:0]  I_K,   // LENGTH OF THE SEQUENCE
    
    output reg [15:0] O_MEMORY_ADDRESS,
    output reg O_MEMORY_ENABLE,
    output reg [7:0] O_MEMORY_WRITE_DATA,
    output reg O_MEMORY_WRITE_ENABLE,
    input [7:0] I_MEMORY_READ_DATA,
    output reg O_DONE
);

reg [7:0] LAST_VALID_VALUE;
reg [9:0] WORD_INDEX;

reg [7:0] C;

parameter IDLE             = 4'd0;
parameter READ_FLAG        = 4'd1;
parameter READ_DATA        = 4'd2;
parameter PROCESS          = 4'd3;
parameter WRITE_VALID_BYTE = 4'd4;
parameter WRITE_ZERO_BYTE  = 4'd5;
parameter CREDIBILITY_ADD  = 4'd6;
parameter WRITE_CREDIBILITY= 4'd7;
parameter DONE_FLAG        = 4'd8;

reg [3:0] PRES_STATE;
reg [3:0] NEXT_STATE;

always@(posedge I_CLOCK or posedge I_RESET)
begin
    if(I_RESET) PRES_STATE <= IDLE;
    else        PRES_STATE <= NEXT_STATE;
end

always@(*)
begin
    case(PRES_STATE)
    IDLE:
    begin
        if(I_START)   NEXT_STATE = READ_FLAG;
        else          NEXT_STATE = PRES_STATE;    
    end
    READ_FLAG:        NEXT_STATE = READ_DATA;
    READ_DATA:        NEXT_STATE = PROCESS;
    PROCESS:
    begin
        if(WORD_INDEX < I_K)
        begin
            if(I_MEMORY_READ_DATA[7:0] == 8'd0) NEXT_STATE = WRITE_ZERO_BYTE;
            else                                NEXT_STATE = WRITE_VALID_BYTE;
        end
        else          NEXT_STATE = DONE_FLAG;          
    end
    WRITE_ZERO_BYTE:   NEXT_STATE = CREDIBILITY_ADD;
    WRITE_VALID_BYTE:  NEXT_STATE = CREDIBILITY_ADD;
    CREDIBILITY_ADD:   NEXT_STATE = WRITE_CREDIBILITY;
    WRITE_CREDIBILITY: NEXT_STATE = READ_FLAG; 
    DONE_FLAG:         
    begin
        if(I_START == 1'b0) NEXT_STATE = IDLE;
        else                NEXT_STATE = PRES_STATE;    
    end
    default:           NEXT_STATE = IDLE;
    endcase 
end

always@(posedge I_CLOCK)
begin
    if(PRES_STATE == DONE_FLAG) O_DONE <= 1'b1;
    else                        O_DONE <= 1'b0;
end

always@(posedge I_CLOCK or posedge I_RESET)
begin
    if(I_RESET)                     O_MEMORY_ENABLE <= 1'b0;
    else if(PRES_STATE == DONE_FLAG)O_MEMORY_ENABLE <= 1'b0;
    else if(PRES_STATE == READ_FLAG)O_MEMORY_ENABLE <= 1'b1;
    else                            O_MEMORY_ENABLE <= O_MEMORY_ENABLE;
end

always@(posedge I_CLOCK or posedge I_RESET)
begin
    if(I_RESET)                             O_MEMORY_WRITE_ENABLE <= 1'b0;
    else if(PRES_STATE == WRITE_ZERO_BYTE)  O_MEMORY_WRITE_ENABLE <= 1'b1;
    else if(PRES_STATE == WRITE_VALID_BYTE) O_MEMORY_WRITE_ENABLE <= 1'b1;
    else if(PRES_STATE == WRITE_CREDIBILITY)O_MEMORY_WRITE_ENABLE <= 1'b1;
    else                                    O_MEMORY_WRITE_ENABLE <= 1'b0;
end

always@(posedge I_CLOCK or posedge I_RESET)
begin
    if(I_RESET)                             WORD_INDEX <= 16'd0;
    else if(PRES_STATE == WRITE_CREDIBILITY)WORD_INDEX <= WORD_INDEX + 16'd1;
    else if(PRES_STATE == DONE_FLAG)        WORD_INDEX <= 16'd0;
    else                                    WORD_INDEX <= WORD_INDEX;
end

always@(posedge I_CLOCK or posedge I_RESET)
begin
    if(I_RESET)                           O_MEMORY_ADDRESS <= 16'd0;
    else if(PRES_STATE == READ_FLAG)      O_MEMORY_ADDRESS <= I_ADD + (WORD_INDEX * 2);
    else if(PRES_STATE == CREDIBILITY_ADD)O_MEMORY_ADDRESS <= O_MEMORY_ADDRESS + 16'd1;
    else if(PRES_STATE == DONE_FLAG)      O_MEMORY_ADDRESS <= 16'd0;
    else                                  O_MEMORY_ADDRESS <= O_MEMORY_ADDRESS;
end

always@(posedge I_CLOCK or posedge I_RESET)
begin
    if(I_RESET)                             LAST_VALID_VALUE <= 8'd0;
    else if(PRES_STATE == WRITE_VALID_BYTE) LAST_VALID_VALUE <= I_MEMORY_READ_DATA[7:0];
    else if(PRES_STATE == DONE_FLAG)        LAST_VALID_VALUE <= 8'd0;
    else                                    LAST_VALID_VALUE <= LAST_VALID_VALUE;
end

always@(posedge I_CLOCK or posedge I_RESET)
begin
    if(I_RESET)                            C <= 8'd0;
    else if(PRES_STATE == WRITE_VALID_BYTE)C <= 8'd31;
    else if(PRES_STATE == WRITE_ZERO_BYTE) 
    begin
        if(C > 0)
            C <= C - 1;
        else
            C <= 0;
    end
    else if(PRES_STATE == DONE_FLAG)       C <= 8'd0;
    else                                   C <= C;
end

always@(posedge I_CLOCK or posedge I_RESET)
begin
    if(I_RESET)                             O_MEMORY_WRITE_DATA <= 16'd0;
    else if(PRES_STATE == WRITE_ZERO_BYTE)  O_MEMORY_WRITE_DATA <= LAST_VALID_VALUE[7:0];
    else if(PRES_STATE == WRITE_VALID_BYTE) O_MEMORY_WRITE_DATA <= I_MEMORY_READ_DATA[7:0];
    else if(PRES_STATE == WRITE_CREDIBILITY)O_MEMORY_WRITE_DATA <= C[7:0];
    else                                    O_MEMORY_WRITE_DATA <= 16'd0;
end

endmodule


module sevenSegmentDisplay
(
input [3:0] numeral_bit,

output a,
output b,
output c,
output d,
output e,
output f,
output g
);

wire not_numeral_bit_3;
wire not_numeral_bit_2;
wire not_numeral_bit_1;
wire not_numeral_bit_0;

wire numeral_bit_2_and_numeral_bit_0;
wire not_2_and_not_0;
wire numeral_20_or_not_20;
wire numeral_bit_3_or_numeral_bit_1;

wire not_1_and_not_0;
wire numeral_bit_1_and_numeral_bit_0;
wire not_1_and_not_0_or_numeral_bit_1_and_numeral_bit_0;

wire numeral_bit_3_or_numeral_bit_2;
wire not_1_or_numeral_bit_0;
wire numeral_1_and_not_0;
wire numeral_1_and_not_2;
wire numeral_20_and_not_1;
wire numeral_1_and_not_0_or_not_2_and_not_0;
wire numeral_1_and_not_2_or_numeral_20_and_not_1;
wire term_or_00;

wire numeral_2_and_not_0;
wire numeral_2_and_not_1;
wire numeral_2_and_not_0_or_numeral_2_and_not_1;
wire numeral_3_or_not_1_and_not_0;

wire numeral_1_and_not_0_or_numeral_2_and_not_1;
wire numeral_1_and_not_2_or_numeral_3;

assign not_numeral_bit_3 = ~ numeral_bit[3];
assign not_numeral_bit_2 = ~ numeral_bit[2];
assign not_numeral_bit_1 = ~ numeral_bit[1];
assign not_numeral_bit_0 = ~ numeral_bit[0];

assign numeral_bit_2_and_numeral_bit_0 = numeral_bit[2] & numeral_bit[0];
assign not_2_and_not_0 = not_numeral_bit_2 & not_numeral_bit_0;
assign numeral_20_or_not_20 = numeral_bit_2_and_numeral_bit_0 | not_2_and_not_0;
assign numeral_bit_3_or_numeral_bit_1 = numeral_bit[3] | numeral_bit[1];

assign not_1_and_not_0 = not_numeral_bit_1 & not_numeral_bit_0;
assign numeral_bit_1_and_numeral_bit_0 = numeral_bit[1] & numeral_bit[0];
assign not_1_and_not_0_or_numeral_bit_1_and_numeral_bit_0 = not_1_and_not_0 | numeral_bit_1_and_numeral_bit_0;

assign numeral_bit_3_or_numeral_bit_2 = numeral_bit[3] | numeral_bit[2];
assign not_1_or_numeral_bit_0 = not_numeral_bit_1 | numeral_bit[0];

assign numeral_1_and_not_0 = numeral_bit[1] & not_numeral_bit_0;
assign numeral_1_and_not_2 = numeral_bit[1] & not_numeral_bit_2;
assign numeral_20_and_not_1 = numeral_bit_2_and_numeral_bit_0 & not_numeral_bit_1;
assign numeral_1_and_not_0_or_not_2_and_not_0 = numeral_1_and_not_0 | not_2_and_not_0;
assign numeral_1_and_not_2_or_numeral_20_and_not_1 = numeral_1_and_not_2 | numeral_20_and_not_1;
assign term_or_00 = numeral_1_and_not_0_or_not_2_and_not_0 | numeral_1_and_not_2_or_numeral_20_and_not_1;

assign numeral_2_and_not_0 = numeral_bit[2] & not_numeral_bit_0;
assign numeral_2_and_not_1 = numeral_bit[2] & not_numeral_bit_1;
assign numeral_2_and_not_0_or_numeral_2_and_not_1 = numeral_2_and_not_0 | numeral_2_and_not_1;
assign numeral_3_or_not_1_and_not_0 = numeral_bit[3] | not_1_and_not_0;

assign numeral_1_and_not_0_or_numeral_2_and_not_1 = numeral_1_and_not_0 | numeral_2_and_not_1;
assign numeral_1_and_not_2_or_numeral_3 = numeral_1_and_not_2 | numeral_bit[3];

assign a = numeral_20_or_not_20 | numeral_bit_3_or_numeral_bit_1;
assign b = not_numeral_bit_2 | not_1_and_not_0_or_numeral_bit_1_and_numeral_bit_0;
assign c = numeral_bit_3_or_numeral_bit_2 | not_1_or_numeral_bit_0; 
assign d = numeral_bit[3] | term_or_00;
assign e = not_2_and_not_0 | numeral_1_and_not_0;
assign f = numeral_2_and_not_0_or_numeral_2_and_not_1 | numeral_3_or_not_1_and_not_0;
assign g = numeral_1_and_not_0_or_numeral_2_and_not_1 | numeral_1_and_not_2_or_numeral_3;

endmodule
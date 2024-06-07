module sevenSegmentDisplayC
(
	input [3:0] numeral_bit,
	output c
);

wire not_numeral_bit_3;
wire not_numeral_bit_2;
wire not_numeral_bit_1;
wire not_numeral_bit_0;

wire numeral_bit_3_or_numeral_bit_2;
wire not_1_or_numeral_bit_0;

wire maxterm_02;

assign not_numeral_bit_3 = ~ numeral_bit[3];
assign not_numeral_bit_2 = ~ numeral_bit[2];
assign not_numeral_bit_1 = ~ numeral_bit[1];
assign not_numeral_bit_0 = ~ numeral_bit[0];

assign numeral_bit_3_or_numeral_bit_2 = numeral_bit[3] | numeral_bit[2];

assign not_1_or_numeral_bit_0 = not_numeral_bit_1 | numeral_bit[0];

assign maxterm_02 = numeral_bit_3_or_numeral_bit_2 | not_1_or_numeral_bit_0; 

assign c = maxterm_02;
endmodule
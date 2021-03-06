// modulo de clock

//`timescale 1ns/1ps

module clock_gen(sdram_clk, sys_clk);

	parameter P_SYS  = 10;     //    200MHz
	parameter P_SDR  = 20;     //    100MHz

	output reg     sdram_clk;
	output reg     sys_clk;

	initial begin
		sys_clk = 0;
	end
	initial begin 
		sdram_clk = 0;
	end

	always #(P_SYS/2) begin
		sys_clk = !sys_clk;
	end

	always #(P_SDR/2) begin 
		sdram_clk = !sdram_clk;
	end

endmodule 
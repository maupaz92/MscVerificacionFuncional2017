// modulo de clock

//`timescale 1ns/1ps

module aserciones_program_col_addr(
	assertion_interface white_box_intf,
	input enable_colbits_flag
	);


	logic [12:0] row_temp; 
	logic [11:0] col_temp; 
	logic [1:0] bank_temp;
	
	
	
	always @ (posedge white_box_intf.clk) begin
		if (white_box_intf.cfg_colbits == 00) begin 
				assign col_temp 	= white_box_intf.memory_address[7:0];
				assign bank_temp 	= white_box_intf.memory_address[9:8];
				assign row_temp 	= white_box_intf.memory_address[22:10];
		end 
		else if (white_box_intf.cfg_colbits == 01) begin 
				assign col_temp 	= white_box_intf.memory_address[8:0];
				assign bank_temp 	= white_box_intf.memory_address[10:9];
				assign row_temp 	= white_box_intf.memory_address[23:11];
		end 
		else if (white_box_intf.cfg_colbits == 10) begin 
				assign col_temp 	= white_box_intf.memory_address[9:0];
				assign bank_temp 	= white_box_intf.memory_address[11:10];
				assign row_temp 	= white_box_intf.memory_address[24:12];
		end 
		else begin 
				assign col_temp 	= white_box_intf.memory_address[10:0];
				assign bank_temp 	= white_box_intf.memory_address[12:11];
				assign row_temp 	= white_box_intf.memory_address[25:13];
		end 
	end
	
	
	// sequences
	
	sequence req_cfg;
		$rose(white_box_intf.whbox_wren);
	endsequence
	
	sequence samecol;
		(white_box_intf.whbox_column[11:2] == col_temp[11:2]);
	endsequence
	
	sequence samebank;
		(white_box_intf.whbox_bank[1:0] == bank_temp[1:0]);
	endsequence

	sequence samerow;
		(white_box_intf.whbox_row[11:0] == row_temp[11:0]);
	endsequence
	
	sequence matchaddr;
		(samecol and samebank and samerow);
	endsequence	
	
	property combinacion;
		@(posedge white_box_intf.sdram_clk) disable iff(~enable_colbits_flag)
			(req_cfg |=> matchaddr);
	endproperty
		
		
	//---------- 
		
	sequence validacion_addr_dummy;
		(white_box_intf.sdr_addr == 0);
	endsequence
	
	property print_addr;
		@(posedge white_box_intf.sdram_clk)
			$rose(white_box_intf.x2a_wrstart) |-> validacion_addr_dummy;
	endproperty
	
	addr_cero: assert property (print_addr)
		$display("direccion igual a cero");
	else begin		
		$display("=======> dir igual a : %x", white_box_intf.sdr_addr);
	end

	
/* 	// Assertion to verify the expected row, colum, bank in the request is the same
	CfgcolumCh: assert property (combinacion)
		$display("Programming the config column bits can be write the data in the same row, bank and column");
	else
		$error("ERROR: Programming the config column bits can't be write the data in the same row, bank and column");

	//
	cov_CfgcolumCh: cover property (@(posedge white_box_intf.sdram_clk) disable iff(~enable_colbits_flag) (req_cfg |=> matchaddr)
	);
 */
	
/* 	// coverage
	covergroup cg_cfgaddrReq @(posedge white_box_intf.sdram_clk iff enable_colbits_flag);
		column: coverpoint col_temp{
			bins col_a = {12'h80};
		}
		bank: coverpoint bank_temp[1:0]{
			bins bank_a =  {0};
		}
		row: coverpoint row_temp[11:0]{
			bins row_a =  {12'h06};
		}
		endgroup
	
	// covergroup instance
	cg_cfgaddrReq cg_addReq = new; */

	
	
	
	
	

endmodule 
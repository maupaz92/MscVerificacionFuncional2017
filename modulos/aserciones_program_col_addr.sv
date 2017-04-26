// modulo de clock

//`timescale 1ns/1ps

module aserciones_program_col_addr(
	assertion_interface white_box_intf,
	input enable_colbits_flag
	);


	reg [12:0] row_temp_wb; 
	reg [11:0] col_temp_wb; 
	reg [1:0] bank_temp_wb;
	
	//reg [12:0] row_temp_mem; 
	//localparam [11:0] comparador; 
	`ifdef SDR_32BIT
		localparam comparador = 8;//12'h0ff;
	`else
		localparam comparador = 9;//12'h1ff;
	`endif
	//reg [1:0] bank_temp_mem;
	//int limite;
	
	
	always @ (posedge white_box_intf.sdram_clk) begin
		
		if (white_box_intf.cfg_colbits == 00) begin 
				col_temp_wb 	= white_box_intf.addr_i[7:0];
				bank_temp_wb 	= white_box_intf.addr_i[9:8];
				row_temp_wb 	= white_box_intf.addr_i[22:10];
				//col_temp_mem	= white_box_intf.sdr_addr[7:0];
				//comparador = 12'h0ff;
		end 
		else if (white_box_intf.cfg_colbits == 01) begin 
				col_temp_wb 	= white_box_intf.addr_i[8:0];
				bank_temp_wb 	= white_box_intf.addr_i[10:9];
				row_temp_wb 	= white_box_intf.addr_i[23:11];
				//col_temp_mem	= white_box_intf.sdr_addr[8:0];
				//comparador = 12'h1ff;
		end 
		else if (white_box_intf.cfg_colbits == 10) begin 
				col_temp_wb 	= white_box_intf.addr_i[9:0];
				bank_temp_wb 	= white_box_intf.addr_i[11:10];
				row_temp_wb 	= white_box_intf.addr_i[24:12];
				//col_temp_mem	= white_box_intf.sdr_addr[9:0];
				//comparador = 12'h2ff;
		end 
		else begin 
				col_temp_wb 	= white_box_intf.addr_i[10:0];
				bank_temp_wb 	= white_box_intf.addr_i[12:11];
				row_temp_wb 	= white_box_intf.addr_i[25:13];
				//ol_temp_mem	= white_box_intf.sdr_addr[10:0];
				//comparador = 12'h3ff;
		end 
	end
	
	
	// sequences
/* 	
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
	endproperty */
		
		
	//---------- 
		
	//sequence validacion_addr;
		//(white_box_intf.sdr_addr == col_temp);
	//endsequence
	
	property validacion_addr;
		@(posedge white_box_intf.sdram_clk)
			// cuando haya un write, se evalua si la columna que va hacia la mem sea igual a la que 
			// entro hacia el WB
			$rose(white_box_intf.x2a_wrstart) |-> (col_temp_wb ^ white_box_intf.sdr_addr[comparador-1:0] ) !== 0;
	endproperty
	
	addr_cero: assert property (validacion_addr)
		$display("direcciones identicas valor %x ", (col_temp_wb ^ white_box_intf.sdr_addr[comparador-1:0] ));
	else begin		
		//$display("=======> dir igual WB : %x, MEM: %x ", col_temp_wb, (white_box_intf.sdr_addr[comparador-1:0]) );
		$display("=======> direcciones diferentes WB : %x, MEM: %x ", col_temp_wb, (col_temp_wb ^ white_box_intf.sdr_addr[comparador-1:0] ) );
	end

	//---------- 
	//property verif_colbits_uno;
		//@(posedge white_box_intf.sdram_clk) iff(white_box_intf.cfg_colbits == 2'b00)
			
	//endproperty
	
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



module testbench_top;

	wire sys_clk;
	wire sdram_clk;
	
	//--------------------------------------------
	// SDRAM 
	//--------------------------------------------
	wire [31:0]           Dq                 ; // SDRAM Read/Write Data Bus
	wire [3:0]            sdr_dqm            ; // SDRAM DATA Mask
	wire [1:0]            sdr_ba             ; // SDRAM Bank Select
	wire [12:0]           sdr_addr           ; // SDRAM ADRESS
	wire                  sdr_init_done      ; // SDRAM Init Done 	
	
	
	// instancia de la interface
	senales system_interface(
		.sdram_clk(sdram_clk),
		.sys_clk(sys_clk)
	);
	

	clock_gen clk_mod(
		.sdram_clk(sdram_clk),
		.sys_clk(sys_clk)
	);

	sdrc_top DUV;
		

	// instancia de la memoria
	mt48lc2m32b2 #(
		.data_bits(32)
		) 
		u_sdram32 (
			  .Dq                 (Dq                 ) , 
			  .Addr               (sdr_addr[10:0]     ), 
			  .Ba                 (sdr_ba             ), 
			  .Clk                (sdram_clk_d        ), 
			  .Cke                (sdr_cke            ), 
			  .Cs_n               (sdr_cs_n           ), 
			  .Ras_n              (sdr_ras_n          ), 
			  .Cas_n              (sdr_cas_n          ), 
			  .We_n               (sdr_we_n           ), 
			  .Dqm                (sdr_dqm            )
		 );


endmodule











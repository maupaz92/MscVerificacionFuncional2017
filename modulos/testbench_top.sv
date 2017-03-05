


module testbench_top;


	localparam DATA_WIDTH = 16;
	localparam BYTE_WIDTH = 2;


	wire sys_clk;
	wire sdram_clk;
	
	
	//--------------------------------------------
	// SDRAM 
	//--------------------------------------------
	wire [DATA_WIDTH-1:0]		Dq                 ; // SDRAM Read/Write Data Bus
	wire [BYTE_WIDTH-1:0]		sdr_dqm            ; // SDRAM DATA Mask
	wire [1:0]          		sdr_ba             ; // SDRAM Bank Select
	wire [12:0]         		sdr_addr           ; // SDRAM ADRESS
	wire #(2.0) 				sdram_clk_d   = sdram_clk;	
	
	wire						sdr_cke;
	wire						sdr_cs_n;
	wire						sdr_ras_n;
	wire						sdr_cas_n;
	wire						sdr_we_n;
	
	
	
	//***********************************************************************
	// Interface 
	//***********************************************************************
	senales system_interface(
		.sdram_clk(sdram_clk),
		.sys_clk(sys_clk)
	);
	

	//***********************************************************************
	// instancia del generador de clock 
	//***********************************************************************
	clock_gen clk_mod(
		.sdram_clk(sdram_clk),
		.sys_clk(sys_clk)
	);

	//***********************************************************************
	// instancia del DUV 
	//***********************************************************************
	memory_controller #(
		.SDR_DW(DATA_WIDTH),
		.SDR_BW(BYTE_WIDTH)
	) DUV (
		.intf_master_controller(system_interface.duv_port),
		.sdr_cke	(sdr_cke), 
		.sdr_cs_n	(sdr_cs_n), 
		.sdr_ras_n	(sdr_ras_n), 
		.sdr_cas_n	(sdr_cas_n), 
		.sdr_we_n	(sdr_we_n),
		.sdr_dqm	(sdr_dqm), 
		.sdr_ba		(sdr_ba), 
		.sdr_addr	(sdr_addr), 
		.sdr_dq		(Dq)
	);
		

	//***********************************************************************
	// instancia de memoria
	//***********************************************************************
	mt48lc2m32b2 #(
		.data_bits(32)
	) u_sdram32 (
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











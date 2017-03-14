
`timescale 1ns/1ps

//`include "./RTL/core/sdr_define.v"
//`define SDR_16BIT

module testbench_top;


	localparam DATA_WIDTH = 32;
	
	//localparam DATA_TO_MEM_WIDTH = 32;
	//localparam BYTE_DATA_TO_MEM_WIDTH = 4;
	localparam APP_AW = 26;

	wire sys_clk;
	wire sdram_clk;
	
	//REBECA-CA WAS HERE	
	//--------------------------------------------
	// SDRAM 
	//--------------------------------------------
	
	//--------------------------------------------
	// SDRAM I/F 
	//--------------------------------------------

	`ifdef SDR_32BIT
	   wire [31:0]           Dq                 ; // SDRAM Read/Write Data Bus
	   wire [3:0]            sdr_dqm            ; // SDRAM DATA Mask
	`elsif SDR_16BIT 
	   wire [15:0]           Dq                 ; // SDRAM Read/Write Data Bus
	   wire [1:0]            sdr_dqm            ; // SDRAM DATA Mask
	`else 
	   wire [7:0]           Dq                 ; // SDRAM Read/Write Data Bus
	   wire [0:0]           sdr_dqm            ; // SDRAM DATA Mask
	`endif	
	
	
	wire [1:0]          					sdr_ba             ; // SDRAM Bank Select
	wire [12:0]         					sdr_addr           ; // SDRAM ADRESS
	wire #(2.0) 							sdram_clk_d   = sdram_clk;	
	
	wire						sdr_cke;
	wire						sdr_cs_n;
	wire						sdr_ras_n;
	wire						sdr_cas_n;
	wire						sdr_we_n;
	
	
	
	//***********************************************************************
	// Interface 
	//***********************************************************************
	senales # (
		.dw(DATA_WIDTH),
		.APP_AW(APP_AW)
	)
	system_interface(
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
	
	
	test test_program(
		.driver_port(system_interface.driver_port),
		.monitor_port(system_interface.monitor_port),
		.config_port(system_interface.config_port)
	);
	
	//***********************************************************************
	// instancia del DUV 
	//***********************************************************************
	
	`ifdef SDR_32BIT
		memory_controller #(
			.SDR_DW(32),
			.SDR_BW(4),
			.dw(DATA_WIDTH),
			.APP_AW(APP_AW)
		) DUV (
	`elsif SDR_16BIT
		memory_controller #(
			.SDR_DW(16),
			.SDR_BW(2),
			.dw(DATA_WIDTH),
			.APP_AW(APP_AW)
		) DUV (
	`else 
		memory_controller #(
			.SDR_DW(8),
			.SDR_BW(1),
			.dw(DATA_WIDTH),
			.APP_AW(APP_AW)
		) DUV (
	`endif
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
	// mt48lc2m32b2 #(
		// .data_bits(32)
	// ) u_sdram32 (
		  // .Dq                 (Dq                 ) , 
		  // .Addr               (sdr_addr[10:0]     ), 
		  // .Ba                 (sdr_ba             ), 
		  // .Clk                (sdram_clk_d        ), 
		  // .Cke                (sdr_cke            ), 
		  // .Cs_n               (sdr_cs_n           ), 
		  // .Ras_n              (sdr_ras_n          ), 
		  // .Cas_n              (sdr_cas_n          ), 
		  // .We_n               (sdr_we_n           ), 
		  // .Dqm                (sdr_dqm            )
	 // );

		 
		 

	`ifdef SDR_32BIT
	mt48lc2m32b2 #(.data_bits(32)) u_sdram32 (
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

	`elsif SDR_16BIT

	   IS42VM16400K u_sdram16 (
			  .dq                 (Dq                 ), 
			  .addr               (sdr_addr[11:0]     ), 
			  .ba                 (sdr_ba             ), 
			  .clk                (sdram_clk_d        ), 
			  .cke                (sdr_cke            ), 
			  .csb                (sdr_cs_n           ), 
			  .rasb               (sdr_ras_n          ), 
			  .casb               (sdr_cas_n          ), 
			  .web                (sdr_we_n           ), 
			  .dqm                (sdr_dqm            )
		);
	`else 


	mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
			  .Dq                 (Dq                 ) , 
			  .Addr               (sdr_addr[11:0]     ), 
			  .Ba                 (sdr_ba             ), 
			  .Clk                (sdram_clk_d        ), 
			  .Cke                (sdr_cke            ), 
			  .Cs_n               (sdr_cs_n           ), 
			  .Ras_n              (sdr_ras_n          ), 
			  .Cas_n              (sdr_cas_n          ), 
			  .We_n               (sdr_we_n           ), 
			  .Dqm                (sdr_dqm            )
		 );
	`endif		 
		 
		 
		 
		 
		 

endmodule











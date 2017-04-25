
// ruta de las instancias hasta el DUV para obtener las señales del mismo
`define TOP_PATH  testbench_top.DUV
`define REQ_GEN_MODULE_PATH testbench_top.DUV.u_sdrc_core.u_req_gen
`define SDRC_XFR_CTL_PATH testbench_top.DUV.u_sdrc_core.u_xfr_ctl
`define SDRC_BS_CONVERT_PATH testbench_top.DUV.u_sdrc_core.u_bs_convert
//`define CAS_Flag  testbench_top.test
`define wb2sdrc_PATH  testbench_top.DUV.u_wb2sdrc

interface assertion_interface;

	//************************************************************************************
	
	logic clk;
	logic reset;
	logic stb;
	logic we;
	logic sel;
	logic ack;
	logic cyc;
	
	logic 				sdram_clk;
	logic				sdram_resetn;
	logic               sdr_cke           ; // SDRAM CKE
	logic 				sdr_cs_n          ; // SDRAM Chip Select
	logic               sdr_ras_n         ; // SDRAM ras
	logic               sdr_cas_n         ; // SDRAM cas
	logic				sdr_we_n          ;// SDRAM write enable
	logic               sdr_init_done     ;
	
	logic [12:0]		sdr_addr;
	
	logic               sdr_rd_valid     ;
	logic [31:0]        sdr_rd_data     ;
	logic [2:0]         cfg_sdr_cas     ;
	logic [12:0]        cfg_sdr_mode_reg     ;
	

	// signal definition for 3rd delivery, cover plan
	
	logic [1:0]			cfg_colbits;
	logic [25:0]		memory_address;
	
	logic 			whbox_req; 	
	logic [1:0] 	whbox_bank;	
	logic [12:0]	whbox_row;	
	logic [12:0]	whbox_column;
	logic 			whbox_wren;
	logic 			whbox_bankready;
	
	logic [2:0] cas_latency;
	logic [12:0] sdram_mode_reg;
	logic x2a_rdok;
	logic app_rd_valid;
	logic [31:0] data_read;
	logic rd_start;
	//8/16/32 signals---------------------->
	
	logic [31:0] mem_wr_data;
	logic [31:0] app_wr_data;
	logic [31:0] mem_rd_data;
	logic [31:0] app_rd_data;
	logic [1:0]sdr_width;
	logic [1:0] read_count;
	logic [1:0] write_count;
	logic x2a_wrstart;
	logic x2a_wrlast;
	logic x2a_rdlast;
	logic x2a_rdok;
	logic x2a_wrnext;
	logic app_rd_valid;
	logic app_wr_next;
	logic [23:0] saved_rd_data;
	
	//************************************************************************************	
	assign clk 		= `TOP_PATH.wb_clk_i;
	assign reset 	= `TOP_PATH.wb_rst_i;
	assign stb 		= `TOP_PATH.wb_stb_i;
	assign we		= `TOP_PATH.wb_we_i;
	assign sel 		= `TOP_PATH.wb_sel_i;
	assign ack		= `TOP_PATH.wb_ack_o;
	assign cyc		= `TOP_PATH.wb_cyc_i;
	
	assign sdr_cke			= `TOP_PATH.sdr_cke;
	assign sdr_cs_n 		= `TOP_PATH.sdr_cs_n;
	assign sdr_ras_n		= `TOP_PATH.sdr_ras_n;
	assign sdr_cas_n		= `TOP_PATH.sdr_cas_n;
	assign sdr_we_n			= `TOP_PATH.sdr_we_n;
	assign sdr_init_done	= `TOP_PATH.sdr_init_done;
	assign sdram_clk		= `TOP_PATH.sdram_clk;
	assign sdram_resetn		= `TOP_PATH.sdram_resetn;
	
	assign sdr_addr			= `TOP_PATH.sdr_addr;
	
	assign sdr_rd_valid		= `wb2sdrc_PATH.sdr_rd_valid;
	assign sdr_rd_data		= `wb2sdrc_PATH.sdr_rd_data;
	assign cfg_sdr_cas		= `TOP_PATH.cfg_sdr_cas;
	assign cfg_sdr_mode_reg		= `TOP_PATH.cfg_sdr_mode_reg;
	

	
	
	//************************************************************************************
	//************************************************************************************
	//  signal assignation for 3rd delivery, cover plan
	//************************************************************************************
	//************************************************************************************
	
	assign cfg_colbits		= `REQ_GEN_MODULE_PATH.cfg_colbits;
	assign memory_address	= `REQ_GEN_MODULE_PATH.req_addr;
	
	//whbox  = whitebox
	
	assign whbox_req 	 	= `REQ_GEN_MODULE_PATH.req	  ; //request
	assign whbox_bank		= `REQ_GEN_MODULE_PATH.r2b_ba	; //bank address requested
	assign whbox_row  		= `REQ_GEN_MODULE_PATH.r2b_raddr	; //row address requested
	assign whbox_column  	= `REQ_GEN_MODULE_PATH.r2b_caddr	; //column address requested
	assign whbox_wren	 	= `REQ_GEN_MODULE_PATH.r2b_write	; //write request = 1 / read request = 0
	assign whbox_bankready	= `REQ_GEN_MODULE_PATH.b2r_arb_ok	;//Bank controller fifo is not full and ready to accept the command
	
	//************************************************************************************
	//************************************************************************************
	//  signal assignation for CAS Latency
	//************************************************************************************
	//************************************************************************************
	
	assign cas_latency			= `SDRC_XFR_CTL_PATH.cas_latency;		//CAS latency 
	assign sdram_mode_reg 		= `SDRC_XFR_CTL_PATH.sdram_mode_reg;				//Mode Reg 
	assign x2a_rdok 		= `SDRC_XFR_CTL_PATH.x2a_rdok;				//READ ready 
	assign rd_start 		= `SDRC_XFR_CTL_PATH.rd_start;				//start ready 
	assign x2a_wrstart		= `SDRC_XFR_CTL_PATH.x2a_wrstart;				//READ ready 
	assign app_rd_valid 		= `SDRC_BS_CONVERT_PATH.app_rd_valid;				//READ Data ready
	assign data_read = `SDRC_BS_CONVERT_PATH.app_rd_data;				//READ Data
	
	
	
	//************************************************************************************
	//************************************************************************************
	//  signal assignation for 3rd delivery, 8/16/32
	//************************************************************************************
	//************************************************************************************
	
	assign app_rd_data = `SDRC_BS_CONVERT_PATH.app_rd_data;
	assign x2a_rddt = `SDRC_BS_CONVERT_PATH.x2a_rddt;
	assign app_wr_data = `SDRC_BS_CONVERT_PATH.app_wr_data;
	assign a2x_wrdt = `SDRC_BS_CONVERT_PATH.a2x_wrdt;
	assign rd_xfr_count = `SDRC_BS_CONVERT_PATH.rd_xfr_count;
	assign wr_xfr_count = `SDRC_BS_CONVERT_PATH.wr_xfr_count;
	assign sdr_width = `SDRC_BS_CONVERT_PATH.sdr_width;	
	//assign x2a_wrstart = `SDRC_BS_CONVERT_PATH.x2a_wrstart;
	assign x2a_wrlast = `SDRC_BS_CONVERT_PATH.x2a_wrlast;
	assign x2a_rdlast = `SDRC_BS_CONVERT_PATH.x2a_rdlast;
	//assign x2a_rdok = `SDRC_BS_CONVERT_PATH.x2a_rdok;  --> ya esta asignada en el CAS
	assign x2a_wrnext = `SDRC_BS_CONVERT_PATH.x2a_wrnext;
	assign app_wr_next = `SDRC_BS_CONVERT_PATH.app_wr_next;
	//assign app_rd_valid = `SDRC_BS_CONVERT_PATH.app_rd_valid; --> ya esta asignada en el CAS
	assign saved_rd_data = `SDRC_BS_CONVERT_PATH.saved_rd_data;
	
	
	
	
	
	
	
	
	// NOTHING FROM HERE TO BOTTOM 
	
	//************************************************************************************
	//************************************************************************************
	// wishbone assertions 
	//************************************************************************************
	//************************************************************************************

/* 	//------start--rule 3.00 & 3.05 & 3.10----------------------
	sequence a;
		//Paginas 31 & 32 del wisbone b4 Spec
		reset ##1 (reset & ~stb) [*1:$] ##1 (~reset & ~stb);
	endsequence 
	  
	property Prueba1;
		@ (posedge clk)
			$rose(reset) |-> a;
	endproperty


	assert property (Prueba1) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO REGLA DE INICIALIZACION 3.00 3.05 3.10\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO REGLA DE INICIALIZACION 3.00 3.05 3.10\n\n\n");
	//------finish--rule 3.00 & 3.05 & 3.10--------------------- */

	
	/* 
	//------start-----rule 3.25---------------------------------
	//----Single Write---
	sequence b;
		//Classic standard SINGLE WRITE Cycle, Pag43 del wishbone b4 Spec
		(we & cyc & stb) [*1:$] ##1 $fell(stb & cyc); 
	endsequence

	property Prueba2;
		@ (posedge clk)
			//empieza con el flanco positivo de we y stb simultaneo
			$rose(we & stb) |-> b; 
	endproperty

	assert property (Prueba2) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SE CUMPLIO LA REGLA 3.25 en SINGLE WRITE\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO LA REGLA 3.25 en SINGLE WRITE\n\n\n");
	
	
	//----Single Read----
	sequence c;
		//Classic standard SINGLE WRITE Cycle, Pag43 del wishbone b4 Spec
		(~we & cyc & stb) [*1:$] ##1 $fell(stb & cyc); 
	endsequence

	property Prueba3;
		@ (posedge clk)
			//empieza con el flanco positivo de we y stb simultaneo
			$rose(stb) && $fell(we) |-> c; 
	endproperty

	assert property (Prueba3) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SE CUMPLIO LA REGLA 3.25 en SINGLE READ\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO LA REGLA 3.25 en SINGLE READ\n\n\n");

	//------finish-----rule 3.25----------------------------- */

	/* 
	//-----start----rule 3.35-------------------------
	sequence d;
		//Classic standard SINGLE WRITE Cycle, Pag43 del wishbone b4 Spec
		##1 ack; 
	endsequence

	property Prueba4;
		@ (posedge clk)
			//empieza con el flanco positivo de we y stb simultaneo
			$rose(stb) && $rose(cyc) |-> d; 
	endproperty

	assert property (Prueba4) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SE CUMPLIO LA REGLA 3.35\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO LA REGLA 3.35\n\n\n");

	
	
	//************************************************************************************
	//************************************************************************************
	// SDRAM assertions 
	//************************************************************************************
	//************************************************************************************	
	
	sequence nop_seq;
		 ((sdr_cs_n) & (sdr_ras_n) & (sdr_cas_n) & (sdr_we_n) );
	endsequence
	
	sequence precharge;
		##2 ((~sdr_cs_n) & (~sdr_ras_n) & (sdr_cas_n) & (~sdr_we_n)) ##1 nop_seq;
	endsequence
	
	sequence auto_refresh;
		((~sdr_cs_n) & (~sdr_ras_n) & (~sdr_cas_n) & (sdr_we_n) );
	endsequence
	
	sequence t_RFC;
		(##7 auto_refresh ##1 nop_seq) [*1:$];
	endsequence

	sequence Load_Mode_Register;
		##8 ((~sdr_cs_n) & (~sdr_ras_n) & (~sdr_cas_n) & (~sdr_we_n) );
	endsequence
	
	sequence Init_Memory;
		##1 nop_seq ##8 sdr_init_done;
	endsequence
	
	sequence master_sequence;
		nop_seq [*505] ##0 precharge ##3 auto_refresh ##1 nop_seq ##1 t_RFC ##0 Load_Mode_Register ##0 Init_Memory ;
	endsequence

	property memory_init_prop;
		@ (posedge sdram_clk )
			$rose(sdram_resetn) |-> master_sequence  ;
	endproperty
	

	memory_init_prop_assert  : assert property (memory_init_prop) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ @%0dns Assertion Correct - Memory Initialized\n\n\n", $time); 
	else  $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ @%0dns Assertion Failed - Memory Not Initialized\n\n\n", $time);
	
	 */


endinterface







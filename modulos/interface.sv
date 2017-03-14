

interface senales #(
	dw = 32,
	APP_AW = 26
)(
	input bit sys_clk,
	input bit sdram_clk
);


//****************************************
// Wish Bone Interface
//****************************************

//inputs 
logic             		wb_rst_i	;
logic             		wb_stb_i	;
logic  [APP_AW-1:0]     wb_addr_i	;
logic            		wb_we_i		; // 1 - Write, 0 - Read
logic  [dw-1:0]   		wb_dat_i	;
logic  [dw/8-1:0] 		wb_sel_i	; // Byte enable
logic             		wb_cyc_i	;
logic   [2:0]     		wb_cti_i	;
//outputs
logic             		wb_ack_o	;
logic  [dw-1:0]   		wb_dat_o	;



//****************************************
// SDRAM Interface
//****************************************

//inputs
logic [1:0]			cfg_sdr_width	;
logic [1:0]			cfg_colbits		;
logic [1:0]			cfg_req_depth	;
logic				cfg_sdr_en		;
logic [12:0]		cfg_sdr_mode_reg;
logic [3:0]			cfg_sdr_tras_d	;
logic [3:0]			cfg_sdr_trp_d	;
logic [3:0]			cfg_sdr_trcd_d	;
logic [2:0]			cfg_sdr_cas		;
logic [3:0]			cfg_sdr_trcar_d	;
logic [3:0]			cfg_sdr_twr_d	;
logic [11:0]		cfg_sdr_rfsh	;  // esto depende de unos parametros LEER ******************************************
logic [2:0]			cfg_sdr_rfmax	;  // este tmb
//outputs 
logic				sdr_init_done	;
logic				sdram_resetn	;


//****************************************
// definiciones de modports
//****************************************

// -------------------------------------   
// PUERTOS PARA COMUNICACIONES CON WISHBONE

//señales que salen del que inicia la comunicacion con el wishbone, el master
modport driver_port (
	input wb_ack_o, sdr_init_done, sys_clk, sdram_clk,
	output wb_addr_i, wb_cyc_i, wb_dat_i, wb_sel_i, wb_stb_i, wb_we_i, wb_rst_i, sdram_resetn
	);	
	
// puerto para el monitor
modport monitor_port (
	input wb_ack_o, wb_dat_o, sys_clk, sdram_clk,
	output wb_addr_i, wb_cyc_i, wb_stb_i, wb_we_i
	);

// señales que recibe el modulo wishbone 
modport duv_port (
	input wb_stb_i, wb_addr_i, wb_we_i, wb_dat_i, wb_sel_i, wb_cyc_i, wb_cti_i, wb_rst_i,
		cfg_colbits, cfg_req_depth, cfg_sdr_cas, cfg_sdr_en, cfg_sdr_mode_reg, cfg_sdr_rfmax,
		cfg_sdr_rfsh, cfg_sdr_tras_d, cfg_sdr_trcar_d, cfg_sdr_trcd_d, cfg_sdr_trp_d, cfg_sdr_twr_d,
		cfg_sdr_width, sdram_resetn, sys_clk, sdram_clk,
	output wb_ack_o, wb_dat_o, sdr_init_done
	);	

modport config_port(
	output cfg_colbits, cfg_req_depth, cfg_sdr_cas, cfg_sdr_en, cfg_sdr_mode_reg, cfg_sdr_rfmax,
		cfg_sdr_rfsh, cfg_sdr_tras_d, cfg_sdr_trcar_d, cfg_sdr_trcd_d, cfg_sdr_trp_d, cfg_sdr_twr_d,
		cfg_sdr_width, sdram_resetn
	);

endinterface







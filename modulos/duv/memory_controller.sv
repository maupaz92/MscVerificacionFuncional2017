





module memory_controller #(
	
	parameter      SDR_DW   = 16,  // SDR Data Width, bits que van hacia el modulo de memoria
	parameter      SDR_BW   = 2,   // SDR Byte Width, bytes en el bus de datos
	
	parameter      APP_AW   = 26,  // Application Address Width
	
	parameter      tw       = 8,   // tag id width
	parameter      bl       = 9,   // burst_lenght_width 	
	parameter      dw       = 32  // data width
)(

	interface intf_master_controller			,
	//------------------------------------------------
	// signals to SDRAMs
	//------------------------------------------------
	output                  sdr_cke            , // SDRAM CKE
	output 					sdr_cs_n           , // SDRAM Chip Select
	output                  sdr_ras_n          , // SDRAM ras
	output                  sdr_cas_n          , // SDRAM cas
	output					sdr_we_n           ,// SDRAM write enable
	output [SDR_BW-1:0] 	sdr_dqm            , // SDRAM Data Mask
	output [1:0] 			sdr_ba             , // SDRAM Bank Enable
	output [12:0] 			sdr_addr           , // SDRAM Address
	inout [SDR_DW-1:0] 		sdr_dq                // SDRA Data Input/output	
);



	//--------------------------------------------
	// wishbone to SDRAM controller signals
	//--------------------------------------------
	wire                  app_req            ; // SDRAM request
	wire [APP_AW-1:0]     app_req_addr       ; // SDRAM Request Address
	wire [bl-1:0]         app_req_len        ;
	wire                  app_req_wr_n       ; // 0 - Write, 1 -> Read
	wire                  app_req_ack        ; // SDRAM request Accepted
	wire                  app_busy_n         ; // 0 -> sdr busy
	wire [dw/8-1:0]       app_wr_en_n        ; // Active low sdr byte-wise write data valid
	wire                  app_wr_next_req    ; // Ready to accept the next write
	wire                  app_rd_valid       ; // sdr read valid
	wire                  app_last_rd        ; // Indicate last Read of Burst Transfer	
	//wire                  app_last_wr        ; // Indicate last Write of Burst Transfer
	wire [dw-1:0]         app_wr_data        ; // sdr write data
	wire  [dw-1:0]        app_rd_data        ; // sdr read data

	// sdram pad clock is routed back through pad
	// SDRAM Clock from Pad, used for registering Read Data
	wire #(1.0) sdram_pad_clk = intf_master_controller.sdram_clk;
	
	/****************************************
	*  These logic has to be implemented using Pads
	*  **************************************/
	wire  [SDR_DW-1:0]    pad_sdr_din         ; // SDRA Data Input
	wire  [SDR_DW-1:0]    sdr_dout            ; // SDRAM Data Output
	wire  [SDR_BW-1:0]    sdr_den_n           ; // SDRAM Data Output enable	
	

	//=========================================================================
	
	assign   sdr_dq = (&sdr_den_n == 1'b0) ? sdr_dout :  {SDR_DW{1'bz}}; 
	assign   pad_sdr_din = sdr_dq;	
	
	
	
	//=========================================================================
	wb2sdrc #(
		.dw(dw),
		.tw(tw),
		.bl(bl)
	) u_wb2sdrc (
      // WB bus
          .wb_rst_i           (intf_master_controller.wb_rst_i 			 ) ,
          .wb_clk_i           (intf_master_controller.sys_clk            ) ,

          .wb_stb_i           (intf_master_controller.wb_stb_i           ) ,
          .wb_ack_o           (intf_master_controller.wb_ack_o           ) ,
          .wb_addr_i          (intf_master_controller.wb_addr_i          ) ,
          .wb_we_i            (intf_master_controller.wb_we_i            ) ,
          .wb_dat_i           (intf_master_controller.wb_dat_i           ) ,
          .wb_sel_i           (intf_master_controller.wb_sel_i           ) ,
          .wb_dat_o           (intf_master_controller.wb_dat_o           ) ,
          .wb_cyc_i           (intf_master_controller.wb_cyc_i           ) ,
          .wb_cti_i           (intf_master_controller.wb_cti_i           ) , 


      //SDRAM Controller Hand-Shake Signal 
          .sdram_clk          (intf_master_controller.sdram_clk       ) ,
          .sdram_resetn       (intf_master_controller.sdram_resetn 	  ) ,
          .sdr_req            (app_req            ) ,
          .sdr_req_addr       (app_req_addr       ) ,
          .sdr_req_len        (app_req_len        ) ,
          .sdr_req_wr_n       (app_req_wr_n       ) ,
          .sdr_req_ack        (app_req_ack        ) ,
          .sdr_busy_n         (app_busy_n         ) ,
          .sdr_wr_en_n        (app_wr_en_n        ) ,
          .sdr_wr_next        (app_wr_next_req    ) ,
          .sdr_rd_valid       (app_rd_valid       ) ,
          .sdr_last_rd        (app_last_rd        ) , 
          .sdr_wr_data        (app_wr_data        ) ,
          .sdr_rd_data        (app_rd_data        ) 

    ); 



	//=========================================================================
	sdrc_core 
		#(
		.SDR_DW(SDR_DW) , 
		.SDR_BW(SDR_BW)) 
		u_sdrc_core (
          .clk                (intf_master_controller.sdram_clk          ) ,
          .pad_clk            (sdram_pad_clk      ) ,
          .reset_n            (intf_master_controller.sdram_resetn	         ) ,
          .sdr_width          (intf_master_controller.cfg_sdr_width      ) ,
          .cfg_colbits        (intf_master_controller.cfg_colbits        ) ,

 		/* Request from whisbone */
          .app_req            (app_req            ) ,// Transfer Request
          .app_req_addr       (app_req_addr       ) ,// SDRAM Address
          .app_req_len        (app_req_len        ) ,// Burst Length (in 16 bit words)
          .app_req_wrap       (1'b0               ) ,// Wrap mode request 
          .app_req_wr_n       (app_req_wr_n       ) ,// 0 => Write request, 1 => read req
          .app_req_ack        (app_req_ack        ) ,// Request has been accepted
		  .cfg_req_depth      (intf_master_controller.cfg_req_depth      ) ,//how many req. buffer should hold
          .app_wr_data        (app_wr_data        ) ,
          .app_wr_en_n        (app_wr_en_n        ) ,
          .app_rd_data        (app_rd_data        ) ,
          .app_rd_valid       (app_rd_valid       ) ,
		  .app_last_rd        (app_last_rd        ) ,
          .app_last_wr        (			          ) , // no se usa 
          .app_wr_next_req    (app_wr_next_req    ) ,
          .sdr_init_done      (intf_master_controller.sdr_init_done      ) ,
          .app_req_dma_last   (app_req            ) ,
 
 		/* Interface to SDRAMs */
          .sdr_cs_n           (sdr_cs_n           ) ,
          .sdr_cke            (sdr_cke            ) ,
          .sdr_ras_n          (sdr_ras_n          ) ,
          .sdr_cas_n          (sdr_cas_n          ) ,
          .sdr_we_n           (sdr_we_n           ) ,
          .sdr_dqm            (sdr_dqm            ) ,
          .sdr_ba             (sdr_ba             ) ,
          .sdr_addr           (sdr_addr           ) , 
          .pad_sdr_din        (pad_sdr_din        ) ,
          .sdr_dout           (sdr_dout           ) ,
          .sdr_den_n          (sdr_den_n          ) ,
 
 		/* Parameters */
          .cfg_sdr_en         (intf_master_controller.cfg_sdr_en         ) ,
          .cfg_sdr_mode_reg   (intf_master_controller.cfg_sdr_mode_reg   ) ,
          .cfg_sdr_tras_d     (intf_master_controller.cfg_sdr_tras_d     ) ,
          .cfg_sdr_trp_d      (intf_master_controller.cfg_sdr_trp_d      ) ,
          .cfg_sdr_trcd_d     (intf_master_controller.cfg_sdr_trcd_d     ) ,
          .cfg_sdr_cas        (intf_master_controller.cfg_sdr_cas        ) ,
          .cfg_sdr_trcar_d    (intf_master_controller.cfg_sdr_trcar_d    ) ,
          .cfg_sdr_twr_d      (intf_master_controller.cfg_sdr_twr_d      ) ,
          .cfg_sdr_rfsh       (intf_master_controller.cfg_sdr_rfsh       ) ,
          .cfg_sdr_rfmax      (intf_master_controller.cfg_sdr_rfmax      ) 
	);	

	//***************************//
	// Assertions for SDRAM Init //
	//***************************//
		
	sequence nop_seq;
		 ((sdr_cs_n) && (sdr_ras_n) && (sdr_cas_n) && (sdr_we_n) );
	endsequence
	
	sequence precharge;
		##2 ((~sdr_cs_n) && (~sdr_ras_n) && (sdr_cas_n) && (~sdr_we_n)) ##1 nop_seq;
	endsequence
	
	sequence auto_refresh;
		((~sdr_cs_n) && (~sdr_ras_n) && (~sdr_cas_n) && (sdr_we_n) );
	endsequence
	
	sequence t_RFC;
		(##7 auto_refresh ##1 nop_seq) [*14];
	endsequence

	sequence Load_Mode_Register;
		##8 ((~sdr_cs_n) && (~sdr_ras_n) && (~sdr_cas_n) && (~sdr_we_n) );
	endsequence
	
	sequence Init_Memory;
		##1 nop_seq ##8 intf_master_controller.sdr_init_done;
	endsequence

	property memory_init_prop;
		@ (posedge intf_master_controller.sdram_clk )
		// disable iff (intf_master_controller.sdr_init_done)
		 intf_master_controller.sdram_resetn |-> nop_seq |-> precharge |-> ##3 auto_refresh |-> ##1 nop_seq |-> ##1 t_RFC |-> Load_Mode_Register |-> Init_Memory;
	endproperty
	

	memory_init_prop_assert  : assert property (memory_init_prop) $display("@%0dns Assertion Correct - Memory Initialized", $time); else  $display("@%0dns Assertion Failed", $time);



endmodule










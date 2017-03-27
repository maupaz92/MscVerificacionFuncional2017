
// ruta de las instancias hasta el DUV para obtener las señales del mismo
`define TOP_PATH  testbench_top.DUV


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
	
	//************************************************************************************
	//************************************************************************************
	// wishbone assertions 
	//************************************************************************************
	//************************************************************************************

	//------start--rule 3.00 & 3.05 & 3.10----------------------
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
	//------finish--rule 3.00 & 3.05 & 3.10---------------------

	
	
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

	//------finish-----rule 3.25-----------------------------

	
	//************************************************************************************
	//************************************************************************************
	// SDRAM assertions 
	//************************************************************************************
	//************************************************************************************
	
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
		##1 nop_seq ##8 sdr_init_done;
	endsequence

	property memory_init_prop;
		@ (posedge sdram_clk )
		// disable iff (sdr_init_done)
		 sdram_resetn |-> nop_seq |-> precharge |-> ##3 auto_refresh |-> ##1 nop_seq |-> ##1 t_RFC |-> Load_Mode_Register |-> Init_Memory;
	endproperty
	

	memory_init_prop_assert  : assert property (memory_init_prop) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ @%0dns Assertion Correct - Memory Initialized\n\n\n", $time); 
	else  $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ @%0dns Assertion Failed\n\n\n", $time);


endinterface







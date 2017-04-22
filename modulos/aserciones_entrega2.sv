// modulo de clock

//`timescale 1ns/1ps

module aserciones_entrega2(assertion_interface white_box_intf);

	
	//************************************************************************************
	//************************************************************************************
	// wishbone assertions 
	//************************************************************************************
	//************************************************************************************

	//------start--rule 3.00 & 3.05 & 3.10----------------------
	sequence a;
		//Paginas 31 & 32 del wisbone b4 Spec
		white_box_intf.reset ##1 (white_box_intf.reset & ~white_box_intf.stb) [*1:$] ##1 (~white_box_intf.reset & ~white_box_intf.stb);
	endsequence 
	  
	property Prueba1;
		@ (posedge white_box_intf.clk)
			$rose(white_box_intf.reset) |-> a;
	endproperty


	assert property (Prueba1) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO REGLA DE INICIALIZACION 3.00 3.05 3.10\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO REGLA DE INICIALIZACION 3.00 3.05 3.10\n\n\n");
	//------finish--rule 3.00 & 3.05 & 3.10---------------------
	
	
	//------start-----rule 3.25---------------------------------
	//----Single Write---
	sequence b;
		//Classic standard SINGLE WRITE Cycle, Pag43 del wishbone b4 Spec
		(white_box_intf.we & white_box_intf.cyc & white_box_intf.stb) [*1:$] ##1 $fell(white_box_intf.stb & white_box_intf.cyc); 
	endsequence

	property Prueba2;
		@ (posedge white_box_intf.clk)
			//empieza con el flanco positivo de we y stb simultaneo
			$rose(white_box_intf.we & white_box_intf.stb) |-> b; 
	endproperty

	assert property (Prueba2) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SE CUMPLIO LA REGLA 3.25 en SINGLE WRITE\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO LA REGLA 3.25 en SINGLE WRITE\n\n\n");
	
	
	//----Single Read----
	sequence c;
		//Classic standard SINGLE WRITE Cycle, Pag43 del wishbone b4 Spec
		(~white_box_intf.we & white_box_intf.cyc & white_box_intf.stb) [*1:$] ##1 $fell(white_box_intf.stb & white_box_intf.cyc); 
	endsequence

	property Prueba3;
		@ (posedge white_box_intf.clk)
			//empieza con el flanco positivo de we y stb simultaneo
			$rose(white_box_intf.stb) && $fell(white_box_intf.we) |-> c; 
	endproperty

	assert property (Prueba3) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SE CUMPLIO LA REGLA 3.25 en SINGLE READ\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO LA REGLA 3.25 en SINGLE READ\n\n\n");

	//------finish-----rule 3.25-----------------------------
	
	
	
	//-----start----rule 3.35-------------------------
	sequence d;
		//Classic standard SINGLE WRITE Cycle, Pag43 del wishbone b4 Spec
		##1 white_box_intf.ack; 
	endsequence

	property Prueba4;
		@ (posedge white_box_intf.clk)
			//empieza con el flanco positivo de we y stb simultaneo
			$rose(white_box_intf.stb) && $rose(white_box_intf.cyc) |-> d; 
	endproperty

	assert property (Prueba4) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SE CUMPLIO LA REGLA 3.35\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO LA REGLA 3.35\n\n\n");

	
	
	//************************************************************************************
	//************************************************************************************
	// SDRAM assertions 
	//************************************************************************************
	//************************************************************************************	
	
	sequence nop_seq;
		 ((white_box_intf.sdr_cs_n) & (white_box_intf.sdr_ras_n) & (white_box_intf.sdr_cas_n) & (white_box_intf.sdr_we_n) );
	endsequence
	
	sequence precharge;
		##2 ((~white_box_intf.sdr_cs_n) & (~white_box_intf.sdr_ras_n) & (white_box_intf.sdr_cas_n) & (~white_box_intf.sdr_we_n)) ##1 nop_seq;
	endsequence
	
	sequence auto_refresh;
		((~white_box_intf.sdr_cs_n) & (~white_box_intf.sdr_ras_n) & (~white_box_intf.sdr_cas_n) & (white_box_intf.sdr_we_n) );
	endsequence
	
	sequence t_RFC;
		(##7 auto_refresh ##1 nop_seq) [*1:$];
	endsequence

	sequence Load_Mode_Register;
		##8 ((~white_box_intf.sdr_cs_n) & (~white_box_intf.sdr_ras_n) & (~white_box_intf.sdr_cas_n) & (~white_box_intf.sdr_we_n) );
	endsequence
	
	sequence Init_Memory;
		##1 nop_seq ##8 white_box_intf.sdr_init_done;
	endsequence
	
	sequence master_sequence;
		##505 nop_seq ##0 precharge ##3 auto_refresh ##1 nop_seq ##1 t_RFC ##0 Load_Mode_Register ##0 Init_Memory ;
	endsequence

	property memory_init_prop;
		@ (posedge white_box_intf.sdram_clk )
			$rose(white_box_intf.sdram_resetn) |-> master_sequence  ;
	endproperty
	

	memory_init_prop_assert  : assert property (memory_init_prop) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ @%0dns Assertion Correct - Memory Initialized\n\n\n", $time); 
	else  $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ @%0dns Assertion Failed - Memory Not Initialized\n\n\n", $time);
	
	
	
	
	

endmodule 
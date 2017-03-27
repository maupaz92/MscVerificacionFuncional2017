
// ruta de las instancias hasta el DUV para obtener las señales del mismo
`define TOP_PATH  testbench_top.DUV


interface assertion_interface;

	logic clk;
	logic reset;
	logic stb;
	logic we;
	logic sel;
	logic ack;
	logic cyc;
	
	
	assign clk 		= `TOP_PATH.wb_clk_i;
	assign reset 	= `TOP_PATH.wb_rst_i;
	assign stb 		= `TOP_PATH.wb_stb_i;
	assign we		= `TOP_PATH.wb_we_i;
	assign sel 		= `TOP_PATH.wb_sel_i;
	assign ack		= `TOP_PATH.wb_ack_o;
	assign cyc		= `TOP_PATH.wb_cyc_i;
	
	
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


	assert property (Prueba1) $display("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO REGLA DE INICIALIZACION 3.00 3.05 3.10");
	else $error ("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO REGLA DE INICIALIZACION 3.00 3.05 3.10");
	//------finish--rule 3.00 & 3.05 & 3.10---------------------

	
	
	//------start-----rule 3.25---------------------------------
	//----Single Write---
	sequence b;
		//Classic standard SINGLE WRITE Cycle, Pag43 del wishbone b4 Spec
		(we & cyc & stb) ##1 (we & ack & cyc & stb) ##1 (~stb & ~cyc & ~ack); 
	endsequence

	property Prueba2;
		@ (posedge clk)
			//empieza con el flanco positivo de we y stb simultaneo
			$rose(we & stb) |-> b; 
	endproperty

	assert property (Prueba2) $display("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SE CUMPLIO LA REGLA 3.25 en SINGLE WRITE");
	else $error ("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO LA REGLA 3.25 en SINGLE WRITE");
	
	
	//----Single Read----
	sequence c;
		//Classic standard SINGLE WRITE Cycle, Pag43 del wishbone b4 Spec
		(~we & cyc & stb) ##1 (~we & ack & cyc & stb) ##1 (~stb & ~cyc & ~ack); 
	endsequence

	property Prueba3;
		@ (posedge clk)
			//empieza con el flanco positivo de we y stb simultaneo
			$rose(stb) && $fell(we) |-> c; 
	endproperty

	assert property (Prueba3) $display("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SE CUMPLIO LA REGLA 3.25 en SINGLE READ");
	else $error ("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO LA REGLA 3.25 en SINGLE READ");

	//------finish-----rule 3.25-----------------------------

	
	//************************************************************************************
	//************************************************************************************
	// SDRAM assertions 
	//************************************************************************************
	//************************************************************************************
	

endinterface










module aserciones_8_16_32(assertion_interface white_box_intf);


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
	logic clk;
	
	assign app_rd_data = white_box_intf.app_rd_data;
	assign mem_rd_data = white_box_intf.x2a_rddt;
	assign app_wr_data = white_box_intf.app_wr_data;
	assign mem_wr_data = white_box_intf.a2x_wrdt;
	assign read_count = white_box_intf.rd_xfr_count;
	assign write_count = white_box_intf.wr_xfr_count;
	assign sdr_width = white_box_intf.sdr_width;	
	assign x2a_wrstart = white_box_intf.x2a_wrstart;
	assign x2a_wrlast = white_box_intf.x2a_wrlast;
	assign x2a_rdlast = white_box_intf.x2a_rdlast;
	assign x2a_rdok = white_box_intf.x2a_rdok;
	assign x2a_wrnext = white_box_intf.x2a_wrnext;
	assign app_wr_next = white_box_intf.app_wr_next;
	assign app_rd_valid = white_box_intf.app_rd_valid;
	assign clk = white_box_intf.clk;
	
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------------------------	
//------------------------Memoria de 32bits-----------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------	



`ifdef SDR_32BIT
	
	
	
	sequence xa;
			((mem_wr_data == app_wr_data) && (app_rd_data==mem_rd_data)) [=1];//  && (app_wr_next==x2a_wrnext)  && (app_rd_valid==x2a_rdok)
		endsequence 

	property write_read_32bits;
			@ (posedge clk)
				$rose(x2a_wrlast) || $rose(x2a_rdlast) |-> xa; //| $rose(x2a_rdlast)
		endproperty

x32_bit_prueba_rd_wr: assert property (write_read_32bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++  FUNCIONANDO READ-WRITE EN 32BITS\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO FUNCIONANDO READ-WRITE EN 32BITS\n\n\n");	
	

	
	
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------------------------	
//------------------------Memoria de 16bits-----------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------	
`elsif SDR_16BIT

		covergroup x16_rd_wr_counts @(posedge clk);
		x16_wr_count: coverpoint write_count{
			bins x16_wr_count_bin = {2'b01, 2'b10};		//evalua el conteo de writes
			}
		
		x16_rd_count: coverpoint read_count{
			bins x16_rd_count_bin = {2'b01, 2'b10};			//evalua el conteo de reads
			}
	
		endgroup	



//----------CHEQUEO DE WR_COUNT:  -------------- CASO 16Bits
//Si x2a_wrlast, el wr_count debe estar en 0. Sino, y x2a_wrnext, wr debe contar +1  
//Esto se puede hacer con una asertion



//-----para iniciarlizar la cuenta
	sequence a;
			(write_count==0);
		endsequence 

	property x16write_count_0;
			@ (posedge clk)
				(x2a_wrlast) |-> a;
		endproperty

x16_wr_count_0:	assert property (x16write_count_0) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");	

//------------para contar +1 
	
	//PARA EL CASO DE 16BITS
		sequence z;
			(write_count==1) ##1 (write_count==2); //Para 16 bits se necesitan 2 cuentas
		endsequence 

		property x16write_count_plus1;
			@ (posedge clk)
				(x2a_wrnext) |-> z;
		endproperty

x16_write_countplus1:		assert property (x16write_count_plus1) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");

	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");	
	
		
	

	
	
	
	 
	
// ----------CHEQUEO DE ESCRITURA (8/16)------------CASO 16Bits
//Cuando wr_xfr_count[0]=1  a2x_wrdt tiene [31:16], sino, tiene [15:0] (caso 16bits)

	sequence ad;
			(app_wr_data[31:16] == mem_wr_data) [=1];
		endsequence 
	sequence ae;
			(app_wr_data[15:0] == mem_wr_data) [=1];		
		endsequence 
	property write1_16bits;
			@ (posedge clk)
				(write_count==2'b01) |-> ad;
		endproperty
		
	property write2_16bits;
			@ (posedge clk)
				(write_count!=2'b01) |-> ae;
		endproperty


wr1_16bits:	assert property (write1_16bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++  SE PASO LA PRIMER TRAMA DE 16bits\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE PASO LA PRIMER TRAMA DE 16bits\n\n\n");
	
wr2_16bits:	assert property (write2_16bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++  SE PASO LA SEGUNDA TRAMA DE 16bits\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE PASO LA SEGUNDA TRAMA DE 16bits\n\n\n");

	

// ----------CHEQUEO DE RD_COUNT:  --------------CASO 16Bits
//Si x2a_rdlast, el wr_count debe estar en 0. Sino, y x2a_rdok, read_count debe contar +1  
//Esto se puede hacer con una asertion


//-----para iniciarlizar la cuenta
	sequence h;
			(read_count==0);
		endsequence 

	property x16read_count_0;
			@ (posedge clk)
				(x2a_rdlast) |-> h;
		endproperty

x16_read_count:	assert property (x16read_count_0) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE RD_COUNT\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE RD_COUNT\n\n\n");	

//------------para contar +1 
	
	sequence i;
			(read_count==1) ##1 (read_count==2) ##1 (read_count==3) ##1 (read_count==4); //Para 16 bits se necesitan 2 cuentas
		endsequence 

	property x16read_count_plus1;
			@ (posedge clk)
				(x2a_rdok) |-> i;
		endproperty

x16_read_countplus1:	assert property (x16read_count_plus1) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");	
	
 
 
 

// ----------CHEQUEO LECTURA ------------CASO 16Bits
	
//  if(x2a_rdok) begin
//	   if(sdr_width == 2'b01) // 16 Bit SDR Mode
//	      saved_rd_data[15:0]  <= x2a_rddt;
//	    end
//			
 //app_rd_data = {x2a_rddt,saved_rd_data[15:0]}; ----> codigo original
 
 
 sequence ai;
			(app_rd_data[15:0] == mem_rd_data); //Para 16 bits se necesitan 2 cuentas
		endsequence 

	property read_16bits;
			@ (posedge clk)
				(x2a_rdok) |-> ai;
		endproperty

x16_read:	assert property (read_16bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO LA	LECTURA\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO LA LECTURA\n\n\n");	
 	
	
	
	
	
	
	
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------------------------	
//------------------------Memoria de 8bits-----------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------	

`else   //Caso de 8bits

		covergroup x8_rd_wr_counts @(posedge clk);
		x8_wr_count: coverpoint write_count{
			bins x8_wr_count_bin = {2'b01, 2'b10, 2'b11};		//evalua el conteo de writes
			}
		
		x8_rd_count: coverpoint read_count{
			bins x8_rd_count_bin = {2'b01, 2'b10, 2'b11};			//evalua el conteo de reads
			}
	
		endgroup	




// ----------CHEQUEO DE WR_COUNT:  -------------- CASO 8Bits
//Si x2a_wrlast, el wr_count debe estar en 0. Sino, y x2a_wrnext, wr debe contar +1  
//Esto se puede hacer con una asertion


	//PARA EL CASO DE 8 BITS
//-----para iniciarlizar la cuenta
		sequence b;
				(write_count==0);
			endsequence 

		property x8write_count_0;
				@ (posedge clk)
					(x2a_wrlast) |-> b;
			endproperty

x8_wr_count0:		assert property (x8write_count_0) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO INICIAL DE WR_COUNT\n\n\n");
		else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO INICIAL DE WR_COUNT\n\n\n");	
		

		sequence c;
			(write_count==1) ##1 (write_count==2) ##1 (write_count==3) ##1 (write_count==0); //Para 8 bits se necesitan 4 cuentas
		endsequence 

		property x8write_count_plus1;
			@ (posedge clk)
				(x2a_wrstart) |-> c;
		endproperty

x8_wr_countplus1:		assert property (x8write_count_plus1) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");

		else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");
	
	

// ----------CHEQUEO DE ESCRITURA (8/16)------------CASO 8Bits
//Cuando wr_xfr_count[0]=1  a2x_wrdt tiene [31:16], sino, tiene [15:0] (caso 16bits)
	
	sequence bd;
			(app_wr_data[31:24] == mem_wr_data) [=1];
		endsequence 
	

	property write1_8bits;
			@ (posedge clk)
				(write_count==2'b11) |-> bd;
		endproperty
	
//---------------------------------------	
		
	sequence be;
			(app_wr_data[23:16] == mem_wr_data) [=1];			
		endsequence
		
	property write2_8bits;
			@ (posedge clk)
				(write_count==2'b10) |-> be;
		endproperty
		
//---------------------------------------

	
	sequence bx;
			(app_wr_data[15:8] == mem_wr_data) [=1];			
		endsequence
		
	property write3_8bits;
			@ (posedge clk)
				(write_count==2'b01) |-> bx;
		endproperty
//---------------------------------------

	sequence bz;
			(app_wr_data[7:0] == mem_wr_data) [=1];			
		endsequence
		
	property write4_8bits;
			@ (posedge clk)
				(write_count==2'b00) |-> bz;
		endproperty		

		

x8_wr1:	assert property (write1_8bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++  SE PASO LA PRIMER TRAMA DE 16bits\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE PASO LA PRIMER TRAMA DE 16bits\n\n\n");
	
x8_wr2:	assert property (write2_8bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++  SE PASO LA SEGUNDA TRAMA DE 16bits\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE PASO LA SEGUNDA TRAMA DE 16bits\n\n\n");

x8_wr3:	assert property (write3_8bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++  SE PASO LA TERCER TRAMA DE 16bits\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE PASO LA TERCER TRAMA DE 16bits\n\n\n");
	
x8_wr4:	assert property (write4_8bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++  SE PASO LA CUARTA TRAMA DE 16bits\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE PASO LA CUARTA TRAMA DE 16bits\n\n\n");
	


// ----------CHEQUEO DE RD_COUNT:  --------------CASO 8Bits
//Si x2a_rdlast, el wr_count debe estar en 0. Sino, y x2a_rdok, read_count debe contar +1  
//Esto se puede hacer con una asertion

	sequence ah;
			(read_count==0);
		endsequence 

	property read_count_0;
			@ (posedge clk)
				(x2a_rdlast) |-> ah;
		endproperty

x8_rd_count0:	assert property (read_count_0) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO INICIAL DE RD_COUNT\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO INICIAL DE RD_COUNT\n\n\n");	

//------------para contar +1 
	
	sequence ai;
			(read_count==1) ##1 (read_count==2) ##1 (read_count==3); //Para 8 bits se necesitan 3 cuentas
		endsequence 

	property x8read_count_plus1;
			@ (posedge clk)
				(x2a_rdok) |-> ai;
		endproperty

x8_rd_countplus1:	assert property (x8read_count_plus1) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");	
	

	// ----------CHEQUEO LECTURA------------CASO 8Bits
 //if(x2a_rdok) begin
//	   if(sdr_width == 2'b01) // 16 Bit SDR Mode
//	      saved_rd_data[15:0]  <= x2a_rddt;
//            else begin// 8 bit SDR Mode - 
	//       if(rd_xfr_count[1:0] == 2'b00)      saved_rd_data[7:0]   <= x2a_rddt[7:0];
	  //     else if(rd_xfr_count[1:0] == 2'b01) saved_rd_data[15:8]  <= x2a_rddt[7:0];
	    //   else if(rd_xfr_count[1:0] == 2'b10) saved_rd_data[23:16] <= x2a_rddt[7:0];
	   // end
	

 
	sequence ci;
			(app_rd_data[7:0] == mem_rd_data); 
		endsequence 

	property read1_8bits;
			@ (posedge clk)
				(read_count[1:0] == 2'b00) |-> ci;
		endproperty

//------------------------------------------------------------------------	
	
	sequence di;
			(app_rd_data[15:8]  <= mem_rd_data); 
		endsequence 

	property read2_8bits;
			@ (posedge clk)
				(read_count[1:0] == 2'b01) |-> di;
		endproperty
//--------------------------------------------------------------------		
	
	sequence ei;
			(app_rd_data[23:16] <= mem_rd_data); //Para 16 bits se necesitan 2 cuentas
		endsequence 

	property read3_8bits;
			@ (posedge clk)
				(read_count[1:0] == 2'b10) |-> ei;
		endproperty
		
		
		
x8_read:	assert property (read3_8bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO LA	LECTURA\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO LA LECTURA\n\n\n");	
 
	


 
 
 
 
 
 
 
 
 
 
 
 



// -------MONITOREO DE sdr_widt CUANDO SDR_32BIT/16/8-------------

//	cover_sdr_width: coverpoint sdr_width;
		

		
		
	
	
 `endif

endmodule 	
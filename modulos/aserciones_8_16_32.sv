


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
	
	assign app_rd_data[31:0] = white_box_intf.app_rd_data[31:0];
	assign mem_rd_data[31:0] = white_box_intf.x2a_rddt[31:0];
	assign app_wr_data[31:0] = white_box_intf.app_wr_data[31:0];
	assign mem_wr_data[31:0] = white_box_intf.a2x_wrdt[31:0];
	assign read_count[1:0] = white_box_intf.rd_xfr_count[1:0];
	assign write_count[1:0] = white_box_intf.wr_xfr_count[1:0];
	assign sdr_width[1:0] = white_box_intf.sdr_width[1:0];	
	assign x2a_wrstart = white_box_intf.x2a_wrstart;
	assign x2a_wrlast = white_box_intf.x2a_wrlast;
	assign x2a_rdlast = white_box_intf.x2a_rdlast;
	assign x2a_rdok = white_box_intf.x2a_rdok;
	assign x2a_wrnext = white_box_intf.x2a_wrnext;
	assign app_wr_next = white_box_intf.app_wr_next;
	assign app_rd_valid = white_box_intf.app_rd_valid;
	
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------------------------	
//------------------------Memoria de 32bits-----------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------	
	
	
	
	
	sequence xa;
			(mem_wr_data==app_wr_data) && (app_wr_next==x2a_wrnext) && (app_rd_data==mem_rd_data) && (app_rd_valid==x2a_rdok);
		endsequence 

	property write_read_32bits;
			@ (posedge clk)
				(sdr_width == 2'b00) |-> xa;
		endproperty

	assert property (write_read_32bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++  FUNCIONANDO READ-WRITE EN 32BITS\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO FUNCIONANDO READ-WRITE EN 32BITS\n\n\n");	
	

//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------------------------	
//------------------------Memoria de 16bits-----------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------	



/* ----------CHEQUEO DE WR_COUNT:  -------------- CASO 16Bits
Si x2a_wrlast, el wr_count debe estar en 0. Sino, y x2a_wrnext, wr debe contar +1  */
//Esto se puede hacer con una asertion



//-----para iniciarlizar la cuenta
	sequence a;
			(write_count==0);
		endsequence 

	property x16write_count_0;
			@ (posedge clk)
				(x2a_wrlast) |-> a;
		endproperty

	assert property (x16write_count_0) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");	

//------------para contar +1 
	
	//PARA EL CASO DE 16BITS
		sequence z;
			(write_count==1) ##1 (wr_count==2); //Para 16 bits se necesitan 2 cuentas
		endsequence 

		property x16write_count_plus1;
			@ (posedge clk)
				(x2a_wrnext) |-> z;
		endproperty

		assert property (x16write_count_plus1) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");

	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");	
	
		
	

	
	
	
	 
	
/* ----------CHEQUEO DE ESCRITURA (8/16)------------CASO 16Bits
Cuando wr_xfr_count[0]=1  a2x_wrdt tiene [31:16], sino, tiene [15:0] (caso 16bits)*/

	sequence ad;
			(app_wr_data[31:16] == mem_wr_data) [=1];
		endsequence 
	sequence ae;
			(app_wr_data[15:0] == mem_wr_data) [=1];		

	property write1_16bits;
			@ (posedge clk)
				(write_count==2'b01) |-> ad;
		endproperty
		
	property write2_16bits;
			@ (posedge clk)
				(write_count!=2'b01) |-> ae;
		endproperty


	assert property (write1_16bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++  SE PASO LA PRIMER TRAMA DE 16bits\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE PASO LA PRIMER TRAMA DE 16bits\n\n\n");
	
	assert property (write2_16bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++  SE PASO LA SEGUNDA TRAMA DE 16bits\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE PASO LA SEGUNDA TRAMA DE 16bits\n\n\n");

	

/* ----------CHEQUEO DE RD_COUNT:  --------------CASO 16Bits
Si x2a_rdlast, el wr_count debe estar en 0. Sino, y x2a_rdok, read_count debe contar +1  */
//Esto se puede hacer con una asertion


//-----para iniciarlizar la cuenta
	sequence h;
			(read_count==0);
		endsequence 

	property x16read_count_0;
			@ (posedge clk)
				(x2a_rdlast) |-> h;
		endproperty

	assert property (x16read_count_0) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE RD_COUNT\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE RD_COUNT\n\n\n");	

//------------para contar +1 
	
	sequence i;
			(read_count==1) ##1 (read_count==2) ##1 (read_count==3) ##1 (read_count==4); //Para 16 bits se necesitan 2 cuentas
		endsequence 

	property x16read_count_plus1;
			@ (posedge clk)
				(x2a_rdok) |-> i;
		endproperty

	assert property (x16read_count_plus1) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");	
	
 
 
 

/* ----------CHEQUEO LECTURA ------------CASO 16Bits
/*
  if(x2a_rdok) begin
	   if(sdr_width == 2'b01) // 16 Bit SDR Mode
	      saved_rd_data[15:0]  <= x2a_rddt;
	    end
*/		
 //app_rd_data = {x2a_rddt,saved_rd_data[15:0]}; ----> codigo original
 
 
 sequence ai;
			(saved_rd_data[15:0] == x2a_rddt); //Para 16 bits se necesitan 2 cuentas
		endsequence 

	property read_16bits;
			@ (posedge clk)
				(x2a_rdok) |-> ai;
		endproperty

	assert property (read_16bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO LA	LECTURA\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO LA LECTURA\n\n\n");	
 	
	
	
	
	
	
	
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------		
//----------------------------------------------------------------------------------------------------------------	
//------------------------Memoria de 8bits-----------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------	
//----------------------------------------------------------------------------------------------------------------	


/* ----------CHEQUEO DE WR_COUNT:  -------------- CASO 8Bits
Si x2a_wrlast, el wr_count debe estar en 0. Sino, y x2a_wrnext, wr debe contar +1  */
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

		assert property (x8write_count_0) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");
		else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");	
		

		sequence c;
			(write_count==1) ##1 (write_count==2) ##1 (write_count==3) ##1 (write_count==0); //Para 8 bits se necesitan 4 cuentas
		endsequence 

		property x8write_count_plus1;
			@ (posedge clk)
				(x2a_wrstart) |-> c;
		endproperty

		assert property (x8write_count_plus1) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");

		else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");
	
	

/* ----------CHEQUEO DE ESCRITURA (8/16)------------CASO 8Bits
Cuando wr_xfr_count[0]=1  a2x_wrdt tiene [31:16], sino, tiene [15:0] (caso 16bits)*/	
	
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
		
	property write2_8bits;
			@ (posedge clk)
				(write_count==2'b10) |-> be;
		endproperty
		
//---------------------------------------

	
	sequence bx;
			(app_wr_data[15:8] == mem_wr_data) [=1];			
		
	property write3_8bits;
			@ (posedge clk)
				(write_count==2'b01) |-> bx;
		endproperty
//---------------------------------------

	sequence bz;
			(app_wr_data[7:0] == mem_wr_data) [=1];			
		
	property write4_8bits;
			@ (posedge clk)
				(write_count==2'b00) |-> bz;
		endproperty		

		

	assert property (write1_8bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++  SE PASO LA PRIMER TRAMA DE 16bits\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE PASO LA PRIMER TRAMA DE 16bits\n\n\n");
	
	assert property (write2_8bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++  SE PASO LA SEGUNDA TRAMA DE 16bits\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE PASO LA SEGUNDA TRAMA DE 16bits\n\n\n");

	assert property (write3_8bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++  SE PASO LA TERCER TRAMA DE 16bits\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE PASO LA TERCER TRAMA DE 16bits\n\n\n");
	
	assert property (write4_8bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++  SE PASO LA CUARTA TRAMA DE 16bits\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE PASO LA CUARTA TRAMA DE 16bits\n\n\n");
	


/* ----------CHEQUEO DE RD_COUNT:  --------------CASO 8Bits
Si x2a_rdlast, el wr_count debe estar en 0. Sino, y x2a_rdok, read_count debe contar +1  */
//Esto se puede hacer con una asertion

	sequence ah;
			(x8read_count==0);
		endsequence 

	property read_count_0;
			@ (posedge clk)
				(x2a_rdlast) |-> ah;
		endproperty

	assert property (x8read_count_0) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE RD_COUNT\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE RD_COUNT\n\n\n");	

//------------para contar +1 
	
	sequence ai;
			(read_count==1) ##1 (read_count==2) ##1 (read_count==3); //Para 8 bits se necesitan 3 cuentas
		endsequence 

	property x8read_count_plus1;
			@ (posedge clk)
				(x2a_rdok) |-> ai;
		endproperty

	assert property (x8read_count_plus1) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO EL CONTEO DE WR_COUNT\n\n\n");	
	

/* ----------CHEQUEO LECTURA------------CASO 8Bits
 if(x2a_rdok) begin
	   if(sdr_width == 2'b01) // 16 Bit SDR Mode
	      saved_rd_data[15:0]  <= x2a_rddt;
            else begin// 8 bit SDR Mode - 
	       if(rd_xfr_count[1:0] == 2'b00)      saved_rd_data[7:0]   <= x2a_rddt[7:0];
	       else if(rd_xfr_count[1:0] == 2'b01) saved_rd_data[15:8]  <= x2a_rddt[7:0];
	       else if(rd_xfr_count[1:0] == 2'b10) saved_rd_data[23:16] <= x2a_rddt[7:0];
	    end
 */

 
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

	property read2_8bits;
			@ (posedge clk)
				(read_count[1:0] == 2'b10) |-> ei;
		endproperty
		
		
		
	assert property (read2_8bits) $display("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  SI SE CUMPLIO LA	LECTURA\n\n\n");
	else $error ("\n\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  NO SE CUMPLIO LA LECTURA\n\n\n");	
 
	


 
 
 
 
 
 
 
 
 
 
 
 
 



/* -------MONITOREO DE sdr_widt CUANDO SDR_32BIT/16/8-------------*/

	cover_sdr_width: coverpoint sdr_width;
		
		
	

		
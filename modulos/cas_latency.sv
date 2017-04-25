module cas_latency(assertion_interface white_box_intf
	);
	
	//Verificacion de solicitud de lectura

	logic enable_cas_flag;

	
	assign enable_cas_flag  = (white_box_intf.cas_latency == 3'h2) ? 1'b1 : 1'b0;			//1 cuando es CAS 2
		
//Cobertura cuando de que CAS sea 2 o 3	
	covergroup cas_verif @(posedge white_box_intf.sdram_clk);
		cov_Cfg_sdr_cas_cas: coverpoint white_box_intf.cas_latency{
			bins sdr_cas = {3'h2, 3'h3};							//Evalua configuracion de CAS Latency que se diera ambos casos
			}
		
		cov_CfgMode_reg_cas: coverpoint white_box_intf.sdram_mode_reg{
			bins mode_reg_cas2 = {13'h023, 13'h033};			//Evalua configuracion de Mode reg que sucesiera ambos casos
			}
	
	endgroup	

	// covergroup instance
	cas_verif cas_verif_inst = new;	
	
	//Verificacion de configuracion de registros
	property verf_cas2;
		@(posedge white_box_intf.clk) disable iff(~enable_cas_flag)
		((white_box_intf.sdram_mode_reg == 13'h23));
	endproperty
	
	property verf_cas3;
		@(posedge white_box_intf.clk) disable iff(enable_cas_flag)
		((white_box_intf.sdram_mode_reg == 13'h33));
	endproperty
	
	assert_verf_cas2: assert property (verf_cas2) else $error("verf_cas2 error");					//Evalua configuracion del registro cas cuando es igual a 2
	
	assert_verf_cas3: assert property (verf_cas3) else $error("verf_cas3 error");					//Evalua configuracion del registro cas cuando es igual a 3
	
	//Verificacion de que el dato sea valido
	
	sequence read_ready;
		white_box_intf.x2a_rdok == 1'b1;
	endsequence
	
	sequence ack_data_verf;		
		(white_box_intf.data_read == 32'hzzzzzzzz);
	endsequence
	
	sequence data_valid;
		white_box_intf.app_rd_valid == 1'b1;
	endsequence
	
	property Dato_valido_Listo;
		@(posedge white_box_intf.clk)
		(data_valid |-> not ack_data_verf); 
	endproperty
	
	Cfg_cDato_listo3: assert property (Dato_valido_Listo) else $error("Dato_listo 3 error"); 		//Evalua que el dato este cuando se supone tiene que estar
	
	
	sequence app_rd_valid_verf;
		white_box_intf.app_rd_valid == white_box_intf.sdr_rd_valid;
	endsequence
	
	sequence app_rd_data_verf;
		white_box_intf.data_read == white_box_intf.sdr_rd_data;
	endsequence
	
	sequence cas_latency_verf;
		white_box_intf.cas_latency == white_box_intf.cfg_sdr_cas;
	endsequence
	
	sequence sdram_mode_reg_verf;
		white_box_intf.sdram_mode_reg == white_box_intf.cfg_sdr_mode_reg;
	endsequence
	
	
	
	property Senales_verf;
		@(posedge white_box_intf.clk)
		(app_rd_valid_verf |-> app_rd_data_verf |-> cas_latency_verf |-> sdram_mode_reg_verf); 
	endproperty
	
	Cfg_Verificacion_Senales: assert property (Senales_verf) else $error("Cfg_Verificacion_Senales 3 error"); //Evalua que el dato este cuando se supone tiene que estar
	

	//Verificacion de ciclos
	
	sequence cas2_verf;
		##4 read_ready;
	endsequence
	
	sequence cas3_verf;
		##5 read_ready;
	endsequence
	
	
	property ciclos_cas2;
		@(posedge white_box_intf.sdram_clk) disable iff(~enable_cas_flag)
		($rose(white_box_intf.rd_start)|-> cas2_verf); 
	endproperty
	
	
	Cfg_ciclos_cas2: assert property (ciclos_cas2) $display("Ciclos_listo exitoso");			//Evalua que el dato este cuando se supone tiene que estar
	else $error("Ciclos_listo 2 error");
	
	
	property ciclos_cas3;
		@(posedge white_box_intf.sdram_clk) disable iff(enable_cas_flag)
		($rose(white_box_intf.rd_start) |-> cas3_verf); 
	endproperty
	
	
	Cfg_ciclos_cas3: assert property (ciclos_cas3) $display("Ciclos_listo exitoso");			//Evalua que el dato este cuando se supone tiene que estar
	else $error("Ciclos_listo 3 error");
	
endmodule 	
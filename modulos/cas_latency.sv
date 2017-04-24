module cas_latency(assertion_interface white_box_intf
	);
	
	//Verificacion de solicitud de lectura

	logic Read_ack =  ~white_box_intf.sdr_cs_n & white_box_intf.sdr_ras_n & ~white_box_intf.sdr_cas_n & white_box_intf.sdr_we_n; 
	logic enable_cas_flag;
	logic sdram_mode_reg_23;
	logic sdram_mode_reg_33;
	
	
	
	
	
	assign enable_cas_flag  = (white_box_intf.cas_latency == 3'h2) ? 1'b1 : 1'b0;			//CAS 2 cuando es 1
	//assign sdram_mode_reg_23  = (white_box_intf.sdram_mode_reg == 13'h23) ? 1'b1 : 1'b0;
	//assign sdram_mode_reg_33  = (white_box_intf.sdram_mode_reg == 13'h33) ? 1'b1 : 1'b0;
		
//Cobertura cuando CAS es 2 o 3	
	covergroup cas_verif @(posedge white_box_intf.sdram_clk);
		cov_Cfg_sdr_cas_cas: coverpoint white_box_intf.cas_latency{
			bins sdr_cas = {3'h2, 3'h3};							//Evalua configuracion de CAS Latency
			}
		
		cov_CfgMode_reg_cas: coverpoint white_box_intf.sdram_mode_reg{
			bins mode_reg_cas2 = {13'h023, 13'h033};			//Evalua configuracion de Mode reg
			}
	
	endgroup	
	
	//Cobertura de que haya un read
	covergroup read_verif @(posedge white_box_intf.sdram_clk);
		cov_Cfg_read_ack_cas: coverpoint Read_ack{
			bins Read_ack_cas = {1};
			}
			
		cov_Cfg_x2a_rdok_cas: coverpoint white_box_intf.x2a_rdok{
			bins  x2a_rdok_cas = {1};
			}

	endgroup
	
	// covergroup instance
	cas_verif cas_verif_inst = new;
	read_verif cas_read_verif = new;

	
	property ciclos_cas2;
		@(negedge white_box_intf.clk) disable iff(~enable_cas_flag) 
		($rose(white_box_intf.x2a_rdok) |->  ##4 white_box_intf.app_rd_valid); 
	endproperty
	
	Cfg_ciclos_cas2: cover property (ciclos_cas2) $display("Ciclos Cas 2 exitoso");
	
	property ciclos_cas3;
		@(negedge white_box_intf.clk) disable iff(enable_cas_flag) 
		($rose(white_box_intf.x2a_rdok) |-> ##6 white_box_intf.app_rd_valid); 
	endproperty
	
	
	Cfg_ciclos_cas3: cover property (ciclos_cas3) $display("Ciclos Cas 3 exitoso");
	
	property verf_cas2;
		@(posedge white_box_intf.clk) disable iff(~enable_cas_flag)
		((white_box_intf.sdram_mode_reg == 13'h23));
	endproperty
	
	property verf_cas3;
		@(posedge white_box_intf.clk) disable iff(enable_cas_flag)
		((white_box_intf.sdram_mode_reg == 13'h33));
	endproperty
	
	assert_verf_cas2: assert property (verf_cas2) $display("Registro cfg Cas 2 exitoso");
	else $error("verf_cas2 error");
	
	assert_verf_cas3: assert property (verf_cas3) $display("Registro cfg Cas 3 exitoso");
	else $error("verf_cas3 error");
	
	
	
endmodule 	
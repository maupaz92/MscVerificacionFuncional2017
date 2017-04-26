module Banks_coverage(assertion_interface white_box_intf
	);

	logic [1:0] bank_requesed;

	/* **** Assertion: bank ready to write **** */
// seqeunce 
	sequence write_req;
		(white_box_intf.whbox_wren);
	endsequence
	
	sequence bank_ready;
		white_box_intf.whbox_bankready;
	endsequence
// assert 
	ReadyBankCh: assert property (@(posedge white_box_intf.sdram_clk) disable iff(~white_box_intf.sdram_resetn) (write_req |=> bank_ready)) else $display("bank into the SDRAM not ready to allow write request");

	cov_ReadyBank: cover property (@(posedge white_box_intf.sdram_clk) disable iff(~white_box_intf.sdram_resetn) (write_req |=> bank_ready));

	covergroup Cov_bank_value_verif @(posedge white_box_intf.sdram_clk);
		cov_bank_verif_value: coverpoint white_box_intf.whbox_bank{
			bins Bank_value = {2'h0, 2'h1, 2'h2, 2'h3};							//Evalua configuracion de CAS Latency que se diera ambos casos
			}
	endgroup

	//Banco solicitado
	always @ (posedge white_box_intf.clk) begin
		bank_requesed [1:0] <= (white_box_intf.cfg_colbits == 2'b00) ? {white_box_intf.sdr_addr[9:8]}   :
			  (white_box_intf.cfg_colbits == 2'b01) ? {white_box_intf.sdr_addr[10:9]}  :
			  (white_box_intf.cfg_colbits == 2'b10) ? {white_box_intf.sdr_addr[11:10]} : {white_box_intf.sdr_addr[12:11]};
	end
	
	
	property same_banks_verif;
		@(posedge white_box_intf.clk)
		((bank_requesed == white_box_intf.whbox_bank));
	endproperty
	
	assert_verf_same_banks: cover property (same_banks_verif);//else $error("Los bancos no son iguales");					//Verifica que el banco solicitado y el asignado sea el mismo
	
	
	
endmodule
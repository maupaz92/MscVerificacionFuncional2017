class estimulo_manual 
	#(int APP_AW = 26, int APP_BL = 9) 
	extends estimulo #(APP_AW, APP_BL);
	
	logic[APP_AW-1:0] addr;
	logic[APP_BL-1:0] bl;

	function logic [APP_AW-1:0] get_address;
		return this.addr;
	endfunction
	
	function logic [APP_BL-1:0] get_burstLength;
		return this.bl;
	endfunction

endclass
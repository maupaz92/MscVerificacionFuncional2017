class estimulo1 
	#(int APP_AW = 26, int APP_BL = 9) 
	extends estimulo #(APP_AW, APP_BL)
	;
	
	
	rand logic[APP_AW-1:0] addr;
	rand logic[APP_BL-1:0] bl;
	rand logic[31:0] data;
	
	//constraint addr_restriction {addr >= 'h4; addr <= 'h1fffff;}
	constraint bl_restriction {bl > 0; bl <= 'h3;}
	
	function logic [APP_AW-1:0] get_address;
		return this.addr;
	endfunction
	
	function logic [APP_BL-1:0] get_burstLength;
		return this.bl;
	endfunction
	
	function logic [31:0] get_data;
		return this.data;
	endfunction
	
	


endclass
class estimulo2;
	rand logic[31:0] addr;
	rand logic[7:0] bl;
	//logic [7:0] bl;
	//constraint addr_restriction {addr inside {32'h0001_0FF4, 32'h0002_0FF8,32'h0003_0FFA};}
	constraint addr_restriction {addr >= 'h4; addr <= 'h1fffff;}
	constraint bl_restriction {bl inside {'hF};};
	
	//bl = 4'hf;


endclass
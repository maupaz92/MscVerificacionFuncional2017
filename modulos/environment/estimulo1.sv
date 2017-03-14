class estimulo1;
	rand logic[31:0] addr;
	rand logic[7:0] bl;
	constraint addr_restriction {addr >= 'h4; addr <= 'h1fffff;}
	constraint bl_restriction {bl <= 'h3;}


endclass
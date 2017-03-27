class estimulo3;
	//logic [31:0] addr;
	rand logic [11:0] row;
	rand logic [1:0] bank;
	rand logic [7:0] column;
	rand logic[7:0] bl;
	constraint addr_restriction {row <= 'h1ff;}
	//constraint bl_restriction {bl <= 'h3;}
	
	//assign addr = {8'b0,row,bank,column,2'b00};


endclass
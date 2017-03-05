
class driver;
	virtual duv_master_sink interface_wb_sink;
	virtual int_scoreboard interface_sb;

	task burst_write (logic input [31:0] Address, logic input [7:0]  bl)
		int i;
		begin
		  interface_sb.push_address(Address);
		  interface_sb.push_burst(bl);

		   @ (negedge sys_clk);
		   $display("Write Address: %x, Burst Size: %d",Address,bl);

		   for(i=0; i < bl; i++) begin
			  interface_wb_sink.wb_stb_i        = 1;
			  interface_wb_sink.wb_cyc_i        = 1;
			  interface_wb_sink.wb_we_i         = 1;
			  interface_wb_sink.wb_sel_i        = 4'b1111;
			  interface_wb_sink.wb_addr_i       = Address[31:2]+i;
			  interface_wb_sink.wb_dat_i        = $random & 32'hFFFFFFFF;
			  interface_sb.push_data(interface_wb_sink.wb_dat_i);

			  do begin
				  @ (posedge sys_clk);
			  end while(interface_wb_sink.wb_ack_o == 1'b0);
				  @ (negedge sys_clk);
		   
			   $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,wb_addr_i,wb_dat_i);
		   end
		   interface_wb_sink.wb_stb_i        = 0;
		   interface_wb_sink.wb_cyc_i        = 0;
		   interface_wb_sink.wb_we_i         = 'hx;
		   interface_wb_sink.wb_sel_i        = 'hx;
		   interface_wb_sink.wb_addr_i       = 'hx;
		   interface_wb_sink.wb_dat_i        = 'hx;
		end
	endtask
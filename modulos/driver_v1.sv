
class driver;
	scoreboard sb;														//scoreboard inputs
	virtual senales interface_signals;

	
	function new(virtual senales interface_signals, scoreboard sb);
	begin
		this.interface_signals = interface_signals;
		this.sb = sb;
	end
	endfunction
	
	task reset();
		begin			
			repeat (5)@ (negedge interface_signals.sys_clk);
				interface_signals.wb_rst_i = 1'h0;
				interface_signals.sdram_resetn = 1'h1;
			repeat (5)@ (negedge interface_signals.sys_clk);
				interface_signals.wb_rst_i = 1'h1;
				interface_signals.sdram_resetn = 1'h0;					// Applying reset
			repeat (5)@ (negedge interface_signals.sys_clk);
				interface_signals.wb_rst_i = 1'h0;
				interface_signals.sdram_resetn = 1'h1;					// Releasing reset
			
			 wait(interface_signals.sdr_init_done == 1);
		end
	endtask
	
	
	task burst_write;
		input [31:0] Address; 
		input [7:0]  bl;
		int i;
		begin
		  sb.push_address(Address);
		  sb.push_burst(bl);

		   @ (negedge interface_signals.sys_clk);
		   $display("Write Address: %x, Burst Size: %d",Address,bl);

		   for(i=0; i < bl; i++) begin
			  interface_signals.wb_stb_i        = 1;
			  interface_signals.wb_cyc_i        = 1;
			  interface_signals.wb_we_i         = 1;
			  interface_signals.wb_sel_i        = 4'b1111;
			  interface_signals.wb_addr_i       = Address[31:2]+i;
			  interface_signals.wb_dat_i        = $random & 32'hFFFFFFFF;
			  sb.push_data(interface_signals.wb_dat_i);

			  do begin
				  @ (posedge interface_signals.sys_clk);
			  end 
			  while(interface_signals.wb_ack_o == 1'b0);
				@ (negedge interface_signals.sys_clk);
					$display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,interface_signals.wb_addr_i,interface_signals.wb_dat_i);
		   end
		   
		   interface_signals.wb_stb_i        = 0;
		   interface_signals.wb_cyc_i        = 0;
		   interface_signals.wb_we_i         = 'hx;
		   interface_signals.wb_sel_i        = 'hx;
		   interface_signals.wb_addr_i       = 'hx;
		   interface_signals.wb_dat_i        = 'hx;
		end
	endtask
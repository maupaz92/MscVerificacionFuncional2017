
class driver #(

	int BIT_ADDRESS 	= 32
);
	scoreboard sb;	
	virtual senales.driver_port interface_signals;
	
	
	function new(virtual senales.driver_port interface_signals_new, scoreboard sb_new);
	begin
		this.interface_signals = interface_signals_new;
		this.sb = sb_new;
	end
	endfunction

//Reset method	
	task reset;
		begin			
			interface_signals.wb_rst_i = 1'h0;
			interface_signals.sdram_resetn = 1'h1;
			//repeat (5)@ (negedge interface_signals.sys_clk);
			#100;
			interface_signals.wb_rst_i = 1'h1;
			interface_signals.sdram_resetn = 1'h0;					// Applying reset
			//repeat (5)@ (negedge interface_signals.sys_clk);
			#10000; //agregado un cero
			interface_signals.wb_rst_i = 1'h0;
			interface_signals.sdram_resetn = 1'h1;					// Releasing reset
			#1000
			wait(interface_signals.sdr_init_done == 1);
			#1000;
		end
	endtask
	
//Write method	
	task burst_write (input estimulo current_stimulus);
		int i;
		reg [BIT_ADDRESS-1:0] temp_address;
		begin
		  sb.push_address(current_stimulus.get_address());
		  sb.push_burst(current_stimulus.get_burstLength());

		   @ (negedge interface_signals.sys_clk);
		   $display("Write Address: %x, Burst Size: %d", current_stimulus.get_address(), current_stimulus.get_burstLength());

		   for(i=0; i < current_stimulus.get_burstLength(); i++) begin
			  interface_signals.wb_stb_i        = 1;
			  interface_signals.wb_cyc_i        = 1;
			  interface_signals.wb_we_i         = 1;
			  interface_signals.wb_sel_i        = 4'b1111;
			  temp_address = current_stimulus.get_address();
			  interface_signals.wb_addr_i       = temp_address[BIT_ADDRESS-1:2]+i;
			  interface_signals.wb_dat_i        = current_stimulus.get_data();
			  sb.push_data(interface_signals.wb_dat_i);

			  do begin
				  @ (posedge interface_signals.sys_clk);
			  end 
			  while(interface_signals.wb_ack_o == 1'b0);
				@ (negedge interface_signals.sys_clk);
					$display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",
						i, interface_signals.wb_addr_i, interface_signals.wb_dat_i);
		   end
		   
		   interface_signals.wb_stb_i        = 0;
		   interface_signals.wb_cyc_i        = 0;
		   interface_signals.wb_we_i         = 'hx;
		   interface_signals.wb_sel_i        = 'h0;
		   interface_signals.wb_addr_i       = 'hx;
		   interface_signals.wb_dat_i        = 'hx;
		end
	endtask
endclass
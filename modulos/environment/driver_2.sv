
class driver_2 #(

	int BIT_ADDRESS 	= 32
);
	scoreboard sb;	
	estimulo2 estimulo_2;
	virtual senales.driver_port interface_signals;

	
	function new(virtual senales.driver_port interface_signals_new, scoreboard sb_new, estimulo2 estimulos_2_new);
	begin
		this.interface_signals = interface_signals_new;
		this.sb = sb_new;
		this.estimulo_2 = estimulos_2_new;
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
	task burst_write;
		int i;
		begin
		  sb.push_address(estimulo_2.addr);
		  sb.push_burst(estimulo_2.bl);

		   @ (negedge interface_signals.sys_clk);
		   $display("Write Address: %x, Burst Size: %d",estimulo_2.addr,estimulo_2.bl);

		   for(i=0; i < estimulo_2.bl; i++) begin
			  interface_signals.wb_stb_i        = 1;
			  interface_signals.wb_cyc_i        = 1;
			  interface_signals.wb_we_i         = 1;
			  interface_signals.wb_sel_i        = 4'b1111;
			  interface_signals.wb_addr_i       = estimulo_2.addr[BIT_ADDRESS-1:2]+i;
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
endclass
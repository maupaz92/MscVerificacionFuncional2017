

`include "sdrc_define.v"
class monitor #(

	int BIT_ADDRESS 	= 32,
	int BIT_DATA		= 32
	
);
	scoreboard sb; 
	virtual senales.monitor_port intf; 

	function new(virtual senales.monitor_port intf, scoreboard sb); 
		this.intf = intf; 
		this.sb = sb; 
	endfunction 
	
	task burst_read(ref reg [31:0] ErrCnt);
		//ref input reg [31:0] ErrCnt;
		reg [BIT_ADDRESS-1:0] Address;
		reg [7:0]  bl;

		int i,j;
		reg [BIT_DATA-1:0]   exp_data;
		begin
			`ifdef Test_fail
				Address = 32'h4_bbbb; 
			`else
				sb.pop_address(Address);
			`endif
		   sb.pop_burst(bl); 
		   
		   @ (negedge intf.sys_clk);

			  for(j=0; j < bl; j++) begin
				 intf.wb_stb_i        = 1;
				 intf.wb_cyc_i        = 1;
				 intf.wb_we_i         = 0;
				 intf.wb_addr_i       = Address[BIT_ADDRESS-1:2]+j;

				 sb.pop_data(exp_data); // Expected Read Data
				 do begin
					 @ (posedge intf.sys_clk);
				 end 
				 
				 while(intf.wb_ack_o == 1'b0);
					 if(intf.wb_dat_o !== exp_data) 
						begin
							$display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,intf.wb_addr_i,intf.wb_dat_o,exp_data);
							ErrCnt = ErrCnt+1;
						end 
					 else 
						begin
							 $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,intf.wb_addr_i,intf.wb_dat_o);
						 end 
					 @ (negedge intf.sdram_clk);
				end
		   intf.wb_stb_i        = 0;
		   intf.wb_cyc_i        = 0;
		   intf.wb_we_i         = 'hx;
		   intf.wb_addr_i       = 'hx;
		end
	endtask
endclass 

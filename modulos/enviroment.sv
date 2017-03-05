
`include "sdrc_define.v"

class enviroment;

	virtual senales intf_driver;
	virtual senales intf_monitor;
	virtual senales intf_config;
	driver local_driver;
	monitor local_monitor;
	scoreboard local_scoreboard;
	
	function new(virtual senales intf_driver, virtual senales intf_monitor, virtual senales intf_config);
		begin
			this.intf_driver = intf_driver;
			this.intf_monitor = intf_monitor;
			this.intf_config = intf_config;
			local_scoreboard = new();
			local_driver = new(intf_driver, local_scoreboard);
			local_monitor = new(intf_monitor, local_scoreboard);
		end
	endfunction
		
	task start_configuration();
		begin
			// System configuration
			`ifdef SDR_32BIT
					  intf_config.cfg_sdr_width = 2'b00;			// 32 BIT SDRAM
			`elsif SDR_16BIT
					  intf_config.cfg_sdr_width = 2'b01;            // 16 BIT SDRAM
			`else 
					  intf_config.cfg_sdr_width = 2'b10;            // 8 BIT SDRAM
			`endif
					  intf_config.cfg_colbits = 2'b00;              // 8 Bit Column Address		

			intf_config.cfg_req_depth = 2'h3;               	        //how many req. buffer should hold
			intf_config.cfg_sdr_en = 1'b1;               
			intf_config.cfg_sdr_mode_reg = 13'h033;
			intf_config.cfg_sdr_tras_d = 4'h4;               
			intf_config.cfg_sdr_trp_d = 4'h2;               
			intf_config.cfg_sdr_trcd_d = 4'h2;               
			intf_config.cfg_sdr_cas = 3'h3;               
			intf_config.cfg_sdr_trcar_d = 4'h7;               
			intf_config.cfg_sdr_twr_d = 4'h1;               
			intf_config.cfg_sdr_rfsh = 12'h100;             // reduced from 12'hC35
			intf_config.cfg_sdr_rfmax = 3'h6;               			
		end
	endtask
	
	task reset();
		begin
		local_driver.reset();
		$display(" %0t : Environment  : end of reset() method",$time);
		end
	endtask
	
	task wait_for_end();
		begin
			repeat (10) @ (posedge intf_driver.sys_clk);
		end
	endtask
	
	task run;
		begin
			input [31:0] Address; 
			input [7:0]  bl;
			reset();
			start_configuration();			
			local_driver.burst_write(Address,bl);
			wait_for_end();
			local_monitor.burst_read();
		end
	endtask
	
endclass
			
	
		
		
	

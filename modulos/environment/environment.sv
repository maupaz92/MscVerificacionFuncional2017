`include "sdrc_define.v"
class environment;

	virtual senales.driver_port intf_driver;
	virtual senales.monitor_port intf_monitor;
	virtual senales.config_port intf_config;
	//estimulo1 estimulo_1;
	driver local_driver;
	//driver_2 local_driver2;
	//driver_3 local_driver3;
	monitor local_monitor;
	scoreboard local_scoreboard;
	
	function new(virtual senales.driver_port intf_driver, 
		virtual senales.monitor_port intf_monitor, 
		virtual senales.config_port intf_config);
		//estimulo1 estimulo_1, estimulo2 estimulo_2, estimulo3 estimulo_3);
		
		this.intf_driver = intf_driver;
		this.intf_monitor = intf_monitor;
		this.intf_config = intf_config;
		local_scoreboard = new();
		local_driver #(.BIT_ADDRESS(32)) = new(this.intf_driver, local_scoreboard);
		//local_driver2 = new(this.intf_driver, local_scoreboard,estimulo_2);
		//local_driver3 = new(this.intf_driver, local_scoreboard,estimulo_3);
		local_monitor = new(this.intf_monitor, local_scoreboard);
	endfunction
		
	task start_configuration;
		// System configuration
		`ifdef SDR_32BIT
			this.intf_config.cfg_sdr_width = 2'b00;			// 32 BIT SDRAM
		`elsif SDR_16BIT
			this.intf_config.cfg_sdr_width = 2'b01;            // 16 BIT SDRAM
		`else 
			this.intf_config.cfg_sdr_width = 2'b10;            // 8 BIT SDRAM
		`endif
			this.intf_config.cfg_colbits = 2'b00;              // 8 Bit Column Address
		
		//this.intf_config.cfg_sdr_width = 2'b00;			// 32 BIT SDRAM
		this.intf_config.cfg_req_depth = 2'h3;           //how many req. buffer should hold
		this.intf_config.cfg_sdr_en = 1'b1;               
		this.intf_config.cfg_sdr_mode_reg = 13'h033;
		this.intf_config.cfg_sdr_tras_d = 4'h4;               
		this.intf_config.cfg_sdr_trp_d = 4'h2;               
		this.intf_config.cfg_sdr_trcd_d = 4'h2;               
		this.intf_config.cfg_sdr_cas = 3'h3;               
		this.intf_config.cfg_sdr_trcar_d = 4'h7;               
		this.intf_config.cfg_sdr_twr_d = 4'h1;               
		this.intf_config.cfg_sdr_rfsh = 12'h100;             // reduced from 12'hC35
		this.intf_config.cfg_sdr_rfmax = 3'h6;  
		//wb configuration
		this.intf_driver.wb_addr_i      = 0;
		this.intf_driver.wb_dat_i      = 0;
		this.intf_driver.wb_sel_i       = 4'h0;
		this.intf_driver.wb_we_i        = 0;
		this.intf_driver.wb_stb_i       = 0;
		this.intf_driver.wb_cyc_i       = 0;
	endtask
	
	task reset;
		this.local_driver.reset();
		$display(" %0t : Environment  : end of reset() method",$time);		
	endtask
	
	task wait_for_end();
		repeat (10) @ (posedge intf_driver.sys_clk);
	endtask
	
	task start();
		this.start_configuration();
		this.reset();
	endtask	
	
	task write_to_memory;
		input estimulo current_stimulus;
		this.local_driver.burst_write(current_stimulus);
		this.wait_for_end();
	endtask
	
	task read_data;
		ref reg [31:0] error_count;
		this.local_monitor.burst_read(error_count);
	endtask
	
	
endclass
			
	
		
		
	

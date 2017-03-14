class environment2 extends environment;
	virtual senales.driver_port intf_driver;
	virtual senales.monitor_port intf_monitor;
	virtual senales.config_port intf_config;
	estimulo1 estimulo_1 = new() ;
	
	function new(virtual senales.driver_port intf_driver,
				 virtual senales.monitor_port intf_monitor,
				 virtual senales.config_port intf_config);
		super.new(intf_driver, intf_monitor, intf_config,estimulo_1);
	endfunction

	/*task start();
		super.start();
	endtask
	
	task read_data;
		ref reg [31:0] error_count;
		super.read_data(error_count);
	endtask*/
	

	task run();
		if (estimulo_1.randomize() == 1)
			begin
				local_driver.burst_write();
				$display ("Dato generado randonmente: address = %h bl = %d \n", estimulo_1.addr, estimulo_1.bl);
				wait_for_end();
			end
		else
			$display ("Error en la randomizacion\n");
		//end
		
	endtask

endclass
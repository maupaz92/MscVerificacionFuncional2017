class environment2 extends environment;
	virtual senales.driver_port intf_driver;
	virtual senales.monitor_port intf_monitor;
	virtual senales.config_port intf_config;
	estimulo1 estimulo_1 = new() ;
	estimulo2 estimulo_2 = new() ;
	estimulo3 estimulo_3 = new() ;
	
	function new(virtual senales.driver_port intf_driver,
				 virtual senales.monitor_port intf_monitor,
				 virtual senales.config_port intf_config);
		super.new(intf_driver, intf_monitor, intf_config,estimulo_1,estimulo_2,estimulo_3);
	endfunction
	

	task run();
		if (estimulo_1.randomize() == 1)
			begin
				local_driver.burst_write();
				$display ("Dato generado randonmente con estimulo2: address = %h bl = %d \n", estimulo_1.addr, estimulo_1.bl);
				wait_for_end();
			end
		else
			$display ("Error en la randomizacion\n");
		//end
		
	endtask
	
	task run_2();
		if (estimulo_2.randomize() == 1)
			begin
				local_driver2.burst_write();
				$display ("Dato generado randonmente con estimulo2: address = %h bl = %d \n", estimulo_2.addr, estimulo_2.bl);
				wait_for_end();
			end
		else
			$display ("Error en la randomizacion\n");
		//end
		
	endtask
	
	task run_3();
		if (estimulo_3.randomize() == 1)
			begin
				local_driver3.burst_write();
				$display ("Dato generado randonmente con estimulo2: address = %h bl = %d \n", estimulo_3.row, estimulo_3.bl);
				wait_for_end();
			end
		else
			$display ("Error en la randomizacion\n");
		//end
		
	endtask

endclass
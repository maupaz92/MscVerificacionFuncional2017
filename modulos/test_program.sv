


program test(
	senales.driver_port driver_port,
	senales.monitor_port monitor_port,
	senales.config_port config_port
);

	environment test_bench_environment;
	estimulo1 #(.APP_AW(26), .APP_BL(9)) primera_prueba;
	
	
	reg [31:0] error_count;
	//reg [31:0] StartAddr;
	
	
	initial begin
		
		error_count = 0;
		
		primera_prueba = new(); 
		
		test_bench_environment = new(driver_port, monitor_port, config_port);
		test_bench_environment.start();
		
		//escribir un dato
		#1000;
		$display("---------------------------------------------------------------------------- ");
		$display(" 						Case-1: Single Write/Read Case        			   	   ");
		$display("---------------------------------------------------------------------------- ");
		
		if (primera_prueba.randomize())
			test_bench_environment.write_to_memory(primera_prueba);
		test_bench_environment.read_data(error_count);
		
		
		
		//test_bench_environment.write_to_memory();
		//test_bench_environment.read_data(error_count);
		#1000;
		 
		 
		 
		$display("###############################");
		if(error_count == 0)
			$display("STATUS: SDRAM Write/Read TEST PASSED");
		else
			$display("ERROR:  SDRAM Write/Read TEST FAILED");
			$display("###############################");

		$finish;
	
	end 







endprogram












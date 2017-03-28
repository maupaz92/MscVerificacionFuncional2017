


program test(
	senales.driver_port driver_port,
	senales.monitor_port monitor_port,
	senales.config_port config_port
);


	environment2 test_bench_environment;
	reg [31:0] error_count;
	reg [31:0] StartAddr;
	initial begin
		
		error_count = 0;
		test_bench_environment = new(driver_port, monitor_port, config_port);
		test_bench_environment.start();
		
		//escribir un dato
		#1000;
		$display("---------------------------------------------------------------------------- ");
		$display(" 						Case-1: Single Write/Read Case        			   	   ");
		$display("---------------------------------------------------------------------------- ");
		test_bench_environment.run();
		test_bench_environment.read_data(error_count);
		test_bench_environment.run();
		test_bench_environment.read_data(error_count);
		
		#1000;
		
		
		$display("---------------------------------------------------------------------------- ");
		$display(" 				Case-2: Cross Over					        			   	   ");
		$display("---------------------------------------------------------------------------- ");
		test_bench_environment.run_2();
		test_bench_environment.read_data(error_count);
		test_bench_environment.run_2();
		test_bench_environment.read_data(error_count);
		
		#1000;
		
		
		$display("---------------------------------------------------------------------------- ");
		$display(" 		Case-3: Generacion Aleatoria de fila,columna y banco			   	   ");
		$display("---------------------------------------------------------------------------- ");
		
		test_bench_environment.run_3(); 
		test_bench_environment.read_data(error_count);	
		test_bench_environment.run_3(); 
		test_bench_environment.read_data(error_count);			
		 
		 
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












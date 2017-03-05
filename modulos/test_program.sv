


program test(
	interface driver_port,
	interface monitor_port,
	interface config_port
);


	environment test_bench_environment;
	
	initial begin
		
		test_bench_environment = new(driver_port, monitor_port, config_port);
		test_bench_environment.run(32'h4_0000,8'h4);
	
	end 













endprogram












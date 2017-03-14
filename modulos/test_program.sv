


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
		
		#1000;
		// Repeat one more time to analysis the 
		// SDRAM state change for same col/row address
		$display("---------------------------------------------------------------------------- ");
		$display(" 				Case-2: Repeat same transfer once again        			   	   ");
		$display("---------------------------------------------------------------------------- ");
		test_bench_environment.run();
		test_bench_environment.read_data(error_count);
		test_bench_environment.run();
		test_bench_environment.read_data(error_count);
		
		$display("---------------------------------------------------------------------------- ");
		$display(" 						Case-3 Create a Page Cross Over        			   	   ");
		$display("---------------------------------------------------------------------------- ");
		
		  test_bench_environment.run();  
		 /* test_bench_environment.run2(32'h0001_0FF4,8'hF);  
		  test_bench_environment.run2(32'h0002_0FF8,8'hF);  
		  test_bench_environment.run2(32'h0003_0FFC,8'hF);  
		  test_bench_environment.run2(32'h0004_0FE0,8'hF);  
		  test_bench_environment.run2(32'h0005_0FE4,8'hF);  
		  test_bench_environment.run2(32'h0006_0FE8,8'hF);  
		  test_bench_environment.run2(32'h0007_0FEC,8'hF);  
		  test_bench_environment.run2(32'h0008_0FD0,8'hF);  
		  test_bench_environment.run2(32'h0009_0FD4,8'hF);  
		  test_bench_environment.run2(32'h000A_0FD8,8'hF);  
		  test_bench_environment.run2(32'h000B_0FDC,8'hF);  
		  test_bench_environment.run2(32'h000C_0FC0,8'hF);  
		  test_bench_environment.run2(32'h000D_0FC4,8'hF);  
		  test_bench_environment.run2(32'h000E_0FC8,8'hF);  
		  test_bench_environment.run2(32'h000F_0FCC,8'hF);  
		  test_bench_environment.run2(32'h0010_0FB0,8'hF);  
		  test_bench_environment.run2(32'h0011_0FB4,8'hF);  
		  test_bench_environment.run2(32'h0012_0FB8,8'hF);  
		  test_bench_environment.run2(32'h0013_0FBC,8'hF);  
		  test_bench_environment.run2(32'h0014_0FA0,8'hF);  
		  test_bench_environment.run2(32'h0015_0FA4,8'hF);  
		  test_bench_environment.run2(32'h0016_0FA8,8'hF);  
		  test_bench_environment.run2(32'h0017_0FAC,8'hF);
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);  
		  test_bench_environment.read_data(error_count);
  

  
  $display("----------------------------------------");
  $display(" Case:4 4 Write & 4 Read                ");
  $display("----------------------------------------");
  test_bench_environment.run2(32'h4_0000,8'h4);  
  test_bench_environment.run2(32'h5_0000,8'h5);  
  test_bench_environment.run2(32'h6_0000,8'h6);  
  test_bench_environment.run2(32'h7_0000,8'h7);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  

  $display("---------------------------------------");
  $display(" Case:5 24 Write & 24 Read With Different Bank and Row ");
  $display("---------------------------------------");
  //----------------------------------------
  // Address Decodeing:
  //  with cfg_col bit configured as: 00
  //    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
  //
  test_bench_environment.run2({12'h000,2'b00,8'h00,2'b00},8'h4);   // Row: 0 Bank : 0
  test_bench_environment.run2({12'h000,2'b01,8'h00,2'b00},8'h5);   // Row: 0 Bank : 1
  test_bench_environment.run2({12'h000,2'b10,8'h00,2'b00},8'h6);   // Row: 0 Bank : 2
  test_bench_environment.run2({12'h000,2'b11,8'h00,2'b00},8'h7);   // Row: 0 Bank : 3
  test_bench_environment.run2({12'h001,2'b00,8'h00,2'b00},8'h4);   // Row: 1 Bank : 0
  test_bench_environment.run2({12'h001,2'b01,8'h00,2'b00},8'h5);   // Row: 1 Bank : 1
  test_bench_environment.run2({12'h001,2'b10,8'h00,2'b00},8'h6);   // Row: 1 Bank : 2
  test_bench_environment.run2({12'h001,2'b11,8'h00,2'b00},8'h7);   // Row: 1 Bank : 3
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  

  test_bench_environment.run2({12'h002,2'b00,8'h00,2'b00},8'h4);   // Row: 2 Bank : 0
  test_bench_environment.run2({12'h002,2'b01,8'h00,2'b00},8'h5);   // Row: 2 Bank : 1
  test_bench_environment.run2({12'h002,2'b10,8'h00,2'b00},8'h6);   // Row: 2 Bank : 2
  test_bench_environment.run2({12'h002,2'b11,8'h00,2'b00},8'h7);   // Row: 2 Bank : 3
  test_bench_environment.run2({12'h003,2'b00,8'h00,2'b00},8'h4);   // Row: 3 Bank : 0
  test_bench_environment.run2({12'h003,2'b01,8'h00,2'b00},8'h5);   // Row: 3 Bank : 1
  test_bench_environment.run2({12'h003,2'b10,8'h00,2'b00},8'h6);   // Row: 3 Bank : 2
  test_bench_environment.run2({12'h003,2'b11,8'h00,2'b00},8'h7);   // Row: 3 Bank : 3

  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  

  test_bench_environment.run2({12'h002,2'b00,8'h00,2'b00},8'h4);   // Row: 2 Bank : 0
  test_bench_environment.run2({12'h002,2'b01,8'h01,2'b00},8'h5);   // Row: 2 Bank : 1
  test_bench_environment.run2({12'h002,2'b10,8'h02,2'b00},8'h6);   // Row: 2 Bank : 2
  test_bench_environment.run2({12'h002,2'b11,8'h03,2'b00},8'h7);   // Row: 2 Bank : 3
  test_bench_environment.run2({12'h003,2'b00,8'h04,2'b00},8'h4);   // Row: 3 Bank : 0
  test_bench_environment.run2({12'h003,2'b01,8'h05,2'b00},8'h5);   // Row: 3 Bank : 1
  test_bench_environment.run2({12'h003,2'b10,8'h06,2'b00},8'h6);   // Row: 3 Bank : 2
  test_bench_environment.run2({12'h003,2'b11,8'h07,2'b00},8'h7);   // Row: 3 Bank : 3

  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  test_bench_environment.read_data(error_count);  
  $display("---------------------------------------------------");
  $display(" Case: 6 Random 2 write and 2 read random");
  $display("---------------------------------------------------");
  for(int k=0; k < 20; k++) begin
  
     StartAddr = $random & 32'h003FFFFF;
     test_bench_environment.run2(StartAddr,($random & 8'h0f)+1);  
 #100;

     StartAddr = $random & 32'h003FFFFF;
     test_bench_environment.run2(StartAddr,($random & 8'h0f)+1);  
 #100;
     test_bench_environment.read_data(error_count);  
 #100;
     test_bench_environment.read_data(error_count);  
 #100;
  end
		*/
		$display("###############################");
		if(error_count == 0)
			$display("STATUS: SDRAM Write/Read TEST PASSED");
		else
			$display("ERROR:  SDRAM Write/Read TEST FAILED");
			$display("###############################");

		$finish;
	
	end 







endprogram












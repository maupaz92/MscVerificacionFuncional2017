

class scoreboard #(
	
	int BIT_ADDRESS 	= 32,
	int BIT_DATA		= 32
	
);
	
	int afifo[$]; 	// Address  fifo
	int bfifo[$]; 	// Burst Length fifo
	int dfifo[$]; 	// Data fifo
	
	task push_address;
		input [BIT_ADDRESS-1:0] Address;
		afifo.push_back(Address);
	endtask
	
	task push_burst;
		input [7:0]  bl;
		bfifo.push_back(bl);
	endtask
	
	task push_data;
		input [BIT_DATA-1:0]  Data;
		dfifo.push_back(Data);
	endtask
		
	task pop_address;
		output [BIT_ADDRESS-1:0] Address;
		Address = afifo.pop_front(); 
	endtask
	
	task pop_burst;
		output [7:0]  bl;
		bl = bfifo.pop_front();
	endtask
	
	task pop_data;
		output [BIT_DATA-1:0]  Data;
		Data = dfifo.pop_front();
	endtask	
endclass
	
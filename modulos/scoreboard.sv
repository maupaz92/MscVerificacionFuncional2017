class scoreboard;
	
	int afifo[$]; 	// Address  fifo
	int bfifo[$]; 	// Burst Length fifo
	int dfifo[$]; 	// Data fifo
	
	task push_address;
	begin
		input [31:0] Address;
		afifo.push_back(Address);
	end
	endtask
	
	task push_burst;
	begin
		input [7:0]  bl;
		bfifo.push_back(bl);
	end
	endtask
	
	task push_data;
	begin
		input [31:0]  Data;
		dfifo.push_back(Data);
	end
	endtask
		
	task pop_address;
	begin
		output [31:0] Address;
		Address = afifo.pop_front(); 
	end
	endtask
	
	task pop_burst;
	begin
		output [7:0]  bl;
		bl = bfifo.pop_front();
	end
	endtask
	
	task pop_data;
	begin
		output [31:0]  Data;
		Data = dfifo.pop_front();
	end
	endtask	
endclass


class scoreboard_mailbox;
	mailbox driver_sb_address;
	mailbox driver_sb_bl;
	mailbox driver_data;
	mailbox sb_monitor_address;
	mailbox sb_monitor_bl;
	mailbox sb_monitor_data;
	
	function new(mailbox driver_sb_address, mailbox driver_sb_bl, mailbox driver_data, mailbox sb_monitor_address, mailbox sb_monitor_bl, mailbox sb_monitor_data);
		begin
			this.driver_sb = driver_sb;
			this.sb_monitor = sb_monitor;
		end
	endfunction
	
	task push_pop;
		begin
		logic [31:0] Address; 
		logic [7:0]  bl;
		logic [31:0] Data; 
		driver_sb_address.get(Address);
		driver_sb_bl.get(bl);
		driver_data.get(Data);
		sb_monitor_address.put(Address);
		sb_monitor_bl.put(bl);
		sb_monitor_data.put(Data);
		end
	endtask
endclass
	
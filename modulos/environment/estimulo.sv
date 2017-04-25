virtual class estimulo #(
	int APP_AW = 32,
	int APP_BL = 9
	);

	pure virtual function logic [APP_AW-1:0] get_address();
	pure virtual function logic [APP_BL-1:0] get_burstLength();
	pure virtual function logic [31:0] get_data();


endclass
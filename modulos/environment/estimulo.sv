virtual class estimulo #(
	int APP_AW = 26,
	int APP_BL = 9
	);

	pure virtual function logic [APP_AW-1:0] get_address();
	pure virtual function logic [APP_BL-1:0] get_burstLength();


endclass
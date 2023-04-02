module topModule_tb();
reg clk,rst,Insert_Card,More_Transaction,deposite_user,withdraw_user,user_approve;
reg [3:0] PIN_user;
reg [20:0] card_info;
reg [9:0] amount_user; 
					
wire [9:0] newBalance;
wire [9:0] cash;
task assert_reset; begin
	rst = 0;
	repeat(3) @(negedge clk);
	rst = 1;
	repeat(3) @(negedge clk);
	rst = 0;
	end 
endtask 

initial begin
	clk = 0;
	forever #1 clk = ~clk;
end

initial begin
	$readmemh("mem.dat",DUT.mem_.mem);
	assert_reset;
	Insert_Card = 1; // to insert card
	card_info = 21'h0A64C1; //0000_1010_0110_0100_1100_0001 valid account 0A64C1
	#5;
	PIN_user = 4'b1111;
	// PIN_user = 4'b1110;
	// @(negedge clk);        //count works successfully
	// PIN_user = 4'b1100;
	// @(negedge clk);
	// PIN_user = 4'b1011;
	#2; 
	deposite_user = 1;
	#4;
	amount_user = 100;
	#2;
	user_approve = 1;
	#4;
	More_Transaction = 1;
	user_approve = 0;
	#2;
	deposite_user = 0;
	withdraw_user = 0;
	More_Transaction = 1;
	#2;
	amount_user = 40;
	// deposite_user = 0;
	// withdraw_user = 0;
	#2;
	More_Transaction = 0;
	withdraw_user = 1;
	user_approve = 1;
	PIN_user = 4'bxxxx;
	//Insert_Card = 0;
	//$display("Process End please get your card out!!");
	//$display("if you need more More_Transaction : \n please enter 1 else enter 0 and get you card out ");
	#8;
	user_approve = 0;
	//PIN_user = 4'b1110;
	//@(negedge clk);        //count works successfully
	//PIN_user = 4'b1100;
	repeat(2) @(negedge clk);
	PIN_user = 4'b1011;
	repeat(2) @(negedge clk);
	PIN_user = 4'b1110;
	repeat(1) @(negedge clk);
	PIN_user = 4'b1100;
	#2;
	PIN_user = 4'bxxxx;
	repeat(2)@(negedge clk);
	//PIN_user = 4'b1111;
	#4;
	Insert_Card = 0;
	#8;
	Insert_Card = 1;
	card_info = 21'h1BC560;//0001_1011_1100_0101_0110_0000 valid account 0A64C1
	//pin = 1011
	#5;
	PIN_user = 4'b1011;
	#2;
	withdraw_user = 0;
	#2
	amount_user = 100;
	#2;
	user_approve = 1;
	#2;

	// #2;
	// deposite_user = 1;
	// #1;
	// amount_user = 300;
	// #6;
	// More_Transaction = 1;
	// user_approve = 1;
	// #4;
	// user_approve = 0;
	// #2;
	// withdraw_user = 0;
	// deposite_user = 0;
	// #2;
	// //withdraw_user = 0;
	// //assert_reset; 
	// amount_user = 400;
	// user_approve = 1;
	#4;
	$stop;

end
// initial begin
// 	$writememh("mem.dat",DUT.mem_.mem);
// end
topModule DUT( 	 clk,
				 rst,
				 PIN_user,
				 Insert_Card,
				 card_info,
				 More_Transaction,
				 amount_user,
				 deposite_user,
				 withdraw_user,
				 user_approve,
				 newBalance,
				 cash
			 );
endmodule
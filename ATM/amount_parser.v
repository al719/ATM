module amount_parser(//card store inf
						//input clk,
						input [9:0] amount_user,
						input [9:0] amount_account,
						input deposite,
						input withdraw,
						input balance_update,
						output reg amount_entered_sucessfully,
						output reg valid_transaction,
						output reg [9:0] newBalance,
						output reg [9:0] cash_user
					);
parameter MAX_AMOUNT = 10'b11_1111_1111;
always @(*) begin
	if(deposite) begin
		//$display("11111111111111111111");
		amount_entered_sucessfully = 1;
		if((MAX_AMOUNT - amount_account)<amount_user) begin 
			//$display("2222222222222222222222222");
			valid_transaction = 0;
			//cash_user = 0;
		end 
		else begin 
			//$display("333333333333333333333333");
			valid_transaction = 1;
	end
end 
	else if(withdraw) begin
		amount_entered_sucessfully = 1;
		if(amount_user > amount_account || amount_account == 0) begin 
			valid_transaction = 0;
			//cash_user = 0;
			//$display("not valid amount in mem");
		end 
		else 
			valid_transaction = 1;
	end
	else 
		amount_entered_sucessfully = 0;
end
always @(balance_update) begin
	if(balance_update && deposite) begin 
		newBalance = amount_account + amount_user;
		cash_user = amount_user;
		//$display("deposite");
	end 
	else if(balance_update && withdraw) begin 
		newBalance = amount_account - amount_user;
		cash_user = amount_user;
		//$display("withdraw , amount account = %0d",amount_account);
	end 
	else begin 
		newBalance = amount_account;
		cash_user = amount_user;
		//$display("no thing");
	end 
end
//assign amount_entered_sucessfully = 1;
endmodule
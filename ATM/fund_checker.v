module fund_checker(
					input deposite_user,
					input withdraw_user,
					//input [9:0] entered_amount,
					output [1:0] option_selected
					);
assign option_selected = (deposite_user) ? 1 : (~withdraw_user) ? 2 : 0;

endmodule
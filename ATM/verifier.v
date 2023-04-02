module verifier(
				input user_approve,
				output transaction_verified
				);
assign transaction_verified = (user_approve) ? 1 : 0;
endmodule
module store_card_info(// 1 + 16 + 4 + 10 
						input wire card_scanned,
						input wire[15:0] account,
						//input wire[4:0] acc_addr,
						input wire[31:0] info_Ram,
						//input lock_acc,
						// input update,
						// input [9:0] newUpdatedBalance,

						output reg[3:0] PIN_check,
						//output wire[4:0] get_info_Ram,
						output reg account_un_locked//MSB of 32-info_Ram
						//output reg[15:0] acc_Ram;
						//output reg [31:0] account_information
						);
//reg [31:0] account_information;
always @(*) begin

	if(~(account ^ info_Ram[30:15]) &&card_scanned) begin//(account == info_Ram[30:15]) &&
		PIN_check = info_Ram[14:11];
		account_un_locked = info_Ram[31];
	end
	else begin  
		//$display("//////////////////////////");
		 account_un_locked = 0;
	end
end
// always @(*) begin 
// if(update) begin 
// 	account_information = info_Ram;
// 	account_information[9:0] = newUpdatedBalance;
// end 
// else 
// 	account_information = info_Ram;
//end
//assign info_Ram[9:0] = (update) ? (newUpdatedBalance) : (info_Ram[9:0] ^ 0) ;
//assign get_info_Ram = acc_addr;
//assign info_Ram[31] = (lock_acc) ? 1 : 0 ;
endmodule
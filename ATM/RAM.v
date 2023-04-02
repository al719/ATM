module RAM(
			input clk,
			input rst,
			input [4:0] acc_addr,
			input lock_acc,
			input update,
			input [9:0] balance,
			// input cash,
			//input [3:0] PIN_update,

			output reg [31:0] acc_info
			);

reg [31:0] mem [4:0];
reg [31:0] acc;
always @(posedge clk or posedge rst) begin
	if(rst)
		acc_info <= 0;
	else if(lock_acc) begin
		acc_info = mem[acc_addr];
		acc_info[31] = 1;
		mem[acc_addr] = acc_info;
		end 
	else begin
		acc_info <= mem[acc_addr];
	end 
end
always @(update) begin 
	acc = mem[acc_addr];
	acc[9:0] = balance;
	mem[acc_addr] = acc;
end

/*
always @(acc_addr) begin
	acc_info = mem[3];
end
*/
//assign acc_info[31] = (lock_acc) ? 1 : 0 ;
endmodule
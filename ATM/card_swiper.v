module card_swiper(
					input Insert_Card,
					input wire[20:0] card_info,
					output reg [15:0] account_info,
					//output reg [4:0] PIN,
					output reg[4:0] acc_addr, 
					output reg card_scanned
					);
always @(card_info) begin
	if(Insert_Card) begin
		account_info = card_info[20:5];
		//PIN = card_info[4:0];
		acc_addr = card_info[4:0];
		card_scanned = 1;
	end
	else card_scanned = 0;
end


endmodule  
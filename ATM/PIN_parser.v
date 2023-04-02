module PIN_parser(
					input clk,
					input store_state,
					input pin_rest,
					input [3:0] PIN_card,
					input [3:0] PIN_user,
					input [1:0] count,
					output PIN_matched
					//output reg [3:0] pin_restt
					//output [3:0] PIN_user_restart
					);
 reg [3:0] pin_restt;
 // always@(posedge clk)
 // 	pin_restt = PIN_user;
always@(count,pin_rest) begin//pin_rest,PIN_user
	//pin_restt = PIN_user;
	if(pin_rest)
		pin_restt = 4'hx;
	else
		pin_restt = PIN_user;
end
//assign PIN_user = pin_restt;
assign PIN_matched = ((PIN_card == pin_restt) && store_state) ? 1 : 0;
//assign PIN_user_restart = (pin_rest) ? PIN_user : 4'hx;
endmodule
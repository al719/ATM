module ATM_controller(
						input clk,
						input rst,
						//input [3:0] pin_restt,
						//input lock_state,//get it from mem to s3 state
						input Insert_Card,
						input card_scanned,
						input Account_Unlocked,
						input PIN_Matched,
						//input InValid_PIN_count,
						input [1:0] option_select,
						input Amount_entered,
						input Valid_Transaction,
						input More_Transaction,//from top module
						input Transaction_verified,
						//input wire[3:0] PIN,
						
						output reg lock_acc,//locked this account out from s4 state
						//output flags
						//output reg Insert_Card_out,
						output reg card_scanned_out,
						output reg stored_done,
						output reg PIN_Matched_sucessfully,
						//output reg InValid_PIN_count_out,
						output reg deposite_selected,
						output reg withdraw_selected,
						//output reg verifiy_to_user,
						output reg update_balance,
						output reg pin_restart,
						//output reg More_Transaction_out,
						//output reg Transaction_verified_out, 
						output reg [1:0] count
						//output reg invalid_monitoring
						);

// states
/*
parameter Scan_Card 			= 4'b0000;
parameter Scan_Line 			= 4'b0001;
parameter Storing_info 			= 4'b0010;
parameter Enter_PIN 			= 4'b0011;
parameter Count 				= 4'b0100;
parameter Transaction_Type 		= 4'b0101;
parameter Enter_Deposite_amount = 4'b0110;
parameter Deposite_Check 		= 4'b0111;
parameter Invalid 				= 4'b1000;
parameter AnyThingElse 			= 4'b1001;
parameter Deposite_verify 		= 4'b1010;
parameter Updating_Balance 		= 4'b1011;
parameter Enter_Withdraw_Amount = 4'b1100;
parameter Withdraw_Check 		= 4'b1101;
parameter Withdraw_Verify 		= 4'b1110;
*/
///////////////////////////////////////////////

typedef enum  {
Scan_Card,
Scan_Line,
Storing_info,
Enter_PIN,
Count,
Transaction_Type,
Enter_Deposite_amount,
Deposite_Check,
Invalid,
AnyThingElse,
Deposite_verify,
Updating_Balance,
Enter_Withdraw_Amount,
Withdraw_Check,
Withdraw_Verify} state_;

///////////////////////////////////////////////
//reg [1:0] count;// out to pin parser to count 3 times 
state_ c_state,next_state;



///////////////////////////////////////////////
// state memory
always @(posedge clk or posedge rst) begin
	if (rst)
		c_state <= Scan_Card;
	else 
		c_state <= next_state;
end
///////////////////////////////////////////////

 //////////////////////////////////
//update next state
always @(*)begin
	 case(c_state)
	 	Scan_Card : begin
	 		if(Insert_Card)
	 			next_state = Scan_Line;
	 		else 
	 			next_state = Scan_Card;
	 		end 
	 	Scan_Line : begin
	 		if(card_scanned)
	 			next_state = Storing_info;
	 		else 
	 			next_state = Scan_Card;
	 	end
	 	Storing_info : begin
	 		if(~Account_Unlocked) // repair lock flag @ all modules rename account_locked
	 			next_state = Enter_PIN;
	 		else 
	 			next_state = Scan_Card;
	 	end
	 	Enter_PIN : begin
			 	if(count>0) begin	
			 		//$display("count = %0d",count);
			 		if(PIN_Matched)
			 			next_state = Transaction_Type;
			 		else 
			 			next_state = Enter_PIN;
			 	end 
			 	else begin 
			 			next_state = Scan_Card;
			 			//lock_acc = 1;
			 		end 
	 	end
	 	/*
	 	Count : begin // To Check
	 		if(~InValid_PIN_count && cnt>0) 
	 			next_state = Count;
	 			//next = Enter PIN
	 		else 
	 			next_state = Scan_Card;
	 	end
	 	*/
	 	Transaction_Type : begin
	 		if(option_select === 1 && PIN_Matched_sucessfully)
	 			next_state = Enter_Deposite_amount;
	 		else if(option_select === 2 && PIN_Matched_sucessfully)
	 			next_state = Enter_Withdraw_Amount;
	 		else 
	 			next_state = Transaction_Type;
	 	end
	 	Enter_Deposite_amount : begin
	 		if(Amount_entered)
	 			next_state = Deposite_Check;
	 		else 
	 			next_state = Transaction_Type;
	 	end
	 	Deposite_Check : begin //s7
	 		if(Valid_Transaction)
	 			next_state = Deposite_verify;
	 		else 
	 			next_state = Invalid;
	 	end
	 	Deposite_verify : begin // s10
	 		if(Transaction_verified)
	 			next_state = Updating_Balance;
	 		else 
	 			next_state = Deposite_verify;
	 	end
	 	Updating_Balance : begin
	 		next_state = AnyThingElse;
	 	end
	 	Enter_Withdraw_Amount : begin//s12
	 		if(Amount_entered)
	 			next_state = Withdraw_Check;
	 		else 
	 			next_state = Transaction_Type;
	 	end
	 	Withdraw_Check : begin//s13
	 		if(Valid_Transaction)
	 			next_state = Withdraw_Verify;
	 		else 
	 			next_state = Invalid;
	 	end
	 	Withdraw_Verify : begin//s14
	 		if(Transaction_verified)
	 			next_state = Updating_Balance;
	 		else 
	 			next_state = Withdraw_Verify;
	 	end
	 	Invalid : begin
	 		next_state = AnyThingElse;
	 	end
	 	AnyThingElse : begin
	 		if(More_Transaction)
	 			next_state = Transaction_Type;
	 		else 
	 			next_state = Scan_Card;
	 	end
	endcase
end	

//output always
always @(posedge clk) begin
	case(c_state)
		Scan_Card : begin
				lock_acc = 0;
				//invalid_monitoring = 0;
	 			pin_restart = 1;
	 			card_scanned_out = 1;
	 			update_balance = 0;
	 			deposite_selected = 0;
	 			withdraw_selected = 1;
	 			PIN_Matched_sucessfully = 0;
	 			stored_done = 0;

	 		end 
	 	// Scan_Line : begin
	 		
	 	// end
	 	Storing_info : begin
	 		count = 3;
	 		stored_done = 1; 
	 		pin_restart = 0;
	 	end
	 	Enter_PIN : begin

	 		if(~PIN_Matched) begin 
	 			count = count -1;
	 			//$display("-------------");
	 		end 
	 		else if(count == 0) begin 
	 			lock_acc = 1;
	 			//$display("////////////");
	 		end 
	 		else begin 
	 			PIN_Matched_sucessfully = 1;
	 			//lock_acc = 0;
	 			//$display("xxxxxxxxxxxxxx");
	 		end 
	 	end
	 	/*
	 	Count : begin // To Check
	 		
	 	end
	 	*/
	 	Transaction_Type : begin
	 		//invalid_monitoring = 0;
	 		update_balance = 0;
	 		// deposite_selected = 0;
	 		// withdraw_selected = 0;
	 		if(option_select === 1) begin
	 			deposite_selected = 1;
	 			withdraw_selected = 0;
	 			//Amount_entered_out = 1;
	 			end 
	 		else if(option_select === 2) begin
	 			withdraw_selected = 1;
	 			deposite_selected = 0;
	 			//Amount_entered_out = 1;
	 			end 
	 		else begin
	 			deposite_selected = 0;
	 			withdraw_selected = 1;
	 		end
	 	end
	 	/*
	 	Enter_Deposite_amount : begin
	 		
	 	end
	 	
	 	Deposite_Check : begin //s7
	 		if(Valid_Transaction)
	 			verifiy_to_user = 1;
	 		else 
	 			verifiy_to_user = 0;
	 	end
	 	*/
	 	Deposite_verify : begin // s10
	 		if(Transaction_verified)
	 			update_balance = 1;
	 		else 
	 			update_balance = 0;
	 	end
	 	// Updating_Balance just in output
	 	/*
	 	Enter_Withdraw_Amount : begin//s12
	 		
	 	end
	 	
	 	Withdraw_Check : begin//s13
	 		if(Valid_Transaction)
	 			verifiy_to_user = 1;
	 		else 
	 			verifiy_to_user = 0;
	 	end
	 	*/
	 	Withdraw_Verify : begin//s14
	 		if(Transaction_verified)
	 			update_balance = 1;
	 		else 
	 			update_balance = 0;
	 	end
	 	// the next state => $monitor their output
	 	/*
	 	Invalid : begin
	 		invalid_monitoring = 1;
	 	end
	 	
	 	AnyThingElse : begin
	 		invalid_monitoring = 0;
	 	end
	 	*/
	endcase
end
endmodule
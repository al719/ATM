module topModule(
					input clk,
					input rst,
					input [3:0] PIN_user,
					input Insert_Card,
					input wire[20:0] card_info,
					input More_Transaction,
					input [9:0] amount_user,
					input deposite_user,
					input withdraw_user,
					input user_approve,



					output [9:0] new_balance,
					output [9:0] new_cash
					);
wire [9:0] new_cassh;
//reg [9:0] cassh;
//internal wires for connections
//flags for state machines
wire card_scanned;
wire card_scanned_out;
wire [15:0] account_info;
wire [4:0] acc_addr;
wire [31:0] info_Ram;
wire lock_acc;
wire [3:0] PIN_check;
wire Account_Unlocked;
wire stored_done;
wire PIN_matched;
wire deposite_selected;
wire withdraw_selected;
wire update_balance;
wire valid_transaction;
wire [1:0] option_selected;
wire transaction_verified;
wire Amount_entered;
wire pin_rest;
//wire [3:0] pin_restt;
wire [1:0] count_;
//wire [31:0] account_information_;
//wire invalid_monitorr;
// wire [9:0] new_balance;
// wire [9:0] new_cash;
card_swiper scanner(
					  Insert_Card,
					  card_info,//from topmodule
					  account_info,//card swipper to store info
					  acc_addr,//output from scanner[card] to RAM
					  card_scanned//to state machine
					);
store_card_info CSIM( 
						.card_scanned(card_scanned_out),//from state machine
						.account(account_info),//from scanner
						.info_Ram(info_Ram),//from ram
						//.lock_acc(lock_acc),
						// .update(update_balance),
						// .newUpdatedBalance(user_new_balance),
						.PIN_check(PIN_check),//to pin parser
						.account_un_locked(Account_Unlocked)//MSB of 32-info_Ram [to state machine]
						//.account_information(account_information_)
						);
PIN_parser pin_parser(
					.clk(clk),
					.store_state(stored_done),//from state machine
					.pin_rest(pin_rest),
					.PIN_card(info_Ram[14:11]),//from store card module
					.PIN_user(PIN_user),//from topmodule
					.count(count_),
					.PIN_matched(PIN_matched)//to state machine
					//pin_restt
					);
amount_parser insert_amount(//card store inf

						amount_user,//user
						info_Ram[9:0],//bit select from ram
						deposite_selected,// state machine
						withdraw_selected,// state machine
						update_balance,//from state machine
						Amount_entered,
						valid_transaction,//to state machine
						new_balance,// final output to topmodule
						new_cassh
					);

fund_checker fund_check(
					deposite_user,//from topmodule user
					withdraw_user,//from topmodule user
					//input [9:0] entered_amount,
					option_selected //to state machine
					);
verifier  final_checker(
				user_approve,//from user
				transaction_verified //to state machine
				);

ATM_controller controller(
						.clk(clk),
						.rst(rst),
						//.pin_restt(pin_restt),
						//input lock_state,//get it from mem to s3 state
						.Insert_Card(Insert_Card),//from top module
						.card_scanned(card_scanned),// card swipper
						.Account_Unlocked(Account_Unlocked),//store card info
						.PIN_Matched(PIN_matched),//pin parser
						//input InValid_PIN_count,
						.option_select(option_selected),//fund check
						.Amount_entered(Amount_entered),//
						.Valid_Transaction(valid_transaction),
						.More_Transaction(More_Transaction),//from top module
						.Transaction_verified(transaction_verified),
						//input wire[3:0] PIN,
						
						.lock_acc(lock_acc),//locked this account out from s4 state
						//output flags
						//output reg Insert_Card_out,
						.card_scanned_out(card_scanned_out),
						.stored_done(stored_done),
						.PIN_Matched_sucessfully(PIN_Matched_sucessfully),
						//output reg InValid_PIN_count_out,
						.deposite_selected(deposite_selected),
						.withdraw_selected(withdraw_selected),
						//output reg verifiy_to_user,
						.update_balance(update_balance),
						//output reg More_Transaction_out,
						//output reg Transaction_verified_out, 
						
						.pin_restart(pin_rest),
						.count(count_)
						//.invalid_monitoring(invalid_monitorr)
						);
RAM mem_(
			 clk,
			 rst,
			 acc_addr,
			 lock_acc,
			 update_balance,
			 new_balance,
			 info_Ram
			);
//assign PIN_user = (pin_rest) ? 4'hx : $display("Enter your PIN");
/*
monitor_out monitoring(
						invalid_monitorr
						
						);
*/

assign new_cash = (valid_transaction) ? new_cassh : 0;
endmodule
vlib work
vlog topModule.sv topModule_tb.v
vsim -voptargs=+accs work.topModule_tb
add wave *
add wave -position insertpoint  \
sim:/topModule_tb/DUT/mem_/mem
add wave -position insertpoint  \
sim:/topModule_tb/DUT/controller/count \
sim:/topModule_tb/DUT/controller/c_state \
sim:/topModule_tb/DUT/controller/next_state
add wave -position insertpoint  \
sim:/topModule_tb/DUT/scanner/account_info \
sim:/topModule_tb/DUT/scanner/acc_addr \
sim:/topModule_tb/DUT/scanner/card_scanned
add wave -position insertpoint  \
sim:/topModule_tb/DUT/scanner/card_info
add wave -position insertpoint  \
sim:/topModule_tb/DUT/CSIM/info_Ram
add wave -position insertpoint  \
sim:/topModule_tb/DUT/pin_parser/PIN_card
add wave -position insertpoint  \
sim:/topModule_tb/DUT/pin_parser/PIN_matched
add wave -position insertpoint  \
sim:/topModule_tb/DUT/pin_parser/store_state
add wave -position insertpoint  \
sim:/topModule_tb/DUT/controller/PIN_Matched_sucessfully
add wave -position insertpoint  \
sim:/topModule_tb/DUT/pin_parser/pin_restt
add wave -position insertpoint  \
sim:/topModule_tb/DUT/CSIM/account_information
add wave -position insertpoint  \
sim:/topModule_tb/DUT/CSIM/account_un_locked
add wave -position insertpoint  \
sim:/topModule_tb/DUT/controller/lock_acc
add wave -position insertpoint  \
sim:/topModule_tb/DUT/mem_/lock_acc
add wave -position insertpoint  \
sim:/topModule_tb/DUT/controller/lock_acc
run -all
#quit -sim
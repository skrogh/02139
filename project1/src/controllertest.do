#reset signals without simulation default values
force reset 1
run 1
force reset 0
run 1

#use the manual clock for testing to avoid changing the clock manager
force sel_man 1
force clk_man 0 0, 1 5 -repeat 10
force clk_50 0

#force input signals low to start
force coin2 0
force coin5 0
#Modelsim breaks on force price "00111"
force price(0) 1
force price(1) 1
force price(2) 1
force price(3) 0
force price(4) 0
force buy 0

#Vending machine should go to waiting state
run 20

#assert coin2, vending machine should go to add2 and stay for a cycle
force coin2 1
run 20

#back to wait
force coin2 0
run 20

#assert coin5, vending machine should go to add5 and stay for a cycle
force coin5 1
run 20

#back to wait
force coin5 0
run 10

#try buying without enough money, alarm should be asserted
force buy 1
run 20

#back to wait
force buy 0
run 10

#put enough money in the machine 
force coin5 1
run 10
force coin5 0
run 10

#try buying with enough money, release can should be high
force buy 1
#check that the machine holds release_can high as long as buy is asserted
run 40

#back to wait
force buy 0
run 20

#check that reset, resets the sum
force reset 1
run 20
force reset 0
run 20
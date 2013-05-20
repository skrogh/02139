force reset 1
run 1
force reset 0
run 1
force sel_man 0
force clk_man 0
force clk_50 0 0, 1 5 -repeat 10
force coin2 0
force coin5 0
force price "00100"
force buy 0
run 20
force coin2 1
run 20
force coin2 0
run 20
force coin5 1
run 20
force coin5 0
run 10
force buy 1
run 20
force buy 0
run 10 
force coin5 1
run 10
force coin5 0
run 10
force buy 1
run 40
force buy 0
run 20
force reset 1
run 20
force reset 0
run 20
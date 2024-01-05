# updating .....
vlog main_cache00.v
restart -force
#------------------------------------------------------------------------
# initializing signals and generate clk
set clk_period 50
force -freeze /top/clk 1 0, 0 {25 ns} -r $clk_period
force -freeze /top/rst 0 , 1 10  -cancel 10

force -freeze /top/addr 0 ,  1 [expr 1*$clk_period] , 2 [expr 2*$clk_period]  , 3 [expr 3*$clk_period] , 4 [expr 4*$clk_period] , 5 [expr 5*$clk_period], 1 [expr 7*$clk_period]  , 2 [expr 11*$clk_period] , 3 [expr 15*$clk_period] , 4 [expr 18*$clk_period]
force -freeze /top/DataIn 0 , 1 [expr 1*$clk_period] , 2 [expr 2*$clk_period] , 3 [expr 3*$clk_period] , 4 [expr 4*$clk_period] , 5 [expr 5*$clk_period]
force -freeze /top/read 0 , 1 [expr 6*$clk_period]
force -freeze /top/write 0 , 1 10 , 0 [expr 6*$clk_period] 

run 1800 ns
write format restart rerun.do

vlib work
vlog Design.v Test_Bench.v +cover -covercells
vsim -voptargs=+acc work.TestBenchATM -cover
add wave *
coverage save ATM_TestBenc_db.ucdb -onexit -du topLevelATM
vcover report -html mod16_cov
run -all
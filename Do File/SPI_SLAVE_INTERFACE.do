vlib work
vlog RAM.v SPI_Slave.v SPI_Wrapper.v MASTER.v
vsim -voptargs=+acc work.MASTER
add wave *
run -all
#quit -sim
onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc"  -L axi_lite_ipif_v3_0_4 -L lib_cdc_v1_0_3 -L interrupt_control_v3_1_5 -L axi_gpio_v2_0_33 -L xil_defaultlib -L secureip -lib xil_defaultlib xil_defaultlib.

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {.udo}

run 1000ns

quit -force

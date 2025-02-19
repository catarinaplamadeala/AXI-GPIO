transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+  -L axi_lite_ipif_v3_0_4 -L lib_cdc_v1_0_3 -L interrupt_control_v3_1_5 -L axi_gpio_v2_0_33 -L xil_defaultlib -L secureip -O5 xil_defaultlib.

do {.udo}

run 1000ns

endsim

quit -force

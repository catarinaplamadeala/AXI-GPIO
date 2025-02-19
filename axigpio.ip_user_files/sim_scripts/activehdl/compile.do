transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/axi_lite_ipif_v3_0_4
vlib activehdl/lib_cdc_v1_0_3
vlib activehdl/interrupt_control_v3_1_5
vlib activehdl/axi_gpio_v2_0_33
vlib activehdl/xil_defaultlib

vmap axi_lite_ipif_v3_0_4 activehdl/axi_lite_ipif_v3_0_4
vmap lib_cdc_v1_0_3 activehdl/lib_cdc_v1_0_3
vmap interrupt_control_v3_1_5 activehdl/interrupt_control_v3_1_5
vmap axi_gpio_v2_0_33 activehdl/axi_gpio_v2_0_33
vmap xil_defaultlib activehdl/xil_defaultlib

vcom -work axi_lite_ipif_v3_0_4 -93  \
"../../ipstatic/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work lib_cdc_v1_0_3 -93  \
"../../ipstatic/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work interrupt_control_v3_1_5 -93  \
"../../ipstatic/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_gpio_v2_0_33 -93  \
"../../ipstatic/hdl/axi_gpio_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  \
"../../../axigpio.gen/sources_1/ip/axi_gpio_0/sim/axi_gpio_0.vhd" \



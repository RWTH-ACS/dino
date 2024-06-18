# Create 3Mhz derived clock
#create_generated_clock -name villassensorif_clk -source [get_pins bd_main_i/user_si570_sysclk_clk_p] -divide_by 4 [get_pins bd_main_i/c_counter_binary_0/THRESH0]


# CONV L/S activate
# Pull all CONV_OE to high to activate L/S outputs  (HPC0)
#   CONV_OE      <-> FMC_LA20_N    <-> E12
set_property PACKAGE_PIN E12 [get_ports {conv_oe[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {conv_oe[0]}]

# RJ1 interface (HPC0)
#    RJ1_CLK     <-> FMC_LA00_CC_P  <-> F17
#    RJ1_CLK_DE  <-> FMC_LA00_CC_N  <-> F16
#    RJ1_DATA    <-> FMC_LA05_P     <-> K17
#    RJ1_DATA_DE <-> FMC_LA05_N     <-> J17
#    RJ1_CONV    <-> FMC_LA02_P     <-> L20
#    RJ1_SCL     <-> SC5            <-> FMC_LA23_P
#    RJ1_SDO     <-> SD5            <-> FMC_LA23_N
set_property PACKAGE_PIN F17 [get_ports serial_clk_1]
set_property IOSTANDARD LVCMOS18 [get_ports serial_clk_1]
set_property PACKAGE_PIN F16 [get_ports {serial_clk_de[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_clk_de[0]}]
set_property PACKAGE_PIN K17 [get_ports serial_data_1]
set_property IOSTANDARD LVCMOS18 [get_ports serial_data_1]
set_property PACKAGE_PIN J17 [get_ports {serial_data_de[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_data_de[0]}]
set_property PACKAGE_PIN L20 [get_ports conv_1]
set_property IOSTANDARD LVCMOS18 [get_ports conv_1]


# RJ2 interface (HPC0)
#    RJ2_CLK     <-> FMC_LA11_P  <-> A13
#    RJ2_CLK_DE  <-> FMC_LA11_N  <-> A12
#    RJ2_DATA    <-> FMC_LA07_P  <-> J16
#    RJ2_DATA_DE <-> FMC_LA07_N  <-> J15
#    RJ2_CONV    <-> FMC_LA15_P  <-> D16
#    RJ2_SCL     <-> SC7         <-> FMC_LA23_P
#    RJ2_SDO     <-> SD7         <-> FMC_LA23_N
set_property PACKAGE_PIN A13 [get_ports serial_clk_2]
set_property IOSTANDARD LVCMOS18 [get_ports serial_clk_2]
set_property PACKAGE_PIN A12 [get_ports {serial_clk_de[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_clk_de[1]}]
set_property PACKAGE_PIN J16 [get_ports serial_data_2]
set_property IOSTANDARD LVCMOS18 [get_ports serial_data_2]
set_property PACKAGE_PIN J15 [get_ports {serial_data_de[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_data_de[1]}]
set_property PACKAGE_PIN D16 [get_ports conv_2]
set_property IOSTANDARD LVCMOS18 [get_ports conv_2]

# RJ3 interface (HPC0)
#    RJ3_CLK     <-> FMC_LA25_P    <-> C7
#    RJ3_CLK_DE  <-> FMC_LA25_N    <-> C6
#    RJ3_DATA    <-> FMC_LA21_P    <-> B10
#    RJ3_DATA_DE <-> FMC_LA21_N    <-> A10
#    RJ3_CONV    <-> FMC_LA19_N    <-> C11
#    RJ3_SCL     <-> SC1           <-> FMC_LA23_P
#    RJ3_SDO     <-> SD1           <-> FMC_LA23_N
set_property PACKAGE_PIN C7 [get_ports serial_clk_3]
set_property IOSTANDARD LVCMOS18 [get_ports serial_clk_3]
set_property PACKAGE_PIN C6 [get_ports {serial_clk_de[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_clk_de[2]}]
set_property PACKAGE_PIN B10 [get_ports serial_data_3]
set_property IOSTANDARD LVCMOS18 [get_ports serial_data_3]
set_property PACKAGE_PIN A10 [get_ports {serial_data_de[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_data_de[2]}]
set_property PACKAGE_PIN C11 [get_ports conv_3]
set_property IOSTANDARD LVCMOS18 [get_ports conv_3]

# RJ4 interface (HPC0)
#    RJ4_CLK     <-> FMC_LA31_N    <-> E7
#    RJ4_CLK_DE  <-> FMC_LA31_P    <-> F7
#    RJ4_DATA    <-> FMC_LA30_P    <-> E9
#    RJ4_DATA_DE <-> FMC_LA30_N    <-> D9
#    RJ4_CONV    <-> FMC_LA29_N    <-> J10
#    RJ4_SCL     <-> SC3           <-> FMC_LA23_P
#    RJ4_SDO     <-> SD3           <-> FMC_LA23_N
set_property PACKAGE_PIN E7 [get_ports serial_clk_4]
set_property IOSTANDARD LVCMOS18 [get_ports serial_clk_4]
set_property PACKAGE_PIN F7 [get_ports {serial_clk_de[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_clk_de[3]}]
set_property PACKAGE_PIN E9 [get_ports serial_data_4]
set_property IOSTANDARD LVCMOS18 [get_ports serial_data_4]
set_property PACKAGE_PIN D9 [get_ports {serial_data_de[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_data_de[3]}]
set_property PACKAGE_PIN J10 [get_ports conv_4]
set_property IOSTANDARD LVCMOS18 [get_ports conv_4]

# RJ5 interface (HPC0)
#    RJ5_CLK     <-> FMC_LA06_P    <-> H19
#    RJ5_CLK_DE  <-> FMC_LA06_N    <-> G19
#    RJ5_DATA    <-> FMC_LA01_CC_N <-> H17
#    RJ5_DATA_DE <-> FMC_LA01_CC_P <-> H18
#    RJ5_CONV    <-> FMC_LA02_N    <-> K20
#    RJ5_SCL     <-> SC4           <-> FMC_LA23_P
#    RJ5_SDO     <-> SD4           <-> FMC_LA23_N
set_property PACKAGE_PIN H19 [get_ports serial_clk_5]
set_property IOSTANDARD LVCMOS18 [get_ports serial_clk_5]
set_property PACKAGE_PIN G19 [get_ports {serial_clk_de[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_clk_de[4]}]
set_property PACKAGE_PIN H17 [get_ports serial_data_5]
set_property IOSTANDARD LVCMOS18 [get_ports serial_data_5]
set_property PACKAGE_PIN H18 [get_ports {serial_data_de[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_data_de[4]}]
set_property PACKAGE_PIN K20 [get_ports conv_5]
set_property IOSTANDARD LVCMOS18 [get_ports conv_5]

# RJ6 interface (HPC0)
#    RJ6_CLK     <-> FMC_LA04_P    <-> L17
#    RJ6_CLK_DE  <-> FMC_LA04_N    <-> L16
#    RJ6_DATA    <-> FMC_LA03_P    <-> K19
#    RJ6_DATA_DE <-> FMC_LA03_N    <-> K18
#    RJ6_CONV    <-> FMC_LA15_N    <-> C16
#    RJ6_SCL     <-> SC6           <-> FMC_LA23_P
#    RJ6_SDO     <-> SD6           <-> FMC_LA23_N
set_property PACKAGE_PIN L17 [get_ports serial_clk_6]
set_property IOSTANDARD LVCMOS18 [get_ports serial_clk_6]
set_property PACKAGE_PIN L16 [get_ports {serial_clk_de[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_clk_de[5]}]
set_property PACKAGE_PIN K19 [get_ports serial_data_6]
set_property IOSTANDARD LVCMOS18 [get_ports serial_data_6]
set_property PACKAGE_PIN K18 [get_ports {serial_data_de[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_data_de[5]}]
set_property PACKAGE_PIN C16 [get_ports conv_6]
set_property IOSTANDARD LVCMOS18 [get_ports conv_6]

# RJ7 interface (HPC0)
#    RJ7_CLK     <-> FMC_LA28_P    <-> M13
#    RJ7_CLK_DE  <-> FMC_LA28_N    <-> L13
#    RJ7_DATA    <-> FMC_LA24_P    <-> B6
#    RJ7_DATA_DE <-> FMC_LA24_N    <-> A6
#    RJ7_CONV    <-> FMC_LA19_P    <-> D12
#    RJ7_SCL     <-> SC0           <-> FMC_LA23_P
#    RJ7_SDO     <-> SD0           <-> FMC_LA23_N
set_property PACKAGE_PIN M13 [get_ports serial_clk_7]
set_property IOSTANDARD LVCMOS18 [get_ports serial_clk_7]
set_property PACKAGE_PIN L13 [get_ports {serial_clk_de[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_clk_de[6]}]
set_property PACKAGE_PIN B6 [get_ports serial_data_7]
set_property IOSTANDARD LVCMOS18 [get_ports serial_data_7]
set_property PACKAGE_PIN A6 [get_ports {serial_data_de[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_data_de[6]}]
set_property PACKAGE_PIN D12 [get_ports conv_7]
set_property IOSTANDARD LVCMOS18 [get_ports conv_7]

# RJ8 interface (HPC0)
#    RJ8_CLK     <-> FMC_LA33_P        <-> C9
#    RJ8_CLK_DE  <-> FMC_LA33_N        <-> C8
#    RJ8_DATA    <-> FMC_LA32_P        <-> F8
#    RJ8_DATA_DE <-> FMC_LA32_N        <-> E8
#    RJ8_CONV    <-> FMC_LA29_P        <-> K10
#    RJ8_SCL     <-> SC2               <-> FMC_LA23_P
#    RJ8_SDO     <-> SD2               <-> FMC_LA23_N
set_property PACKAGE_PIN C9 [get_ports serial_clk_8]
set_property IOSTANDARD LVCMOS18 [get_ports serial_clk_8]
set_property PACKAGE_PIN C8 [get_ports {serial_clk_de[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_clk_de[7]}]
set_property PACKAGE_PIN F8 [get_ports serial_data_8]
set_property IOSTANDARD LVCMOS18 [get_ports serial_data_8]
set_property PACKAGE_PIN E8 [get_ports {serial_data_de[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {serial_data_de[7]}]
set_property PACKAGE_PIN K10 [get_ports conv_8]
set_property IOSTANDARD LVCMOS18 [get_ports conv_8]

# 250.0MHz GT Reference clock constraint
#create_clock -name GT_REFCLK1 -period 4.0	 [get_ports GT_DIFF_REFCLK1_0_clk_p]
# Reference clock location
set_property PACKAGE_PIN W9 [get_ports {GT_DIFF_REFCLK1_0_clk_n[0]}]
set_property PACKAGE_PIN W10 [get_ports {GT_DIFF_REFCLK1_0_clk_p[0]}]
# Transceiver P1
#set_property LOC GTHE4_CHANNEL_X0Y10 [get_cells {bd_main_i/aurora/aurora_8b10b_0/U0/bd_main_aurora_8b10b_0_2_core_i/gt_wrapper_i/bd_main_aurora_8b10b_0_2_gt_i/inst/gen_gtwizard_gthe4_top.bd_main_aurora_8b10b_0_2_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[2].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST}]
#set_property LOC GTHE4_CHANNEL_X0Y10 [get_cells {design_1_i/aurora/util_ds_buf_0/U0/USE_IBUFDS_GTE4.GEN_IBUFDS_GTE4[0].IBUFDS_GTE4_I}]
set_property PACKAGE_PIN AA2 [get_ports {GT_SERIAL_RX_0_rxp[0]}]
set_property PACKAGE_PIN AA1 [get_ports {GT_SERIAL_RX_0_rxn[0]}]
set_property PACKAGE_PIN Y4 [get_ports {GT_SERIAL_TX_0_txp[0]}]
set_property PACKAGE_PIN Y3 [get_ports {GT_SERIAL_TX_0_txn[0]}]

# I2C interface (HPC0)
#   SDA     <-> FMC_LA23_N  <-> A11
#   SCL     <-> FMC_LA23_P  <-> B11
set_property PACKAGE_PIN A11 [get_ports I2C0_sda_io]
set_property IOSTANDARD LVCMOS18 [get_ports I2C0_sda_io]
set_property OFFCHIP_TERM NONE [get_ports I2C0_sda_io]
set_property PULLUP true [get_ports I2C0_sda_io]
set_property PACKAGE_PIN B11 [get_ports I2C0_scl_io]
set_property IOSTANDARD LVCMOS18 [get_ports I2C0_scl_io]
set_property OFFCHIP_TERM NONE [get_ports I2C0_scl_io]
set_property PULLUP true [get_ports I2C0_scl_io]


## LEDs
set_property PACKAGE_PIN AL11 [get_ports {leds[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {leds[0]}]
set_property PACKAGE_PIN AL13 [get_ports {leds[1]}]
set_property IOSTANDARD LVCMOS12 [get_ports {leds[1]}]
set_property PACKAGE_PIN AK13 [get_ports {leds[2]}]
set_property IOSTANDARD LVCMOS12 [get_ports {leds[2]}]
set_property PACKAGE_PIN AE15 [get_ports {leds[3]}]
set_property IOSTANDARD LVCMOS12 [get_ports {leds[3]}]
set_property PACKAGE_PIN AM8 [get_ports {leds[4]}]
set_property IOSTANDARD LVCMOS12 [get_ports {leds[4]}]
set_property PACKAGE_PIN AM9 [get_ports {leds[5]}]
set_property IOSTANDARD LVCMOS12 [get_ports {leds[5]}]
set_property PACKAGE_PIN AM10 [get_ports {leds[6]}]
set_property IOSTANDARD LVCMOS12 [get_ports {leds[6]}]
set_property PACKAGE_PIN AM11 [get_ports {leds[7]}]
set_property IOSTANDARD LVCMOS12 [get_ports {leds[7]}]


set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]

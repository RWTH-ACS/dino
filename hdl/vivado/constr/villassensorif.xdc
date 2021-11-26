#create_generated_clock -name villassensor_clk -source [get_pins bd_main_i/clk_wiz_0/inst/plle4_adv_inst/CLKIN] -edges {1 2 3} -edge_shift {0.000 23.331 46.662} -add -master_clock user_si570_sysclk_clk_p [get_pins bd_main_i/clk_wiz_0/inst/plle4_adv_inst/CLKOUT0]
#set_false_path -hold -from [get_clocks user_si570_sysclk_clk_p] -through [get_nets bd_main_i/clk_wiz_0/inst/villassensor_clk_bd_main_clk_wiz_0_0]
#set_false_path -from [get_clocks villassensor_clk] -through [get_nets bd_main_i/clk_wiz_0/inst/villassensor_clk_bd_main_clk_wiz_0_0]
#set_clock_groups -physically_exclusive -group [get_clocks {user_si570_sysclk_clk_p villassensor_clk}]

create_generated_clock -name villassensorif_clk -source [get_pins bd_main_i/user_si570_sysclk_clk_p] -divide_by 2 [get_pins bd_main_i/c_counter_binary_0/THRESH0]


# IO for villassensor
set_property PACKAGE_PIN B23 [get_ports conv_0]
set_property IOSTANDARD LVCMOS18 [get_ports conv_0]
set_property PACKAGE_PIN K24 [get_ports serial_data_0]
set_property IOSTANDARD LVCMOS18 [get_ports serial_data_0]
set_property PACKAGE_PIN A23 [get_ports serial_clk_0]
set_property IOSTANDARD LVCMOS18 [get_ports serial_clk_0]

# Debug hub
set_property C_CLK_INPUT_FREQ_HZ 30000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_pins bd_main_i/clk_wiz_0/ila_clk]

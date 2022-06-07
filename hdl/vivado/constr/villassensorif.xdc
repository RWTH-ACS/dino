# Create 3Mhz derived clock
create_generated_clock -name villassensorif_clk -source [get_pins bd_main_i/user_si570_sysclk_clk_p] -divide_by 4 [get_pins bd_main_i/c_counter_binary_0/THRESH0]


# CONV L/S activate
# Pull all CONV_OE to high to activate L/S outputs
#   CONV_OE      <-> FMC_LA02_N    <-> K23
set_property PACKAGE_PIN K23 [get_ports conv_oe]
set_property IOSTANDARD LVCMOS18 [get_ports conv_oe]

# RJ2 interface
#    RJ2_CLK     <-> FMC_LA10_N  <-> E22
#    RJ2_CLK_DE  <-> FMC_LA10_P  <-> F22
#    RJ2_DATA    <-> FMC_LA09_N  <-> F20
#    RJ2_DATA_DE <-> FMC_LA09_P  <-> G20
#    RJ2_CONV    <-> FMC_LA08_N  <-> H26
#    RJ2_SCL     <-> SC7         <-> FMC_LA05_N
#    RJ2_SDO     <-> SD7         <-> FMC_LA05_P
set_property PACKAGE_PIN H26 [get_ports conv_2]
set_property IOSTANDARD LVCMOS18 [get_ports conv_2]
set_property PACKAGE_PIN G20 [get_ports {driver_enables[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {driver_enables[3]}]
set_property PACKAGE_PIN F20 [get_ports serial_data_2]
set_property IOSTANDARD LVCMOS18 [get_ports serial_data_2]
set_property PACKAGE_PIN F22 [get_ports {driver_enables[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {driver_enables[2]}]
set_property PACKAGE_PIN E22 [get_ports serial_clk_2]
set_property IOSTANDARD LVCMOS18 [get_ports serial_clk_2]

# RJ3 interface
#    RJ3_CLK     <-> FMC_LA06_N    <-> H22
#    RJ3_CLK_DE  <-> FMC_LA06_P    <-> H21
#    RJ3_DATA    <-> FMC_LA01_CC_N <-> D24
#    RJ3_DATA_DE <-> FMC_LA01_CC_P <-> E24
#    RJ3_CONV    <-> FMC_LA03_P    <-> J21
#    RJ3_SCL     <-> SC1           <-> FMC_LA05_N
#    RJ3_SDO     <-> SD1           <-> FMC_LA05_P
set_property PACKAGE_PIN J21 [get_ports conv_3]
set_property IOSTANDARD LVCMOS18 [get_ports conv_3]
set_property PACKAGE_PIN E24 [get_ports {driver_enables[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {driver_enables[1]}]
set_property PACKAGE_PIN D24 [get_ports serial_data_3]
set_property IOSTANDARD LVCMOS18 [get_ports serial_data_3]
set_property PACKAGE_PIN H21 [get_ports {driver_enables[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {driver_enables[0]}]
set_property PACKAGE_PIN H22 [get_ports serial_clk_3]
set_property IOSTANDARD LVCMOS18 [get_ports serial_clk_3]

# I2C interface
#   SDA     <-> FMC_LA05_P  <-> G25
#   SCL     <-> FMC_LA05_N  <-> G26
set_property PACKAGE_PIN G25 [get_ports {i2c_sda[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {i2c_sda[0]}]
set_property PACKAGE_PIN G26 [get_ports {i2c_scl[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {i2c_scl[0]}]
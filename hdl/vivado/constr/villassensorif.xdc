# Create 3Mhz derived clock
#create_generated_clock -name villassensorif_clk -source [get_pins bd_main_i/user_si570_sysclk_clk_p] -divide_by 4 [get_pins bd_main_i/c_counter_binary_0/THRESH0]


# CONV L/S activate
# Pull all CONV_OE to high to activate L/S outputs  (HPC0 | HPC1)
#   CONV_OE      <-> FMC_LA02_N    <-> K20 | K23
set_property PACKAGE_PIN K23 [get_ports conv_oe]
set_property IOSTANDARD LVCMOS18 [get_ports conv_oe]

# RJ1 interface (HPC0 | HPC1)
#    RJ1_CLK     <-> FMC_LA16_N  <-> C17 | C19
#    RJ1_CLK_DE  <-> FMC_LA16_P  <-> D17 | C18
#    RJ1_DATA    <-> FMC_LA15_N  <-> C16 | A19
#    RJ1_DATA_DE <-> FMC_LA15_P  <-> D16 | A18
#    RJ1_CONV    <-> FMC_LA12_N  <-> F18 | D19
#    RJ1_SCL     <-> SC5         <-> FMC_LA05_N
#    RJ1_SDO     <-> SD5         <-> FMC_LA05_P
set_property PACKAGE_PIN C19        [get_ports serial_clk_1]
set_property IOSTANDARD LVCMOS18    [get_ports serial_clk_1]
set_property PACKAGE_PIN C18        [get_ports {serial_clk_de[0]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_clk_de[0]}]
set_property PACKAGE_PIN A19        [get_ports serial_data_1]
set_property IOSTANDARD LVCMOS18    [get_ports serial_data_1]
set_property PACKAGE_PIN A18        [get_ports {serial_data_de[0]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_data_de[0]}]
set_property PACKAGE_PIN D19        [get_ports conv_1]
set_property IOSTANDARD LVCMOS18    [get_ports conv_1]


# RJ2 interface (HPC0 | HPC1)
#    RJ2_CLK     <-> FMC_LA10_N  <-> K15 | E22
#    RJ2_CLK_DE  <-> FMC_LA10_P  <-> L15 | F22
#    RJ2_DATA    <-> FMC_LA09_N  <-> G16 | F20
#    RJ2_DATA_DE <-> FMC_LA09_P  <-> H16 | G20
#    RJ2_CONV    <-> FMC_LA08_N  <-> E17 | H26
#    RJ2_SCL     <-> SC7         <-> FMC_LA05_N
#    RJ2_SDO     <-> SD7         <-> FMC_LA05_P
set_property PACKAGE_PIN E22        [get_ports serial_clk_2]
set_property IOSTANDARD LVCMOS18    [get_ports serial_clk_2]
set_property PACKAGE_PIN F22        [get_ports {serial_clk_de[1]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_clk_de[1]}]
set_property PACKAGE_PIN F20        [get_ports serial_data_2]
set_property IOSTANDARD LVCMOS18    [get_ports serial_data_2]
set_property PACKAGE_PIN G20        [get_ports {serial_data_de[1]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_data_de[1]}]
set_property PACKAGE_PIN H26        [get_ports conv_2]
set_property IOSTANDARD LVCMOS18    [get_ports conv_2]

# RJ3 interface (HPC0 | HPC1)
#    RJ3_CLK     <-> FMC_LA06_N    <-> G19 | H22
#    RJ3_CLK_DE  <-> FMC_LA06_P    <-> H19 | H21
#    RJ3_DATA    <-> FMC_LA01_CC_N <-> H17 | D24
#    RJ3_DATA_DE <-> FMC_LA01_CC_P <-> H18 | E24
#    RJ3_CONV    <-> FMC_LA03_P    <-> K19 | J21
#    RJ3_SCL     <-> SC1           <-> FMC_LA05_N
#    RJ3_SDO     <-> SD1           <-> FMC_LA05_P
set_property PACKAGE_PIN H22        [get_ports serial_clk_3]
set_property IOSTANDARD LVCMOS18    [get_ports serial_clk_3]
set_property PACKAGE_PIN H21        [get_ports {serial_clk_de[2]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_clk_de[2]}]
set_property PACKAGE_PIN D24        [get_ports serial_data_3]
set_property IOSTANDARD LVCMOS18    [get_ports serial_data_3]
set_property PACKAGE_PIN E24        [get_ports {serial_data_de[2]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_data_de[2]}]
set_property PACKAGE_PIN J21        [get_ports conv_3]
set_property IOSTANDARD LVCMOS18    [get_ports conv_3]

# RJ4 interface (HPC0 | HPC1)
#    RJ4_CLK     <-> FMC_DP0_C2M_N <-> R5  | AJ5
#    RJ4_CLK_DE  <-> FMC_DP0_C2M_P <-> R6  | AJ6
#    RJ4_DATA    <-> FMC_LA00_CC_N <-> F16 | B19
#    RJ4_DATA_DE <-> FMC_LA00_CC_P <-> F17 | B18
#    RJ4_CONV    <-> FMC_LA02_P    <-> L20 | K22
#    RJ4_SCL     <-> SC3           <-> FMC_LA05_N
#    RJ4_SDO     <-> SD3           <-> FMC_LA05_P
set_property PACKAGE_PIN K22        [get_ports {serial_clk_de[3]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_clk_de[3]}]
set_property PACKAGE_PIN B18        [get_ports {serial_data_de[3]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_data_de[3]}]
# RJ5 interface (HPC0 | HPC1)
#    RJ5_CLK     <-> FMC_LA11_N    <-> A12 | A21
#    RJ5_CLK_DE  <-> FMC_LA11_P    <-> A13 | A20
#    RJ5_DATA    <-> FMC_LA07_N    <-> J15 | C23
#    RJ5_DATA_DE <-> FMC_LA07_P    <-> J16 | D22
#    RJ5_CONV    <-> FMC_LA12_P    <-> G18 | E19
#    RJ5_SCL     <-> SC4           <-> FMC_LA05_N
#    RJ5_SDO     <-> SD4           <-> FMC_LA05_P
set_property PACKAGE_PIN A21        [get_ports serial_clk_5]
set_property IOSTANDARD LVCMOS18    [get_ports serial_clk_5]
set_property PACKAGE_PIN A20        [get_ports {serial_clk_de[4]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_clk_de[4]}]
set_property PACKAGE_PIN C23        [get_ports serial_data_5]
set_property IOSTANDARD LVCMOS18    [get_ports serial_data_5]
set_property PACKAGE_PIN D22        [get_ports {serial_data_de[4]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_data_de[4]}]
set_property PACKAGE_PIN E19        [get_ports conv_5]
set_property IOSTANDARD LVCMOS18    [get_ports conv_5]

# RJ6 interface (HPC0 | HPC1)
#    RJ6_CLK     <-> FMC_LA14_N    <-> C12 | D21
#    RJ6_CLK_DE  <-> FMC_LA14_P    <-> C13 | D20
#    RJ6_DATA    <-> FMC_LA13_N    <-> F15 | C22
#    RJ6_DATA_DE <-> FMC_LA13_P    <-> G15 | C21
#    RJ6_CONV    <-> FMC_LA08_P    <-> E18 | J25
#    RJ6_SCL     <-> SC6           <-> FMC_LA05_N
#    RJ6_SDO     <-> SD6           <-> FMC_LA05_P
set_property PACKAGE_PIN D21        [get_ports serial_clk_6]
set_property IOSTANDARD LVCMOS18    [get_ports serial_clk_6]
set_property PACKAGE_PIN D20        [get_ports {serial_clk_de[5]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_clk_de[5]}]
set_property PACKAGE_PIN C22        [get_ports serial_data_6]
set_property IOSTANDARD LVCMOS18    [get_ports serial_data_6]
set_property PACKAGE_PIN C21        [get_ports {serial_data_de[5]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_data_de[5]}]
set_property PACKAGE_PIN J25        [get_ports conv_6]
set_property IOSTANDARD LVCMOS18    [get_ports conv_6]

# RJ7 interface (HPC0 | HPC1)
#    RJ7_CLK     <-> FMC_DP0_M2C_N <-> R1  | AK3
#    RJ7_CLK_DE  <-> FMC_DP0_M2C_P <-> R2  | AK4
#    RJ7_DATA    <-> FMC_LA04_N    <-> L16 | H24
#    RJ7_DATA_DE <-> FMC_LA04_P    <-> L17 | J24
#    RJ7_CONV    <-> FMC_LA03_N    <-> K18 | J22
#    RJ7_SCL     <-> SC0           <-> FMC_LA05_N
#    RJ7_SDO     <-> SD0           <-> FMC_LA05_P
set_property PACKAGE_PIN J22        [get_ports {serial_clk_de[6]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_clk_de[6]}]
set_property PACKAGE_PIN J24        [get_ports {serial_data_de[6]}]
set_property IOSTANDARD LVCMOS18    [get_ports {serial_data_de[6]}]

# RJ8 interface (HPC0 | HPC1)
#    RJ8_CLK     <-> FMC_HA01_CC_P <-> -
#    RJ8_CLK_DE  <-> FMC_HA01_CC_N <-> -
#    RJ8_DATA    <-> FMC_HA00_CC_N <-> -
#    RJ8_DATA_DE <-> FMC_HA00_CC_P <-> -
#    RJ8_CONV    <-> FMC_HA05_N    <-> -
#    RJ8_SCL     <-> SC2           <-> FMC_LA05_N
#    RJ8_SDO     <-> SD2           <-> FMC_LA05_P

# I2C interface
#   SDA     <-> FMC_LA05_P  <-> K17 | G25
#   SCL     <-> FMC_LA05_N  <-> J18 | G26
set_property PACKAGE_PIN G25 [get_ports {i2c_sda[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {i2c_sda[0]}]
set_property PACKAGE_PIN G26 [get_ports {i2c_scl[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {i2c_scl[0]}]
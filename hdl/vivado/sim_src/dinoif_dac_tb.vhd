----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/28/2023 02:51:57 PM
-- Design Name: 
-- Module Name: dinoif_dac_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dinoif_dac_tb is
--  Port ( );
end dinoif_dac_tb;

architecture Behavioral of dinoif_dac_tb is
component dinoif_dac is
    Port ( aclk : in STD_LOGIC;
           resetn : in STD_LOGIC;
           clk_20mhz : in STD_LOGIC;
           begin_conv : in STD_LOGIC;
           serial_data : out STD_LOGIC;      
           load : out STD_LOGIC;
           serial_clk : out STD_LOGIC;
           S00_AXIS_tdata : in STD_LOGIC_VECTOR (15 downto 0);
           S00_AXIS_tvalid : in STD_LOGIC;
           S00_AXIS_tlast : in STD_LOGIC;
           active : out STD_LOGIC
           );
    end component;
    component config_timer is
    Port ( clk : in STD_LOGIC;
           resetn : in STD_LOGIC;
           cmp_val : in STD_LOGIC_VECTOR (31 downto 0);
           thresh : out STD_LOGIC);
    end component;
    signal aclk : STD_LOGIC := '0';
    signal resetn : STD_LOGIC := '0';
    signal clk_20mhz : STD_LOGIC := '0';
    signal begin_conv : STD_LOGIC := '0';
    
    signal fpga_serial_data : STD_LOGIC := '0';
    signal fpga_load : STD_LOGIC;
    signal fpga_serial_clk : STD_LOGIC;
    signal dino_serial_data : STD_LOGIC := '0';
    signal dino_load : STD_LOGIC := '0';
    signal dino_serial_clk : STD_LOGIC := '0';
    
    signal S00_AXIS_tdata : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal S00_AXIS_tvalid : STD_LOGIC := '0';
    signal S00_AXIS_tlast : STD_LOGIC := '0';
    signal active : STD_LOGIC;
    
    constant aclk_frequ : natural := 50_000_000;
    constant aclk_period : time := ( 1 sec ) / aclk_frequ;
    constant clk_20mhz_frequ : natural := 20_000_000;
    constant clk_20mhz_period : time := ( 1 sec ) / clk_20mhz_frequ;
    
    constant timer_cmp_val : STD_LOGIC_VECTOR(31 downto 0) := std_logic_vector(to_unsigned(100, 32));
    
    constant dac_input1 : STD_LOGIC_VECTOR(15 downto 0) := b"1111010101010101";
    constant dac_input2 : STD_LOGIC_VECTOR(15 downto 0) := b"1000101010101010";
    
begin
    dinoif : dinoif_dac port map (
           aclk => aclk,
           resetn => resetn,
           clk_20mhz => clk_20mhz,
           begin_conv => begin_conv,
           serial_data => fpga_serial_data,
           load => fpga_load,
           serial_clk => fpga_serial_clk,
           S00_AXIS_tdata => S00_AXIS_tdata,
           S00_AXIS_tvalid => S00_AXIS_tvalid,
           S00_AXIS_tlast => S00_AXIS_tlast,
           active => active);
    timer : config_timer port map ( 
           clk => clk_20mhz,
           resetn => resetn,
           cmp_val => timer_cmp_val,
           thresh => begin_conv);
    process
    begin
        aclk <= '1';
        wait for aclk_period/2;
        aclk <= '0';
        wait for aclk_period/2;    
    end process;
    
    process
    begin
        clk_20mhz <= '1';
        wait for clk_20mhz_period/2;
        clk_20mhz <= '0';
        wait for clk_20mhz_period/2;    
    end process;

    -- Simulate delay line
    -- ADUM4120-1 propagation delay 22-58ns
    dino_load <= transport fpga_load after 60ns;
    -- ADM2486 propagation delay 25-55 ns
    dino_serial_clk <= transport fpga_serial_clk after 20ns;
    dino_serial_data <= transport fpga_serial_data after 20ns;
  
    -- LTC2312-14 behavioral model
    process
    begin
        S00_AXIS_tdata <= (others => '0');
        S00_AXIS_tvalid <= '0';
        S00_AXIS_tlast <= '0';
        wait until resetn = '1';
        wait until rising_edge(clk_20mhz);
        S00_AXIS_tdata <= dac_input1;
        S00_AXIS_tvalid <= '1';
        S00_AXIS_tlast <= '1';
        wait until rising_edge(clk_20mhz);
        S00_AXIS_tdata <= (others => '0');
        S00_AXIS_tvalid <= '0';
        S00_AXIS_tlast <= '0';
        wait until rising_edge(begin_conv);
        wait until rising_edge(clk_20mhz);
        S00_AXIS_tdata <= dac_input2;
        S00_AXIS_tvalid <= '1';
        S00_AXIS_tlast <= '1';
        wait until rising_edge(clk_20mhz);
        S00_AXIS_tdata <= (others => '0');
        S00_AXIS_tvalid <= '0';
        S00_AXIS_tlast <= '0';
        wait until rising_edge(begin_conv);
    end process;
    
    process
    begin
        wait for 1000ns;
        resetn <= '1';
        wait;
    end process;
end Behavioral;

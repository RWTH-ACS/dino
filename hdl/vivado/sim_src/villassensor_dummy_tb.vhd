----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 03:48:38 PM
-- Design Name: 
-- Module Name: villassensor_dummy_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity villassensor_dummy_tb is
--  Port ( );
end villassensor_dummy_tb;

architecture Behavioral of villassensor_dummy_tb is
component villassensorif is
    Port ( clk : in STD_LOGIC;
           resetn : in STD_LOGIC;
           begin_conv : in STD_LOGIC;
           serial_data : in STD_LOGIC;      
           conv : out STD_LOGIC;
           serial_clk : out STD_LOGIC;
           --S00_AXIS_tdata : in STD_LOGIC_VECTOR (15 downto 0);
           --S00_AXIS_tvalid : in STD_LOGIC;
           --S00_AXIS_tready : out STD_LOGIC;
           M00_AXIS_tdata : out STD_LOGIC_VECTOR (15 downto 0);
           M00_AXIS_tvalid: out STD_LOGIC;
           M00_AXIS_tlast: out STD_LOGIC
           );
    end component;
component villassensor_dummy is
   Port ( clk : in STD_LOGIC;
           conv : in STD_LOGIC;
           serial_data : out STD_LOGIC);
end component;

  signal clk : STD_LOGIC := '0';
  signal resetn : STD_LOGIC := '1';
  signal begin_conv : STD_LOGIC := '0';
  signal serial_data : STD_LOGIC;
  signal conv : STD_LOGIC;
  signal serial_clk : STD_LOGIC;
  signal value : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
  signal value_rdy : STD_LOGIC;  
  signal axis_tlast : STD_LOGIC;
  
  signal conv_ready : STD_LOGIC := '0';
  
begin
 vs : villassensorif port map (clk => clk,
           resetn => resetn,
           begin_conv => begin_conv,
           serial_data => serial_data,
           conv => conv,
           serial_clk => serial_clk,
           --S00_AXIS_tdata => axis_in_tdata,
           --S00_AXIS_tvalid => axis_in_tvalid,
           --S00_AXIS_tready => axis_in_tready,
           M00_AXIS_tdata => value,
           M00_AXIS_tvalid => value_rdy,
           M00_AXIS_tlast => axis_tlast);
    dummy : villassensor_dummy port map (clk => serial_clk,
           conv => conv,
           serial_data => serial_data);

    process
    begin
        clk <= '1';
        wait for 25ns;
        clk <= '0';
        wait for 25ns;    
    end process;
    
    process
    begin
        wait for 49950ns;
        begin_conv <= '1';
        wait for 50ns;
        begin_conv <= '0';
    end process;
    
    process
    begin
        wait until rising_edge(conv) and conv_ready='0';
        conv_ready <= '1' after 1700ns;
    end process;
    
end Behavioral;

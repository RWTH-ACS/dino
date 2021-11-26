----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2021 10:53:15 AM
-- Design Name: 
-- Module Name: config_timer_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity config_timer_tb is
--  Port ( );
end config_timer_tb;

architecture Behavioral of config_timer_tb is
    component config_timer is
    Port ( clk : in STD_LOGIC;
           resetn : in STD_LOGIC;
           cmp_val : in STD_LOGIC_VECTOR (31 downto 0);
           thresh : out STD_LOGIC);
    end component;
    
    signal clk : STD_LOGIC := '0';
    signal resetn : STD_LOGIC := '0';
    signal cmp_val : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal thresh : STD_LOGIC;
begin
    UUT : config_timer port map (clk => clk,
        resetn => resetn,
        cmp_val => cmp_val,
        thresh => thresh);

process begin
    clk <= '1';
    wait for 25ns;
    clk <= '0';
    wait for 25ns;    
end process;

process begin
    wait for 100ns;
    resetn <= '1';
    wait for 200ns;
    cmp_val <= std_logic_vector(to_unsigned(20,32));
    wait for 10000ns;
    cmp_val <= std_logic_vector(to_unsigned(10,32));
    wait for 10000ns;
end process;

end Behavioral;

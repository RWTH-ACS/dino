----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2022 05:22:21 PM
-- Design Name: 
-- Module Name: aurora_demo - Behavioral
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

entity aurora_reset is
    Port ( clk : in STD_LOGIC;
           reset : out STD_LOGIC
           );
end aurora_reset;

architecture Behavioral of aurora_reset is
    signal clk_cnt : integer := 0;
    signal do_reset : std_logic := '1';
    
    constant send_frequency : integer := 10000;
    constant clock_frequency : integer := 100e6;    
    
begin

reset <= do_reset;

process (clk, clk_cnt) begin
    if rising_edge(clk) then
        if do_reset = '1' then
            clk_cnt <= clk_cnt + 1;
        end if;
        if clk_cnt >= 500 then
            do_reset <= '0';
        end if;
    end if;
end process;
    
end Behavioral;

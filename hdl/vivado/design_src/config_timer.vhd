----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2021 10:31:17 AM
-- Design Name: 
-- Module Name: config_timer - Behavioral
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

entity config_timer is
    Port ( clk : in STD_LOGIC;
           resetn : in STD_LOGIC;
           cmp_val : in STD_LOGIC_VECTOR (31 downto 0);
           thresh : out STD_LOGIC);
end config_timer;

architecture Behavioral of config_timer is
    signal cmp : integer := 0;
    signal cnt : integer := 0; 
begin

process (clk, resetn, cmp_val, cnt) begin
    if rising_edge(clk) then
        if resetn='0' then
            cmp <= 0;
            cnt <= 0;
        else
            cnt <= cnt + 1;
            cmp <= to_integer(unsigned(cmp_val));
            if cnt >= cmp then
                thresh <= '1';
                cnt <= 0;
            else
                thresh <= '0';
            end if;
        end if;
    end if;
end process;

end Behavioral;

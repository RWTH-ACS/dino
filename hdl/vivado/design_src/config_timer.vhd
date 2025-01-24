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
           cmp_val_clk : in STD_LOGIC;
           cmp_val : in STD_LOGIC_VECTOR (31 downto 0);
           cmp_val_pre_thresh : in STD_LOGIC_VECTOR(31 downto 0);
           thresh : out STD_LOGIC;
           pre_thresh : out STD_LOGIC);
end config_timer;

architecture Behavioral of config_timer is
    signal cmp : integer := 0;
    signal cmp_pre_thresh : integer := 0;
    signal cnt : integer := 0;
begin

process (cmp_val_clk, resetn, cmp_val) begin
    if rising_edge(cmp_val_clk) then
       if resetn='0' then
        cmp <= 0;
        cmp_pre_thresh <= 0;
       else 
        cmp <= to_integer(unsigned(cmp_val));
        cmp_pre_thresh <= to_integer(unsigned(cmp_val_pre_thresh));
       end if;
    end if;
end process;

process (clk, resetn, cmp, cnt) begin
    if rising_edge(clk) then
        if resetn='0' then
            cnt <= 0;
        else
            cnt <= cnt + 1;
            if cnt = cmp_pre_thresh then
                pre_thresh <= '1';
            else
                pre_thresh <= '0';
            end if;
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

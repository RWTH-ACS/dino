----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 01:44:49 PM
-- Design Name: 
-- Module Name: villassensor_dummy - Behavioral
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

entity villassensor_dummy is
    Port ( clk : in STD_LOGIC;
           conv : in STD_LOGIC;
           serial_data : out STD_LOGIC);
end villassensor_dummy;

architecture Behavioral of villassensor_dummy is
    signal serial_data_out : STD_LOGIC := '0';
    signal data_cnt : integer := 0;
    signal sample_cnt : integer := 0;
    signal sample_cnt_reg : STD_LOGIC_VECTOR(13 downto 0) := (others => '0');
begin

process(clk, data_cnt, sample_cnt_reg, sample_cnt) begin
    if rising_edge(clk) then
        data_cnt <= data_cnt + 1;
        if data_cnt >= 1 then
            serial_data_out <= sample_cnt_reg(13);
            sample_cnt_reg <= sample_cnt_reg(12 downto 0) & '0';
        else
            serial_data_out <= '0';
            sample_cnt_reg <= sample_cnt_reg;
        end if;

        
        if data_cnt = 0 then           
            sample_cnt <= sample_cnt + 1;
        end if;
                
        if data_cnt = 15 then
            sample_cnt_reg <= std_logic_vector(to_unsigned(sample_cnt,14));
            serial_data_out <= '0';
            data_cnt <= 0;
        end if;
    end if;

end process;
    serial_data <= serial_data_out;

end Behavioral;

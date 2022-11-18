----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2022 02:56:20 PM
-- Design Name: 
-- Module Name: append_seqnum - Behavioral
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

entity append_seqnum is
    Port ( clk : in STD_LOGIC;
           aresetn : in STD_LOGIC;
           S00_AXIS_tdata : in STD_LOGIC_VECTOR (31 downto 0);
           S00_AXIS_tvalid : in STD_LOGIC;
           S00_AXIS_tlast : in STD_LOGIC;
           M00_AXIS_tdata : out STD_LOGIC_VECTOR (31 downto 0);
           M00_AXIS_tvalid: out STD_LOGIC;
           M00_AXIS_tlast: out STD_LOGIC
           );
end append_seqnum;

architecture Behavioral of append_seqnum is
    -- natural has size of 31 bits unsigned
    signal cnt : natural := 0;
    type State_t is (FORWARD, APPEND);
    signal state : State_t := FORWARD;
begin
    
    process(clk, aresetn, S00_AXIS_tdata, S00_AXIS_tvalid, S00_AXIS_tlast, cnt, state) begin
        if rising_edge(clk) then
            if aresetn = '0' then
                cnt <= 0;
                M00_AXIS_tdata <= (others => '0');
                M00_AXIS_tvalid <= '0';
                M00_AXIS_tlast <= '0';
            else
                case state is
                    when FORWARD =>
                        M00_AXIS_tdata <= S00_AXIS_tdata;
                        M00_AXIS_tvalid <= S00_AXIS_tvalid;
                        M00_AXIS_tlast <= '0';
                        if (S00_AXIS_tlast = '1') then
                            state <= APPEND;
                        else
                            state <= FORWARD;
                        end if;
                    when APPEND =>
                        M00_AXIS_tdata <= std_logic_vector(to_unsigned(cnt, 32));
                        M00_AXIS_tvalid <= '1';
                        M00_AXIS_tlast <= '1';
                        cnt <= cnt + 1;
                        state <= FORWARD;
                end case;
            end if;
        end if;
    end process;
    

end Behavioral;

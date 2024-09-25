----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/02/2024 04:17:37 PM
-- Design Name: 
-- Module Name: preprend_seqnum - Behavioral
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

entity prepend_seqnum is
    generic (
        C_AXIS_DATA_WIDTH : integer := 32
    );
    Port ( aclk : in STD_LOGIC;
           aresetn : in STD_LOGIC;
           S00_AXIS_tdata : in STD_LOGIC_VECTOR (C_AXIS_DATA_WIDTH-1 downto 0);
           S00_AXIS_tvalid : in STD_LOGIC;
           S00_AXIS_tlast : in STD_LOGIC;
           M00_AXIS_tdata : out STD_LOGIC_VECTOR (C_AXIS_DATA_WIDTH-1 downto 0);
           M00_AXIS_tvalid: out STD_LOGIC;
           M00_AXIS_tlast: out STD_LOGIC;
           current_seqnum : out STD_LOGIC_VECTOR (C_AXIS_DATA_WIDTH-1 downto 0)
           );
end prepend_seqnum;

architecture Behavioral of prepend_seqnum is
-- natural has size of 31 bits unsigned
    signal seqnum : natural := 0;
    type State_t is (PREPEND, FORWARD);
    signal state : State_t := PREPEND;
    signal last_tdata : std_logic_vector(C_AXIS_DATA_WIDTH-1 downto 0) := (others => '0');
    signal last_tlast : std_logic := '0';
    signal last_tvalid : std_logic := '0';
begin   
 
current_seqnum <= std_logic_vector(to_unsigned(seqnum, C_AXIS_DATA_WIDTH));
 
process(aclk, aresetn, S00_AXIS_tdata, S00_AXIS_tvalid, S00_AXIS_tlast, seqnum, state, last_tdata, last_tlast, last_tvalid) begin
    if rising_edge(aclk) then
        if aresetn = '0' then
            seqnum <= 0;
            M00_AXIS_tdata <= (others => '0');
            M00_AXIS_tvalid <= '0';
            M00_AXIS_tlast <= '0';
            state <= PREPEND;
            last_tdata <= (others => '0');
            last_tlast <= '0';
            last_tvalid <= '0';
        else
            last_tdata <= S00_AXIS_tdata;
            last_tlast <= S00_AXIS_tlast;
            last_tvalid <= S00_AXIS_tvalid;
            
            case state is
                when PREPEND =>
                    M00_AXIS_tdata <= std_logic_vector(to_unsigned(seqnum, C_AXIS_DATA_WIDTH));
                    M00_AXIS_tvalid <= S00_AXIS_tvalid;
                    M00_AXIS_tlast <= '0';
                    if S00_AXIS_tvalid = '1' then
                        state <= FORWARD;
                        seqnum <= seqnum + 1;
                    else
                        state <= PREPEND;
                    end if;
                when FORWARD =>
                    M00_AXIS_tdata <= last_tdata;
                    M00_AXIS_tvalid <= last_tvalid;
                    M00_AXIS_tlast <= last_tlast;
                    if last_tlast = '1' then
                        state <= PREPEND;
                    else
                        state <= FORWARD;
                    end if;
            end case;
        end if;
    end if;
end process;

end Behavioral;

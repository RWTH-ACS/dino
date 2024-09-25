----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/02/2024 04:45:41 PM
-- Design Name: 
-- Module Name: prepend_seqnum_tb - Behavioral
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

entity prepend_seqnum_tb is
--  Port ( );
end prepend_seqnum_tb;

architecture Behavioral of prepend_seqnum_tb is
    component prepend_seqnum is
    Port ( aclk : in STD_LOGIC;
           aresetn : in STD_LOGIC;
           S00_AXIS_tdata : in STD_LOGIC_VECTOR (31 downto 0);
           S00_AXIS_tvalid : in STD_LOGIC;
           S00_AXIS_tlast : in STD_LOGIC;
           M00_AXIS_tdata : out STD_LOGIC_VECTOR (31 downto 0);
           M00_AXIS_tvalid: out STD_LOGIC;
           M00_AXIS_tlast: out STD_LOGIC;
           current_seqnum : out STD_LOGIC_VECTOR (31 downto 0)
           );
    end component;
    
    signal clk : STD_LOGIC := '0';
    signal aresetn : STD_LOGIC := '0';
    signal S00_AXIS_tdata : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal S00_AXIS_tvalid : STD_LOGIC := '0';
    signal S00_AXIS_tlast : STD_LOGIC := '0';
    signal M00_AXIS_tdata : STD_LOGIC_VECTOR (31 downto 0);
    signal M00_AXIS_tvalid : STD_LOGIC;
    signal M00_AXIS_tlast : STD_LOGIC;
    signal current_seqnum : STD_LOGIC_VECTOR(31 downto 0);

begin
    UUT : prepend_seqnum port map (aclk => clk,
        aresetn => aresetn,
        S00_AXIS_tdata => S00_AXIS_tdata,
        S00_AXIS_tvalid => S00_AXIS_tvalid,
        S00_AXIS_tlast => S00_AXIS_tlast,
        M00_AXIS_tdata => M00_AXIS_tdata,
        M00_AXIS_tvalid => M00_AXIS_tvalid,
        M00_AXIS_tlast => M00_AXIS_tlast,
        current_seqnum => current_seqnum);

process begin
    clk <= '1';
    wait for 25ns;
    clk <= '0';
    wait for 25ns;    
end process;

process begin
    wait for 100ns;
    aresetn <= '1';
    wait for 200ns;
    S00_AXIS_tdata <= std_logic_vector(to_unsigned(20,32));
    S00_AXIS_tvalid <= '1';
    S00_AXIS_tlast <= '1';
    wait for 50ns;
    S00_AXIS_tdata <= (others => '0');
    S00_AXIS_tvalid <= '0';
    S00_AXIS_tlast <= '0';
    wait for 10000ns;
    S00_AXIS_tdata <= std_logic_vector(to_unsigned(21,32));
    S00_AXIS_tvalid <= '1';
    S00_AXIS_tlast <= '0';
    wait for 50ns;
    S00_AXIS_tdata <= std_logic_vector(to_unsigned(22,32));
    S00_AXIS_tvalid <= '1';
    S00_AXIS_tlast <= '1';
    wait for 50ns;
    S00_AXIS_tdata <= std_logic_vector(to_unsigned(23,32));
    S00_AXIS_tvalid <= '1';
    S00_AXIS_tlast <= '0';
    wait for 50ns;
    S00_AXIS_tdata <= (others => '0');
    S00_AXIS_tvalid <= '0';
    S00_AXIS_tlast <= '0';
    wait for 50ns;
    S00_AXIS_tdata <= std_logic_vector(to_unsigned(22,32));
    S00_AXIS_tvalid <= '1';
    S00_AXIS_tlast <= '0';
    wait for 50ns;
    S00_AXIS_tdata <= std_logic_vector(to_unsigned(22,32));
    S00_AXIS_tvalid <= '1';
    S00_AXIS_tlast <= '0';
    wait for 50ns;
    S00_AXIS_tdata <= std_logic_vector(to_unsigned(22,32));
    S00_AXIS_tvalid <= '1';
    S00_AXIS_tlast <= '1';
    wait for 50ns;
    S00_AXIS_tdata <= (others => '0');
    S00_AXIS_tvalid <= '0';
    S00_AXIS_tlast <= '0';
    wait for 10000ns;
end process;

end Behavioral;

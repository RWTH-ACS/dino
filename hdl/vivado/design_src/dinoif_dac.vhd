----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/26/2023 06:55:36 PM
-- Design Name: 
-- Module Name: dinoif_dac - Behavioral
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

entity dinoif_dac is
    Port ( aclk : in STD_LOGIC;
           resetn : in STD_LOGIC;
           clk_25mhz : in STD_LOGIC;
           external_trig : in STD_LOGIC;
           use_external_trig : in STD_LOGIC;
           serial_data : out STD_LOGIC;      
           load : out STD_LOGIC;
           serial_clk : out STD_LOGIC;
           S00_AXIS_tdata : in STD_LOGIC_VECTOR (15 downto 0);
           S00_AXIS_tvalid : in STD_LOGIC;
           S00_AXIS_tlast : in STD_LOGIC;
           active : out STD_LOGIC
           );
           
end dinoif_dac;

architecture Behavioral of dinoif_dac is
    attribute X_INTERFACE_PARAMETER : string;
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO of aclk: SIGNAL is "xilinx.com:signal:clock:1.0 clk CLK";
    ATTRIBUTE X_INTERFACE_INFO of clk_25mhz: SIGNAL is "xilinx.com:signal:clock:1.0 clk CLK";
    ATTRIBUTE X_INTERFACE_INFO of serial_clk: SIGNAL is "xilinx.com:signal:clock:1.0 serial_clk CLK";
    -- Supported parameters: ASSOCIATED_CLKEN, ASSOCIATED_RESET, ASSOCIATED_ASYNC_RESET, ASSOCIATED_BUSIF, CLK_DOMAIN, PHASE, FREQ_HZ
    -- Most of these parameters are optional. However, when using AXI, at least one clock must be associated to the AXI interface.
    -- Use the axi interface name for ASSOCIATED_BUSIF, if there are multiple interfaces, separate each name by ':'
    -- Use the port name for ASSOCIATED_RESET.
    -- Output clocks will require FREQ_HZ to be set (note the value is in HZ and an integer is expected).
    --ATTRIBUTE X_INTERFACE_PARAMETER of clk: SIGNAL is "ASSOCIATED_BUSIF S00_AXIS, ASSOCIATED_RESET reset, FREQ_HZ 20000000";
    ATTRIBUTE X_INTERFACE_PARAMETER of aclk: SIGNAL is "ASSOCIATED_BUSIF S00_AXIS, ASSOCIATED_RESET resetn";
    ATTRIBUTE X_INTERFACE_PARAMETER of serial_clk: signal is "FREQ_HZ 25000000";
    ATTRIBUTE X_INTERFACE_PARAMETER of clk_25mhz: signal is "FREQ_HZ 25000000";
    ATTRIBUTE X_INTERFACE_INFO of resetn : SIGNAL is "xilinx.com:signal:reset:1.0 resetn RST";
    ATTRIBUTE X_INTERFACE_PARAMETER of resetn : SIGNAL is "POLARITY ACTIVE_LOW";


    constant serial_frequ : integer := 25_000_000;
    constant serial_rate : time := 1 sec / serial_frequ;
    
    constant dac_bits : integer := 16;

    type State_t is (IDLE, UPDATE, LOAD_VAL);
    signal state : State_t := IDLE;
    signal data : STD_LOGIC_VECTOR (dac_bits-1 downto 0) := (others => '0');
    signal out_data : STD_LOGIC_VECTOR (dac_bits-1 downto 0) := (others => '0');
    signal out_load : STD_LOGIC := '1';
    signal serial_clk_enable : STD_LOGIC := '0';
    signal write_cnt : integer range 0 to 1024 := 0;
    signal begin_conv : STD_LOGIC := '0';
    signal internal_trig : STD_LOGIC := '0';
    signal reset_internal_trig : STD_LOGIC := '0';
    
    
begin
    begin_conv <= ( use_external_trig and external_trig ) or ( not use_external_trig and internal_trig );
    
    process (clk_25mhz, state, resetn, begin_conv, data, out_data, write_cnt) begin
        if falling_edge(clk_25mhz) then
            if resetn='0' then
                state <= IDLE;
                out_data <= (others => '0');
            else
                if use_external_trig = '0' and internal_trig = '1' then
                    reset_internal_trig <= '1';
                else
                    reset_internal_trig <= '0';
                end if;
                write_cnt <= write_cnt + 1;
                case state is
                when IDLE =>
                    serial_data <= '0';
                    serial_clk_enable <= '0';
                    active <= '0';
                    out_load <= '1';
                    out_data <= (others => '0');  
                    if begin_conv = '1' then
                        state <= UPDATE;
                    else
                        state <= IDLE;
                    end if;
                when UPDATE =>
                    serial_data <= '0';
                    serial_clk_enable <= '0';
                    active <= '1';  
                    out_load <= '0';
                    out_data <= data;
                    write_cnt <= 0;
                    state <= LOAD_VAL;
                when LOAD_VAL =>
                    out_load <= '0';
                    active <= '1';
                    if write_cnt < dac_bits + 1 then                       
                        state <= LOAD_VAL;
                        serial_data <= out_data(dac_bits-1);
                        if write_cnt > 0 then
                            serial_clk_enable <= '1';
                            out_data(dac_bits-1 downto 0) <= out_data(dac_bits-2 downto 0) & '0';
                        end if;
                    else
                        serial_clk_enable <= '0';
                        serial_data <= '0';
                        state <= IDLE;
                    end if;
                end case;
            end if;
        end if;
    end process;

    process(aclk, data, S00_AXIS_tvalid, S00_AXIS_tdata) begin
        if rising_edge(aclk) then
            if S00_AXIS_tvalid = '1' and data /= S00_AXIS_tdata then
                data <= S00_AXIS_tdata;
                internal_trig <= '1';
            elsif reset_internal_trig = '1' then
                internal_trig <= '0';
            end if;
        end if;
    end process;

    process(serial_clk_enable, clk_25mhz) begin
        if serial_clk_enable = '1' then
            serial_clk <= clk_25mhz;
        else
            serial_clk <= '0';
        end if;
    end process;

    load <= out_load;
end Behavioral;

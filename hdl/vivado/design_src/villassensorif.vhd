----------------------------------------------------------------------------------
-- Company: ACS, RWTH Aachen University
-- Engineer: Niklas Eiling
-- 
-- Create Date: 09/29/2020 10:14:00 AM
-- Design Name: 
-- Module Name: villassensorif - Behavioral
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

-- Package IP IP-xact XML Standard
-- AXI Merger suchen/entwickeln
-- Sampling Rate soll anpassbar sein, Am besten per IP timer. Timer triggered state machine start.
-- GPS synchronized conversion (PLL)
-- Output villassensorif
entity villassensorif is
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
           
end villassensorif;

architecture Behavioral of villassensorif is
    attribute X_INTERFACE_PARAMETER : string;
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO of clk: SIGNAL is "xilinx.com:signal:clock:1.0 clk CLK";
    ATTRIBUTE X_INTERFACE_INFO of serial_clk: SIGNAL is "xilinx.com:signal:clock:1.0 serial_clk CLK";
    -- Supported parameters: ASSOCIATED_CLKEN, ASSOCIATED_RESET, ASSOCIATED_ASYNC_RESET, ASSOCIATED_BUSIF, CLK_DOMAIN, PHASE, FREQ_HZ
    -- Most of these parameters are optional. However, when using AXI, at least one clock must be associated to the AXI interface.
    -- Use the axi interface name for ASSOCIATED_BUSIF, if there are multiple interfaces, separate each name by ':'
    -- Use the port name for ASSOCIATED_RESET.
    -- Output clocks will require FREQ_HZ to be set (note the value is in HZ and an integer is expected).
    --ATTRIBUTE X_INTERFACE_PARAMETER of clk: SIGNAL is "ASSOCIATED_BUSIF S00_AXIS, ASSOCIATED_RESET reset, FREQ_HZ 20000000";
    --ATTRIBUTE X_INTERFACE_PARAMETER of clk: SIGNAL is "ASSOCIATED_BUSIF M00_AXIS, ASSOCIATED_RESET resetn, FREQ_HZ 20000000";
    --attribute X_INTERFACE_PARAMETER of serial_clk: signal is "FREQ_HZ 20000000";
    ATTRIBUTE X_INTERFACE_PARAMETER of clk: SIGNAL is "ASSOCIATED_BUSIF M00_AXIS, ASSOCIATED_RESET resetn, FREQ_HZ 3000000";
    attribute X_INTERFACE_PARAMETER of serial_clk: signal is "FREQ_HZ 3000000";
    ATTRIBUTE X_INTERFACE_INFO of resetn : SIGNAL is "xilinx.com:signal:reset:1.0 resetn RST";
    ATTRIBUTE X_INTERFACE_PARAMETER of resetn : SIGNAL is "POLARY ACTIVE_LOW";




    type State_t is (INIT, CONVERT, WAKEUP, READ, OUTPUT);
    signal state : State_t := INIT;
    signal data : STD_LOGIC_VECTOR (13 downto 0) := (others => '0');
    signal out_ready : STD_LOGIC := '0';
    signal out_conv : STD_LOGIC := '0';
    signal serial_clk_enable : STD_LOGIC := '0';
    signal cnt : integer range 0 to 40 := 0; -- 1.7us conversion time are 4 cycles@2MHz, 20 cycles@MHz, 40 cycles@20MHz, 30 cycles@15Mhz
    --signal cnt : integer range 0 to 20 := 0;
    
begin
    -- S00_AXIS_tready <= '0';
    
    process (clk, state, resetn, begin_conv, cnt, serial_data) begin
        if rising_edge(clk) then
            if resetn='0' then
                state <= INIT;
            else
                cnt <= cnt + 1;
                case state is
                    when INIT =>
                        data <= (others => '0');
                        out_ready <= '0';
                        out_conv <= '0';
                        serial_clk_enable <= '0';
                        if begin_conv = '1' then
                            state <= CONVERT;
                        else
                            state <= INIT;
                        end if;
                        cnt <= 0;                  
                    when CONVERT =>
                        data <= (others => '0');
                        out_ready <= '0';
                        serial_clk_enable <= '0';   
                        --if cnt=40 then
                        if cnt=6 then
                            out_conv <= '0';
                            state <= WAKEUP;
                            cnt <= 0;                  
                        else
                            out_conv <= '1';
                            state <= CONVERT;       
                        end if;
                    when WAKEUP =>
                        data <= (others => '0');
                        out_ready <= '0';
                        serial_clk_enable <= '1';   
                        out_conv <= '0';
                        state <= READ;
                        cnt <= 0;                  
                    when READ =>
                        data <= data(12 downto 0) & serial_data;
                        out_ready <= '0';
                        out_conv <= '0';                       
                        if cnt=14 then
                            serial_clk_enable <= '0';
                            state <= OUTPUT;
                            cnt <= 0;
                        else
                            serial_clk_enable <= '1';
                            state <= READ;
                        end if;
                    when OUTPUT =>
                        data <= data;
                        out_ready <= '1';
                        out_conv <= '0';
                        serial_clk_enable <= '0';
                        state <= INIT;
                        cnt <= 0;
    
                end case;
            end if;
        end if;
    end process;
    
    process(clk, out_ready, data) begin
        if rising_edge(clk) then
            if out_ready = '1' then
                M00_AXIS_tdata(13 downto 0) <= data;
                M00_AXIS_tvalid <= '1';
            else
                M00_AXIS_tdata(13 downto 0) <= (others => '0');
                M00_AXIS_tvalid <= '0';
            end if;
        end if;
    end process;
    
    process(serial_clk_enable, clk) begin
        if serial_clk_enable = '1' then
            serial_clk <= clk;
        else
            serial_clk <= '0';
        end if;
    end process;
    
    
    
    conv <= out_conv;
    
    M00_AXIS_tdata(15 downto 14) <= (others => '0');
    M00_AXIS_tlast <= '1';
    --S00_AXIS_tready <= '1';
    
end Behavioral;

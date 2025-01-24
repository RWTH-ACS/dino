----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Niklas Eiling
-- 
-- Create Date: 04/12/2024
-- Design Name: 
-- Module Name: dinoif_adc - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 2021.1
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- All Jumpers on DINO PCB set to bridge pins 1 and 2 to bypass logic circuit
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

-- Package IP IP-xact XML Standard
entity dinoif_adc is
    Port ( aclk : in STD_LOGIC;
           resetn : in STD_LOGIC;
           clk_25mhz : in STD_LOGIC;
           begin_conv : in STD_LOGIC;
           serial_data : in STD_LOGIC;      
           conv : out STD_LOGIC;
           serial_clk : out STD_LOGIC;
           M00_AXIS_tdata : out STD_LOGIC_VECTOR (15 downto 0);
           M00_AXIS_tvalid : out STD_LOGIC;
           M00_AXIS_tlast : out STD_LOGIC;
           active : out STD_LOGIC
           );
           
end dinoif_adc;

architecture Behavioral of dinoif_adc is
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
    ATTRIBUTE X_INTERFACE_PARAMETER of aclk: SIGNAL is "ASSOCIATED_BUSIF M00_AXIS, ASSOCIATED_RESET resetn";
    attribute X_INTERFACE_PARAMETER of serial_clk: signal is "FREQ_HZ 25000000";
    attribute X_INTERFACE_PARAMETER of clk_25mhz: signal is "FREQ_HZ 25000000";
    ATTRIBUTE X_INTERFACE_INFO of resetn : SIGNAL is "xilinx.com:signal:reset:1.0 resetn RST";
    ATTRIBUTE X_INTERFACE_PARAMETER of resetn : SIGNAL is "POLARY ACTIVE_LOW";


    constant serial_frequ : integer := 25_000_000;
    constant serial_rate : time := 1 sec / serial_frequ;
    
    --    constant adc_convmin : time := 1.3 us; -- LTC2312
    constant adc_convmin : time := 40 ns; -- LTC2314
    constant adc_convmin_cycles : integer := adc_convmin / serial_rate;
    constant adc_bits : integer := 16;

    type State_t is (IDLE, CONVERT, AQUIRE);
    type ReadState_t is (IDLE, RDY, READ);
    signal state : State_t := IDLE;
    signal read_state : ReadState_t := IDLE;
    signal data : STD_LOGIC_VECTOR (adc_bits-1 downto 0) := (others => '0');
    signal out_ready : STD_LOGIC := '0';
    signal out_ready_ack : STD_LOGIC := '0'; 
    signal out_conv : STD_LOGIC := '1';
    signal serial_clk_enable : STD_LOGIC := '0';
    signal cnt : integer range 0 to adc_bits := 0;
    signal read_cnt : integer range 0 to 1024 := 0;
    signal out_active : STD_LOGIC := '0';
    signal repeat_cnt : integer range 0 to 1 := 0;
    
begin
    process (clk_25mhz, state, resetn, begin_conv, cnt, serial_data, repeat_cnt) begin
        if rising_edge(clk_25mhz) then
            if resetn='0' then
                state <= IDLE;
                read_state <= IDLE;
                data <= (others => '0');
                out_ready <= '0';
                repeat_cnt <= 0;
            else
                cnt <= cnt + 1;
                read_cnt <= read_cnt + 1;
                case state is
                when IDLE =>
                    out_conv <= '0';
                    serial_clk_enable <= '0';
                    if begin_conv = '1' then
                        state <= CONVERT;
                    else
                        state <= IDLE;
                    end if;
                    cnt <= 0;
                when CONVERT =>
                    if cnt=adc_convmin_cycles then
                        state <= AQUIRE;
                        cnt <= 0;
                        out_conv <= '0';
                        serial_clk_enable <= '1';
                    else
                        state <= CONVERT;
                        out_conv <= '1';
                        serial_clk_enable <= '0';
                    end if;
                when AQUIRE =>
                    out_conv <= '0';
                    if cnt = adc_bits-1 then
                        if repeat_cnt = 1 then
                            repeat_cnt <= 0;
                            state <= IDLE;
                        else
                            repeat_cnt <= repeat_cnt+1;
                            state <= CONVERT;
                            
                        end if;
                        serial_clk_enable <= '0';
                        cnt <= 0;
                    else
                        state <= AQUIRE;
                        serial_clk_enable <= '1';
                    end if;          
                end case;
                case read_state is
                    when IDLE =>
                        read_cnt <= 0;
                        if state = AQUIRE and repeat_cnt=1 then
                            read_state <= RDY;
                        else
                            read_state <= IDLE;
                        end if;
                    when RDY =>
                        out_ready <= '0';
                        data <= (others => '0');
                        if state /= CONVERT then
                            read_state <= READ;
                            read_cnt <= 0;
                            out_active <= '1';
                        else
                            -- timeout
                            out_active <= '0';
                            read_state <= IDLE;
                        end if;
                    when READ =>
                        data <= data(adc_bits-2 downto 0) & serial_data;
                        -- number of actual bits send. 
                        -- should be bits-1 but the low phase before the acutal adc data arrives is two cycles so use bits to compensate                
                        if read_cnt = 14 then
                            read_state <= IDLE;
                            out_ready <= '1';
                        else
                            read_state <= READ;
                            out_ready <= '0';
                        end if;
                end case;
            end if;
        end if;
    end process;

    process(aclk, out_ready, data, out_ready_ack) begin
        if rising_edge(aclk) then
            if out_ready = '1' and out_ready_ack = '0' then
                M00_AXIS_tdata(adc_bits-1 downto 0) <= data;
                M00_AXIS_tvalid <= '1';
                out_ready_ack <= '1';
            elsif out_ready = '1' and out_ready_ack = '1' then
                M00_AXIS_tdata(adc_bits-1 downto 0) <= (others => '0');
                M00_AXIS_tvalid <= '0';
            else 
                M00_AXIS_tdata(adc_bits-1 downto 0) <= (others => '0');
                M00_AXIS_tvalid <= '0';
                out_ready_ack <= '0';
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



    conv <= out_conv;
    active <= out_active;
    
    M00_AXIS_tdata(15 downto adc_bits) <= (others => '0');
    M00_AXIS_tlast <= '1';

end Behavioral;

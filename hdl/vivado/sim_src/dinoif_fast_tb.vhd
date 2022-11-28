----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/28/2022 02:51:25 PM
-- Design Name: 
-- Module Name: dinoif_fast_tb - Behavioral
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

entity dinoif_fast_tb is
--  Port ( );
end dinoif_fast_tb;

architecture Behavioral of dinoif_fast_tb is
component dinoif_fast is
    Port ( aclk : in STD_LOGIC;
           resetn : in STD_LOGIC;
           clk_20mhz : in STD_LOGIC;
           begin_conv : in STD_LOGIC;
           serial_data : in STD_LOGIC;      
           conv : out STD_LOGIC;
           serial_clk : out STD_LOGIC;
           M00_AXIS_tdata : out STD_LOGIC_VECTOR (15 downto 0);
           M00_AXIS_tvalid: out STD_LOGIC;
           M00_AXIS_tlast: out STD_LOGIC
           );
    end component;
    component config_timer is
    Port ( clk : in STD_LOGIC;
           resetn : in STD_LOGIC;
           cmp_val : in STD_LOGIC_VECTOR (31 downto 0);
           thresh : out STD_LOGIC);
    end component;
    signal aclk : STD_LOGIC := '0';
    signal resetn : STD_LOGIC := '0';
    signal clk_20mhz : STD_LOGIC := '0';
    signal begin_conv : STD_LOGIC;
    
    signal fpga_serial_data : STD_LOGIC := '0';
    signal fpga_conv : STD_LOGIC;
    signal fpga_serial_clk : STD_LOGIC;
    signal dino_serial_data : STD_LOGIC := '0';
    signal dino_conv : STD_LOGIC := '0';
    signal dino_last_nconv : STD_LOGIC := '0';
    signal dino_serial_clk : STD_LOGIC := '0';
    signal adc_serial_data : STD_LOGIC;
    signal adc_conv : STD_LOGIC := '0';
    signal adc_serial_clk : STD_LOGIC := '0';
    
    signal M00_AXIS_tdata : STD_LOGIC_VECTOR (15 downto 0);
    signal M00_AXIS_tvalid : STD_LOGIC;
    signal M00_AXIS_tlast : STD_LOGIC;
    
    constant aclk_frequ : natural := 50_000_000;
    constant aclk_period : time := ( 1 sec ) / aclk_frequ;
    constant clk_20mhz_frequ : natural := 20_000_000;
    constant clk_20mhz_period : time := ( 1 sec ) / clk_20mhz_frequ;
    
    constant timer_cmp_val : STD_LOGIC_VECTOR(31 downto 0) := std_logic_vector(to_unsigned(100, 32));
    
    constant adc_output1 : STD_LOGIC_VECTOR(13 downto 0) := b"01010101010101";
    constant adc_output2 : STD_LOGIC_VECTOR(13 downto 0) := b"10101010101010";
    
begin
    dinoif : dinoif_fast port map (
           aclk => aclk,
           resetn => resetn,
           clk_20mhz => clk_20mhz,
           begin_conv => begin_conv,
           serial_data => fpga_serial_data,
           conv => fpga_conv,
           serial_clk => fpga_serial_clk,
           M00_AXIS_tdata => M00_AXIS_tdata,
           M00_AXIS_tvalid => M00_AXIS_tvalid,
           M00_AXIS_tlast => M00_AXIS_tlast);
    timer : config_timer port map ( 
           clk => clk_20mhz,
           resetn => resetn,
           cmp_val => timer_cmp_val,
           thresh => begin_conv);
    process
    begin
        aclk <= '1';
        wait for aclk_period/2;
        aclk <= '0';
        wait for aclk_period/2;    
    end process;
    
    process
    begin
        clk_20mhz <= '1';
        wait for clk_20mhz_period/2;
        clk_20mhz <= '0';
        wait for clk_20mhz_period/2;    
    end process;

    -- Simulate delay line
    dino_conv <= transport fpga_conv after 80ns;
    dino_serial_clk <= transport fpga_serial_clk after 100ns;
    fpga_serial_data <= transport dino_serial_data after 100ns;

    -- edge injection circuit
    process (dino_serial_clk, dino_conv, adc_conv) begin
        if rising_edge(dino_serial_clk) then
            adc_conv <= dino_conv;           -- 1Q output of flipflop 
            dino_last_nconv <= not adc_conv; -- 2Q output of flipflop                     
        end if;
    end process;
    adc_serial_clk <= (not adc_conv) and dino_last_nconv and dino_serial_clk;
    dino_serial_data <= adc_serial_data or adc_conv; 
    
    -- LTC2312-14 behavioral model
    process
    begin
        wait until rising_edge(adc_conv);
        wait for 1ns;
        -- we assume that conv is held constant for the 1300ns hold time
        if adc_serial_clk = '0' then
            adc_serial_data <= 'U';
            wait for 1300 ns;
            wait until falling_edge(adc_conv);
            for k in adc_output1'length-1 downto 0 loop
                adc_serial_data <= adc_output1(k);
                wait until falling_edge(adc_serial_clk);
            end loop;
            adc_serial_data <= '0';
        -- Because of the DINO ADC logic circuit
        -- adc_conv and adc_serial_clk can never be high at the same time.
        elsif adc_serial_clk = '1' then   
            adc_serial_data <= 'U';
            wait for 1300 ns;
            wait until falling_edge(adc_conv);
            for k in adc_output1'length-1 downto 0 loop
                wait until falling_edge(adc_serial_clk);
                adc_serial_data <= adc_output1(k);          
            end loop;
            wait until falling_edge(adc_serial_clk);
            adc_serial_data <= '0';
        end if;
    end process;
    
    process
    begin
        wait for 1000ns;
        resetn <= '1';
        wait;
    end process;
end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2020 03:17:47 PM
-- Design Name: 
-- Module Name: vilassensorif_tb - Behavioral
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

entity vilassensorif_tb is
--  Port ( );
end vilassensorif_tb;

architecture Behavioral of vilassensorif_tb is
    component villassensorif_fast is
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
    end component;
    signal clk : STD_LOGIC := '0';
    signal resetn : STD_LOGIC := '1';
    signal serial_data : STD_LOGIC := '0';
    signal conv : STD_LOGIC := '0';
    signal serial_clk : STD_LOGIC := '0';
    signal value : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal value_rdy : STD_LOGIC;
    signal begin_conv : STD_LOGIC := '0';
    
    signal axis_tlast : STD_LOGIC;
    
    -- ADC internal signals
    signal conv_ready : STD_LOGIC := '0';
    signal adc_val : STD_LOGIC_VECTOR (13 downto 0) := "10111010111001"; -- 0x2EB9
    signal nap_mode : STD_LOGIC := '1';
    
    --delayed lines (after transceiver, before ADC)    
    signal conv_delay : STD_LOGIC := '0';
    signal serial_clk_delay : STD_LOGIC := '0';
    signal serial_data_nodelay : STD_LOGIC := '0';
    
    --adc lines (at ADC, after propagation path, before return path)
    signal conv_adc : STD_LOGIC := '0';
    signal serial_clk_adc : STD_LOGIC := '0';
    signal serial_data_adc : STD_LOGIC := '0';
    signal serial_clk_reg : STD_LOGIC := '0';
    
    

begin
    UUT : villassensorif_fast port map (clk => clk,
            resetn => resetn,
            begin_conv => begin_conv,
            serial_data => serial_data,
            conv => conv,
            serial_clk => serial_clk,
            --S00_AXIS_tdata => axis_in_tdata,
            --S00_AXIS_tvalid => axis_in_tvalid,
            --S00_AXIS_tready => axis_in_tready,
            M00_AXIS_tdata => value,
            M00_AXIS_tvalid => value_rdy,
            M00_AXIS_tlast => axis_tlast);

    -- edge injection circuit
    process (serial_clk_delay, conv_delay, serial_data_adc) begin
        if rising_edge(serial_clk_delay) then
            conv_adc <= conv_delay;
            serial_clk_reg <= not conv_adc;                     
        end if;
    end process;
    serial_clk_adc <= (not conv_adc) and serial_clk_delay and serial_clk_reg;
    serial_data_nodelay <= serial_data_adc or conv_adc; 
    
    -- 20 MHz clock
    process
    begin
        clk <= '1';
        wait for 25ns;
        clk <= '0';
        wait for 25ns;    
    end process;
    
    -- sample rate signal
    process
    begin
        wait for 19950ns;
        begin_conv <= '1';
        wait for 50ns;
        begin_conv <= '0';
    end process;
    

    -- Simulate delay line
    conv_delay <= transport conv after 100ns;
    serial_clk_delay <= transport serial_clk after 100ns;
    serial_data <= transport serial_data_nodelay after 100ns;
    
    -- simulate conversion delay
    process
    begin
        wait until rising_edge(conv_adc) and conv_ready='0';
        conv_ready <= '1' after 1700ns;
    end process;
    

    
    -- nap mode logic
    process (serial_clk_adc, conv_adc, nap_mode)
    begin
        if falling_edge(serial_clk_adc) and nap_mode='1' then
            nap_mode <= '0';
        elsif conv_adc='1' then
            nap_mode <= '1';
        end if;
    end process;
    
    -- serial_data output logic    
    process (conv_adc, adc_val(13), nap_mode)
    begin
        if (conv_adc='0' and conv_ready='1' and nap_mode='0') then
            serial_data_adc <= adc_val(13);
        else
            serial_data_adc <= '0';
        end if;
    end process;
    
    process
    begin
        wait until (falling_edge(serial_clk_adc) and conv_adc='0' and conv_ready='1' and nap_mode='0');      
        adc_val <= adc_val(12 downto 0) & '0';
    end process;
    
    

end Behavioral;

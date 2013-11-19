--------------------------------------------------------------------------------
-- Engineer: 
-- 
-- Create Date: 18.10.2013 17:10:06
-- Design Name: 
-- Module Name: Taktteiler - Behavioral
-- Project Name: Aufgabe 1
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Taktteiler is
    port(
    clk: in std_logic;
    reset: in std_logic;
    led: out std_logic_vector(3 downto 0)
    );
end Taktteiler;

architecture Behavioral of Taktteiler is
    type PWM_SIGNALS is array (0 to 7) of unsigned ( 7 downto 0);
    signal pwm_input1 : PWM_SIGNALS := ("00000000" , "00000101" , "00001010" , "00011110" , "00110010" , "01010000" , "01111000" , "11111111");
    signal count : unsigned (26 downto 0);
    --signal count : unsigned (18 downto 0);
    signal pwm_input : unsigned (7 downto 0);
    signal pwm_reset : std_logic;
    signal pwm_out : std_logic;
begin

    pwm : entity work.pwm
    port map(
        clk => clk,
        reset => pwm_reset,
        pwm_in => pwm_input,
        pwm_out => pwm_out
    );

    process(clk, reset)
    begin
        if rising_edge(clk) then
    		if reset = '1' then
    		count <= (others => '0');
    		else
    		count <= count + 1;
    		end if;
    	end if;
    end process;
    
    process(clk)
        variable pwm_counter: natural := 0;
    begin
        if rising_edge(clk) then
            if count = "10000000000000000000000000" then
            pwm_input <= pwm_input1(pwm_counter);
            pwm_counter := pwm_counter + 1;
            if pwm_counter = 8 then
                pwm_counter := 0;
            end if;
            pwm_reset <= '1';
            else
                pwm_reset <= '0';
            end if;
        end if;
    end process;
    
 --   led(0) <= '0';
 --   led(1) <= '0';
 --   led(3) <= '0';
      led(2) <= pwm_out;


end;

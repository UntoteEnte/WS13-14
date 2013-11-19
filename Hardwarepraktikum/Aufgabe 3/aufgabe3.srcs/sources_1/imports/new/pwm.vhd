----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/28/2013 03:01:30 PM
-- Design Name: 
-- Module Name: pwm - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm is
    Port( 
    clk : in std_logic;
    reset : in std_logic;
    pwm_in : in unsigned ( 7 downto 0);
    pwm_out : out std_logic
    );
end pwm;

architecture Behavioral of pwm is
    signal count : unsigned (7 downto 0);
begin
    process (clk, reset)
    begin 
        if rising_edge(clk) then
            if reset ='1' then
                count <= (others => '0');
            else 
                count <= count + 1;
            end if;       
        end if;
    end process;

process(clk)
   begin
    if rising_edge(clk) then
        if (count <= pwm_in) then
            pwm_out <= '1';
        else 
            pwm_out <= '0';
        end if;
    end if;
end process;
end Behavioral;

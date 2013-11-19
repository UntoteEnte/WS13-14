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
    signal count : unsigned (26 downto 0);
begin
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
    
   led(2) <= count(26);
   led(3) <= '0';
   led(1) <= '0';
   led(0) <= '0';

end;

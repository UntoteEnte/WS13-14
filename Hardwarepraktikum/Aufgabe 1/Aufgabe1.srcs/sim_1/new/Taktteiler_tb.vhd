library IEEE;
use IEEE.STD_LOGIC_1164.ALL;   

entity Taktteiler_tb is
end;

architecture test of Taktteiler_tb is
    signal clk : std_logic;
    signal reset : std_logic;
    signal led : std_logic_vector(3 downto 0);
    constant period:time:=15  ns;
begin
    uut: entity work.Taktteiler(Behavioral)
    port map(
        clk => clk,
        reset => reset,
        led => led   
    );
    stimulus:process   
   begin
   reset <= '1';
   wait for 10 ns;
   assert led ="0000" report "reset fail";
   reset <= '0';
   wait for 1000000000 ns;
  assert led="0100" report "takteiler fail";
   wait for 1000000000 ns;
   assert led="0000" report "takteiler fail";
  
   end process;
  
      clocktrigger:process
       begin
       clk <= '0';
       wait for period/2;
       clk <= '1';
       wait for period/2;
       end process;
end;

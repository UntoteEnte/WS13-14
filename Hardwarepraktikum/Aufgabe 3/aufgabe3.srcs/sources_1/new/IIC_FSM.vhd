----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2013 12:51:42 PM
-- Design Name: 
-- Module Name: IIC_FSM - Behavioral
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IIC_FSM is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sda : inout STD_LOGIC;
           scl : inout STD_LOGIC);
end IIC_FSM;

architecture Behavioral of IIC_FSM is

    type StateType is ( WRITEADDRESS, COMMANDBYTE, READADDRESS, RECEIVE);
    signal currentState, nextState : StateType;
    signal pwm_input : std_logic_vector(7 downto 0);
  
    signal start : std_logic;
    signal stop : std_logic
    signal read : std_logic;
    signal write : std_logic;
    signal ack_in : std_logic;
    signal din : std_logic_vector(7 downto 0);
    signal cmd_ack : std_logic; 

    signal sda_oen : std_logic  -- i2c data line output enable, active low

begin
    I2C_control : entity work.i2c_master_byte_ctrl
    port map(
            clk => clk,
    		rst => reset,
    		nReset,
    		ena => '1',
     
    		clk_cnt => clk/(4* scl), -- ?
     
    		-- input signals
    		start => start,
    		stop => stop,
    		read => read,
    		write => write,
    		ack_in => ack_in,
    		din => din,
    
    		-- output signals
    		cmd_ack => cmd_ack,
    		ack_out,
    		i2c_busy,
    		i2c_al,
    		dout => pwm_input,
     
    		-- i2c lines
    		scl_i => scl,
    		scl_o => scl,
    		scl_oen => '0',
    		sda_i  => sda, 
    		sda_o => sda, 
    		sda_oen => sda_oen  
    ); 
    
   Transition: process (currentState, sda, scl)
   begin
    case currentState is
    when WRITEADDRESS =>
        if cmd_ack = '1'
            nextState => COMMANDBYTE;
        else
            nextState => WRITEADDRESS;
        end if;
    when COMMANDBYTE => 
        if cmd_ack = '1'
            nextState => READADDRESS;
        else
            nextState => COMNMANDBYTE;
        end if;
    when READADDRESS =>
        if cmd_ack ='1'
            nextState => RECEIVE;
        else
            nextState => READADDRESS;
        end if;
    when RECEIVE => 
        if cmd_ack = '0'
            nextState => WRITEADDRESS;
        else 
            nextState => RECEIVE;
        end if;
        
   end process Transition;
    
    StateMemory: process (clock, reset)
    begin
        if reset ='1' then
            curentState <= IDLE;
        elsif clock'event and clock='1' then 
             currentState <= nextState;
    end process StateMemory;
    
    Output: process (currentState)
    begin
        case currentState is

        when WRITEADRESS =>
            start <= '1';
            stop <= '0';
            read <= '0';
            write <= '1';
            ack_in <= '1';
            d_in <= "10010010";
        when COMMANDBYTE =>
            start <= '0';
            stop <= '0';
            read <= '0';
            write <= '1';
            ack_in <= '0';
            d_in <= "10101100";
        when READADDRESS =>
            start <= '0';
            stop <= '0';
            read <= '1';
            write <= '0';
            ack_in <= '0';
            d_in <= "10010011";
        when RECEIVE =>
            start <= '0';
            stop <= '0';
            read <= '1';
            write <= '0';
            ack_in <= '0'; 
    end process Output;
end Behavioral;

-- A Input Processor
-- Modifies input A based on control signals S0 and S1

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity a_input_processor is
    port (
        A_in  : in  std_logic_vector(3 downto 0);
        S0    : in  std_logic;
        S1    : in  std_logic;
        A_out : out std_logic_vector(3 downto 0)
    );
end a_input_processor;

architecture structural of a_input_processor is
    
    component inverter_4bit
        port (
            input  : in  std_logic_vector(3 downto 0);
            output : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component mux_2to1_4bit
        port (
            input0 : in  std_logic_vector(3 downto 0);
            input1 : in  std_logic_vector(3 downto 0);
            sel    : in  std_logic;
            output : out std_logic_vector(3 downto 0)
        );
    end component;
    
    signal A_inverted : std_logic_vector(3 downto 0);
    signal mux1_out   : std_logic_vector(3 downto 0);
    signal sel_signal : std_logic;
    
begin
    
    -- AND gate for select signal: sel = S1 AND S0
    sel_signal <= S1 and S0;
    
    -- Invert A
    U1: inverter_4bit
        port map (
            input  => A_in,
            output => A_inverted
        );
    
    -- First mux: select between A and inverted A based on S1
    U2: mux_2to1_4bit
        port map (
            input0 => A_in,
            input1 => A_inverted,
            sel    => S1,
            output => mux1_out
        );
    
    -- Second mux: select between mux1 output and A based on (S1 AND S0)
    -- When S1=0, S0=0: A passes through (sel=0, so input0=A)
    -- When S1=0, S0=1: A passes through (sel=0, so input0=A)
    -- When S1=1, S0=0: ~A passes through (sel=0, so input0=~A)
    -- When S1=1, S0=1: A (sel=1, so input1=A, overrides the inversion)
    U3: mux_2to1_4bit
        port map (
            input0 => mux1_out,
            input1 => A_in,
            sel    => sel_signal,
            output => A_out
        );
    
end structural;

-- 4-bit ALU with 8 functions
-- Top Level Entity

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_4 is
    port (
        A    : in  std_logic_vector(3 downto 0);
        B    : in  std_logic_vector(3 downto 0);
        Cin  : in  std_logic;
        S0   : in  std_logic;
        S1   : in  std_logic;
        G    : out std_logic_vector(3 downto 0);
        Cout : out std_logic
    );
end alu_4;

architecture structural of alu_4 is
    
    -- Component declarations
    component a_input_processor
        port (
            A_in  : in  std_logic_vector(3 downto 0);
            S0    : in  std_logic;
            S1    : in  std_logic;
            A_out : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component b_input_processor
        port (
            B_in  : in  std_logic_vector(3 downto 0);
            S0    : in  std_logic;
            S1    : in  std_logic;
            B_out : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component adder_4bit
        port (
            X    : in  std_logic_vector(3 downto 0);
            Y    : in  std_logic_vector(3 downto 0);
            Cin  : in  std_logic;
            Sum  : out std_logic_vector(3 downto 0);
            Cout : out std_logic
        );
    end component;
    
    -- Internal signals
    signal A_processed : std_logic_vector(3 downto 0);
    signal B_processed : std_logic_vector(3 downto 0);
    
begin
    
    -- Unit 1: Process input A based on control signals
    U1: a_input_processor
        port map (
            A_in  => A,
            S0    => S0,
            S1    => S1,
            A_out => A_processed
        );
    
    -- Unit 2: Process input B based on control signals
    U2: b_input_processor
        port map (
            B_in  => B,
            S0    => S0,
            S1    => S1,
            B_out => B_processed
        );
    
    -- Unit 3: 4-bit adder to compute G = A_processed + B_processed + Cin
    U3: adder_4bit
        port map (
            X    => A_processed,
            Y    => B_processed,
            Cin  => Cin,
            Sum  => G,
            Cout => Cout
        );
    
end structural;

--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
 
entity blur_filter_testbench is
end blur_filter_testbench;
 
architecture behavior of blur_filter_testbench is
component blur_binary_filter
Port (a11: in bit_vector(7 downto 0);
      a12: in bit_vector(7 downto 0);
      a13: in bit_vector(7 downto 0);
      a21: in bit_vector(7 downto 0);
      a22: in bit_vector(7 downto 0);
      a23: in bit_vector(7 downto 0);
      a31: in bit_vector(7 downto 0);
      a32: in bit_vector(7 downto 0);
      a33: in bit_vector(7 downto 0);
      result: out bit_vector(7 downto 0);
      clk: in bit);
end component;

component blur_RNS_new_filter
Port (a11: in bit_vector(7 downto 0);
      a12: in bit_vector(7 downto 0);
      a13: in bit_vector(7 downto 0);
      a21: in bit_vector(7 downto 0);
      a22: in bit_vector(7 downto 0);
      a23: in bit_vector(7 downto 0);
      a31: in bit_vector(7 downto 0);
      a32: in bit_vector(7 downto 0);
      a33: in bit_vector(7 downto 0);
      result: out bit_vector(7 downto 0);
      clk: in bit);
end component;

component blur_RNS_greek_filter
Port (a11: in bit_vector(7 downto 0);
      a12: in bit_vector(7 downto 0);
      a13: in bit_vector(7 downto 0);
      a21: in bit_vector(7 downto 0);
      a22: in bit_vector(7 downto 0);
      a23: in bit_vector(7 downto 0);
      a31: in bit_vector(7 downto 0);
      a32: in bit_vector(7 downto 0);
      a33: in bit_vector(7 downto 0);
      result: out bit_vector(7 downto 0);
      clk: in bit);
end component;

signal blur_binary: bit_vector(7 downto 0);
signal blur_RNS_greek: bit_vector(7 downto 0);
signal blur_RNS_new: bit_vector(7 downto 0);

signal a11 : bit_vector(7 downto 0) := To_BitVector(conv_std_logic_vector(7,8));
signal a12 : bit_vector(7 downto 0) := To_BitVector(conv_std_logic_vector(15,8));
signal a13 : bit_vector(7 downto 0) := To_BitVector(conv_std_logic_vector(38,8));
signal a21 : bit_vector(7 downto 0) := To_BitVector(conv_std_logic_vector(15,8));
signal a22 : bit_vector(7 downto 0) := To_BitVector(conv_std_logic_vector(150,8));
signal a23 : bit_vector(7 downto 0) := To_BitVector(conv_std_logic_vector(15,8));
signal a31 : bit_vector(7 downto 0) := To_BitVector(conv_std_logic_vector(12,8));
signal a32 : bit_vector(7 downto 0) := To_BitVector(conv_std_logic_vector(16,8));
signal a33 : bit_vector(7 downto 0) := To_BitVector(conv_std_logic_vector(255,8));

constant clock_period : time := 10 ns;
signal clock : bit := '0';

begin
uut_binary_filter: blur_binary_filter port map(a11, a12, a13, a21, a22, a23, a31, a32, a33, blur_binary, clock);
uut_RNS_new_filter: blur_RNS_new_filter port map(a11, a12, a13, a21, a22, a23, a31, a32, a33, blur_RNS_new, clock);
uut_RNS_greek_filter: blur_RNS_greek_filter port map(a11, a12, a13, a21, a22, a23, a31, a32, a33, blur_RNS_greek, clock);

clock_process :process
begin
  clock <= '1';
  wait for clock_period/2;
  clock <= '0';
  wait for clock_period/2;
  end process;
end;

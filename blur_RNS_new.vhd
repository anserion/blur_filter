-----------------------------------------------------------------
-- модуль фильтрации в СОК (деление на 15 производится внутри СОК)
-----------------------------------------------------------------
entity blur_RNS_new_filter is
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
end blur_RNS_new_filter;

architecture Behavioral of blur_RNS_new_filter is
   component BSS_8bit_to_RNS_15_16_17
   Port (a: in bit_vector(7 downto 0);
         r15: out bit_vector(3 downto 0);
         r16: out bit_vector(3 downto 0);
         r17: out bit_vector(4 downto 0);
         clk: in bit);
   end component;

   component blur_RNS_15_16_17_adder
   Port (a11_15: in bit_vector(3 downto 0);
         a11_16: in bit_vector(3 downto 0);
         a11_17: in bit_vector(4 downto 0);
         a12_15: in bit_vector(3 downto 0);
         a12_16: in bit_vector(3 downto 0);
         a12_17: in bit_vector(4 downto 0);
         a13_15: in bit_vector(3 downto 0);
         a13_16: in bit_vector(3 downto 0);
         a13_17: in bit_vector(4 downto 0);
         a21_15: in bit_vector(3 downto 0);
         a21_16: in bit_vector(3 downto 0);
         a21_17: in bit_vector(4 downto 0);
         a22_15: in bit_vector(3 downto 0);
         a22_16: in bit_vector(3 downto 0);
         a22_17: in bit_vector(4 downto 0);
         a23_15: in bit_vector(3 downto 0);
         a23_16: in bit_vector(3 downto 0);
         a23_17: in bit_vector(4 downto 0);
         a31_15: in bit_vector(3 downto 0);
         a31_16: in bit_vector(3 downto 0);
         a31_17: in bit_vector(4 downto 0);
         a32_15: in bit_vector(3 downto 0);
         a32_16: in bit_vector(3 downto 0);
         a32_17: in bit_vector(4 downto 0);
         a33_15: in bit_vector(3 downto 0);
         a33_16: in bit_vector(3 downto 0);
         a33_17: in bit_vector(4 downto 0);
         res_15: out bit_vector(3 downto 0);
         res_16: out bit_vector(3 downto 0);
         res_17: out bit_vector(4 downto 0);
         clk: in bit);
   end component;

   component RNS_15_16_17_div15
   Port (a15,a16: in bit_vector(3 downto 0);
         a17: in bit_vector(4 downto 0);
         r16: out bit_vector(3 downto 0);
         r17: out bit_vector(4 downto 0);
         clk: in bit);
   end component;

   component RNS_16_17_to_8bit
   Port (a: out bit_vector(7 downto 0);
         r16: in bit_vector(3 downto 0);
         r17: in bit_vector(4 downto 0);
         clk: in bit);
   end component;

signal a11_15, a12_15, a13_15, a21_15, a22_15, a23_15, a31_15, a32_15, a33_15: bit_vector(3 downto 0);
signal a11_16, a12_16, a13_16, a21_16, a22_16, a23_16, a31_16, a32_16, a33_16: bit_vector(3 downto 0);
signal a11_17, a12_17, a13_17, a21_17, a22_17, a23_17, a31_17, a32_17, a33_17: bit_vector(4 downto 0);
signal S_15, S_16, blur_16: bit_vector(3 downto 0);
signal S_17, blur_17: bit_vector(4 downto 0);
 
begin
   a11_to_RNS:  BSS_8bit_to_RNS_15_16_17 port map(a11, a11_15, a11_16, a11_17, clk);
   a12_to_RNS:  BSS_8bit_to_RNS_15_16_17 port map(a12, a12_15, a12_16, a12_17, clk);
   a13_to_RNS:  BSS_8bit_to_RNS_15_16_17 port map(a13, a13_15, a13_16, a13_17, clk);
   a21_to_RNS:  BSS_8bit_to_RNS_15_16_17 port map(a21, a21_15, a21_16, a21_17, clk);
   a22_to_RNS:  BSS_8bit_to_RNS_15_16_17 port map(a22, a22_15, a22_16, a22_17, clk);
   a23_to_RNS:  BSS_8bit_to_RNS_15_16_17 port map(a23, a23_15, a23_16, a23_17, clk);
   a31_to_RNS:  BSS_8bit_to_RNS_15_16_17 port map(a31, a31_15, a31_16, a31_17, clk);
   a32_to_RNS:  BSS_8bit_to_RNS_15_16_17 port map(a32, a32_15, a32_16, a32_17, clk);
   a33_to_RNS:  BSS_8bit_to_RNS_15_16_17 port map(a33, a33_15, a33_16, a33_17, clk);
 
   RNS_adder: blur_RNS_15_16_17_adder port map(
      a11_15, a11_16, a11_17,
      a12_15, a12_16, a12_17,
      a13_15, a13_16, a13_17,
      a21_15, a21_16, a21_17,
      a22_15, a22_16, a22_17,
      a23_15, a23_16, a23_17,
      a31_15, a31_16, a31_17,
      a32_15, a32_16, a32_17,
      a33_15, a33_16, a33_17,
      S_15, S_16, S_17, clk);
      
	RNS_div15: RNS_15_16_17_div15 port map(S_15, S_16, S_17, blur_16, blur_17, clk);
   RNS_to_BSS: RNS_16_17_to_8bit port map(result, blur_16, blur_17, clk);
end Behavioral;
--------------------------------------------------------------

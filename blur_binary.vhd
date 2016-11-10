-----------------------------------------------------------------
-- модуль фильтрации целиком в двоичной системе счисления
-----------------------------------------------------------------
entity blur_binary_filter is
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
          clk: in bit
          );
end blur_binary_filter;

architecture Behavioral of blur_binary_filter is
   component blur_binary_adder
   Port (a11: in bit_vector(7 downto 0);
         a12: in bit_vector(7 downto 0);
         a13: in bit_vector(7 downto 0);
         a21: in bit_vector(7 downto 0);
         a22: in bit_vector(7 downto 0);
         a23: in bit_vector(7 downto 0);
         a31: in bit_vector(7 downto 0);
         a32: in bit_vector(7 downto 0);
         a33: in bit_vector(7 downto 0);
         result: out bit_vector(11 downto 0);
         clk: in bit
	      );
   end component;
	
   component binary_12bit_div15
   Port (S: in bit_vector(11 downto 0); result: out bit_vector(7 downto 0); clk: in bit);
   end component;

component binary_nm_div is
Generic (n,m: integer);
Port (a: in bit_vector(n-1 downto 0);
      b: in bit_vector(m-1 downto 0);
      q: out bit_vector(n-1 downto 0);
      r: out bit_vector(m-1 downto 0);
      clk: in bit);
end component;

signal S_12bit,q_12bit: bit_vector(11 downto 0);
signal r_4bit: bit_vector(3 downto 0);

begin
   binary_adder: blur_binary_adder port map(a11, a12, a13, a21, a22, a23, a31, a32, a33, S_12bit, clk);
   --binary_div15: binary_12bit_div15 port map(S_12bit, result, clk);
   binary_div15: binary_nm_div generic map(12,4) port map(s_12bit,"1111",q_12bit,r_4bit,clk);
   result<=q_12bit(7 downto 0);
end Behavioral;
--------------------------------------------------------------

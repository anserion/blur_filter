-----------------------------------------------------------------
-- блок быстрого целочисленного деления 12-битного двоичного числа на 15
-- производится приближение result=S*273/4096
-- для ускорения расчета  result=(s*256+s*16+s)/4096
--(сдвиговыми операциями) result=(s<<8 + s<<4 + s)>>12
--(дополнительные оптимизации - складывать только биты, влияющие на ответ
--для первого сложения - не учитывать младшие 4 бита,
--для второго сложения - не учитывать младшие 4 бита
--это понижает разрядности сумматоров до 16 и 12 соответственно)
-----------------------------------------------------------------
entity binary_12bit_div15 is
	Port (S: in bit_vector(11 downto 0); result: out bit_vector(7 downto 0); clk: in bit);
end binary_12bit_div15;

architecture Behavioral of binary_12bit_div15 is
component binary_adder
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n downto 0);
      clk: in bit);
end component;
signal arg_tmp_17bit,res_tmp_17bit:bit_vector(16 downto 0);
signal res_tmp_13bit:bit_vector(12 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     arg_tmp_17bit<=res_tmp_17bit;
     result<=res_tmp_13bit(11 downto 4);
   end if;
end process;
   s1:binary_adder generic map(16) port map("0000"&S,"00000000"&S(11 downto 4),res_tmp_17bit,clk);
   s2:binary_adder generic map(12) port map(S,arg_tmp_17bit(15 downto 4),res_tmp_13bit,clk);
end Behavioral;
------------------------------------------------------------------------

----------------------------------------------------------------
-- древовидный перемножитель-сумматор матрицы фильтра "размытие"
-- работает в двоичной системе счисления
----------------------------------------------------------------
entity blur_binary_adder is
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
          clk: in bit);
end blur_binary_adder;

architecture Behavioral of blur_binary_adder is
component binary_adder
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n downto 0);
      clk: in bit);
end component;
signal x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,xA,xB,xC,xD,xE:bit_vector(7 downto 0);

signal res_y0,res_y1,res_y2,res_y3,res_y4,res_y5,res_y6:bit_vector(8 downto 0);
signal arg_y0,arg_y1,arg_y2,arg_y3,arg_y4,arg_y5,arg_y6:bit_vector(8 downto 0);

signal res_z0,res_z1,res_z2,res_z3:bit_vector(9 downto 0);
signal arg_z0,arg_z1,arg_z2,arg_z3:bit_vector(9 downto 0);

signal res_u0,res_u1:bit_vector(10 downto 0);
signal arg_u0,arg_u1:bit_vector(10 downto 0);

signal tmp_result:bit_vector(11 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
   x0<=a11;
   x1<=a12; x2<=a12;
   x3<=a13;
   x4<=a21; x5<=a21;
   x6<=a22; x7<=a22; x8<=a22;
   x9<=a23; xA<=a23;
   xB<=a31;
   xC<=a32; xD<=a32;
   xE<=a33;

   arg_y0<=res_y0;
   arg_y1<=res_y1;
   arg_y2<=res_y2;
   arg_y3<=res_y3;
   arg_y4<=res_y4;
   arg_y5<=res_y5;
   arg_y6<=res_y6;

   arg_z0<=res_z0;
   arg_z1<=res_z1;
   arg_z2<=res_z2;
   arg_z3<=res_z3;
   
   arg_u0<=res_u0;
   arg_u1<=res_u1;

   result<=tmp_result;
   end if;
end process;

   sy0:binary_adder generic map(8) port map(x0,x1,res_y0,clk);
   sy1:binary_adder generic map(8) port map(x2,x3,res_y1,clk);
   sy2:binary_adder generic map(8) port map(x4,x5,res_y2,clk);
   sy3:binary_adder generic map(8) port map(x6,x7,res_y3,clk);
   sy4:binary_adder generic map(8) port map(x8,x9,res_y4,clk);
   sy5:binary_adder generic map(8) port map(xA,xB,res_y5,clk);
   sy6:binary_adder generic map(8) port map(xC,xD,res_y6,clk);
      
   sz0:binary_adder generic map(9) port map(arg_y0,arg_y1,res_z0,clk);
   sz1:binary_adder generic map(9) port map(arg_y2,arg_y3,res_z1,clk);
   sz2:binary_adder generic map(9) port map(arg_y4,arg_y5,res_z2,clk);
   sz3:binary_adder generic map(9) port map(arg_y6,"0"&xE,res_z3,clk);
         
   su0:binary_adder generic map(10) port map(arg_z0,arg_z1,res_u0,clk);
   su1:binary_adder generic map(10) port map(arg_z2,arg_z3,res_u1,clk);
         
   s:binary_adder generic map(11) port map(arg_u0,arg_u1,tmp_result,clk);
end Behavioral;
-----------------------------------------------------------------------

------------------------------------------------------------------------
-- древовидный перемножитель-сумматор матрицы фильтра "размытие"
-- работает в RNS_15_16_17
------------------------------------------------------------------------
entity blur_RNS_15_16_17_adder is
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
end blur_RNS_15_16_17_adder;

architecture Behavioral of blur_RNS_15_16_17_adder is
   component add_mod_15 is
	Port (op1,op2: in bit_vector(3 downto 0); res: out bit_vector(3 downto 0); clk: in bit);
   end component;

   component add_mod_16 is
	Port (op1,op2: in bit_vector(3 downto 0); res: out bit_vector(3 downto 0); clk: in bit);
   end component;

   component add_mod_17 is
	Port (op1,op2: in bit_vector(4 downto 0);	res: out bit_vector(4 downto 0); clk: in bit);
   end component;

signal x0_15,x1_15,x2_15,x3_15,x4_15,x5_15,x6_15,x7_15,x8_15,x9_15,xA_15,xB_15,xC_15,xD_15,xE_15: bit_vector(3 downto 0);
signal x0_16,x1_16,x2_16,x3_16,x4_16,x5_16,x6_16,x7_16,x8_16,x9_16,xA_16,xB_16,xC_16,xD_16,xE_16: bit_vector(3 downto 0);
signal x0_17,x1_17,x2_17,x3_17,x4_17,x5_17,x6_17,x7_17,x8_17,x9_17,xA_17,xB_17,xC_17,xD_17,xE_17: bit_vector(4 downto 0);

signal res_y0_15,res_y1_15,res_y2_15,res_y3_15,res_y4_15,res_y5_15,res_y6_15: bit_vector(3 downto 0);
signal res_y0_16,res_y1_16,res_y2_16,res_y3_16,res_y4_16,res_y5_16,res_y6_16: bit_vector(3 downto 0);
signal res_y0_17,res_y1_17,res_y2_17,res_y3_17,res_y4_17,res_y5_17,res_y6_17: bit_vector(4 downto 0);

signal arg_y0_15,arg_y1_15,arg_y2_15,arg_y3_15,arg_y4_15,arg_y5_15,arg_y6_15: bit_vector(3 downto 0);
signal arg_y0_16,arg_y1_16,arg_y2_16,arg_y3_16,arg_y4_16,arg_y5_16,arg_y6_16: bit_vector(3 downto 0);
signal arg_y0_17,arg_y1_17,arg_y2_17,arg_y3_17,arg_y4_17,arg_y5_17,arg_y6_17: bit_vector(4 downto 0);

signal res_z0_15,res_z1_15,res_z2_15,res_z3_15: bit_vector(3 downto 0);
signal res_z0_16,res_z1_16,res_z2_16,res_z3_16: bit_vector(3 downto 0);
signal res_z0_17,res_z1_17,res_z2_17,res_z3_17: bit_vector(4 downto 0);

signal arg_z0_15,arg_z1_15,arg_z2_15,arg_z3_15: bit_vector(3 downto 0);
signal arg_z0_16,arg_z1_16,arg_z2_16,arg_z3_16: bit_vector(3 downto 0);
signal arg_z0_17,arg_z1_17,arg_z2_17,arg_z3_17: bit_vector(4 downto 0);

signal res_u0_15,res_u0_16,res_u1_15,res_u1_16: bit_vector(3 downto 0);
signal res_u0_17,res_u1_17: bit_vector(4 downto 0);

signal arg_u0_15,arg_u0_16,arg_u1_15,arg_u1_16: bit_vector(3 downto 0);
signal arg_u0_17,arg_u1_17: bit_vector(4 downto 0);

signal tmp_res_15,tmp_res_16:bit_vector(3 downto 0);
signal tmp_res_17:bit_vector(4 downto 0);

begin
process(clk)
begin
   if (clk'event and clk = '1') then
   x0_15<=a11_15; x0_16<=a11_16; x0_17<=a11_17;
   x1_15<=a12_15; x1_16<=a12_16; x1_17<=a12_17;
   x2_15<=a12_15; x2_16<=a12_16; x2_17<=a12_17;
   x3_15<=a13_15; x3_16<=a13_16; x3_17<=a13_17;
   x4_15<=a21_15; x4_16<=a21_16; x4_17<=a21_17;
   x5_15<=a21_15; x5_16<=a21_16; x5_17<=a21_17;
   x6_15<=a22_15; x6_16<=a22_16; x6_17<=a22_17;
   x7_15<=a22_15; x7_16<=a22_16; x7_17<=a22_17;
   x8_15<=a22_15; x8_16<=a22_16; x8_17<=a22_17;
   x9_15<=a23_15; x9_16<=a23_16; x9_17<=a23_17;
   xA_15<=a23_15; xA_16<=a23_16; xA_17<=a23_17;
   xB_15<=a31_15; xB_16<=a31_16; xB_17<=a31_17;
   xC_15<=a32_15; xC_16<=a32_16; xC_17<=a32_17;
   xD_15<=a32_15; xD_16<=a32_16; xD_17<=a32_17;
   xE_15<=a33_15; xE_16<=a33_16; xE_17<=a33_17;

   arg_y0_15<=res_y0_15;
   arg_y1_15<=res_y1_15;
   arg_y2_15<=res_y2_15;
   arg_y3_15<=res_y3_15;
   arg_y4_15<=res_y4_15;
   arg_y5_15<=res_y5_15;
   arg_y6_15<=res_y6_15;

   arg_z0_15<=res_z0_15;
   arg_z1_15<=res_z1_15;
   arg_z2_15<=res_z2_15;
   arg_z3_15<=res_z3_15;
   
   arg_u0_15<=res_u0_15;
   arg_u1_15<=res_u1_15;

   arg_y0_16<=res_y0_16;
   arg_y1_16<=res_y1_16;
   arg_y2_16<=res_y2_16;
   arg_y3_16<=res_y3_16;
   arg_y4_16<=res_y4_16;
   arg_y5_16<=res_y5_16;
   arg_y6_16<=res_y6_16;

   arg_z0_16<=res_z0_16;
   arg_z1_16<=res_z1_16;
   arg_z2_16<=res_z2_16;
   arg_z3_16<=res_z3_16;
   
   arg_u0_16<=res_u0_16;
   arg_u1_16<=res_u1_16;

   arg_y0_17<=res_y0_17;
   arg_y1_17<=res_y1_17;
   arg_y2_17<=res_y2_17;
   arg_y3_17<=res_y3_17;
   arg_y4_17<=res_y4_17;
   arg_y5_17<=res_y5_17;
   arg_y6_17<=res_y6_17;

   arg_z0_17<=res_z0_17;
   arg_z1_17<=res_z1_17;
   arg_z2_17<=res_z2_17;
   arg_z3_17<=res_z3_17;
   
   arg_u0_17<=res_u0_17;
   arg_u1_17<=res_u1_17;

   res_15<=tmp_res_15;
   res_16<=tmp_res_16;
   res_17<=tmp_res_17;
   end if;
end process;

--   x0_15<=a11_15; x0_16<=a11_16; x0_17<=a11_17;
--   x1_15<=a12_15; x1_16<=a12_16; x1_17<=a12_17;
--   x2_15<=a12_15; x2_16<=a12_16; x2_17<=a12_17;
--   x3_15<=a13_15; x3_16<=a13_16; x3_17<=a13_17;
--   x4_15<=a21_15; x4_16<=a21_16; x4_17<=a21_17;
--   x5_15<=a21_15; x5_16<=a21_16; x5_17<=a21_17;
--   x6_15<=a22_15; x6_16<=a22_16; x6_17<=a22_17;
--   x7_15<=a22_15; x7_16<=a22_16; x7_17<=a22_17;
--   x8_15<=a22_15; x8_16<=a22_16; x8_17<=a22_17;
--   x9_15<=a23_15; x9_16<=a23_16; x9_17<=a23_17;
--   xA_15<=a23_15; xA_16<=a23_16; xA_17<=a23_17;
--   xB_15<=a31_15; xB_16<=a31_16; xB_17<=a31_17;
--   xC_15<=a32_15; xC_16<=a32_16; xC_17<=a32_17;
--   xD_15<=a32_15; xD_16<=a32_16; xD_17<=a32_17;
--   xE_15<=a33_15; xE_16<=a33_16; xE_17<=a33_17;
--
--   arg_y0_15<=res_y0_15;
--   arg_y1_15<=res_y1_15;
--   arg_y2_15<=res_y2_15;
--   arg_y3_15<=res_y3_15;
--   arg_y4_15<=res_y4_15;
--   arg_y5_15<=res_y5_15;
--   arg_y6_15<=res_y6_15;
--
--   arg_z0_15<=res_z0_15;
--   arg_z1_15<=res_z1_15;
--   arg_z2_15<=res_z2_15;
--   arg_z3_15<=res_z3_15;
--   
--   arg_u0_15<=res_u0_15;
--   arg_u1_15<=res_u1_15;
--
--   arg_y0_16<=res_y0_16;
--   arg_y1_16<=res_y1_16;
--   arg_y2_16<=res_y2_16;
--   arg_y3_16<=res_y3_16;
--   arg_y4_16<=res_y4_16;
--   arg_y5_16<=res_y5_16;
--   arg_y6_16<=res_y6_16;
--
--   arg_z0_16<=res_z0_16;
--   arg_z1_16<=res_z1_16;
--   arg_z2_16<=res_z2_16;
--   arg_z3_16<=res_z3_16;
--   
--   arg_u0_16<=res_u0_16;
--   arg_u1_16<=res_u1_16;
--
--   arg_y0_17<=res_y0_17;
--   arg_y1_17<=res_y1_17;
--   arg_y2_17<=res_y2_17;
--   arg_y3_17<=res_y3_17;
--   arg_y4_17<=res_y4_17;
--   arg_y5_17<=res_y5_17;
--   arg_y6_17<=res_y6_17;
--
--   arg_z0_17<=res_z0_17;
--   arg_z1_17<=res_z1_17;
--   arg_z2_17<=res_z2_17;
--   arg_z3_17<=res_z3_17;
--   
--   arg_u0_17<=res_u0_17;
--   arg_u1_17<=res_u1_17;
--
--   res_15<=tmp_res_15;
--   res_16<=tmp_res_16;
--   res_17<=tmp_res_17;

   add_x0_x1_15: add_mod_15 port map(x0_15,x1_15,res_y0_15,clk);
   add_x2_x3_15: add_mod_15 port map(x2_15,x3_15,res_y1_15,clk);
   add_x4_x5_15: add_mod_15 port map(x4_15,x5_15,res_y2_15,clk);
   add_x6_x7_15: add_mod_15 port map(x6_15,x7_15,res_y3_15,clk);
   add_x8_x9_15: add_mod_15 port map(x8_15,x9_15,res_y4_15,clk);
   add_xA_xB_15: add_mod_15 port map(xA_15,xB_15,res_y5_15,clk);
   add_xC_xD_15: add_mod_15 port map(xC_15,xD_15,res_y6_15,clk);

   add_x0_x1_16: add_mod_16 port map(x0_16,x1_16,res_y0_16,clk);
   add_x2_x3_16: add_mod_16 port map(x2_16,x3_16,res_y1_16,clk);
   add_x4_x5_16: add_mod_16 port map(x4_16,x5_16,res_y2_16,clk);
   add_x6_x7_16: add_mod_16 port map(x6_16,x7_16,res_y3_16,clk);
   add_x8_x9_16: add_mod_16 port map(x8_16,x9_16,res_y4_16,clk);
   add_xA_xB_16: add_mod_16 port map(xA_16,xB_16,res_y5_16,clk);
   add_xC_xD_16: add_mod_16 port map(xC_16,xD_16,res_y6_16,clk);

   add_x0_x1_17: add_mod_17 port map(x0_17,x1_17,res_y0_17,clk);
   add_x2_x3_17: add_mod_17 port map(x2_17,x3_17,res_y1_17,clk);
   add_x4_x5_17: add_mod_17 port map(x4_17,x5_17,res_y2_17,clk);
   add_x6_x7_17: add_mod_17 port map(x6_17,x7_17,res_y3_17,clk);
   add_x8_x9_17: add_mod_17 port map(x8_17,x9_17,res_y4_17,clk);
   add_xA_xB_17: add_mod_17 port map(xA_17,xB_17,res_y5_17,clk);
   add_xC_xD_17: add_mod_17 port map(xC_17,xD_17,res_y6_17,clk);

   add_y0_y1_15: add_mod_15 port map(arg_y0_15,arg_y1_15,res_z0_15,clk);
   add_y2_y3_15: add_mod_15 port map(arg_y2_15,arg_y3_15,res_z1_15,clk);
   add_y4_y5_15: add_mod_15 port map(arg_y4_15,arg_y5_15,res_z2_15,clk);
   add_y6_xE_15: add_mod_15 port map(arg_y6_15,Xe_15,res_z3_15,clk);
   
   add_y0_y1_16: add_mod_16 port map(arg_y0_16,arg_y1_16,res_z0_16,clk);
   add_y2_y3_16: add_mod_16 port map(arg_y2_16,arg_y3_16,res_z1_16,clk);
   add_y4_y5_16: add_mod_16 port map(arg_y4_16,arg_y5_16,res_z2_16,clk);
   add_y6_xE_16: add_mod_16 port map(arg_y6_16,Xe_16,res_z3_16,clk);

   add_y0_y1_17: add_mod_17 port map(arg_y0_17,arg_y1_17,res_z0_17,clk);
   add_y2_y3_17: add_mod_17 port map(arg_y2_17,arg_y3_17,res_z1_17,clk);
   add_y4_y5_17: add_mod_17 port map(arg_y4_17,arg_y5_17,res_z2_17,clk);
   add_y6_xE_17: add_mod_17 port map(arg_y6_17,Xe_17,res_z3_17,clk);

   add_z0_z1_15: add_mod_15 port map(arg_z0_15,arg_z1_15,res_u0_15,clk);
   add_z2_z3_15: add_mod_15 port map(arg_z2_15,arg_z3_15,res_u1_15,clk);

   add_z0_z1_16: add_mod_16 port map(arg_z0_16,arg_z1_16,res_u0_16,clk);
   add_z2_z3_16: add_mod_16 port map(arg_z2_16,arg_z3_16,res_u1_16,clk);

   add_z0_z1_17: add_mod_17 port map(arg_z0_17,arg_z1_17,res_u0_17,clk);
   add_z2_z3_17: add_mod_17 port map(arg_z2_17,arg_z3_17,res_u1_17,clk);

   add_u0_u1_15: add_mod_15 port map(arg_u0_15,arg_u1_15,tmp_res_15,clk);
   add_u0_u1_16: add_mod_16 port map(arg_u0_16,arg_u1_16,tmp_res_16,clk);
   add_u0_u1_17: add_mod_17 port map(arg_u0_17,arg_u1_17,tmp_res_17,clk);
end Behavioral;
------------------------------------------------------------------------

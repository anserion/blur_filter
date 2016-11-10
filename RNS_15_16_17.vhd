------------------------------------------------------------------------
-- ROM остатков от деления 5-битного числа на 15
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity ROM_5bit_mod15 is
port (a:in bit_vector(4 downto 0); r15:out bit_vector(3 downto 0); clk: in bit);
end ROM_5bit_mod15;
architecture Behavioral of ROM_5bit_mod15 is
type TROM_mod15 is array (0 to 31) of bit_vector(3 downto 0);
signal ROM_mod15: TROM_mod15:= (x"0",x"1",x"2",x"3",x"4",x"5",x"6",x"7",
                                x"8",x"9",x"A",x"B",x"C",x"D",x"E",x"0",
                                x"1",x"2",x"3",x"4",x"5",x"6",x"7",x"8",
                                x"9",x"A",x"B",x"C",x"D",x"E",x"0",x"1");
signal tmp_r15: bit_vector(3 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     r15<=tmp_r15;
   end if;
end process;
tmp_r15<=ROM_mod15(conv_integer(To_StdLogicVector(a)));
end Behavioral;

------------------------------------------------------------------------
-- ROM остатков от деления 5-битного числа на 17
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity ROM_5bit_mod17 is
port (a:in bit_vector(4 downto 0); r17:out bit_vector(4 downto 0); clk: in bit);
end ROM_5bit_mod17;
architecture Behavioral of ROM_5bit_mod17 is
type TROM_mod17 is array (0 to 31) of bit_vector(4 downto 0);
signal ROM_mod17: TROM_mod17:= ("00000","00001","00010","00011","00100","00101","00110","00111",
                                "01000","01001","01010","01011","01100","01101","01110","01111",
                                "10000","00000","00001","00010","00011","00100","00101","00110",
                                "00111","01000","01001","01010","01011","01100","01101","01110");
signal tmp_r17: bit_vector(4 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     r17<=tmp_r17;
   end if;
end process;
tmp_r17<=ROM_mod17(conv_integer(To_StdLogicVector(a)));
end Behavioral;

------------------------------------------------------------------------
-- ROM остатков от деления 6-битного числа на 17
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity ROM_6bit_mod17 is
port (a:in bit_vector(5 downto 0); r17:out bit_vector(4 downto 0); clk: in bit);
end ROM_6bit_mod17;
architecture Behavioral of ROM_6bit_mod17 is
type TROM_mod17 is array (0 to 63) of bit_vector(4 downto 0);
signal ROM_mod17: TROM_mod17:= ("00000","00001","00010","00011","00100","00101","00110","00111",
                                "01000","01001","01010","01011","01100","01101","01110","01111",
                                "10000","00000","00001","00010","00011","00100","00101","00110",
                                "00111","01000","01001","01010","01011","01100","01101","01110",
                                "01111","10000","00000","00001","00010","00011","00100","00101",
                                "00110","00111","01000","01001","01010","01011","01100","01101",
                                "01110","01111","10000","00000","00001","00010","00011","00100",
                                "00101","00110","00111","01000","01001","01010","01011","01100");
signal tmp_r17: bit_vector(4 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     r17<=tmp_r17;
   end if;
end process;
tmp_r17<=ROM_mod17(conv_integer(To_StdLogicVector(a)));
end Behavioral;

------------------------------------------------------------------------
-- 4-бит двоичный сумматор
------------------------------------------------------------------------
entity binary_add_4bit is
Port (op1,op2: in bit_vector(3 downto 0);
      res: out bit_vector(4 downto 0);
      clk: in bit);
end binary_add_4bit;
architecture Behavioral of binary_add_4bit is
component full_adder
   Port (op1,op2,carry_in: in bit; res,carry_out: out bit; clk: in bit);
end component;
signal c1,c2,c3:bit;
begin
a0: full_adder port map(op1(0),op2(0),'0',res(0),c1,clk);
a1: full_adder port map(op1(1),op2(1),c1,res(1),c2,clk);
a2: full_adder port map(op1(2),op2(2),c2,res(2),c3,clk);
a3: full_adder port map(op1(3),op2(3),c3,res(3),res(4),clk);
end Behavioral;

------------------------------------------------------------------------
-- 4-бит двоичный вычитатель
------------------------------------------------------------------------
entity binary_sub_4bit is
Port (op1,op2: in bit_vector(3 downto 0);
      res: out bit_vector(4 downto 0);
      clk: in bit);
end binary_sub_4bit;
architecture Behavioral of binary_sub_4bit is
component full_adder
   Port (op1,op2,carry_in: in bit; res,carry_out: out bit; clk: in bit);
end component;
signal c1,c2,c3:bit;
begin
a0: full_adder port map(op1(0),not(op2(0)),'1',res(0),c1,clk);
a1: full_adder port map(op1(1),not(op2(1)),c1,res(1),c2,clk);
a2: full_adder port map(op1(2),not(op2(2)),c2,res(2),c3,clk);
a3: full_adder port map(op1(3),not(op2(3)),c3,res(3),res(4),clk);
end Behavioral;

------------------------------------------------------------------------
-- 5-бит двоичный сумматор
------------------------------------------------------------------------
entity binary_add_5bit is
Port (op1,op2: in bit_vector(4 downto 0);
      res: out bit_vector(5 downto 0);
      clk: in bit);
end binary_add_5bit;
architecture Behavioral of binary_add_5bit is
component full_adder
   Port (op1,op2,carry_in: in bit; res,carry_out: out bit; clk: in bit);
end component;
signal c1,c2,c3,c4:bit;
begin
a0: full_adder port map(op1(0),op2(0),'0',res(0),c1,clk);
a1: full_adder port map(op1(1),op2(1),c1,res(1),c2,clk);
a2: full_adder port map(op1(2),op2(2),c2,res(2),c3,clk);
a3: full_adder port map(op1(3),op2(3),c3,res(3),c4,clk);
a4: full_adder port map(op1(4),op2(4),c4,res(4),res(5),clk);
end Behavioral;

------------------------------------------------------------------------
-- 5-бит двоичный вычитатель
------------------------------------------------------------------------
entity binary_sub_5bit is
Port (op1,op2: in bit_vector(4 downto 0);
      res: out bit_vector(5 downto 0);
      clk: in bit);
end binary_sub_5bit;
architecture Behavioral of binary_sub_5bit is
component full_adder
   Port (op1,op2,carry_in: in bit; res,carry_out: out bit; clk: in bit);
end component;
signal c1,c2,c3,c4:bit;
begin
a0: full_adder port map(op1(0),not(op2(0)),'1',res(0),c1,clk);
a1: full_adder port map(op1(1),not(op2(1)),c1,res(1),c2,clk);
a2: full_adder port map(op1(2),not(op2(2)),c2,res(2),c3,clk);
a3: full_adder port map(op1(3),not(op2(3)),c3,res(3),c4,clk);
a4: full_adder port map(op1(4),not(op2(4)),c4,res(4),res(5),clk);
end Behavioral;

------------------------------------------------------------------------
-- нахождение остатка от деления 8-битного числа на 15
------------------------------------------------------------------------
entity BSS_8bit_mod_15 is
Port(a:in bit_vector(7 downto 0); res:out bit_vector(3 downto 0); clk: in bit);
end BSS_8bit_mod_15;

architecture Behavioral of BSS_8bit_mod_15 is
component binary_add_4bit
Port (op1,op2: in bit_vector(3 downto 0);
      res: out bit_vector(4 downto 0);
      clk: in bit);
end component;
component ROM_5bit_mod15 is
port (a:in bit_vector(4 downto 0); r15:out bit_vector(3 downto 0); clk: in bit);
end component;
signal L_plus_H: bit_vector(4 downto 0);
signal L,H,tmp_r15: bit_vector(3 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_r15;
   end if;
end process;
L<=a(3 downto 0); H<=a(7 downto 4);
SA: binary_add_4bit port map(L,H,L_plus_H,clk);
ROM_mod15: ROM_5bit_mod15 port map(L_plus_H,tmp_r15,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- нахождение остатка от деления 8-битного числа на 16
------------------------------------------------------------------------
entity BSS_8bit_mod_16 is
Port(a:in bit_vector(7 downto 0); res:out bit_vector(3 downto 0); clk: in bit);
end BSS_8bit_mod_16;

architecture Behavioral of BSS_8bit_mod_16 is
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=a(3 downto 0);
   end if;
end process;
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- нахождение остатка от деления 8-битного числа на 17
------------------------------------------------------------------------
entity BSS_8bit_mod_17 is
Port(a:in bit_vector(7 downto 0); res:out bit_vector(4 downto 0); clk: in bit);
end BSS_8bit_mod_17;

architecture Behavioral of BSS_8bit_mod_17 is
component binary_add_4bit
Port (op1,op2: in bit_vector(3 downto 0);
      res: out bit_vector(4 downto 0);
      clk: in bit);
end component;
component binary_sub_4bit
Port (op1,op2: in bit_vector(3 downto 0);
      res: out bit_vector(4 downto 0);
      clk: in bit);
end component;
signal L_minus_H,tmp_r17: bit_vector(4 downto 0);
signal L,H: bit_vector(3 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_r17;
   end if;
end process;
L<=a(3 downto 0); H<=a(7 downto 4);
LMH: binary_sub_4bit port map(L,H,L_minus_H,clk);
LMH1: binary_add_4bit port map(L_minus_H(3 downto 0),"000"&not(L_minus_H(4)),tmp_r17,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- сумматор 4-битных чисел (0-14) по модулю 15
------------------------------------------------------------------------
entity add_mod_15 is
   Port(op1,op2: in bit_vector(3 downto 0);
        res: out bit_vector(3 downto 0);
        clk: in bit);
end add_mod_15;

architecture Behavioral of add_mod_15 is
component binary_add_4bit
Port (op1,op2: in bit_vector(3 downto 0);
      res: out bit_vector(4 downto 0);
      clk: in bit);
end component;
component ROM_5bit_mod15 is
port (a:in bit_vector(4 downto 0); r15:out bit_vector(3 downto 0); clk: in bit);
end component;
signal op1_plus_op2: bit_vector(4 downto 0);
signal tmp_r15: bit_vector(3 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_r15;
   end if;
end process;
SA: binary_add_4bit port map(op1,op2,op1_plus_op2,clk);
ROM_mod15: ROM_5bit_mod15 port map(op1_plus_op2,tmp_r15,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- вычитатель 4-битных чисел (0-14) по модулю 15
------------------------------------------------------------------------
entity sub_mod_15 is
   Port(op1,op2: in bit_vector(3 downto 0);
        res: out bit_vector(3 downto 0);
        clk: in bit);
end sub_mod_15;

architecture Behavioral of sub_mod_15 is
component add_mod_15
Port (op1,op2: in bit_vector(3 downto 0);
      res: out bit_vector(3 downto 0);
      clk: in bit);
end component;

signal tmp_res: bit_vector(3 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_res;
   end if;
end process;
op1_add_op2_dop_15_mod_15: add_mod_15 port map(op1,not(op2),tmp_res,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- перемножитель 4-битных чисел (0-14) по модулю 15
------------------------------------------------------------------------
entity mul_mod_15 is
   Port(op1,op2: in bit_vector(3 downto 0);
        res: out bit_vector(3 downto 0);
        clk: in bit);
end mul_mod_15;

architecture Behavioral of mul_mod_15 is
component add_mod_15
Port (op1,op2: in bit_vector(3 downto 0);
      res: out bit_vector(3 downto 0);
      clk: in bit);
end component;
signal op1x2,op1x4,op1x8,a0,a1,a2,a3,s1,s2,tmp_res: bit_vector(3 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_res;
   end if;
end process;
MAx2: add_mod_15 port map(op1,op1,op1x2,clk);
MAx4: add_mod_15 port map(op1x2,op1x2,op1x4,clk);
MAx8: add_mod_15 port map(op1x4,op1x4,op1x8,clk);

a0<="0000" when op2(0)='0' else op1;
a1<="0000" when op2(1)='0' else op1x2;
a2<="0000" when op2(2)='0' else op1x4;
a3<="0000" when op2(3)='0' else op1x8;

s1_calc: add_mod_15 port map(a0,a1,s1,clk);
s2_calc: add_mod_15 port map(a2,a3,s2,clk);
res_calc: add_mod_15 port map(s1,s2,tmp_res,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- сумматор 4-битных чисел (0-15) по модулю 16
------------------------------------------------------------------------
entity add_mod_16 is
	Port(op1,op2: in bit_vector(3 downto 0);
        res: out bit_vector(3 downto 0);
        clk: in bit);
end add_mod_16;

architecture Behavioral of add_mod_16 is
component binary_add_4bit
Port (op1,op2: in bit_vector(3 downto 0);
      res: out bit_vector(4 downto 0);
      clk: in bit);
end component;
signal tmp_res:bit_vector(4 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_res(3 downto 0);
   end if;
end process;
SA: binary_add_4bit port map(op1,op2,tmp_res,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- вычитатель 4-битных чисел (0-15) по модулю 16
------------------------------------------------------------------------
entity sub_mod_16 is
   Port(op1,op2: in bit_vector(3 downto 0);
        res: out bit_vector(3 downto 0);
        clk: in bit);
end sub_mod_16;

architecture Behavioral of sub_mod_16 is
component binary_add_4bit
Port (op1,op2: in bit_vector(3 downto 0);
      res: out bit_vector(4 downto 0);
      clk: in bit);
end component;

signal op2_dop_16,tmp_r16: bit_vector(4 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_r16(3 downto 0);
   end if;
end process;
SA_op2_dop_16: binary_add_4bit port map(not(op2),"0001",op2_dop_16,clk);
op1_add_op2_dop_16_mod_16: binary_add_4bit port map(op1,op2_dop_16(3 downto 0),tmp_r16,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- перемножитель 4-битных чисел (0-15) по модулю 16
------------------------------------------------------------------------
entity mul_mod_16 is
   Port(op1,op2: in bit_vector(3 downto 0);
        res: out bit_vector(3 downto 0);
        clk: in bit);
end mul_mod_16;

architecture Behavioral of mul_mod_16 is
component add_mod_16
Port (op1,op2: in bit_vector(3 downto 0);
      res: out bit_vector(3 downto 0);
      clk: in bit);
end component;
signal a0,a1,a2,a3,s1,s2,tmp_res: bit_vector(3 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_res;
   end if;
end process;
a0<="0000" when op2(0)='0' else op1;
a1<="0000" when op2(1)='0' else op1(2 downto 0)&'0';
a2<="0000" when op2(2)='0' else op1(1 downto 0)&"00";
a3<="0000" when op2(3)='0' else op1(0)&"000";

s1_calc: add_mod_16 port map(a0,a1,s1,clk);
s2_calc: add_mod_16 port map(a2,a3,s2,clk);
res_calc: add_mod_16 port map(s1,s2,tmp_res,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- сумматор 5-битных чисел (0-16) по модулю 17
------------------------------------------------------------------------
entity add_mod_17 is
	Port(op1,op2: in bit_vector(4 downto 0);
        res: out bit_vector(4 downto 0);
        clk: in bit);
end add_mod_17;

architecture Behavioral of add_mod_17 is
component binary_add_5bit
Port (op1,op2: in bit_vector(4 downto 0);
      res: out bit_vector(5 downto 0);
      clk: in bit);
end component;
component ROM_6bit_mod17 is
port (a:in bit_vector(5 downto 0); r17:out bit_vector(4 downto 0); clk: in bit);
end component;
signal tmp_r17: bit_vector(4 downto 0);
signal op1_plus_op2: bit_vector(5 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_r17;
   end if;
end process;
SA: binary_add_5bit port map(op1,op2,op1_plus_op2,clk);
ROM_mod17: ROM_6bit_mod17 port map(op1_plus_op2,tmp_r17,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- вычитатель 5-битных чисел (0-16) по модулю 17
------------------------------------------------------------------------
entity sub_mod_17 is
   Port(op1,op2: in bit_vector(4 downto 0);
        res: out bit_vector(4 downto 0);
        clk: in bit);
end sub_mod_17;

architecture Behavioral of sub_mod_17 is
component ROM_6bit_mod17 is
port (a:in bit_vector(5 downto 0); r17:out bit_vector(4 downto 0); clk: in bit);
end component;
component binary_add_5bit
Port (op1,op2: in bit_vector(4 downto 0);
      res: out bit_vector(5 downto 0);
      clk: in bit);
end component;

signal op2_dop_17,op1_minus_op2: bit_vector(5 downto 0);
signal tmp_r17: bit_vector(4 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_r17;
   end if;
end process;
SA_op2_dop_17: binary_add_5bit port map("10010",not(op2),op2_dop_17,clk);
SA_op1_minus_op2: binary_add_5bit port map(op1,op2_dop_17(4 downto 0),op1_minus_op2,clk);
ROM_mod17: ROM_6bit_mod17 port map(op1_minus_op2,tmp_r17,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- перемножитель 5-битных чисел (0-16) по модулю 17
------------------------------------------------------------------------
entity mul_mod_17 is
   Port(op1,op2: in bit_vector(4 downto 0);
        res: out bit_vector(4 downto 0);
        clk: in bit);
end mul_mod_17;

architecture Behavioral of mul_mod_17 is
component add_mod_17
Port (op1,op2: in bit_vector(4 downto 0);
      res: out bit_vector(4 downto 0);
      clk: in bit);
end component;
component sub_mod_17
Port (op1,op2: in bit_vector(4 downto 0);
      res: out bit_vector(4 downto 0);
      clk: in bit);
end component;
signal op1x2,op1x4,op1x8,op1x16,a0,a1,a2,a3,a4,s1,s2,s3,s4,tmp_res: bit_vector(4 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_res;
   end if;
end process;
MAx2: add_mod_17 port map(op1,op1,op1x2,clk);
MAx4: add_mod_17 port map(op1x2,op1x2,op1x4,clk);
MAx8: add_mod_17 port map(op1x4,op1x4,op1x8,clk);
MAx16: sub_mod_17 port map("00000",op1,op1x16,clk);

a0<="00000" when op2(0)='0' else op1;
a1<="00000" when op2(1)='0' else op1x2;
a2<="00000" when op2(2)='0' else op1x4;
a3<="00000" when op2(3)='0' else op1x8;
a4<="00000" when op2(4)='0' else op1x16;

s1_calc: add_mod_17 port map(a0,a1,s1,clk);
s2_calc: add_mod_17 port map(a2,a3,s2,clk);
s3_calc: add_mod_17 port map(s1,s2,s3,clk);
s4_calc: add_mod_17 port map(s3,a4,s4,clk);
tmp_res<=s4 when op2(4)='1' else s3;
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- нахождение остатков от деления 8-битного числа на 15,16,17 (4,4,5 бит)
------------------------------------------------------------------------
entity BSS_8bit_to_RNS_15_16_17 is
   Port (a: in bit_vector(7 downto 0);
	      r15: out bit_vector(3 downto 0);
			r16: out bit_vector(3 downto 0);
			r17: out bit_vector(4 downto 0);
         clk: in bit);
end BSS_8bit_to_RNS_15_16_17;

architecture Behavioral of BSS_8bit_to_RNS_15_16_17 is
component BSS_8bit_mod_15
Port(a:in bit_vector(7 downto 0); res:out bit_vector(3 downto 0); clk: in bit);
end component;
component BSS_8bit_mod_16
Port(a:in bit_vector(7 downto 0); res:out bit_vector(3 downto 0); clk: in bit);
end component;
component BSS_8bit_mod_17
Port(a:in bit_vector(7 downto 0); res:out bit_vector(4 downto 0); clk: in bit);
end component;

signal tmp_r15,tmp_r16: bit_vector(3 downto 0);
signal tmp_r17: bit_vector(4 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     r15<=tmp_r15;
     r16<=tmp_r16;
     r17<=tmp_r17;
   end if;
end process;
   SA_mod15: BSS_8bit_mod_15 port map(a,tmp_r15,clk);
   SA_mod16: BSS_8bit_mod_16 port map(a,tmp_r16,clk);
   SA_mod17: BSS_8bit_mod_17 port map(a,tmp_r17,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- нахождение 8-битного числа по его остаткам от деления на 16 и 17
------------------------------------------------------------------------
entity RNS_16_17_to_8bit is
   Port (a: out bit_vector(7 downto 0);
         r16: in bit_vector(3 downto 0);
         r17: in bit_vector(4 downto 0);
         clk: in bit);
end RNS_16_17_to_8bit;

architecture Behavioral of RNS_16_17_to_8bit is
component binary_sub_5bit
Port (op1,op2: in bit_vector(4 downto 0);
      res: out bit_vector(5 downto 0);
      clk: in bit);
end component;
signal tmp: bit_vector(5 downto 0);
signal r17_greater_r16:bit;
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     a(3 downto 0)<=r16;
     a(7 downto 4)<=tmp(3 downto 0);
   end if;
end process;
SA: binary_sub_5bit port map('0'&r16,r17,tmp,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- модуль деления числа в RNS_15_16_17 на 15
------------------------------------------------------------------------
entity RNS_15_16_17_div15 is
	Port (a15,a16: in bit_vector(3 downto 0);
         a17: in bit_vector(4 downto 0);
	      r16: out bit_vector(3 downto 0);
         r17: out bit_vector(4 downto 0);
         clk: in bit);
end RNS_15_16_17_div15;

architecture Behavioral of RNS_15_16_17_div15 is
component add_mod_17
Port (op1,op2: in bit_vector(4 downto 0);
      res: out bit_vector(4 downto 0);
      clk: in bit);
end component;
component sub_mod_17
Port (op1,op2: in bit_vector(4 downto 0);
      res: out bit_vector(4 downto 0);
      clk: in bit);
end component;
component sub_mod_16
Port (op1,op2: in bit_vector(3 downto 0);
      res: out bit_vector(3 downto 0);
      clk: in bit);
end component;

signal a17_minus_a15_mod_17,a17_minus_a15_mod_17x2,a17_minus_a15_mod_17x4,tmp_r17:bit_vector(4 downto 0);
signal tmp_r16:bit_vector(3 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     r16<=tmp_r16;
     r17<=tmp_r17;
   end if;
end process;
--r16=(a15-a16)mod 16 (после кучи упрощений :) )
SA_a15_minus_a16_mod_16: sub_mod_16 port map(a15,a16,tmp_r16,clk);
--r17=((a17-a15)*8) mod 17,    (15^(-1)) mod 17 = 8
SA_a17_minus_a15_mod_17: sub_mod_17 port map(a17,'0'&a15,a17_minus_a15_mod_17,clk);
--(a17_minus_a15_mod_17 * 8) mod 17
MAx2: add_mod_17 port map(a17_minus_a15_mod_17,a17_minus_a15_mod_17,a17_minus_a15_mod_17x2,clk);
MAx4: add_mod_17 port map(a17_minus_a15_mod_17x2,a17_minus_a15_mod_17x2,a17_minus_a15_mod_17x4,clk);
MAx8: add_mod_17 port map(a17_minus_a15_mod_17x4,a17_minus_a15_mod_17x4,tmp_r17,clk);
end Behavioral;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- нахождение 12-битного числа по его остаткам от деления на 15,16,17
-- A = r16 + 16 * ( r15 + 15*(((((17-r17)mod17-r15) mod 17) * (15^(-1)mod 17)) mod 17) ),
-- 15^(-1) mod 17 = 8
------------------------------------------------------------------------
entity RNS_15_16_17_to_12bit is
	Port (a: out bit_vector(11 downto 0);
         r15,r16: in bit_vector(3 downto 0);
			r17: in bit_vector(4 downto 0);
         clk: in bit);
end RNS_15_16_17_to_12bit;

architecture Behavioral of RNS_15_16_17_to_12bit is
component sub_mod_15
   Port(op1,op2: in bit_vector(3 downto 0);
        res: out bit_vector(3 downto 0);
        clk: in bit);
end component;
component sub_mod_17
   Port(op1,op2: in bit_vector(4 downto 0);
        res: out bit_vector(4 downto 0);
        clk: in bit);
end component;
component BSS_8bit_mod_17
Port(a:in bit_vector(7 downto 0); res:out bit_vector(4 downto 0); clk: in bit);
end component;
component binary_subadder
Generic (n: integer);
Port (opcode:bit;
      op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n downto 0);
      clk: in bit);
end component;
component binary_adder
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n downto 0);
      clk: in bit);
end component;
signal r16_minus_r17,r16_minus_r17_minus_r15_minus_r16,rrr_17: bit_vector(4 downto 0);
signal r15_minus_r16: bit_vector(3 downto 0);
signal up8bit_res: bit_vector(8 downto 0);
signal rrr_17_mul_15: bit_vector(9 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     a<=up8bit_res(7 downto 0)&r16;
   end if;
end process;
r15_minus_r16_mod_15: sub_mod_15 port map(r15,r16,r15_minus_r16,clk);
r16_minus_r17_mod_17: sub_mod_17 port map('0'&r16,r17,r16_minus_r17,clk);
r16_minus_r17_minus_r15_minus_r16_mod_17: sub_mod_17 port map(r16_minus_r17,'0'&r15_minus_r16,r16_minus_r17_minus_r15_minus_r16,clk);
rrr_17_mod_17: BSS_8bit_mod_17 port map(r16_minus_r17_minus_r15_minus_r16&"000",rrr_17,clk);
rrr_17_mod_17_mul_15: binary_subadder generic map(9) port map('1',rrr_17&"0000","0000"&rrr_17,rrr_17_mul_15,clk);
up8bit_module: binary_adder generic map(8) port map(rrr_17_mul_15(7 downto 0),"0000"&r15_minus_r16,up8bit_res,clk);
end Behavioral;
------------------------------------------------------------------------

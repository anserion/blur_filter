------------------------------------------------------------------------
-- полный 1-битовый сумматор
------------------------------------------------------------------------
entity full_adder is
   Port (op1,op2,carry_in: in bit; res,carry_out: out bit; clk: in bit);
end full_adder;
architecture Behavioral of full_adder is
signal p:bit;
begin
process(clk)
begin
   if (clk'event and clk = '1') then
      p<=(not(op1) and op2)or (op1 and not(op2));
      res<=(not(p) and carry_in)or(p and not(carry_in));
      carry_out<=(op1 and op2)or(p and carry_in);
   end if;
end process;
end Behavioral;

------------------------------------------------------------------------
-- n-бит двоичный сумматор
------------------------------------------------------------------------
entity binary_adder is
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n downto 0);
      clk: in bit);
end binary_adder;
architecture Behavioral of binary_adder is
component full_adder
   Port (op1,op2,carry_in: in bit; res,carry_out: out bit; clk: in bit);
end component;
signal carry:bit_vector(n downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res(n)<=carry(n);
   end if;
end process;
carry(0)<='0';
gen: for i in 0 to n-1 generate
   begin
     adder: full_adder port map(op1(i),op2(i),carry(i),res(i),carry(i+1),clk);
   end generate;
end Behavioral;

------------------------------------------------------------------------
-- двоичный сумматор n>=m
-- n-бит - первое слагаемое
-- m бит - второе слагаемое
------------------------------------------------------------------------
entity binary_nm_adder is
Generic (n,m: integer);
Port (op1: in bit_vector(n-1 downto 0);
      op2: in bit_vector(m-1 downto 0);
      res: out bit_vector(n downto 0);
      clk: in bit);
end binary_nm_adder;
architecture Behavioral of binary_nm_adder is
component binary_adder
generic(n:integer);
Port(op1,op2:in bit_vector(n-1 downto 0); res:out bit_vector(n downto 0); clk: in bit);
end component;
signal tmp_op2:bit_vector(n-1 downto 0);
begin
tmp_op2(m-1 downto 0)<=op2;
tmp_op2(n-1 downto m)<=(others=>'0');
SA: binary_adder generic map(n) port map(op1,tmp_op2,res,clk);
end Behavioral;

------------------------------------------------------------------------
-- n-бит двоичный сумматор/вычитатель
-- opcode='0' - сумма
-- opcode='1' - разность
------------------------------------------------------------------------
entity binary_subadder is
Generic (n: integer);
Port (opcode: in bit;
      op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n downto 0);
      clk: in bit);
end binary_subadder;
architecture Behavioral of binary_subadder is
component full_adder
   Port (op1,op2,carry_in: in bit; res,carry_out: out bit; clk: in bit);
end component;
signal carry:bit_vector(n downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res(n)<=carry(n);
   end if;
end process;
carry(0)<=opcode;
gen: for i in 0 to n-1 generate
   begin
     adder: full_adder port map(op1(i),op2(i) xor opcode,carry(i),res(i),carry(i+1),clk);
   end generate;
end Behavioral;

------------------------------------------------------------------------
-- двоичный сумматор/вычитатель n>=m
-- opcode='0' - сумма
-- opcode='1' - разность
-- n-бит - первое слагаемое (уменьшаемое)
-- m бит - второе слагаемое (вычитаемое)
------------------------------------------------------------------------
entity binary_nm_subadder is
Generic (n,m: integer);
Port (opcode: in bit;
      op1: in bit_vector(n-1 downto 0);
      op2: in bit_vector(m-1 downto 0);
      res: out bit_vector(n downto 0);
      clk: in bit);
end binary_nm_subadder;
architecture Behavioral of binary_nm_subadder is
component binary_subadder
generic(n:integer);
Port(opcode:bit; 
     op1,op2:in bit_vector(n-1 downto 0);
     res:out bit_vector(n downto 0);
     clk: in bit);
end component;
signal tmp_op2:bit_vector(n-1 downto 0);
begin
tmp_op2(m-1 downto 0)<=op2;
tmp_op2(n-1 downto m)<=(others=>'0');
SA: binary_subadder generic map(n) port map(opcode,op1,tmp_op2,res,clk);
end Behavioral;

------------------------------------------------------------------------
-- n-бит двоичный компаратор (проверка на равенство)
-- res=1 если операнды равны
------------------------------------------------------------------------
entity binary_is_equal is
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit;
      clk: in bit);
end binary_is_equal;
architecture Behavioral of binary_is_equal is
signal tmp_res:bit_vector(n downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
      res<=not(tmp_res(n));
   end if;
end process;
tmp_res(0)<='0';
gen: for i in 0 to n-1 generate tmp_res(i+1)<=tmp_res(i) or (op1(i) xor op2(i)); end generate; 
end Behavioral;

------------------------------------------------------------------------
-- n-бит двоичный компаратор (проверка на "больше")
-- https://ru.wikipedia.org/wiki/Цифровой_компаратор
-- res=1 если операнды op1>op2
------------------------------------------------------------------------
entity binary_is_greater_than is
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit;
      clk: in bit);
end binary_is_greater_than;
architecture Behavioral of binary_is_greater_than is
signal tmp_res,tmp_carry:bit_vector(n downto 0);
signal tmp_cmp,tmp_equ:bit_vector(n-1 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
      res<=tmp_res(0);
   end if;
end process;
tmp_res(n)<='0';
tmp_carry(n)<='1';
gen: for i in n-1 downto 0 generate
begin
  tmp_cmp(i)<=op1(i) and (not(op2(i)));
  tmp_equ(i)<=not(op1(i)xor op2(i));
  tmp_carry(i)<=tmp_carry(i+1)and tmp_equ(i);
  tmp_res(i)<=tmp_res(i+1)or (tmp_carry(i+1) and tmp_cmp(i));
end generate;
end Behavioral;

------------------------------------------------------------------------
-- n-бит двоичный компаратор (проверка на "больше", "меньше", "равно")
-- https://ru.wikipedia.org/wiki/Цифровой_компаратор
-- res_equ=1 если операнды равны
-- res_greater=1 если op1>op2
-- res_lower=1 если op1<op2
------------------------------------------------------------------------
entity binary_cmp is
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res_equ,res_greater,res_lower: out bit;
      clk: in bit);
end binary_cmp;
architecture Behavioral of binary_cmp is
signal tmp_res_g,tmp_res_l,tmp_res_e:bit_vector(n downto 0);
signal tmp_greater,tmp_lower,tmp_equ:bit_vector(n-1 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
      res_greater<=tmp_res_g(0);
      res_lower<=tmp_res_l(0);
      res_equ<=tmp_res_e(0);
   end if;
end process;
tmp_res_g(n)<='0';
tmp_res_l(n)<='0';
tmp_res_e(n)<='1';
gen: for i in n-1 downto 0 generate
begin
  tmp_greater(i)<=op1(i) and (not(op2(i)));
  tmp_lower(i)<=(not(op1(i))) and op2(i);
  tmp_equ(i)<=not(op1(i)xor op2(i));
  tmp_res_e(i)<=tmp_res_e(i+1)and tmp_equ(i);
  tmp_res_g(i)<=tmp_res_g(i+1)or (tmp_res_e(i+1) and tmp_greater(i));
  tmp_res_l(i)<=tmp_res_l(i+1)or (tmp_res_e(i+1) and tmp_lower(i));
end generate;
end Behavioral;

------------------------------------------------------------------------
-- n-бит двоичный перемножитель (столбиком)
------------------------------------------------------------------------
entity binary_mul is
Generic (n: integer:=8);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(2*n-1 downto 0);
      clk: in bit);
end binary_mul;
architecture Behavioral of binary_mul is
component binary_adder
generic(n:integer);
Port(op1,op2:in bit_vector(n-1 downto 0); res:out bit_vector(n downto 0); clk: in bit);
end component;
type T_tmp_sum is array(0 to n) of bit_vector(2*n downto 0);
signal tmp_sum,tmp_op1: T_tmp_sum; 
signal c:bit;
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_sum(n)(2*n-1 downto 0);
   end if;
end process;
tmp_sum(0)<=(others=>'0');
gen: for i in 0 to n-1 generate
   begin
     tmp_op1(i)(2*n-1 downto n+i)<=(others=>'0');
     tmp_op1(i)(n+i-1 downto i)<=(others=>'0') when op2(i)='0' else op1;
     tmp_op1(i)(i-1 downto 0)<=(others=>'0');
     adder: binary_adder generic map(2*n) port map(tmp_op1(i)(2*n-1 downto 0),
                                                   tmp_sum(i)(2*n-1 downto 0),
                                                   tmp_sum(i+1),clk);
   end generate;
end Behavioral;

------------------------------------------------------------------------
-- двоичный перемножитель (столбиком)
-- n-бит - первый множитель
-- m бит - второй множитель
------------------------------------------------------------------------
entity binary_nm_mul is
Generic (n,m: integer);
Port (op1: in bit_vector(n-1 downto 0);
      op2: in bit_vector(m-1 downto 0);
      res: out bit_vector(n+m-1 downto 0);
      clk: in bit);
end binary_nm_mul;
architecture Behavioral of binary_nm_mul is
component binary_adder
generic(n:integer);
Port(op1,op2:in bit_vector(n-1 downto 0); res:out bit_vector(n downto 0); clk: in bit);
end component;
type T_tmp_sum is array(0 to n) of bit_vector(n+m downto 0);
signal tmp_sum,tmp_op1: T_tmp_sum;
signal c:bit;
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     res<=tmp_sum(m)(n+m-1 downto 0);
   end if;
end process;
tmp_sum(0)<=(others=>'0');
gen: for i in 0 to m-1 generate
   begin
     tmp_op1(i)(n+m-1 downto n+i)<=(others=>'0');
     tmp_op1(i)(n+i-1 downto i)<=(others=>'0') when op2(i)='0' else op1;
     tmp_op1(i)(i-1 downto 0)<=(others=>'0');
     adder: binary_adder generic map(n+m) port map(tmp_op1(i)(n+m-1 downto 0),
                                                   tmp_sum(i)(n+m-1 downto 0),
                                                   tmp_sum(i+1),clk);
   end generate;
end Behavioral;

------------------------------------------------------------------------
-- двоичный делитель с остатком (столбиком)
------------------------------------------------------------------------
entity binary_div is
Generic (n: integer);
Port (a,b: in bit_vector(n-1 downto 0);
      q,r: out bit_vector(n-1 downto 0);
      clk: in bit);
end binary_div;
architecture Behavioral of binary_div is
component binary_subadder
Generic (n: integer);
Port (opcode: in bit;
      op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n downto 0);
      clk: in bit);
end component;
component binary_is_greater_than
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit;
      clk: in bit);
end component;
component binary_is_equal
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit;
      clk: in bit);
end component;

type T_2n1_bit is array(0 to n) of bit_vector(n+n-1 downto 0);
signal tmp_r,tmp_b: T_2n1_bit;
signal tmp_q,tmp_equal,tmp_greater:bit_vector(n-1 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     q<=tmp_q;
     r<=tmp_r(n)(n-1 downto 0);
   end if;
end process;
tmp_r(0)(n+n-1 downto n)<=(others=>'0');
tmp_r(0)(n-1 downto 0)<=a;
gen: for i in 0 to n-1 generate
   begin
     cmp_greater_module: binary_is_greater_than generic map(n)
                         port map(tmp_r(i)(n+n-i-2 downto n-i-1),b,tmp_greater(n-i-1),clk);
     cmp_equal_module: binary_is_equal generic map(n)
                         port map(tmp_r(i)(n+n-i-2 downto n-i-1),b,tmp_equal(n-i-1),clk);
     tmp_q(n-i-1)<=tmp_greater(n-i-1) or tmp_equal(n-i-1);                                   
     tmp_b(i)(n+n-1 downto n+n-i-1)<=(others=>'0');
     tmp_b(i)(n-i-2 downto 0)<=(others=>'0');
     tmp_b(i)(n+n-i-2 downto n-i-1)<=(others=>'0') when tmp_q(n-i-1)='0' else b;
     sub_module: binary_subadder generic map(n+n-1)
                                 port map('1',
                                          tmp_r(i)(n+n-2 downto 0),
                                          tmp_b(i)(n+n-2 downto 0),
                                          tmp_r(i+1),
                                          clk);
   end generate;
end Behavioral;

------------------------------------------------------------------------
-- двоичный делитель с остатком (столбиком)
-- n-бит - делимое, частное
-- m бит - делитель, остаток
------------------------------------------------------------------------
entity binary_nm_div is
Generic (n,m: integer);
Port (a: in bit_vector(n-1 downto 0);
      b: in bit_vector(m-1 downto 0);
      q: out bit_vector(n-1 downto 0);
      r: out bit_vector(m-1 downto 0);
      clk: in bit);
end binary_nm_div;
architecture Behavioral of binary_nm_div is
component binary_subadder
Generic (n: integer);
Port (opcode: in bit;
      op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n downto 0);
      clk: in bit);
end component;
component binary_is_greater_than
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit;
      clk: in bit);
end component;
component binary_is_equal
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit;
      clk: in bit);
end component;

type T_nm1_bit is array(0 to n) of bit_vector(n+m-1 downto 0);
signal tmp_r,tmp_b: T_nm1_bit;
signal tmp_q,tmp_equal,tmp_greater:bit_vector(n-1 downto 0);
begin
process(clk)
begin
   if (clk'event and clk = '1') then
     q<=tmp_q;
     r<=tmp_r(n)(m-1 downto 0);
   end if;
end process;
tmp_r(0)(n+m-1 downto n)<=(others=>'0');
tmp_r(0)(n-1 downto 0)<=a;
gen: for i in 0 to n-1 generate
   begin
     cmp_greater_module: binary_is_greater_than generic map(m+1)
                         port map(tmp_r(i)(n+m-i-1 downto n-i-1),'0'&b,tmp_greater(n-i-1),clk);
     cmp_equal_module: binary_is_equal generic map(m+1)
                         port map(tmp_r(i)(n+m-i-1 downto n-i-1),'0'&b,tmp_equal(n-i-1),clk);
     tmp_q(n-i-1)<=tmp_greater(n-i-1) or tmp_equal(n-i-1);                                   
     tmp_b(i)(n+m-1 downto n+m-i-1)<=(others=>'0');
     tmp_b(i)(n-i-2 downto 0)<=(others=>'0');
     tmp_b(i)(n+m-i-2 downto n-i-1)<=(others=>'0') when tmp_q(n-i-1)='0' else b;
     sub_module: binary_subadder generic map(n+m-1)
                                 port map('1',
                                          tmp_r(i)(n+m-2 downto 0),
                                          tmp_b(i)(n+m-2 downto 0),
                                          tmp_r(i+1),
                                          clk);
   end generate;
end Behavioral;

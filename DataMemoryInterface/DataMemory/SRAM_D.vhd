Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;




ENTITY SRAM_D IS
  GENERIC(N: INTEGER:=15;
          m: INTEGER:=32;
          K: INTEGER:=7
	);
  PORT(W_EN, R_EN: IN std_logic;
       WADDR, RADDR: IN std_logic_vector(m-1 DOWNTO 0);
       WDATA: IN std_logic_vector(m-1 DOWNTO 0);
       RDATA: OUT std_logic_vector(m-1 DOWNTO 0));
END SRAM_D;



ARCHITECTURE behavioral OF SRAM_D IS
  
  SIGNAL WVL, RVL: std_logic_vector(2**(K)-1 DOWNTO 0);
  SIGNAL WHL, RHL: std_logic_vector(2**(N-K)-1 DOWNTO 0);
  TYPE data_array IS ARRAY (2**(K)-1 DOWNTO 0) OF std_logic_vector(m-1 DOWNTO 0);
  SIGNAL Din, Dout: data_array;
  
-- Intermediate Signals of Memory-Cells
  TYPE column_intermediate_signal IS ARRAY (2**(K)-1 DOWNTO 0) OF std_logic;
  TYPE row_intermediate_signal IS ARRAY(2**(N-K)-1 DOWNTO 0) OF column_intermediate_signal;
  SIGNAL w, EN_tristate: row_intermediate_signal; 

-- Memory Cell Array   
  TYPE column IS ARRAY (2**(K)-1 DOWNTO 0) OF std_logic_vector(m-1 DOWNTO 0);
  TYPE matrix IS ARRAY(2**(N-K)-1 DOWNTO 0) OF column;
  SIGNAL DL_out : matrix := (others => (others => (others => '0'))); -- this is the array of latches, i.e. memory cell array
  signal TriState_out: matrix; -- these are the tristate buffers on latch output
  
  
  
  BEGIN
     
    
-- Processes for Decoder Operations
    -- Column Decoder for Writing Operation
    p_dec_WVL: PROCESS(all)
      VARIABLE i_WVL: INTEGER RANGE (2**(K)-1) DOWNTO 0;
      BEGIN
        i_WVL := to_integer(unsigned(WADDR(K-1 DOWNTO 0))); 
        WVL <= (others => '0');
        IF (W_EN = '1') THEN
          WVL(i_WVL) <= '1';
        END IF;      
    END PROCESS p_dec_WVL;
    
    -- Row Decoder for Writing Operation
    p_dec_WHL: PROCESS(all)
      VARIABLE i_WHL: INTEGER RANGE (2**(N-K)-1) DOWNTO 0;
      BEGIN
        i_WHL := to_integer(unsigned(WADDR(N-1 DOWNTO K)));
        WHL <= (others => '0');
        WHL(i_WHL) <= '1';      
    END PROCESS p_dec_WHL;
    
    -- Column Decoder for Reading Operation
    p_dec_RVL: PROCESS(all)
      VARIABLE i_RVL: INTEGER RANGE (2**(K)-1) DOWNTO 0;
      BEGIN
        i_RVL := to_integer(unsigned(RADDR(K-1 DOWNTO 0)));
        RVL <= (others => '0');
        IF R_EN = '1'  THEN
          RVL(i_RVL) <= '1';
        END IF;      
    END PROCESS p_dec_RVL;
    
    -- Row Decoder for Reading Operation
    p_dec_RHL: PROCESS(all)
      VARIABLE i_RHL: INTEGER RANGE (2**(N-K)-1) DOWNTO 0;
      BEGIN
        i_RHL := to_integer(unsigned(RADDR(N-1 DOWNTO K)));
        RHL <= (others => '0');
        RHL(i_RHL) <= '1';      
    END PROCESS p_dec_RHL;
    
    
    

       
-- Memory-Cells generate  
        columns: FOR j IN 2**(K)-1 DOWNTO 0
          generate
            rows: FOR i IN 2**(N-K)-1 DOWNTO 0
              generate   
              
                -- Writing Operation
                  Din(j) <= WDATA;
                  w(i)(j) <= WVL(j) AND WHL(i);
                  DL_out(i)(j) <= Din(j) when w(i)(j) = '1' ;
                
                -- Reading Operation
                  EN_tristate(i)(j) <= RVL(j) AND RHL(i);
                  TriState_out(i)(j) <= DL_out(i)(j) when EN_tristate(i)(j) = '1' else (others => 'Z');


                 -- fixed connections to Dout buses
                 Dout(j) <= TriState_out(i)(j);
                
              END generate rows;
              
              --fixed connectiions to RDATA output bus
              RDATA <= Dout(j);
              
          END generate columns;


    
END behavioral;
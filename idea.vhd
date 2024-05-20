Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IDEA_BLOCK is
    generic (
        KEY_SIZE : integer := 128;  -- Taille de la clé en bits
        BLOCK_SIZE : integer := 64   -- Taille du bloc en bits
    );
	port(
		  X1,X2,X3,X4 : in std_logic_vector(BLOCK_SIZE/4 - 1 downto 0);
		  key : in std_logic_vector(KEY_SIZE - 1 downto 0);
		  Y1,Y2,Y3,Y4 : out std_logic_vector(BLOCK_SIZE/4 - 1 downto 0)
	);
end IDEA_BLOCK;

architecture Desc_IDEA_BLOCK of IDEA_BLOCK is
Signal Step1,Step2,Step3,Step4,Step5,Step6,Step7,Step8,Step9,Step10,Step11,Step12,Step13,Step14,Step15: std_logic_vector(BLOCK_SIZE/4 - 1 downto 0);
	begin

		Step1 <= std_logic_vector((unsigned(X1) * unsigned(key(15 downto 0))) mod (2 ** 16 + 1))(15 downto 0) ; 
		Step2 <= std_logic_vector((unsigned(X2) + unsigned(key(31 downto 16))) mod 2 ** 16 ); 
		Step3 <= std_logic_vector((unsigned(X3) + unsigned(key(47 downto 32))) mod 2 ** 16 ); 
		Step4 <= std_logic_vector((unsigned(X4) * unsigned(key(63 downto 48))) mod (2 ** 16 + 1) )(15 downto 0);
		Step5 <= Step1 xor Step3;
		Step6 <= Step2 xor Step4;
		Step7 <= std_logic_vector((unsigned(Step5) * unsigned(key(79 downto 64))) mod (2 ** 16 + 1) )(15 downto 0);
		Step8 <= std_logic_vector((unsigned(Step6) + unsigned(Step7)) mod 2 ** 16 );
		Step9 <=std_logic_vector((unsigned(Step8) * unsigned(key(95 downto 80))) mod (2 ** 16 + 1) )(15 downto 0);
		Step10 <= std_logic_vector((unsigned(Step7) + unsigned(Step9)) mod 2 ** 16 );
		Y1 <= Step1 xor step9;
		Y2 <= Step2 xor Step9;
		Y3 <= Step2 xor Step10;
		Y4 <= Step4 xor Step10;
end Desc_IDEA_BLOCK;

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IDEA is
    generic (
        KEY_SIZE : integer := 128;  -- Taille de la clé en bits
        BLOCK_SIZE : integer := 64   -- Taille du bloc en bits
    );
    port (
        Input : in std_logic_vector(BLOCK_SIZE - 1 downto 0);
        key : in std_logic_vector(KEY_SIZE - 1 downto 0);
        Output : out std_logic_vector(BLOCK_SIZE - 1 downto 0)
    );
end IDEA;

architecture Desc_IDEA of IDEA is
	Signal Intermediary1, Intermediary2,Intermediary3,Intermediary4,Intermediary5,Intermediary6,Intermediary7,Intermediary8: std_logic_vector(BLOCK_SIZE-1 downto 0);
	Signal IntermediaryKey1,IntermediaryKey2,IntermediaryKey3,IntermediaryKey4,IntermediaryKey5,IntermediaryKey6,IntermediaryKey7,IntermediaryKey8: std_logic_vector(KEY_SIZE - 1 downto 0);
	component IDEA_BLOCK 	port( X1,X2,X3,X4 : in std_logic_vector(BLOCK_SIZE/4 -1 downto 0); key : in std_logic_vector(KEY_SIZE - 1 downto 0); Y1,Y2,Y3,Y4 : out std_logic_vector(BLOCK_SIZE/4 - 1 downto 0) ); end component;
	begin
	B1: IDEA_BLOCK port map(INPUT(15 downto 0),INPUT(31 downto 16), INPUT(47 downto 32),INPUT(63 downto 48),key,Intermediary1(15 downto 0),Intermediary1(31 downto 16), Intermediary1(47 downto 32),Intermediary1(63 downto 48));
	IntermediaryKey1 <= key(KEY_SIZE-26 downto 0) & key(KEY_SIZE-1 downto KEY_SIZE-25);
	
	B2: IDEA_BLOCK port map(Intermediary1(15 downto 0),Intermediary1(31 downto 16), Intermediary1(47 downto 32),Intermediary1(63 downto 48),IntermediaryKey1,Intermediary2(15 downto 0),Intermediary2(31 downto 16), Intermediary2(47 downto 32),Intermediary2(63 downto 48));
	IntermediaryKey2 <= IntermediaryKey1(KEY_SIZE-26 downto 0) & IntermediaryKey1(KEY_SIZE-1 downto KEY_SIZE-25);
	
	B3: IDEA_BLOCK port map(Intermediary2(15 downto 0),Intermediary2(31 downto 16), Intermediary2(47 downto 32),Intermediary2(63 downto 48),IntermediaryKey2,Intermediary3(15 downto 0),Intermediary3(31 downto 16), Intermediary3(47 downto 32),Intermediary3(63 downto 48));
	IntermediaryKey3 <= IntermediaryKey2(KEY_SIZE-26 downto 0) & IntermediaryKey2(KEY_SIZE-1 downto KEY_SIZE-25);
	
	B4: IDEA_BLOCK port map(Intermediary3(15 downto 0),Intermediary3(31 downto 16), Intermediary3(47 downto 32),Intermediary3(63 downto 48),IntermediaryKey3,Intermediary4(15 downto 0),Intermediary4(31 downto 16), Intermediary4(47 downto 32),Intermediary4(63 downto 48));
	IntermediaryKey4 <= IntermediaryKey3(KEY_SIZE-26 downto 0) & IntermediaryKey3(KEY_SIZE-1 downto KEY_SIZE-25);
	
	B5: IDEA_BLOCK port map(Intermediary4(15 downto 0),Intermediary4(31 downto 16), Intermediary4(47 downto 32),Intermediary4(63 downto 48),IntermediaryKey4,Intermediary5(15 downto 0),Intermediary5(31 downto 16), Intermediary5(47 downto 32),Intermediary5(63 downto 48));
	IntermediaryKey5 <= IntermediaryKey4(KEY_SIZE-26 downto 0) & IntermediaryKey4(KEY_SIZE-1 downto KEY_SIZE-25);
	
		B6: IDEA_BLOCK port map(Intermediary5(15 downto 0),Intermediary5(31 downto 16), Intermediary5(47 downto 32),Intermediary5(63 downto 48),IntermediaryKey5,Intermediary6(15 downto 0),Intermediary6(31 downto 16), Intermediary6(47 downto 32),Intermediary6(63 downto 48));
	IntermediaryKey6 <= IntermediaryKey5(KEY_SIZE-26 downto 0) & IntermediaryKey5(KEY_SIZE-1 downto KEY_SIZE-25);
	
	B7: IDEA_BLOCK port map(Intermediary6(15 downto 0),Intermediary6(31 downto 16), Intermediary6(47 downto 32),Intermediary6(63 downto 48),IntermediaryKey6,Intermediary7(15 downto 0),Intermediary7(31 downto 16), Intermediary7(47 downto 32),Intermediary7(63 downto 48));
	IntermediaryKey7 <= IntermediaryKey6(KEY_SIZE-26 downto 0) & IntermediaryKey6(KEY_SIZE-1 downto KEY_SIZE-25);
	
	B8: IDEA_BLOCK port map(Intermediary7(15 downto 0),Intermediary7(31 downto 16), Intermediary7(47 downto 32),Intermediary7(63 downto 48),IntermediaryKey7,Intermediary8(15 downto 0),Intermediary8(31 downto 16), Intermediary8(47 downto 32),Intermediary8(63 downto 48));
	IntermediaryKey8 <= IntermediaryKey7(KEY_SIZE-26 downto 0) & IntermediaryKey7(KEY_SIZE-1 downto KEY_SIZE-25);
	
		Output(15 downto 0) <= std_logic_vector((unsigned(Intermediary8(15 downto 0)) * unsigned(IntermediaryKey8(15 downto 0))) mod (2 ** 16 + 1))(15 downto 0) ; 
		Output(31 downto 16) <= std_logic_vector((unsigned(Intermediary8(31 downto 16)) + unsigned(IntermediaryKey8(31 downto 16))) mod 2 ** 16 ); 
		Output(47 downto 32) <= std_logic_vector((unsigned(Intermediary8(47 downto 32)) + unsigned(IntermediaryKey8(47 downto 32))) mod 2 ** 16 ); 
		Output(63 downto 48) <= std_logic_vector((unsigned(Intermediary8(63 downto 48)) * unsigned(IntermediaryKey8(63 downto 48))) mod (2 ** 16 + 1) )(15 downto 0);
	
	end Desc_IDEA;
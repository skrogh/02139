import java.util.*;
import java.io.*;

public class Assembler {

	private static int lineCounter = 0;
	private static Hashtable<String, String> registers;
	private static Hashtable<String, String> opcodes;
	private enum operand { REG, IMMEDIATE, BYTE }
	private static Hashtable<String, operand[]> grammar;
	private static Hashtable<String, Integer> markers;
	private static Hashtable<String, Integer> ram;
	private static String programtext;
	private static int markerline = 0;
	private static String processedtext;

	public static void main( String args[] ) {
		programtext = readFile( args[ 0 ] );
		makeRegisters();
		makeMarkers();
		makeOpcodes();
		makeSyntax();
		processMarkers();
		dump( args[1] );
	}

	private static void makeMarkers() {
		markers = new Hashtable<String, Integer>();
		ram = new Hashtable<String, Integer>();
	}

	private static void makeRegisters() {
		registers = new Hashtable<String, String>();
		for( int i = 0; i < 16; i++ ) {
			registers.put( "r" + i, toBinary( i, 4 ) );
		}
	}
	private static void makeOpcodes() {
		opcodes = new Hashtable<String, String>();
		opcodes.put( "nop", "00000" ); // No operation
		opcodes.put( "add", "00001" ); // Add two registers
		opcodes.put( "sub", "00010" ); // Subtract two registers
		opcodes.put( "sln", "00011" ); // Set low nibble
		opcodes.put( "shn", "00100" ); // Set high nibble
		opcodes.put( "res", "00101" ); // Reset register
		opcodes.put( "mov", "00110" ); // move one reg to another
		opcodes.put( "jmpa", "00111" ); // jump absolute
		opcodes.put( "jmpp", "01000" ); // jump relative positive
		opcodes.put( "jmpn", "01001" ); // jump relative negative
		opcodes.put( "brnp", "01010" ); // branch on carry positive
		opcodes.put( "brnn", "01011" ); // branch negative
		opcodes.put( "rio", "01100" ); // Read IO register to register
		opcodes.put( "sio", "01101" ); // Set IO register to register value
		opcodes.put( "sbr", "01110" ); // set r0 to byte value
		opcodes.put( "sri", "01111" ); // set ram address to byte V
		opcodes.put( "sra", "10000" ); // set ram address to reg V
		opcodes.put( "srvi", "10001" ); // set ram value to byte V
		opcodes.put( "srvr", "10010" ); // set ram value to register value
		opcodes.put( "rra", "10011" ); // read ram into OP_D
		opcodes.put( "and", "10100" ); // bitwise and
		opcodes.put( "addc", "10101" ); //add with carry
		opcodes.put( "cmp", "10110" ); //compare
		opcodes.put( "gpcl", "10111" ); //get PC low-bit
		opcodes.put( "gpch", "11000" ); //get PC high-bit
		opcodes.put( "spc", "11001" ); //set PC
	}

	private static void makeSyntax() {
		grammar = new Hashtable<String, operand[]>();
		grammar.put( "add", new operand[]{ operand.REG, operand.REG } );
		grammar.put( "sub", new operand[]{ operand.REG, operand.REG } );
		grammar.put( "nop", new operand[]{} );
		grammar.put( "sln", new operand[]{ operand.REG, operand.IMMEDIATE } );
		grammar.put( "shn", new operand[]{ operand.REG, operand.IMMEDIATE } );
		grammar.put( "res", new operand[]{ operand.REG } );
		grammar.put( "mov", new operand[]{ operand.REG, operand.REG } );
		grammar.put( "jmpa", new operand[]{ operand.BYTE } );
		grammar.put( "jmpp", new operand[]{ operand.BYTE } );
		grammar.put( "jmpn", new operand[]{ operand.BYTE } );
		grammar.put( "brnp", new operand[]{ operand.BYTE } );
		grammar.put( "brnn", new operand[]{ operand.BYTE } );
		grammar.put( "rio", new operand[]{ operand.REG, operand.REG } );
		grammar.put( "sio", new operand[]{ operand.REG, operand.REG } );
		grammar.put( "sbr", new operand[]{ operand.BYTE } );
		grammar.put( "sra", new operand[]{ operand.REG } );
		grammar.put( "sri", new operand[]{ operand.BYTE } );
		grammar.put( "srvi", new operand[]{ operand.BYTE } );
		grammar.put( "srvr", new operand[]{ operand.REG } );
		grammar.put( "rra", new operand[]{ operand.REG } );
		grammar.put( "and", new operand[]{ operand.REG, operand.REG } );
		grammar.put( "addc", new operand[]{ operand.REG, operand.REG } );
		grammar.put( "cmp", new operand[]{ operand.REG, operand.REG } );
		grammar.put( "gpcl", new operand[]{ operand.REG } );
		grammar.put( "gpch", new operand[]{ operand.REG } );
		grammar.put( "spc", new operand[]{ operand.REG, operand.REG } );
	}

	private static void dump( String filename ) {
		String init = "library IEEE;\n" +
				"use IEEE.std_logic_1164.all;\n" +
				"use IEEE.numeric_std.all;\n" +
				"entity rom is\n" +
				"port( clk : in std_logic;\n" +
				"addr : in std_logic_vector( 9 downto 0 );\n" +
				"do : out std_logic_vector( 12 downto 0 ) );\n" +
				"end rom;\n" +
				"architecture behavioural of rom is\n" +
				"signal addr_clkd : std_logic_vector( 9 downto 0 );\n" +
				"begin\n" +
				"process( CLK ) begin\n" +
				"if rising_edge( CLK ) then\n" +
				"addr_clkd <= addr;\n" +
				"end if;\n" +
				"end process;\n" +
				"with addr_clkd select\n" +
				"do <= ";

		String progcode = compile();

		String end = "\"0000000000000\" when others;\n" +
				"end behavioural;\n";

		writeFile( filename, init + progcode + end );
	}

	private static void processMarkers() {
		processedtext = "";
		Scanner lineScanner = new Scanner( programtext );

		while ( lineScanner.hasNext() ) {
			String line = lineScanner.nextLine();
			Scanner wordScanner = new Scanner( line );
			String firstWord = wordScanner.next();
			if ( ( firstWord.length() > 0 ) && ( firstWord.charAt( 0 ) == '[' ) ) {
				ram.put( 
						firstWord.split( "\\W" )[1], //gives us the first word (well... assuming exactly one non-word character)
						Integer.parseInt( line.split( "=" )[1].trim().split( "\\D" )[0] ) //gives the first int after a =
						);
			} else if ( firstWord.equals( ":" ) ) {
				markers.put( wordScanner.next(), markerline );
			} else {
				markerline += 1;
				processedtext += line;
				processedtext += "\n";
			}
			wordScanner.close();
		}
		// print all labels
		System.out.println(ram.toString());
		System.out.println(markers.toString());

		lineScanner.close();

		programtext = "";
		lineScanner = new Scanner( processedtext );
		markerline = 0;
		while ( lineScanner.hasNext() ) {
			String line = lineScanner.nextLine();
			Scanner wordScanner = new Scanner( line );
			String firstWord = wordScanner.next();
			if ( firstWord.equals( "sri" ) || firstWord.equals( "sbr" ) ) {
				String marker = wordScanner.next();
				if ( ( marker.length() > 0 ) && ( marker.charAt( 0 ) == '[' ) ) { // Has special stuff
					marker = marker.split( "\\W" )[1];
					programtext +=  firstWord + " " + ram.get( marker ) + "\n";
					markerline++;
					// if error, print where
					if ( ram.get( marker ) == null ) 
						System.out.println( line + ": " + marker + "\n" + firstWord + " " + ram.get( marker ) );
				} else { // treat as normal
					markerline++;
					programtext += line;
					programtext += "\n";
				}
			} else if ( firstWord.equals( "jmp" ) ) { //relative jump
				String marker = wordScanner.next();
				//try {
				int displacement = markers.get( marker ) - markerline;
				if ( displacement < 0 )
					programtext += "jmpn " + Math.abs(displacement) + "\n";
				else if ( displacement > 0 )
					programtext += "jmpp " + displacement + "\n";
				markerline++;
				/*} catch ( NullPointerException e ) {
					System.out.println(marker);
				throw e;
				}*/
			} else if ( firstWord.equals( "jmpa" ) ) { //absolute jump
				String marker = wordScanner.next();
				int displacement = markers.get( marker );
				programtext += "jmpa " + displacement + "\n";
				markerline++;
			} else if ( firstWord.equals( "brn" ) ) { //relative branch
				String marker = wordScanner.next();
				try {
					int displacement = markers.get( marker ) - markerline;
					if ( displacement < 0 )
						programtext += "brnn " + Math.abs(displacement) + "\n";
					else if ( displacement > 0 )
						programtext += "brnp " + displacement + "\n";
				} catch ( NullPointerException e ) {
					System.out.println( marker );
					throw e;
				}
				markerline++;
			} else {
				markerline++;
				programtext += line;
				programtext += "\n";
			}
			wordScanner.close();
		}
		lineScanner.close();

	}

	private static String compile() {
		String romcode = "";
		int lineCounter = 0;
		Scanner lineScanner = new Scanner( programtext );
		while( lineScanner.hasNextLine() ) {
			String line = lineScanner.nextLine();
			System.out.printf( "%04d: %s\n", lineCounter, line );
			lineCounter++;
			Scanner wordScanner = new Scanner( line );
			String opc = wordScanner.next();
			if ( opc.equals( "nop" ) ) {
				romcode += addLine( opc, 0 );
				continue;
			}
			operand[] operands = grammar.get( opc );
			String op1 = "";
			String op2 = "";

			for( int i = 0; i < operands.length; i++ ) {
				if ( i == 0 ) 
					op1 = wordScanner.next();
				else if ( i == 1 )
					op2 = wordScanner.next();

			}

			if ( operands[ 0 ] == operand.IMMEDIATE )
				romcode += addLine( opc, toNumber( op1 ) );
			else if ( operands[ 0 ] == operand.BYTE )
				romcode += addLine( opc, toNumber( op1 ) );
			else if (operands.length == 1 &&
					operands[ 0 ] == operand.REG )
				romcode += addLine( opc, op1 );
			else if( operands[ 0 ] == operand.REG &&
					( operands[ 1 ] == operand.IMMEDIATE ||
					operands[ 1] == operand.BYTE ) )
				romcode += addLine( opc, op1, toNumber( op2 ) );
			else if( operands[ 0 ] == operand.REG &&
					operands[ 1 ] == operand.REG )
				romcode += addLine( opc, op1, op2 );

			wordScanner.close();
		}
		lineScanner.close();

		return romcode;

	}

	private static String addLine( String opc, String rd, String rs ) {
		String line = "\"";
		line += opcodes.get( opc );
		line += registers.get( rd );
		line += registers.get( rs );
		line += "\" WHEN \"" + toBinary( lineCounter, 10 ) + "\",\n";
		lineCounter++;
		return line;
	}

	private static String addLine( String opc, String rd ) {
		String line = "\"";
		line += opcodes.get( opc );
		line += registers.get( rd );
		line += "0000";
		line += "\" WHEN \"" + toBinary( lineCounter, 10 ) + "\",\n";
		lineCounter++;
		return line;
	}

	private static String addLine( String opc, int K ) {
		String line = "\"";
		line += opcodes.get( opc );
		line += toBinary( K, 8 );
		line += "\" WHEN ";
		line += "\"" + toBinary( lineCounter, 10 ) + "\",";
		line += "\n";
		lineCounter++;
		return line;
	}

	private static String addLine( String opc, String rd, int K ) {
		String line = "\"";
		line += opcodes.get( opc );
		line += registers.get( rd );
		line += toBinary( K, 4 );
		line += "\" WHEN ";
		line += "\"" + toBinary( lineCounter, 10 ) + "\",";
		line += "\n";
		lineCounter++;
		return line;
	}

	private static int toNumber( String number ) {
		if ( number.length() == 1 && number.charAt( 0 ) == '0' )
			return Integer.parseInt( number );
		else if ( number.charAt( 0 ) == '0' && number.charAt( 1 ) == 'x' )
			return Integer.parseInt( number.substring( 2, number.length() ), 16 );
		else
			return Integer.parseInt( number );

	}

	private static String toBinary( int number, int size ) {
		String binary = Integer.toBinaryString( number );

		while( binary.length() < size ) 
			binary = "0" + binary;

		return binary;
	}

	private static String readFile( String filename ) {
		String text = "";
		try {
			Scanner lineScanner = new Scanner( new File( filename ) );

			while( lineScanner.hasNextLine() ) {
				String line = lineScanner.nextLine();
				Scanner commentScanner = new Scanner( line );
				if ( !commentScanner.hasNext() )
					continue;
				String firstWord = commentScanner.next();
				if ( !firstWord.equals( ";" ) ) {
					text += line;
					text += "\n";
					commentScanner.close();
				} else {
					commentScanner.close();
					continue;
				}
			}
			text = text.replace( ",", "" );
			lineScanner.close();
		}
		catch( FileNotFoundException ex ) {

		}
		return text;
	}

	private static void writeFile( String filename, String writestring ) {
		try{
			FileWriter fstream = new FileWriter( filename );
			BufferedWriter out = new BufferedWriter( fstream );
			out.write( writestring );
			out.close();
		} catch( Exception e ) {
		}

	}
}

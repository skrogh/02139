import java.util.*;
import java.io.*;

public class Assembler {

    private static int lineCounter = 0;
    private static Hashtable<String, String> registers;
    private static Hashtable<String, String> opcodes;
    private enum operand { REG, IMMEDIATE, BYTE }
    private static Hashtable<String, operand[]> grammar;
    private static String programtext;

    public static void main( String args[] ) {
        programtext = readFile( args[ 0 ] );
        makeRegisters();
        makeOpcodes();
        makeSyntax();
        dump( args[1] );
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
    }

    private static void dump( String filename ) {
        String init = "library IEEE;\n" +
            "use IEEE.std_logic_1164.all;\n" +
            "use IEEE.numeric_std.all;\n" +
            "entity rom is\n" +
            "port( addr : in std_logic_vector( 9 downto 0 );\n" +
            "do : out std_logic_vector( 12 downto 0 ) );\n" +
            "end rom;\n" +
            "architecture behavioural of rom is\n" +
            "begin\n" +
            "with addr select\n" +
            "do <= ";

        String progcode = compile();

        String end = "\"0000000000000\" when others;\n" +
            "end behavioural;\n";

        writeFile( filename, init + progcode + end );
    }

    private static String compile() {
        String romcode = "";

        Scanner lineScanner = new Scanner( programtext );
        while( lineScanner.hasNextLine() ) {
            String line = lineScanner.nextLine();
            System.out.println( line );
            Scanner wordScanner = new Scanner( line );
            String opc = wordScanner.next();
            if ( opc.equals( "nop" ) ) {
                addLine( opc, 0 );
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
                text += lineScanner.nextLine();
                text += "\n";
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

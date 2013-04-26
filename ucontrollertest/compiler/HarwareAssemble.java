
public class HarwareAssemble {
	
	static String code = "";
	static int counter = 0;
	
	
	public static String[] reg = new String[16];
	public static String[] regR = new String[16];
	
	public static String[] operations = {
		"nop", "add", "sub", "sln", "shn", "res", "mov", "jmpa", "brnp", "brnn"
	};
	public static String[] operationsR = {
		"00000", "00001", "00010", "00011", "00100", "00101", "00110", "00111", "01000", "01001"
	};
		
	public static void main( String[] args ) {
		// set register enums
		for ( int i = 0; i < reg.length; i++ ) {
			reg[i] = "r" + i;
		}
		for ( int i = 0; i < reg.length; i++ ) {
			regR[i] = Integer.toBinaryString( i );
			while (regR[i].length() < 4 )
				regR[i] = "0" + regR[i];
		}
		addLine( "sln", "r0", 0xF ); // counter register LSM
		addLine( "shn", "r0", 0xF ); // MSB
		
		addLine( "sln", "r2", 0x1 ); // compare register LSM
		addLine( "shn", "r2", 0x0 ); // MSB
	
		addLine( "mov", "r1", "r0" ); // move for comparison
		addLine( "sub", "r1", "r2" ); // compare
		addLine( "brnp", 3 ); // jump two lines if r0 = 0
		addLine( "sub", "r0", "r2" ); // subtract 1 from r0
		addLine( "jmpa", 4 ); // jump to line 4
			//dummy finish code
		addLine( "sln", "r2", 0xA ); // compare register LSM
		addLine( "shn", "r2", 0xA ); // MSB
		
		
		
		
		//Print result
		System.out.println( code );
	}
	
	public static void addLine( String op, String rD, String rS ) {
		String original = op + " " + rD + " " + rS;
		for ( int i = 0; i < operations.length; i++ ) {
			op = op.replace( operations[i], operationsR[i] );
		}
		for ( int i = 0; i < reg.length; i++ ) {
			rD = rD.replace( reg[i], regR[i] );
			rS = rS.replace( reg[i], regR[i] );
		}
		addLine(  op + rD + rS, original );
	}
	
	public static void addLine( String op, String rD, int k ) {
		String original = op + " " + rD + " " + k;
		for ( int i = 0; i < operations.length; i++ ) {
			op = op.replace( operations[i], operationsR[i] );
		}
		for ( int i = 0; i < reg.length; i++ ) {
			rD = rD.replace( reg[i], regR[i] );
		}
		String opa = Integer.toBinaryString( k );
		while (opa.length() < 4 )
			opa = "0" + opa;
		addLine(  op + rD + opa, original );
	}
	
	public static void addLine( String op, int K ) {
		String original = op + " " + K;
		for ( int i = 0; i < operations.length; i++ ) {
			op = op.replace( operations[i], operationsR[i] );
		}
		String opa = Integer.toBinaryString( K );
		while (opa.length() < 8 )
			opa = "0" + opa;
		addLine( op + opa, original );
	}
	
	public static void addLine( String all ) {
		String original = all;
		all = all.replace( " ", "");
		all = all.replace( ",", "");
		all = all.replace( ";", "");
		all = all.replace( "|", "");
		addLine( all, original );
	}
	public static void addLine( String all, String original ) {
		for ( int i = 0; i < reg.length; i++ ) {
			all = all.replace( reg[i], regR[i] );
		}
		for ( int i = 0; i < operations.length; i++ ) {
			all = all.replace( operations[i], operationsR[i] );
		}
		String count = Integer.toBinaryString( counter++ );
		while (count.length() < 10 )
			count = "0" + count;
		code += "\"" + all + "\" when \"" + count + "\",\t--" + original + "\n";
	}
	
}

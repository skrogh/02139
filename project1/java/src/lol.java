
public class lol {

	
	public static void main(String[] args) {
		for ( int i = 0; i < 256; i++ ) {
			System.out.println( "\"" + toBinary((int)(Math.random() * 8192)) + "\" " + "WHEN " + "\"" + toBinary10(i) + "\",");
		}
		
		System.out.println(toBinary(16));
		
	}
	
	public static String toBinary( int num ) {
		
		String out = "";
		while( num != 0 ) {
			out = out + num % 2;
			num /= 2;
		}
		
		for( int i = 0; i < 13; i++ ) {
			i = out.length();
			if(i>=13)
				break;
			out = out + "0";
		}
		
		return new StringBuffer(out).reverse().toString();
	}
	
public static String toBinary10( int num ) {
		
		String out = "";
		while( num != 0 ) {
			out = out + num % 2;
			num /= 2;
		}
		
		for( int i = 0; i < 10; i++ ) {
			i = out.length();
			if(i>=10)
				break;
			out = out + "0";
		}
		
		return new StringBuffer(out).reverse().toString();
	}
	
	public static String toBCD( int num ) {

		String out = "";
		while( num != 0 ) {
			out = out + num % 2;
			num /= 2;
		}
		for( int i = 0; i < 4; i++ ) {
			i = out.length();
			if(i>=4)
				break;
			out = out + "0";
		}
		
		return new StringBuffer(out).reverse().toString();
	}

}

import java.util.*;

public class Test {
    private static Scanner test;
    public static void main( String args[] ) {
        String testline = "add r0 r2\n lol";
        test = new Scanner( testline );
        System.out.println( test.nextLine() + test.nextLine() );
        System.out.println( test.next() );
        System.out.println( test.next() );
    }
}

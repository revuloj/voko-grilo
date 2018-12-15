package de.steloj;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import java.io.StringReader;
import java.io.StringWriter;

/**
 * Unit test for simple App.
 */
public class RngKontroloTest 
    extends TestCase
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public RngKontroloTest( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( RngKontroloTest.class );
    }


    /**
     * Was rncFile found in resources?
     */
    public void testRncFile() {
        assertNotNull(new RngKontrolo().getRncFile());
    }

    /**
     * Test RelaxNG check :-)
     */
    public void testRngKontrolo()
    {
        RngKontrolo rng = new RngKontrolo();
        StringReader reader = new StringReader("<?xml version=\"1.0\"?><vortaro>"+
            "<art><kap>test</kap><drv><kap><tld/>o</kap><dif>Test</dif></drv></art></vortaro>");
        StringWriter writer = new StringWriter();
        try {
            rng.relaxng(reader,writer);
            System.out.println(writer.toString());
            assertTrue( true );
        } catch (Exception E) {
            E.printStackTrace(System.out);
            fail(E.toString());
        }
    }
}

package de.steloj;

// https://www.eclipse.org/jetty/documentation/current/maven-and-jetty.html#jetty-maven-helloworld
// https://github.com/relaxng/

import org.eclipse.jetty.server.Server;

import java.io.IOException;
import java.io.StringWriter;
import java.io.StringReader;

import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.AbstractHandler;

//import com.thaiopensource.relaxng.util.Driver;
import com.thaiopensource.xml.sax.ErrorHandlerImpl;
import org.xml.sax.InputSource;
import com.thaiopensource.util.PropertyMapBuilder;
import com.thaiopensource.util.PropertyMap;
import com.thaiopensource.validate.ValidateProperty;
import com.thaiopensource.validate.rng.CompactSchemaReader;
import com.thaiopensource.validate.ValidationDriver;
import com.thaiopensource.validate.SchemaReader;

/**
 * Starting the Jetty server.
 */
public class RngKontrolo extends AbstractHandler
{
    URL rncFile = this.getClass().getResource("/resources/vokoxml.rnc");

    public RngKontrolo() {
        super();
        //rncFile = this.getClass().getResource("/resources/vokoxml.rnc")
    }


    @Override
    public void handle( String target,
                        Request baseRequest,
                        HttpServletRequest request,
                        HttpServletResponse response ) throws IOException,
                                                      ServletException
    {
        // Declare response encoding and types
        response.setContentType("text/html; charset=utf-8");

        // Declare response status code
        response.setStatus(HttpServletResponse.SC_OK);

        // Write back response
        response.getWriter().println("<h1>Saluton!</h1>");

        // Inform jetty that this request has now been handled
        baseRequest.setHandled(true);
    }

    public String relaxng(String Xml) {

        // error handler / out string writer
        StringWriter writer = new StringWriter();
        PropertyMapBuilder propertyMapBuilder = new PropertyMapBuilder();
        propertyMapBuilder.put(ValidateProperty.ERROR_HANDLER, new ErrorHandlerImpl(writer));
        PropertyMap propertyMap = propertyMapBuilder.toPropertyMap();

        // prepare valditor / load schema
        SchemaReader schemaReader = CompactSchemaReader.getInstance();
        ValidationDriver driver = new ValidationDriver(propertyMap,schemaReader);
        InputSource rncIn = driver.uriOrFileInputSource(rncFile.toString());
        if (driver.loadSchema(rncIn)) {
            // XML fonto    
            StringReader reader = new StringReader(Xml);
            InputSource xmlIn = new InputSource(reader);
            
            // validigu
            driver.validate(xmlIn);
            return writer.toString();
        } else {
            return null;
        }
        
    }

/*
rng_exception(Exc,Text) :-
    jpl_call(Exc, toString, [], Text).


sax_exception(Exc,'org.xml.sax.SAXParseException',
             Line,Col,Msg) :-
    jpl_call(Exc, getLineNumber, [], Line),
    jpl_call(Exc, getColumnNumber, [], Col),
    jpl_call(Exc, getMessage, [], Msg).

error_list_json([Line:Pos-Msg|More],[json([line=Line,pos=Pos,msg=Msg])|MoreJson]) :-
    error_list_json(More,MoreJson).

*/


    public static void main( String[] args ) throws Exception
    {
        System.out.println("CLASSPATH:"+System.getProperty("java.class.path"));
        Server server = new Server(8787);
        server.setHandler(new RngKontrolo());
        server.start();
        //server.dumpStdErr();
        server.join();
    }
}
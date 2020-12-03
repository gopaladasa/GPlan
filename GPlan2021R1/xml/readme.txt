Command Line Transformations Using msxsl.exe


Until now, there has been no off-the-shelf way to perform command line Extensible Stylesheet Language (XSL) transformations using the Microsoft® XSL processor. MSXSL is a command line utility of less than 16 kilobytes (KB) that invokes msxml3.dll to perform the transformation.


Requirements

Because MSXSL is only a wrapper, msxml3.dll must be installed on the computer. You can download msxml3.dll from http://msdn.microsoft.com/xml).

Note   Microsoft Internet Explorer 5.0, Internet Explorer 5.5 and Microsoft Windows® 2000 released msxml.dll. This version is not recent enough to be used with MSXSL.

MSXSL has been tested on Microsoft Windows NT, Windows 2000, Windows 98, and Windows 95.


Use

The use of MSXSL is as follows. Individual options can appear anywhere.
MSXSL source stylesheet [options] [param=value...] [xmlns:prefix=uri...]
Options

-?	Show this message.
-o filename	Write output to named file.
-m startMode	Start the transformation in this mode.
-xw	Strip nonsignificant white space from the source and style sheet.
-xe	Do not resolve external definitions during parse phase.
-v	Validate documents during parse phase.
-t	Show load and transformation timings.
-	Dash used as source argument loads XML from stdin.
-	Dash used as style sheet argument loads XSL from stdin.

To transform an input file called books.xml using a style sheet named format.xsl, execute the following command.

MSXSL books.xml format.xsl –o out.xml

Arguments are separated by white space. Single or double quotes can be used if the arguments themselves must contain white space.

MSXSL –o out.xml “c:\my documents\books.xml” format.xsl my-param=’”Quote”’


Parameters

XSL Transformations (XSLT) enable applications to pass parameters to style sheets. Parameters are used to modify the behavior of a style sheet without requiring any code changes to that style sheet. Although the Microsoft XML Parser 3.0 (MSXML) allows parameters of any XSLT type to be passed to the style sheet, MSXSL allows only strings. Parameters are specified using a list of name-value pairs following the source and style sheet arguments.

MSXSL –o out.xml books.xml format.xsl p1=Microsoft p2=’XSL Transformations’

Any number of parameters can be specified, as long as white space separates a parameter value from the next parameter name. Parameter names must conform to the XML QName syntax, with an optional prefix separated from a local name by a colon character.

MSXSL books.xml format.xsl my-ns:param=’XPath 1.0’ xmlns:my-ns=’urn:my’

If a prefix is specified, it must be defined in a namespace declaration elsewhere on the command line. The prefix cannot be “xmlns” because this identifies a namespace declaration.


Namespace Declarations

Parameter names and the start mode name can contain a prefix part. This prefix is a convenience alias for a namespace Uniform Resource Identifier (URI) that fully qualifies the name. A namespace declaration associates the prefix with a corresponding URI using a syntax that loosely follows that of an XML namespace declaration. (Quotes are optional and prefixes can contain almost any character.) The namespace declaration begins with “xmlns:”, is followed by the prefix being defined, and ends with the URI to which the prefix is bound.

MSXSL books.xml format.xsl my-ns:p1=’Microsoft’ _
  xmlns:my-ns=”http://my.com”

Namespace declarations need not appear before they are used; names are resolved after the entire command line has been parsed. If the same prefix is defined multiple times, the last definition takes precedence.

The default namespace declaration “xmlns” can be used to associate a URI with all names that do not have a prefix part.

MSXSL books.xml format.xsl p1=’Microsoft’ xmlns=”http://my.com”

In this example, parameter p1 will be qualified with the http://my.com URI even though no prefix is used. Thus, this command line is equivalent to the previous command line that explicitly uses the my-ns prefix.

Start Mode (-m Option)

XSLT execution proceeds within a current mode that is identified by a unique qualified name (Qname). When applying template rules, only templates that are associated with this mode can be considered possible matches. By default, template rules are grouped within the empty mode. However, they can be explicitly grouped within another mode by specifying the mode attribute on the xsl:template element.

Although style sheet execution usually begins in the empty mode, this default can be changed by using the –m option to specify another mode. Changing the start mode allows execution to jump directly to an alternate group of templates.

MSXSL books.xml mode.xsl –m my-ns:modeA xmlns:my-ns=”http://my.com”

If, as in the example, the start mode QName contains both a prefix and a local name, the prefix must be defined in a namespace declaration elsewhere on the command line.

External Resolution (-xe Option)

By default, MSXSL instructs the parser to resolve external definitions such as document type definition (DTD) external subsets or external entity references when parsing the source and style sheet documents. The –xe option can be specified to disable this behavior (resolveExternals set to False). This setting will not affect the resolution of external documents referenced by the XSLT include or import elements or the XSLT document() function.

Document Validation (-v Option)

By default, MSXSL turns off document validation. If either the source or style sheet document has a DTD or schema whose content should be checked, the -v option can be specified to turn on validation by setting validateOnParse to True on the Document Object Model (DOM).

White Space Stripping (-xw Option)

The –xw option instructs MSXSL to strip nonsignificant white space from the input XML document during the load phase by setting preserveWhitespace to False on the DOM. Enabling this option can lower memory usage and improve transformation performance while, in most cases, creating equivalent output.

Timings (-t Option)

The relative speed of various transformations can be easily measured by using the –t option. MSXSL will track the performance of the following transformation steps.
•	Time to load, parse, and build the DOM for the input document.
•	Time to load, parse, and build the DOM for the style sheet document.
•	Time to compile the style sheet in preparation for the transformation.
•	Time to execute the style sheet.

Redirection

If the –o option is not specified on the command line, MSXSL will send the raw output bytes to stdout. This means that the following command will dump the result of the transformation directly to the console window.

MSXSL books.xml format.xsl

Be aware that if the xsl:output encoding attribute is set to an encoding that does not match the code page of the console window, strange output may result.

Stdout can be redirected from the command line using the usual mechanisms.

MSXSL books.xml format.xsl > out.xml
MSXSL books.xml format.xsl | more

A single dash character, '-', can be substituted for either the source or style sheet argument. This instructs MSXSL to load the source or style sheet document from stdin rather than from a URL.

MSXSL books.xml format.xsl | MSXSL – toUTF8.xsl

In this example, a formatted books.xml is piped to an identity transformation that converts it to UTF 8 for console display. Linking transformations together like this avoids intermediate file generation.

Errors and timing information are sent to stderr, which can be redirected in Windows NT. This does not work in Windows 95 and Windows 98.

MSXSL books.xml format.xsl > out.xml 2> err.txt

Source Code

The source code to msxsl.exe can be downloaded from the XML site. The sources were originally compiled using Microsoft Visual C++® 6.0. By default, the makefile will create a debug version of msxsl.exe, which includes debug information, unoptimized code, and asserts. To create a retail (release) build, invoke the makefile as follows.

nmake clean cfg=retail

The LIB and INCLUDE environment variables should be set to reference the lib and include directories of Visual C++, as follows.

SET LIB=c:\program files\Microsoft visual studio\vc98\lib
SET INCLUDE=c:\program files\Microsoft visual studio\vc98\include

A small suite of tests can also be built by invoking nmake in the test subdirectory. To run the tests, execute test.exe. Some tests must be verified by inspecting the console window output.

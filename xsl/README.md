This directory contains the XSL transform file to convert UDUNITS xml files into readable HTML.

Brief notes from my email to Steve Emmerson, who has a copy:

I ran it against my own copy of the UDUNITS package using xsltproc, a tool I apparently installed on my OS X machine with anaconda. With luck any XSLT transform engine will work.

    xsltproc udunits2_to_html.xslt /opt/local/share/udunits/udunits2-accepted.xml > udunit2-accepted.html
    xsltproc udunits2_to_html.xslt /opt/local/share/udunits/udunits2-base.xml > udunit2-base.html
    xsltproc udunits2_to_html.xslt /opt/local/share/udunits/udunits2-common.xml > udunit2-common.html
    xsltproc udunits2_to_html.xslt /opt/local/share/udunits/udunits2-derived.xml > udunit2-derived.html
    xsltproc udunits2_to_html.xslt /opt/local/share/udunits/udunits2-prefixes.xml > udunit2-prefixes.html

The HTML files that result are attached below.

You can also run this against the online UDUNITS files. For example the last command could be run as 
    xsltproc udunits2_to_html.xslt http://www.unidata.ucar.edu/software/udunits/udunits-current/udunits/udunits2-prefixes.xml > udunit2-prefixes.html
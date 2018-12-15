# voko-grilo
Servo, kiu kontrolas XML-dosieron laŭ RelaxNG-skemo

Tiu servo uzas la programon Jing de Jing-Trang por kontroli artikolon 
de Reta Vortaro laŭ struktur-difino vokoxml.rnc. La gramatik-lingvo uzata
estas RelaxNG, kiu ebligas pli striktan kontrolon ol nura DTD, sed estas
pli taŭga por nia celo ol XmlSchema.

Cele al restrukturado de la Revo-redaktilo en servetojn (angle Microservices)
kaj ligite kun tio dismeto de Prologaj kaj Javaj partoj de la kodo, ni
kreas jen retservon enpakeblan en "keston" (anlge: Docker container).
Por servi laŭ protokolo HTTP, Jetty estas uzata.

Retan Vortaron vi trovas ĉe http://retavortaro.de

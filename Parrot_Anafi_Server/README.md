# Parrot_Anafi_Service

To run move to Parrot_Anafi_Service directory and type java-jar Parrot_Anafi_Server-0.0.1-SNAPSHOT.jar

Requirements:
<ul>
    <li>java 11</li>
    <li>free 8080 port</li>
</ul>

Server handles basic operations such as displaying battery charge, altitude, connection and gps live coordinates available at aftermentioned endpoints:
<ul>
    <li> /api/battery</li>
    <li> /api/altitude</li>
    <li> /api/connection</li>
    <li> /api/gpslocation</li>
</ul>

Note: </br>
Just GET and POST methods are currently properly implemented.
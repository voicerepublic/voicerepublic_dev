#!/bin/sh

cat <<EOF
<icecast>
    <limits>
        <clients>100</clients>
        <sources>$ICECAST_LIMIT_SOURCES</sources>
        <threadpool>5</threadpool>
        <queue-size>524288</queue-size>
        <client-timeout>30</client-timeout>
        <header-timeout>15</header-timeout>
        <source-timeout>10</source-timeout>
        <!-- If enabled, this will provide a burst of data when a client
             first connects, thereby significantly reducing the startup
             time for listeners that do substantial buffering. However,
             it also significantly increases latency between the source
             client and listening client.  For low-latency setups, you
             might want to disable this. -->
        <burst-on-connect>1</burst-on-connect>
        <!-- same as burst-on-connect, but this allows for being more
             specific on how much to burst. Most people won't need to
             change from the default 64k. Applies to all mountpoints  -->
        <burst-size>65535</burst-size>
    </limits>

    <authentication>
        <!-- Sources log in with username 'source' -->
        <source-password>$ICECAST_SOURCE_PASSWORD</source-password>
        <!-- Relays log in username 'relay' -->
        <relay-password>$ICECAST_RELAY_PASSWORD</relay-password>

        <!-- Admin logs in with the username given below -->
        <admin-user>$ICECAST_ADMIN_USER</admin-user>
        <admin-password>$ICECAST_ADMIN_PASSWORD</admin-password>
    </authentication>

    <!-- set the mountpoint for a shoutcast source to use, the default if not
         specified is /stream but you can change it here if an alternative is
         wanted or an extension is required
    <shoutcast-mount>/live.nsv</shoutcast-mount>
    -->

    <!-- Uncomment this if you want directory listings -->
    <!--
    <directory>
        <yp-url-timeout>15</yp-url-timeout>
        <yp-url>http://dir.xiph.org/cgi-bin/yp-cgi</yp-url>
    </directory>
     -->

    <!-- This is the hostname other people will use to connect to your server.
    It affects mainly the urls generated by Icecast for playlists and yp
    listings. -->
    <hostname>localhost</hostname>

    <!-- You may have multiple <listener> elements -->
    <listen-socket>
        <port>8000</port>
        <!-- <bind-address>127.0.0.1</bind-address> -->
        <!-- <shoutcast-mount>/stream</shoutcast-mount> -->
        <ssl>1</ssl>
    </listen-socket>
    <!--
    <listen-socket>
        <port>8001</port>
    </listen-socket>
    -->

    <!--<master-server>127.0.0.1</master-server>-->
    <!--<master-server-port>8001</master-server-port>-->
    <!--<master-update-interval>120</master-update-interval>-->
    <!--<master-password>hackme</master-password>-->

    <!-- setting this makes all relays on-demand unless overridden, this is
         useful for master relays which do not have <relay> definitions here.
         The default is 0 -->
    <!--<relays-on-demand>1</relays-on-demand>-->

    <!--
    <relay>
        <server>127.0.0.1</server>
        <port>8001</port>
        <mount>/example.ogg</mount>
        <local-mount>/different.ogg</local-mount>
        <on-demand>0</on-demand>

        <relay-shoutcast-metadata>0</relay-shoutcast-metadata>
    </relay>
    -->

    <!-- Only define a <mount> section if you want to use advanced options,
         like alternative usernames or passwords
    <mount>
        <mount-name>/example-complex.ogg</mount-name>

        <username>othersource</username>
        <password>hackmemore</password>

        <max-listeners>1</max-listeners>
        <dump-file>/tmp/dump-example1.ogg</dump-file>
        <burst-size>65536</burst-size>
        <fallback-mount>/example2.ogg</fallback-mount>
        <fallback-override>1</fallback-override>
        <fallback-when-full>1</fallback-when-full>
        <intro>/example_intro.ogg</intro>
        <hidden>1</hidden>
        <no-yp>1</no-yp>
        <authentication type="htpasswd">
                <option name="filename" value="myauth"/>
                <option name="allow_duplicate_users" value="0"/>
        </authentication>
        <on-connect>/connected.sh</on-connect>
        <on-disconnect>/disconnected.sh</on-disconnect>
    </mount>
    -->

    <mount>
      <mount-name>/live.ogg</mount-name>
      <dump-file>/share/dump_%s.ogg</dump-file>
      <on-connect>/share/stream-start</on-connect>
      <on-disconnect>/share/stream-stop</on-disconnect>
      <public>0</public>
      <!--<authentication type="url">
        <option name="mount_add"    value="http://localhost:3000/ice/auth"/>
        <option name="mount_remove" value="http://localhost:3000/ice/auth"/>
        <option name="stream_auth"  value="http://localhost:3000/ice/auth"/>
        </authentication>
        -->
    </mount>

    <mount type='default'>
      <dump-file>/share/dump_%s</dump-file>
      <on-connect>/connected.sh</on-connect>
      <on-disconnect>/disconnected.sh</on-disconnect>
      <public>0</public>
    </mount>

    <http-headers>
      <header name="Access-Control-Allow-Origin" value="*" />
      <header name="X-Robots-Tag" value="noindex, nofollow, noarchive" />
    </http-headers>

    <fileserve>1</fileserve>

    <paths>
		<!-- basedir is only used if chroot is enabled -->
        <basedir>/usr/share/icecast2</basedir>

        <!-- Note that if <chroot> is turned on below, these paths must both
             be relative to the new root, not the original root -->
        <logdir>/share</logdir>
        <webroot>/usr/share/icecast2/web</webroot>
        <adminroot>/usr/share/icecast2/admin</adminroot>
        <!-- <pidfile>/usr/share/icecast2/icecast.pid</pidfile> -->

        <!-- Aliases: treat requests for 'source' path as being for 'dest' path
             May be made specific to a port or bound address using the "port"
             and "bind-address" attributes.
          -->
        <!--
        <alias source="/foo" dest="/bar"/>
          -->
        <!-- Aliases: can also be used for simple redirections as well,
             this example will redirect all requests for http://server:port/ to
             the status page
          -->
        <!--<alias source="/" dest="/status.xsl"/>-->
        <alias source="/" dest="/redirect.html"/>

        <ssl-certificate>/share/icecast.key</ssl-certificate>
    </paths>

    <logging>
        <accesslog>access.log</accesslog>
        <errorlog>error.log</errorlog>
        <!-- <playlistlog>playlist.log</playlistlog> -->
      	<loglevel>4</loglevel> <!-- 4 Debug, 3 Info, 2 Warn, 1 Error -->
      	<logsize>10000</logsize> <!-- Max size of a logfile -->
        <!-- If logarchive is enabled (1), then when logsize is reached
             the logfile will be moved to [error|access|playlist].log.DATESTAMP,
             otherwise it will be moved to [error|access|playlist].log.old.
             Default is non-archive mode (i.e. overwrite)
        -->
        <!-- <logarchive>1</logarchive> -->
    </logging>

    <security>
        <chroot>0</chroot>
        <!--
        <changeowner>
            <user>nobody</user>
            <group>nogroup</group>
        </changeowner>
        -->
    </security>
</icecast>
EOF

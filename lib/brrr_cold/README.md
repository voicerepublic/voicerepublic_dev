Docker container running Icecast2
=================================

    docker build -t branch14/icecast2 .

    docker run --name icecast -p 8000 branch14/icecast2

    docker start icecast

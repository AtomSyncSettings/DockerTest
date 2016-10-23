# DockerTest
An example use of docker

How to set up very quickly:

1. Download and install docker: https://docs.docker.com/engine/installation/ (This is probably the hardest part)
2. Download this git repo, either use:

<code> git clone https://github.com/AtomSyncSettings/DockerTest.git </code>

or [download the zip](https://github.com/AtomSyncSettings/DockerTest/archive/master.zip) & extract it

3. cd to the folder you just extracted and run:

<code> docker build . -t elastixtest/test </code> 


4. You're done! To use the new installation just run:

<code> docker run -it elastixtest/test </code>

And you are logged in with a working elastix and ITK installation!

Try it out by now running:
    
<code> elastix --help </code>

And it should give the elastix help!

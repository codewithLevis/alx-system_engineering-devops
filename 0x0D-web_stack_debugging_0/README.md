# Web stack debugging #0

## Concepts
For this project, we expect you to look at these concepts:

### Network basics
Networking is a big part of what made computers so powerful and why the Internet exists. It allows machines to communicate with each other.
- [What is a protocol](https://www.techtarget.com/searchnetworking/definition/protocol)
- [What is an IP address](https://computer.howstuffworks.com/internet/basics/what-is-an-ip-address.htm)
- [What is TCP/IP](https://www.avast.com/c-what-is-tcp-ip#)
- [What is an Internet Protocol (IP) port?](https://www.lifewire.com/port-numbers-on-computer-networks-817939)

### Docker
#### Readme
- [What is Docker and why is it popular?](https://www.zdnet.com/article/what-is-docker-and-why-is-it-so-darn-popular/)
_Take note: The following instructions are run in a ubuntu-xenial virtual machine setup using Vagrant. To do the same, you can also install docker in any Vagrant virtual machine, or install docker on your host OS (Windows, Linux or Mac OS)_

Let’s first pull a Docker image and run a container:

```
vagrant@ubuntu-xenial:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
vagrant@ubuntu-xenial:~$ docker run -d -ti ubuntu:16.04
Unable to find image 'ubuntu:16.04' locally
16.04: Pulling from library/ubuntu
34667c7e4631: Pull complete
d18d76a881a4: Pull complete
119c7358fbfc: Pull complete
2aaf13f3eff0: Pull complete
Digest: sha256:58d0da8bc2f434983c6ca4713b08be00ff5586eb5cdff47bcde4b2e88fd40f88
Status: Downloaded newer image for ubuntu:16.04
e1fc0d4bbb5d3513b8f7666c91932812da7640346f6e05b7cfc3130ddbbb8278
vagrant@ubuntu-xenial:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
e1fc0d4bbb5d        ubuntu:16.04        "/bin/bash"         About a minute ago   Up About a minute                       keen_blackwell
vagrant@ubuntu-xenial:~$
Note that docker command will pull the Ubuntu docker container image from the Internet and run it. I let you look at the meaning of the flags using the command docker run --help, the main idea is that it keeps the container up and running.

To execute a command on the Docker container, use docker exec:

vagrant@ubuntu-xenial:~$ docker exec -i e1fc0d4bbb5d hostname
e1fc0d4bbb5d
vagrant@ubuntu-xenial:~$ hostname
ubuntu-xenial
vagrant@ubuntu-xenial:~$
```

If you want to connect to your Docker container and use Bash, you need to use `docker exec -ti`:
```
vagrant@ubuntu-xenial:~$ docker exec -ti e1fc0d4bbb5d /bin/bash
root@e1fc0d4bbb5d:/# echo "I am in $(hostname) Docker container"
I am in e1fc0d4bbb5d Docker container
root@e1fc0d4bbb5d:/# exit
exit
vagrant@ubuntu-xenial:~$
```
If you want to stop a container, use `docker stop`:

```
vagrant@ubuntu-xenial:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
e1fc0d4bbb5d        ubuntu:16.04        "/bin/bash"         5 minutes ago       Up 5 minutes                            keen_blackwell
vagrant@ubuntu-xenial:~$ docker stop e1fc0d4bbb5d
e1fc0d4bbb5d
vagrant@ubuntu-xenial:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
vagrant@ubuntu-xenial:~$
```

### Web stack debugging
#### Intro
Debugging usually takes a big chunk of a software engineer’s time. The art of debugging is tough and it takes years, even decades to master, and that is why seasoned software engineers are the best at it… experience. They have seen lots of broken code, buggy systems, weird edge cases and race conditions.

![img](https://s3.amazonaws.com/alx-intranet.hbtn.io/uploads/medias/2020/9/45dffb0b1da8dc2ce47e340d7f88b05652c0f486.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIARDDGGGOUSBVO6H7D%2F20230828%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230828T063037Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=ea1a82a0dcef232eacf9baa22f2b8f48c73f4a4882907419e146f3f21d8d6c1f)

#### Non-exhaustive guide to debugging
##### School specific
If you are struggling to get something right that is run on the checker, like a Bash script or a piece of code, keep in mind that you can simulate the flow by starting a Docker container with the distribution that is specified in the requirements and by running your code. Check the **Docker** concept page for more info.

##### Test and verify your assumptions
The idea is to ask a set of questions until you find the issue. For example, if you installed a web server and it isn’t serving a page when browsing the IP, here are some questions you can ask yourself to start debugging:
- Is the web server started? - You can check using the service manager, also double check by checking process list.
- On what port should it listen? - Check your web server configuration
- Is it actually listening on this port? - `netstat -lpdn` - run as `root` or `sudo` so that you can see the process for each listening port
- It is listening on the correct server IP? - `netstat`  is also your friend here
- Is there a firewall enabled?
- Have you looked at logs? - usually in `/var/log` and `tail -f`  is your friend
- Can I connect to the HTTP port from the location I am browsing from? - `curl` is your friend

There is a good chance that at this point you will already have found part of the issue.

##### Get a quick overview of the machine state
When you connect to a server/machine/computer/container you want to understand what’s happened recently and what’s happening now, and you can do this with 5 commands in a minute or less:
#### `w`
- shows server [uptime](https://www.techtarget.com/whatis/definition/uptime-and-downtime)which is the time during which the server has been continuously running
- shows which users are connected to the server
- load average will give you a good sense of the server health - (read more about load [here](https://scoutapm.com/blog/understanding-load-averages) and [here](https://www.brendangregg.com/blog/2017-08-08/linux-load-averages.html))

#### `history`
- shows which commands were previously run by the user you are currently connected to
- you can learn a lot about what type of work was previously performed on the machine, and what could have gone wrong with it
- where you might want to start your debugging work

#### `top`
- shows what is currently running on this server
- order results by CPU, memory utilization and catch the ones that are resource intensive

#### `df`
- shows disk utilization

#### `netstat`
- what port and IP your server is listening on
- what processes are using sockets
- try `netstat -lpn` on Ubuntu machine


## Background Context
The Webstack debugging series will train you in the art of debugging. Computers and software rarely work the way we want (that’s the “fun” part of the job!).

Being able to debug a webstack is essential for a Full-Stack Software Engineer, and it takes practice to be a master of it.

In this debugging series, broken/bugged webstacks will be given to you, the final goal is to come up with a Bash script that once executed, will bring the webstack to a working state. But before writing this Bash script, you should figure out what is going on and fix it manually.

Let’s start with a very simple example. My server must:
- have a copy of the `/etc/passwd` file in `tmp`
- have a file named `/tmp/isworking` containing the string `OK`

Let’s pretend that without these 2 elements, my web application cannot work.

Let’s go through this example and fix the server.
```
vagrant@vagrant:~$ docker run -d -ti ubuntu:14.04
Unable to find image 'ubuntu:14.04' locally
14.04: Pulling from library/ubuntu
34667c7e4631: Already exists
d18d76a881a4: Already exists
119c7358fbfc: Already exists
2aaf13f3eff0: Already exists
Digest: sha256:58d0da8bc2f434983c6ca4713b08be00ff5586eb5cdff47bcde4b2e88fd40f88
Status: Downloaded newer image for ubuntu:14.04
76f44c0da25e1fdf6bcd4fbc49f4d7b658aba89684080ea5d6e8a0d832be9ff9
vagrant@vagrant:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
76f44c0da25e        ubuntu:14.04        "/bin/bash"         13 seconds ago      Up 12 seconds                           infallible_bhabha
vagrant@vagrant:~$ docker exec -ti 76f44c0da25e /bin/bash
root@76f44c0da25e:/# ls /tmp/
root@76f44c0da25e:/# cp /etc/passwd /tmp/
root@76f44c0da25e:/# echo OK > /tmp/isworking
root@76f44c0da25e:/# ls /tmp/
isworking  passwd
root@76f44c0da25e:/#
vagrant@vagrant:~$
```

Then my answer file would contain:
```
sylvain@ubuntu:~$ cat answerfile
#!/usr/bin/env bash
# Fix my server with these magic 2 lines
cp /etc/passwd /tmp/
echo OK > /tmp/isworking
sylvain@ubuntu:~$
```

Note that as you cannot use interactive software such as `emacs` or `vi` in your Bash script, everything needs to be done from the command line (including file edition).

## Installing Docker
For this project you will be given a container which you can use to solve the task. **If** you would like to have Docker so that you can experiment with it and/or solve this problem locally, you can install it on your machine, your Ubuntu 14.04 VM, or your Ubuntu 16.04 VM if you upgraded.

- [Mac OS](https://docs.docker.com/desktop/install/mac-install/)
- [Windows](https://docs.docker.com/desktop/install/windows-install/)
- [Ubuntu 14.04](https://www.liquidweb.com/kb/how-to-install-docker-on-ubuntu-14-04-lts/)  (Note that Docker for Ubuntu 14 is deprecated and you will have to make some adjustments to the instructions when installing)
- [Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04)



This creates a Docker container with Ubuntu 18.04, [TightVNC Server](https://tightvnc.com) and [baangt](https://baangt.org).

# To build:

```bash
$ make build
```

# To run:

```bash
$ make run
```

which is a shorthand for:

```bash
$ docker run --rm -ti -p 5902:5901 --name docker-ubuntu baangt/docker-ubuntu-vnc:latest
```

After you run the container, you can use VNC to access it by using ``vnc://localhost:5902``. Initial
password for the VNC-Connection is ``password``. You'll find ``baangt`` already up and running and configured
for your test execution.

Check http://localhost:4444/status to see the status of Selenium Grid.

# To get a shell on a running container:

```bash
$ make shell
```




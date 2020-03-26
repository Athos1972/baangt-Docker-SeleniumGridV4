README
======

This creates a Docker container with Ubuntu 18.04, [TightVNC Server](https://tightvnc.com) and [baangt](https://baangt.org).

To build:

```bash
$ make build
```

To run:

```bash
$ make run
```

which is a shorthand for:

```bash
$ docker run --rm -ti -p 5902:5901 --name docker-ubuntu baangt/docker-ubuntu-vnc:latest
```

To get a shell on a running container:

```bash
$ make shell
```

Please check following:

 - donwload latest webdrivers in baangt/browserDrivers folder
 - or if you run baangt and execute with TC.Browser = FF, then latest geckodriver will be downloaded.
 
To run selenium grid 4 
```bash
$ java -jar /baangt/browserDrivers/selenium-server-4.0.0-alpha-5.jar standalone
```

Check http://localhost:4444/status

Use to test baangt/examples/globals_grid4.json

TC.Browser: REMOTE_V4

TC.BrowserAttributes: {'browserName': 'firefox', 'seleniumGridIp': '127.0.0.1', 'seleniumGridPort': '4444'}
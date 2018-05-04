# Dillinger
# What is cluster-smi
It is essentially the same as `nvidia-smi` but for multiple machines.
Running `cluster-smi` and will output something as the following;
```console
user@host $ cluster-smi

Thu Jan 18 21:35:51 2018
+---------+------------------------+---------------------+----------+----------+
| Node    | Gpu                    | Memory-Usage        | Mem-Util | GPU-Util |
+---------+------------------------+---------------------+----------+----------+
| node-00 | 0: TITAN Xp            |  3857MiB / 12189MiB | 31%      | 0%       |
|         | 1: TITAN Xp            | 11689MiB / 12189MiB | 95%      | 0%       |
|         | 2: TITAN Xp            | 10787MiB / 12189MiB | 88%      | 0%       |
|         | 3: TITAN Xp            | 10965MiB / 12189MiB | 89%      | 100%     |
+---------+------------------------+---------------------+----------+----------+
| node-01 | 0: TITAN Xp            | 11667MiB / 12189MiB | 95%      | 100%     |
|         | 1: TITAN Xp            | 11667MiB / 12189MiB | 95%      | 96%      |
|         | 2: TITAN Xp            |  8497MiB / 12189MiB | 69%      | 100%     |
|         | 3: TITAN Xp            |  8499MiB / 12189MiB | 69%      | 98%      |
+---------+------------------------+---------------------+----------+----------+
| node-02 | 0: GeForce GTX 1080 Ti |  1447MiB / 11172MiB | 12%      | 8%       |
|         | 1: GeForce GTX 1080 Ti |  1453MiB / 11172MiB | 13%      | 99%      |
|         | 2: GeForce GTX 1080 Ti |  1673MiB / 11172MiB | 14%      | 0%       |
|         | 3: GeForce GTX 1080 Ti |  6812MiB / 11172MiB | 60%      | 36%      |
+---------+------------------------+---------------------+----------+----------+
```
Please find more information on cluster-smi on [https://github.com/PatWie/cluster-smi](https://github.com/PatWie/cluster-smi)

# Prerequisites
[Docker](https://docs.docker.com/install/) must be installed on all machines using cluster-smi-docker
[nvidia-docker](https://github.com/NVIDIA/nvidia-docker) must installed on the machine running the build.
[nvidia-docker](https://github.com/NVIDIA/nvidia-docker) must installed on the machine(s) running cluster-smi-node

# Build image
You have to build the Docker image yourself because configuration data is currently integrated in a cluster-smi sourcefile that is compiled during the docker build.

Clone git repository:
```sh
$ git clone https://github.com/ieggel/cluster-smi-docker.git
```
Change to the repo root directory:
```sh
$ cd cluster-smi-docker
```
Edit Dockerfile (replace ***nano*** with editor of your choice:
```sh
$ nano Dockerfile
```
Edit the configuration values mentioned in the following section inside the Dockerfile:
```sh
RUN sed -i 's/c.RouterIp = "127.0.0.1"/c.RouterIp = "fastgpu"/g' ./config.go
RUN sed -i 's/c.Ports.Nodes = "9080"/c.Ports.Nodes = "9999"/g' ./config.go
RUN sed -i 's/c.Ports.Clients = "9081"/c.Ports.Clients = "9998"/g' ./config.go
```
The sed commands are replacing a line containing a specific string in the config file with another string of your choice (your config). There are several comments included in the Dockerfile on how to edit those values.

Now you can build the image:
```sh
$ docker --runtime=nvidia build -t <your-image-name> .
```
You can then push the image to Docker Hub (or your preffered registry server):
```sh
$ docker push <your-image-name>
```

# How to run cluster-smi-docker - Option 1: without docker-compose

**Cluster-smi router:**
```sh
$ docker run --runtime=nvidia --net=host <your-image-name> ./cluster-smi-router
```
Note: No docker-nvidia required for the router

**Cluster-smi node:**
```sh
$ docker run --runtime=nvidia --net=host <your-image-name> ./cluster-smi-node
```
Note: docker-nvidia required for the node

**Cluster-smi client:**
```sh
$ docker run --rm --net=host <your-image-name> ./cluster-smi
```
Note: No docker-nvidia required for the client

If you dont want to use the "docker run ..." syntax you can put the command into a bash script and call the bashscript. You can find an example in [additional_files/client_script](additional_scripts/client-script)




# How to run cluster-smi-docker - Option 2: with docker-compose
You can also use docker-compose for the node and router, which makes it convenient to run in a "service" mode by enabling "restart always". This will restart the container in case it fails or the machine is rebooted (Docker deamon needs to be started on bootup, which is normally the case by default).

**Cluster-smi-router:**
Change to additional_scripts/cluster-smi-node directory
```sh
$ cd <repo-root>/additional_scripts/cluster-smi-router
```
Run docker-compose in deamon mode
```sh
$ docker-compose up -d
```

**Cluster-smi-node:**
Change to additional_scripts/cluster-smi-node directory
```sh
$ cd <repo-root>/additional_scripts/cluster-smi-node
```
Run docker-compose in deamon mode
```sh
$ docker-compose up -d
```

**Cluster-smi client:**
Same as in option 1.

Note: Using docker-compose for the client adds no benefits. 

If you dont want to use the "docker run ..." syntax you can put the command into a bash script and call the bashscript. You can find an example in [additional_files/client_script](additional_scripts/client-script)



# ImageCLEF 2018
  - [ImageCLEF Caption - Caption prediction](caption_prediction)
  - [ImageCLEF Caption - Concept detection](concept_detection)
  - [ImageCLEF Tuberculosis - Severity scoring](tuberculosis_severity_scoring)
  - [ImageCLEF Tuberculosis - MDR detection](tuberculosis_mdr_detection)
  - [ImageCLEF Tuberculosis - TBT classification](tuberculosis_tb_type)
  - [ImageCLEF Lifelog - ADLT](lifelog_adlt) 
  - [ImageCLEF Lifelog - LMRT](lifelog_lmrt)
  - [ImageCLEF VQA-Med](vqa_med)
  - 
# LifeCLEF 2018
  - [LifeCLEF Bird - Monophone](bird_monophone)
  - [LifeCLEF Bird - Soundscape](bird_soundscape)
  - [LifeCLEF Expert](expert)
  - [LifeCLEF Geo](geo)

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

Dillinger is a cloud-enabled, mobile-ready, offline-storage, AngularJS powered HTML5 Markdown editor.

  - Type some Markdown on the left
  - See HTML in the right
  - Magic

# New Features!

  - Import a HTML file and watch it magically convert to Markdown
  - Drag and drop images (requires your Dropbox account be linked)


You can also:
  - Import and save files from GitHub, Dropbox, Google Drive and One Drive
  - Drag and drop markdown and HTML files into Dillinger
  - Export documents as Markdown, HTML and PDF

Markdown is a lightweight markup language based on the formatting conventions that people naturally use in email.  As [John Gruber] writes on the [Markdown site][df1]

> The overriding design goal for Markdown's
> formatting syntax is to make it as readable
> as possible. The idea is that a
> Markdown-formatted document should be
> publishable as-is, as plain text, without
> looking like it's been marked up with tags
> or formatting instructions.

This text you see here is *actually* written in Markdown! To get a feel for Markdown's syntax, type some text into the left window and watch the results in the right.

### Tech

Dillinger uses a number of open source projects to work properly:

* [AngularJS] - HTML enhanced for web apps!
* [Ace Editor] - awesome web-based text editor
* [markdown-it] - Markdown parser done right. Fast and easy to extend.
* [Twitter Bootstrap] - great UI boilerplate for modern web apps
* [node.js] - evented I/O for the backend
* [Express] - fast node.js network app framework [@tjholowaychuk]
* [Gulp] - the streaming build system
* [Breakdance](http://breakdance.io) - HTML to Markdown converter
* [jQuery] - duh

And of course Dillinger itself is open source with a [public repository][dill]
 on GitHub.

### Installation

Dillinger requires [Node.js](https://nodejs.org/) v4+ to run.

Install the dependencies and devDependencies and start the server.

```sh
$ cd dillinger
$ npm install -d
$ node app
```

For production environments...

```sh
$ npm install --production
$ NODE_ENV=production node app
```

### Plugins

Dillinger is currently extended with the following plugins. Instructions on how to use them in your own application are linked below.

| Plugin | README |
| ------ | ------ |
| Dropbox | [plugins/dropbox/README.md][PlDb] |
| Github | [plugins/github/README.md][PlGh] |
| Google Drive | [plugins/googledrive/README.md][PlGd] |
| OneDrive | [plugins/onedrive/README.md][PlOd] |
| Medium | [plugins/medium/README.md][PlMe] |
| Google Analytics | [plugins/googleanalytics/README.md][PlGa] |


### Development

Want to contribute? Great!

Dillinger uses Gulp + Webpack for fast developing.
Make a change in your file and instantanously see your updates!

Open your favorite Terminal and run these commands.

First Tab:
```sh
$ node app
```

Second Tab:
```sh
$ gulp watch
```

(optional) Third:
```sh
$ karma test
```
#### Building for source
For production release:
```sh
$ gulp build --prod
```
Generating pre-built zip archives for distribution:
```sh
$ gulp build dist --prod
```
### Docker
Dillinger is very easy to install and deploy in a Docker container.

By default, the Docker will expose port 8080, so change this within the Dockerfile if necessary. When ready, simply use the Dockerfile to build the image.

```sh
cd dillinger
docker build -t joemccann/dillinger:${package.json.version}
```
This will create the dillinger image and pull in the necessary dependencies. Be sure to swap out `${package.json.version}` with the actual version of Dillinger.

Once done, run the Docker image and map the port to whatever you wish on your host. In this example, we simply map port 8000 of the host to port 8080 of the Docker (or whatever port was exposed in the Dockerfile):

```sh
docker run -d -p 8000:8080 --restart="always" <youruser>/dillinger:${package.json.version}
```

Verify the deployment by navigating to your server address in your preferred browser.

```sh
127.0.0.1:8000
```

#### Kubernetes + Google Cloud

See [KUBERNETES.md](https://github.com/joemccann/dillinger/blob/master/KUBERNETES.md)


### Todos

 - Write MORE Tests
 - Add Night Mode

License
----

MIT


**Free Software, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


   [dill]: <https://github.com/joemccann/dillinger>
   [git-repo-url]: <https://github.com/joemccann/dillinger.git>
   [john gruber]: <http://daringfireball.net>
   [df1]: <http://daringfireball.net/projects/markdown/>
   [markdown-it]: <https://github.com/markdown-it/markdown-it>
   [Ace Editor]: <http://ace.ajax.org>
   [node.js]: <http://nodejs.org>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [jQuery]: <http://jquery.com>
   [@tjholowaychuk]: <http://twitter.com/tjholowaychuk>
   [express]: <http://expressjs.com>
   [AngularJS]: <http://angularjs.org>
   [Gulp]: <http://gulpjs.com>

   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]: <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>

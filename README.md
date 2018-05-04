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
If you dont want to use the "docker run ..." syntax you can put the command into a bash script and call the bashscript. You can find an example in [additional_files/client_script](additional_scripts/client-script)
Note: No docker-nvidia required for the client





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
Note: Using docker-compose for the client adds no benefits. If you dont want to use the "docker run ..." syntax you can put the command into a bash script and call the bashscript. You can find an example in [additional_files/client_script](additional_scripts/client-script)

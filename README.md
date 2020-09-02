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
A so called ROUTER (no GPU needed) acts a server which gathers all GPU info from the NODEs. There should be only 1 router.
A NODE (having GPU(s)) sends its GPU INFO to the ROUTER. 
A client send (no GPU needed) sends a request to the ROZTER in order to receive GPU INFO of all NODES.

Please find more information on cluster-smi on [https://github.com/PatWie/cluster-smi](https://github.com/PatWie/cluster-smi)

# Prerequisites
- [Docker](https://docs.docker.com/install/) must be installed on all machines using cluster-smi-docker
- [nvidia container toolkit](https://github.com/NVIDIA/nvidia-docker) must installed on the machine running the build.
- [nvidia container toolkit](https://github.com/NVIDIA/nvidia-docker) must installed on the machine(s) running cluster-smi-node

# Config file
You have to provide a yml config file in order to launch a container. A good way to do that is to create a bind mount from the host system to the container via the -v docker run argument. Please see examples below. 

You can find a sample [config file](https://github.com/PatWie/cluster-smi/blob/master/cluster-smi.example.yml) in the original cluster-smi-repository.

# Docker hub repository
For a ready to run Docker image (which is used in the examples below), You can use the already built image medgift/cluster-smi-docker on [Docker Hub](https://hub.docker.com/r/medgift/cluster-smi-docker/). If you wish to build your own image, please refer to the [Dockerfile](https://github.com/ieggel/cluster-smi-docker/blob/master/Dockerfile).

# How to run cluster-smi-docker - Option 1: without docker-compose

**Cluster-smi router:**
```sh
$ docker run --d --name cluster-smi-router -net=host -v <local-config-file-path>:/cluster-smi.yml medgift/cluster-smi-docker:latest ./cluster-smi-router
```
Note: No nvidia container toolkit required for the router

**Cluster-smi node:**
```sh
$ docker run -d --name cluster-smi-node --gpus all --net=host -v <local-config-file-path>:/cluster-smi.yml medgift/cluster-smi-docker:latest ./cluster-smi-node
```
Note: nvidia container toolkit required for the node

**Cluster-smi client:**
```sh
$ docker run --rm --net=host -v <local-config-file-path>:/cluster-smi.yml medgift/cluster-smi:latest-docker ./cluster-smi
```
Note: No nvidia container toolkit required for the client

If you dont want to use the "docker run ..." syntax you can put the command into a bash script and call the bashscript. You can find an example in [additional_files/client-script](https://github.com/ieggel/cluster-smi-docker/tree/master/additional_scripts)




# How to run cluster-smi-docker - Option 2: with docker-compose
You can also use docker-compose for the node and router, which makes it convenient to run in a "service" mode by enabling "restart always". This will restart the container in case it fails or the machine is rebooted (Docker deamon needs to be started on bootup, which is normally the case by default).


**Cluster-smi-router:**

Change to additional_scripts/cluster-smi-node directory
```sh
$ cd <repo-root>/additional_scripts/cluster-smi-router
```

Edit the path to your local config file in docker-compose.yml:
```sh
volume: 
  - <local_config_file_path>:/cluster-smi.yml
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

Edit the path to your local config file in docker-compose.yml :
```sh
volume: 
  - <local_config_file_path>:/cluster-smi.yml
```

Run docker-compose in deamon mode
```sh
$ docker-compose up -d
```

**Cluster-smi client:**

Same as in option 1.

Note: Using docker-compose for the client adds no benefits. 

If you dont want to use the "docker run ..." syntax you can put the command into a bash script and call the bashscript. You can find an example in [additional_files/client-script](additional_scripts/client-script)


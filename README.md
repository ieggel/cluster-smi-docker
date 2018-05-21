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

# Config file
You have to provide a yml config file in order to launch a container. A good way to do that is to create a bind mount from the host system to the container via the -v docker run argument. Please see examples below. 

You can find a sample (config file)[https://github.com/PatWie/cluster-smi/blob/master/cluster-smi.example.yml] in the original cluster-smi-repository.

# How to run cluster-smi-docker - Option 1: without docker-compose

**Cluster-smi router:**
```sh
$ docker run --net=host -v <local-config-file-path>:/cluster-smi.yml whiteshark/cluster-smi:<version> ./cluster-smi-router
```
Note: No docker-nvidia required for the router

**Cluster-smi node:**
```sh
$ docker run --runtime=nvidia --net=host -v <local-config-file-path>:/cluster-smi.yml whiteshark/cluster-smi:<version> ./cluster-smi-node
```
Note: docker-nvidia required for the node

**Cluster-smi client:**
```sh
$ docker run --rm --net=host -v <local-config-file-path>:/cluster-smi.yml whiteshark/cluster-smi:<version> ./cluster-smi
```
Note: No docker-nvidia required for the client

If you dont want to use the "docker run ..." syntax you can put the command into a bash script and call the bashscript. You can find an example in [additional_files/client-script](additional_scripts/client-script)




# How to run cluster-smi-docker - Option 2: with docker-compose
You can also use docker-compose for the node and router, which makes it convenient to run in a "service" mode by enabling "restart always". This will restart the container in case it fails or the machine is rebooted (Docker deamon needs to be started on bootup, which is normally the case by default).

**Cluster-smi-router:**

Change to additional_scripts/cluster-smi-node directory
```sh
$ cd <repo-root>/additional_scripts/cluster-smi-router
```

Open the file docker-compose.yml and and specify your cluster-smi-docker image version:
```sh
image: whiteshark/cluster-smi-docker<version>
```

Edit the path to your local config file:
```sh
volumne: 
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

Open the file docker-compose.yml and and specify your cluster-smi-docker image version:
```sh
image: whiteshark/cluster-smi-docker<version>
```

Edit the path to your local config file:
```sh
volumne: 
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


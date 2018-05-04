FROM nvidia/cuda:9.0-devel-ubuntu16.04

LABEL maintainer="ivan.eggel@gmail.com"

#Install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    libtool-bin \
    autoconf \
    g++ \
    make \
    git \
    golang-go

#Download and compile zermomq (dependency)
RUN mkdir /zmq
RUN wget http://files.patwie.com/mirror/zeromq-4.1.0-rc1.tar.gz
RUN tar -xf zeromq-4.1.0-rc1.tar.gz -C /zmq
WORKDIR /zmq/zeromq-4.1.0
RUN ./autogen.sh
RUN ./configure
RUN ./configure --prefix=/zmq/zeromq-4.1.0/dist
RUN make
RUN make install

#Download cluster-smi code
WORKDIR /gocode/src/github.com/patwie
RUN git clone https://github.com/PatWie/cluster-smi.git

#Adjust workdir to base code dir
WORKDIR cluster-smi

#Set all necessary environment variables
ENV PKG_CONFIG_PATH="/zmq/zeromq-4.1.0/dist/lib/pkgconfig:${PKG_CONFIG_PATH}"
ENV LD_LIBRARY_PATH="/zmq/zeromq-4.1.0/dist/lib:${LD_LIBRARY_PATH}"
ENV GOPATH="/gocode"

#Set CFLAGS and LDFLAGS according to CUDA setup before compilation
RUN sed -i  's/#cgo CFLAGS: -I\/graphics\/opt\/opt_Ubuntu16.04\/cuda\/toolkit_8.0\/cuda\/include/#cgo CFLAGS: -I\/usr\/local\/cuda\/include/g' ./nvml/nvml.go
RUN sed -i  's/#cgo LDFLAGS: -lnvidia-ml -L\/graphics\/opt\/opt_Ubuntu16.04\/cuda\/toolkit_8.0\/cuda\/lib64\/stubs/#cgo LDFLAGS: -lnvidia-ml -L\/usr\/local\/cuda\/targets\/x86_64-linux\/lib\/stubs/g' ./nvml/nvml.go

#Create new config file with default values
RUN cp config.example.go config.go

#CUSTOM CONFIGURATION => ADJUST TO YOUR OWN NEEDS
#************************************************
#127.0.0.1"/c.RouterIp = "fastgpu"   => set to your own IP/hostname of the router component
#c.Ports.Nodes = "9999"                 => set to the port you want to use for node connections in router component
#c.Ports.Clients = "9998                => set to the port you want to use for client connections in router component
RUN sed -i 's/c.RouterIp = "127.0.0.1"/c.RouterIp = "fastgpu"/g' ./config.go
RUN sed -i 's/c.Ports.Nodes = "9080"/c.Ports.Nodes = "9999"/g' ./config.go
RUN sed -i 's/c.Ports.Clients = "9081"/c.Ports.Clients = "9998"/g' ./config.go
# additional "RUN sed..." if needed
#*************************************************

#BUILD cluster-smi
RUN cd proc && go install
RUN make all




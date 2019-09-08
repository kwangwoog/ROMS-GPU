# Install ubuntu
FROM 		ubuntu:18.04
MAINTAINER	next7885@snu.ac.kr
RUN		apt-get -y update

# Install gcc
RUN apt-get -y install apt-utils
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install gcc
RUN apt-get -y install g++
RUN apt-get -y install gfortran
RUN apt-get -y install wget
RUN apt-get -y install file
RUN wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.4.tar.gz
RUN tar -xvf ./openmpi-3.1.4.tar.gz
RUN export CC=gcc
RUN export CXX=g++
RUN export FC=gfortran
RUN export PATH=$PATH:/usr/bin:/usr/local/mpi/bin
RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib64:/usr/local/mpi/lib
WORKDIR /openmpi-3.1.4
RUN apt-get -y install make
RUN ./configure --prefix=/usr/local/mpi
RUN make
RUN make install
RUN apt-get -y install git
RUN apt-get -y install iputils-ping
RUN apt-get -y install net-tools
ENV username next7885
ENV password sja1974!
RUN git clone https://$username:$password@www.myroms.org/git/src ./roms_src
RUN wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.1.tar.gz
RUN wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.1.tar.gz
RUN wget http://www.zlib.net/zlib-1.2.11.tar.gz
RUN wget https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.10.5.tar.gz
RUN tar -xvf ./hdf5-1.10.5.tar.gz
RUN tar -xvf ./zlib-1.2.11.tar.gz
WORKDIR /openmpi-3.1.4/zlib-1.2.11
RUN ./configure --prefix=/usr/local/zlib
RUN make clean
RUN make && make install
RUN export PATH=$PATH:/usr/local/mpi/bin
WORKDIR /openmpi-3.1.4/hdf5-1.10.5
RUN export CC=mpicc CPPFLAGS=-I/usr/local/hdf5/include LDFLAGS=-L/usr/local/hdf5/lib 
RUN ./configure --prefix=/usr/local/hdf5 --with-zlib=/usr/local/zlib --enable-hl
RUN make clean
RUN make && make install
WORKDIR /openmpi-3.1.4
RUN tar -xvf ./netcdf-c-4.7.1.tar.gz
RUN tar -xvf ./netcdf-fortran-4.5.1.tar.gz

WORKDIR /openmpi-3.1.4/netcdf-c-4.7.1
RUN apt-get -y install vim
RUN apt-get -y install m4
RUN apt-get -y install curl
COPY compile_netcdf.sh /openmpi-3.1.4/netcdf-c-4.7.1/.
RUN ./compile_netcdf.sh
RUN make install
RUN /usr/local/netcdf/bin/nc-config --has-hdf5
WORKDIR /root
COPY initial_profile.sh /root/.
RUN ./initial_profile.sh

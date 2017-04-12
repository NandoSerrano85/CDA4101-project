#! /bin/sh
sudo apt-get install python3 libboost-all-dev python-numpy build-essential python-dev python-setuptools libboost-python-dev libboost-thread-dev -y
tar xzvf pycuda-VERSION.tar.gz

cd pycuda-VERSION
./configure.py --python-exe=/usr/bin/python3 --cuda-root=/usr/local/cuda --cudadrv-lib-dir=/usr/lib/x86_64-linux-gnu --boost-inc-dir=/usr/include --boost-lib-dir=/usr/lib --boost-python-libname=boost_python-py34 --boost-thread-libname=boost_thread --no-use-shipped-boost
make -j 4
sudo python setup.py install
sudo pip install pycuda

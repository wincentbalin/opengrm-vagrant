#!/bin/sh -e
#
# Download and install OpenFST with contributions and all OpenGRM projects
#
# Copyright 2018-2021 Wincent Balin
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Specify package versions
OPENFST_VERSION=1.8.1
BAUMWELCH_VERSION=0.3.6
CATEGORIAL_VERSION=1.3.3
NGRAM_VERSION=1.3.13
THRAX_VERSION=1.3.6
PYNINI_VERSION=2.1.4
SFST_VERSION=1.2.0

# Specify compilation jobs
JOBS="${JOBS:-1}"

# Install OpenFST
wget -q -O - http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-$OPENFST_VERSION.tar.gz | tar zxvf -
cd openfst-$OPENFST_VERSION
./configure --enable-compact-fsts --enable-compress --enable-const-fsts --enable-far --enable-linear-fsts --enable-lookahead-fsts --enable-mpdt --enable-ngram-fsts --enable-pdt --enable-python --enable-special --enable-bin --enable-grm
make -j $JOBS
make install
cd ..
rm -rf openfst-$OPENFST_VERSION
# Index libraries
if [ ! -f /etc/ld.so.conf.d/openfst.conf ]
then
    echo /usr/local/lib >> /etc/ld.so.conf.d/openfst.conf
    echo /usr/local/lib/fst >> /etc/ld.so.conf.d/openfst.conf
fi
ldconfig

# Install Baum-Welch extension
wget -q -O - http://www.opengrm.org/twiki/pub/GRM/BaumWelchDownload/baumwelch-$BAUMWELCH_VERSION.tar.gz | tar zxvf -
cd baumwelch-$BAUMWELCH_VERSION
./configure
make -j $JOBS
make install
cd ..
rm -rf baumwelch-$BAUMWELCH_VERSION
# Index libraries
ldconfig

# Install Categorial extension
wget -q -O - http://openfst.org/twiki/pub/Contrib/FstContrib/categorial-$CATEGORIAL_VERSION.tar.gz | tar zxvf -
cd categorial-$CATEGORIAL_VERSION
./configure
make -j $JOBS
make install
cd ..
rm -rf categorial-$CATEGORIAL_VERSION
# Index libraries
ldconfig

# Install OpenGRM NGram
wget -q -O - http://www.openfst.org/twiki/pub/GRM/NGramDownload/ngram-$NGRAM_VERSION.tar.gz | tar zxvf -
cd ngram-$NGRAM_VERSION
./configure
make -j $JOBS
make install
cd ..
rm -rf ngram-$NGRAM_VERSION
# Index libraries
ldconfig

# Install OpenGRM Thrax
wget -q -O - http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-$THRAX_VERSION.tar.gz | tar zxvf -
cd thrax-$THRAX_VERSION
./configure --enable-bin #--enable-readline
make -j $JOBS
make install
cd ..
rm -rf thrax-$THRAX_VERSION
# Index libraries
ldconfig

# Install OpenGRM Pynini
wget -q -O - http://www.openfst.org/twiki/pub/GRM/PyniniDownload/pynini-$PYNINI_VERSION.tar.gz | tar zxvf -
cd pynini-$PYNINI_VERSION
python3 setup.py install
cd ..
rm -rf pynini-$PYNINI_VERSION
# Index libraries
ldconfig

# Install OpenGRM SFST
wget -q -O - http://www.openfst.org/twiki/pub/GRM/SFstDownload/sfst-$SFST_VERSION.tar.gz | tar zxvf -
cd sfst-$SFST_VERSION
sed -i -e 's/c++11/c++17/g' configure
sed -i -e 's/Minus/f::Minus/g' src/include/sfst/backoff.h src/include/sfst/normalize.h src/include/sfst/state-weights.h
sed -i -e 's/FLAGS_/FST_FLAGS_/g' src/bin/*.cc src/test/*.cc
./configure
make -j $JOBS
make install
cd ..
rm -rf sfst-$SFST_VERSION
# Index libraries
ldconfig

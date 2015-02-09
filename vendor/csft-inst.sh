wget http://www.coreseek.cn/uploads/csft/3.1/Source/mmseg-3.1.tar.gz
wget http://www.coreseek.cn/uploads/csft/3.1/Source/csft-3.1.tar.gz
tar zxvf mmseg-3.1.tar.gz 
cd mmseg-3.1/
./configure --prefix=/opt/mmseg
make
sudo make install
cd ..
tar zxvf csft-3.1.tar.gz 
cd csft-3.1/
./configure --with-mmseg-includes=/opt/mmseg/include/mmseg --with-mmseg-libs=/opt/mmseg/lib --enable-id64 --prefix=/opt/csft
make
sudo make install
cd ..
cd mmseg-3.1/data
/opt/mmseg/bin/mmseg -u unigram.txt 
sudo cp unigram.txt.uni /opt/csft/var/data/uni.lib
cd ..
sudo cp src/win32/mmseg.ini /opt/csft/var/data/

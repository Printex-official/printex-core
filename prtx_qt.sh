sudo apt-get update
sudo apt-get install -y libtool libssl-dev
sudo apt-get install -y libboost-all-dev libboost-program-options-dev libzmq3-dev
sudo apt-get install -y libevent-dev libqrencode3
sudo apt-get install -y libminiupnpc-dev unzip
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

wget https://github.com/Printex-official/printex-core/releases/download/v1.0.0.0/lin-qt.zip
unzip -o lin-qt.zip
rm -rf lin-qt.zip
chmod +x printex-qt
sudo mv printex-qt /usr/local/bin
printex-qt &


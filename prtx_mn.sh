#/bin/bash
clear
echo "Do you want to install the required dependencies and create swap (no if you did it before)? [y/n]"
read DOSETUP

if [[ $DOSETUP =~ "y" ]] ; then
  sudo apt-get update
  sudo apt-get install -y nano htop git curl
  sudo apt-get install -y software-properties-common
  sudo apt-get install -y libtool autotools-dev pkg-config libssl-dev
  sudo apt-get install -y libboost-all-dev libzmq3-dev
  sudo apt-get install -y libevent-dev
  sudo apt-get install -y libminiupnpc-dev
  sudo apt-get install -y unzip
  sudo add-apt-repository  -y  ppa:bitcoin/bitcoin
  sudo apt-get update
  sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

  cd /var
  sudo touch swap.img
  sudo chmod 600 swap.img
  sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=4000
  sudo mkswap /var/swap.img
  sudo swapon /var/swap.img
  sudo free
  sudo chmod 666 /etc/fstab
  sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  cd
  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

echo "Now downloading daemon and CLI"
printex-cli stop
sleep 10
sudo rm -rf /root/.printex
cd ~
wget https://github.com/Printex-official/printex-core/releases/download/v1.0.0.0/lin-daemon.zip
unzip -o lin-daemon.zip
sudo mv -f printexd /usr/local/bin/ && sudo mv -f printex-cli /usr/local/bin/
chmod +x /usr/local/bin/printex*
rm -rf lin-daemon.zip

echo ""
echo "Configuring IP - Please Wait......."

declare -a NODE_IPS
for ips in $(netstat -i | awk '!/Kernel|Iface|lo/ {print $1," "}')
do
  NODE_IPS+=($(curl --interface $ips --connect-timeout 2 -s4 icanhazip.com))
done

if [ ${#NODE_IPS[@]} -gt 1 ]
  then
    echo -e "More than one IP. Please type 0 to use the first IP, 1 for the second and so on...${NC}"
    INDEX=0
    for ip in "${NODE_IPS[@]}"
    do
      echo ${INDEX} $ip
      let INDEX=${INDEX}+1
    done
    read -e choose_ip
    IP=${NODE_IPS[$choose_ip]}
else
  IP=${NODE_IPS[0]}
fi

echo "IP Done"
echo ""
echo "Enter masternode private key for node $ALIAS , Go To your Windows Wallet Tools > Debug Console , Type masternode genkey"
read PRIVKEY

echo "Creating configuration file"

CONF_DIR=/root/.printex
CONF_FILE=printex.conf
PORT=9797

echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> $CONF_FILE
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> $CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_FILE
echo "rpcport=9898" >> $CONF_FILE
echo "listen=1" >> $CONF_FILE
echo "server=1" >> $CONF_FILE
echo "daemon=1" >> $CONF_FILE
echo "logtimestamps=1" >> $CONF_FILE
echo "masternode=1" >> $CONF_FILE
echo "port=$PORT" >> $CONF_FILE
echo "mastenodeaddr=$IP:$PORT" >> $CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_FILE
echo "addnode=seed.boumba.linkpc.net" >> $CONF_FILE

sudo mkdir -p $CONF_DIR
sudo mv $CONF_FILE $CONF_DIR/$CONF_FILE

if [ -d "/home/$USER" ]; then
 echo "Would you like to install command line interface for user $USER? [y/n]"
 read INSTALL_USER
 if [[ $INSTALL_USER =~ "y" ]] ; then
  mkdir /home/$USER/.printex
  sudo cp /root/.printex/printex.conf /home/$USER/.printex/printex.conf
 fi 
fi

printexd -daemon -pid=/root/.printex/printex.pid -conf=/root/.printex/printex.conf -datadir=/root/.printex

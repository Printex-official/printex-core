Printex Core (fork PIVX) integration/staging repository
======================================


It is recommended [use the shell script](https://github.com/Printex-official/printex-core/releases) to install a Printex Masternode on a Linux server running Ubuntu 16.04

***

Quick installation of the Printex daemon under linux. See detailed instructions there [build-unix.md](build-unix.md)

Installation of libraries (using root user):

    add-apt-repository ppa:bitcoin/bitcoin -y
    apt-get update
    apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
    apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
    apt-get install -y libdb4.8-dev libdb4.8++-dev

Cloning the repository and compiling (use any user with the sudo group):

    cd ~
    git clone https://github.com/Printex-official/printex-core
    cd printex-core
    ./autogen.sh
    ./configure
    sudo make
    sudo strip ./src/printexd
    sudo strip ./src/printex-cli
    sudo strip ./src/printex-tx
    sudo strip ./src/test/test_printex
    sudo make install
    cd ~
    rm -rf printex-core/

Running the daemon:

    printexd &

Stopping the daemon:

    printex-cli stop

Daemon status:

    printex-cli getinfo
    printex-cli mnsync status

All binaries for different operating systems, you can download in the releases repository:

https://github.com/Printex-official/printex-core/releases

P2P port:  9797, RPC port:  9898
-
Distributed under the MIT software license, see the accompanying file COPYING or http://www.opensource.org/licenses/mit-license.php.


wget https://github.com/Printex-official/printex-core/releases/download/v1.0.0.0/prtx_mn.sh

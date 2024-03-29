  VMWare提供了三种工作模式，它们是bridged([桥接模式](https://www.baidu.com/s?wd=桥接模式&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao))、NAT(网络地址转换模式)和host-only(主机模式)。要想在网络管理和维护中合理应用它们，你就应该先了解一下这三种工作模式。
1.bridged([桥接模式](https://www.baidu.com/s?wd=桥接模式&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao))
在这种模式下，VMWare虚拟出来的操作系统就像是局域网中和宿主机一样的一台独立的主机，它可以访问网内任何一台机器。在[桥接模式](https://www.baidu.com/s?wd=桥接模式&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)下，你需要手工为虚拟系统配置IP地址、子网掩码，而且还要和宿主机器处于[同一网段](https://www.baidu.com/s?wd=同一网段&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)，这样虚拟系统才能和宿主机器进行通信。同时，由于这个虚拟系统是局域网中的一个独立的主机系统，那么就可以手工配置它的[TCP/IP](https://www.baidu.com/s?wd=TCP%2FIP&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)配置信息，以实现通过局域网的网关或路由器访问互联网。

使用桥接模式的虚拟系统和宿主机器的关系，就像连接在同一个Hub上的两台电脑。想让它们相互通讯，你就需要为虚拟系统配置IP地址和子网掩码，否则就无法通信。

如果你想利用VMWare在局域网内新建一个虚拟服务器，为局域网用户提供网络服务，就应该选择桥接模式。

2.host-only(主机模式)
在某些特殊的网络调试环境中，要求将真实环境和虚拟环境隔离开，这时你就可采用host-only模式。在host-only模式中，所有的虚拟系统是可以相互通信的，但虚拟系统和真实的网络是被隔离开的。

提示:在host-only模式下，虚拟系统和宿主机器系统是可以相互通信的，相当于这两台机器通过双绞线互连。

在host-only模式下，虚拟系统的[TCP/IP](https://www.baidu.com/s?wd=TCP%2FIP&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)配置信息(如IP地址、网关地址、[DNS服务器](https://www.baidu.com/s?wd=DNS服务器&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)等)，都是由VMnet1(host-only)虚拟网络的DHCP服务器来动态分配的。

如果你想利用VMWare创建一个与网内其他机器相隔离的虚拟系统，进行某些特殊的网络调试工作，可以选择host-only模式。

3.NAT(网络地址转换模式)
使用NAT模式，就是让虚拟系统借助NAT(网络地址转换)功能，通过宿主机器所在的网络来访问公网。也就是说，使用NAT模式可以实现在虚拟系统里访问互联网。NAT模式下的虚拟系统的[TCP/IP](https://www.baidu.com/s?wd=TCP%2FIP&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)配置信息是由VMnet8(NAT)虚拟网络的DHCP服务器提供的，无法进行手工修改，因此虚拟系统也就无法和本局域网中的其他真实主机进行通讯。采用NAT模式最大的优势是虚拟系统接入互联网非常简单，你不需要进行任何其他的配置，只需要宿主机器能访问互联网即可。

如果你想利用VMWare安装一个新的虚拟系统，在虚拟系统中不用进行任何手工配置就能直接访问互联网，建议你采用NAT模式。

提示:以上所提到的NAT模式下的VMnet8虚拟网络，host-only模式下的VMnet1虚拟网络，以及bridged模式下的VMnet0虚拟网络，都是由VMWare虚拟机自动配置而生成的，不需要用户自行设置。VMnet8和VMnet1提供DHCP服务，VMnet0虚拟网络则不提供。  
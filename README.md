# docker-keepsolid-vpn

Based on [this](https://github.com/Retch/docker-wireguard-to-privoxy) image<br>

Use it like this:

| argument | optional | default |
| - | - | - |
| EMAIL | no | - |
| PASSWORD | no | - |
| COUNTRY | yes | de |
| DEVICE | yes | first |
<br>

Create manual device slot to not just use the first device, allowing for up to 5 parallel proxies. The location is generated new, just the name matters. The downloaded config should be deleted.
<br>
![image](https://user-images.githubusercontent.com/16291785/190563756-7754ea00-eaa9-40c7-a093-b1678ddc751c.png)
<br>

Hint: Please don't use special chars in your password, as the docker parameters/bash seems to have problems with it

To use the proxy by other containers
```bash
docker run -d --cap-add=NET_ADMIN -v /lib/modules:/lib/modules --sysctl="net.ipv4.conf.all.src_valid_mark=1" --restart unless-stopped --privileged -v /local/path:/etc/wireguard -e "EMAIL=email" -e "PASSWORD=pass" -e "COUNTRY=de" -e "DEVICE=proxy1" --name="proxy1" --network="proxynet" ghcr.io/retch/docker-keepsolid-vpn:main
```

To acess the proxy from other applications or make it pulic accessible
```bash
docker run -d --cap-add=NET_ADMIN -v /lib/modules:/lib/modules --sysctl="net.ipv4.conf.all.src_valid_mark=1" --restart unless-stopped --privileged -v /local/path:/etc/wireguard -e "EMAIL=email" -e "PASSWORD=pass" -e "COUNTRY=de" -e "DEVICE=proxy1" --name="proxy1" -p 8001:8118 ghcr.io/retch/docker-keepsolid-vpn:main
```

<br>
Through the /local/path, the wireguard conf and a working session id can be accessed.
Set a path to avoid the account log-in every start.

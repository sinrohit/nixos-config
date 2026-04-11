{
  ############################################################
  # systemd-networkd: WAN + LAN bridge
  ############################################################

  # Stable interface names by MAC address
  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="00:e0:4c:2e:54:50", NAME="wan0"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="d8:3a:dd:aa:90:7f", NAME="lan0"
  '';

  systemd.network = {
    enable = true;
    networks = {
      # WAN — DHCP client facing ISP / upstream router
      "10-wan0" = {
        matchConfig.Name = "wan0";
        networkConfig = {
          DHCP = "ipv4";
          IPv4Forwarding = true;
          DNS = "127.0.0.1";
        };
        dhcpV4Config = {
          UseDNS = false;
          UseNTP = false;
          UseHostname = false;
        };
        linkConfig.RequiredForOnline = "routable";
      };
      # LAN — static IP, built-in DHCP server
      "20-lan0" = {
        matchConfig.Name = "lan0";
        networkConfig = {
          Address = "10.0.0.1/24";
          IPv4Forwarding = true;
          DHCPServer = true;
          DNS = "10.0.0.1";
        };
        dhcpServerConfig = {
          EmitRouter = true;
          EmitDNS = true;
          DNS = "10.0.0.1";
          EmitNTP = true;
          NTP = "10.0.0.1";
          PoolOffset = 100;
          PoolSize = 100;
          ServerAddress = "10.0.0.1/24";
          DefaultLeaseTimeSec = 3600;
        };
        dhcpServerStaticLeases = [
          # Static leases for your devices go here:
          {
            MACAddress = "b8:85:84:9a:5d:12";
            Address = "10.0.0.10";
          }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}

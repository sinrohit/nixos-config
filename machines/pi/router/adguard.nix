{
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    host = "10.0.0.1";
    port = 3000;

    settings = {
      dns = {
        bind_hosts = [
          "10.0.0.1"
          "127.0.0.1"
          "100.102.29.63"
        ];

        port = 53;

        # Point to your local Unbound instance
        upstream_dns = [ "127.0.0.1:5335" ];
        bootstrap_dns = [ "127.0.0.1:5335" ];

        enable_dnssec = true;
        cache_size = 8388608; # 8MB cache
        cache_ttl_min = 300; # Minimum 5 minutes
        cache_ttl_max = 86400; # Maximum 24 hours

        # How to respond to blocked domains:
        # - "default": AdGuard's default blocked page
        # - "nxdomain": Return NXDOMAIN
        # - "null_ip": Return 0.0.0.0/::
        # - "custom_ip": Return custom IP
        blocking_mode = "nxdomain";

        ratelimit = 20; # Max 20 requests/second per client
        filtering_enabled = true;
      };

      querylog = {
        enabled = true;
        interval = "2160h";
      };
      statistics = {
        enabled = true;
        interval = "24h";
      };
      filters = [
        {
          enabled = true;
          name = "AdGuard DNS filter";
          url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
          id = 1;
        }
        {
          enabled = true;
          name = "Steven Black";
          url = "https://raw.githubusercontent.com/sinrohit/hosts/master/hosts";
          id = 2;
        }
      ];
    };
  };
}

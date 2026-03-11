{
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    stateDir = "/media/forgejo";
    settings = {
      session.COOKIE_SECURE = true;
      server = {
        DOMAIN = "git.sinrohit.com";
        ROOT_URL = "https://git.sinrohit.com/";
        HTTP_PORT = 3000;
        LANDING_PAGE = "/sinrohit";
      };
      log = {
        LEVEL = "Trace";
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
    };
  };
}

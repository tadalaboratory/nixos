{
  outputs =
    { self, ... }:
    {
      templates = {
        "python".path = ./python;
        "node".path = ./node;
      };
    };
}

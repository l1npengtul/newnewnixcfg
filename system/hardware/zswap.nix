{ ... }:
{
  boot.zswap = {
    enable = true;
    compressor = "zstd";
  };
}

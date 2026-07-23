{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.gpu-type = {
      enable = lib.mkEnableOption "enable gpu config";
      type = lib.mkOption {
        description = "type of gpu to use";
        type = lib.types.enum [
          "amd"
          "intel"
          "none"
        ];
        default = "none";
      };
    };
  };

  config =
    lib.mkIf (config.hardware.gpu-type == "amd" && config.hardware.gpu-type.enable) {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa
          libva
          libvdpau-va-gl
          vulkan-loader
          vulkan-validation-layers
          mesa.opencl # Enables Rusticl (OpenCL) support
          rocmPackages.clr.icd
        ];
      };

      environment.systemPackages = with pkgs; [
        mesa-demos
        vulkan-tools
        clinfo
        lact
      ];

      services.lact.enable = true;

      environment.variables = {
        RUSTICL_ENABLE = "radeonsi";
      };
    }
    // lib.mkIf (config.hardware.gpu-type == "intel" && config.hardware.gpu-type.enable) {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa
          libva
          libvdpau-va-gl
          vulkan-loader
          vulkan-validation-layers
          intel-media-driver
          vpl-gpu-rt
        ];
      };

      environment.systemPackages = with pkgs; [
        mesa-demos
        vulkan-tools
        clinfo
      ];

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };
    };
}

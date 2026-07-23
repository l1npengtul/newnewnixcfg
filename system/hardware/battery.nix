{ lib, config, ... }:
{
  options = {
    hardware.battery-optimisations.enable = lib.mkEnableOption "enable battery optimisations";
  };

  config = lib.mkIf config.hardware.battery-optimisations.enable {

    powerManagement = {
      enable = true;
      powertop.enable = true;
    };

    services.power-profiles-daemon.enable = false;

    services.tlp = {
      enable = true;
      settings = {
        SOUND_POWER_SAVE_ON_BAT = 1;

        INTEL_GPU_MIN_FREQ_ON_AC = 100;
        INTEL_GPU_MIN_FREQ_ON_BAT = 100;
        INTEL_GPU_MAX_FREQ_ON_AC = 1950;
        INTEL_GPU_MAX_FREQ_ON_BAT = 600;
        INTEL_GPU_BOOST_FREQ_ON_AC = 1950;
        INTEL_GPU_BOOST_FREQ_ON_BAT = 600;

        PCIE_ASPM_ON_AC = "powersave";
        PCIE_ASPM_ON_BAT = "powersupersave";

        PLATFORM_PROFILE_ON_BAT = "low-power";
        PLATFORM_PROFILE_ON_AC = "balanced";

        MEM_SLEEP_ON_AC = "s2idle";
        MEM_SLEEP_ON_BAT = "deep";

        NMI_WATCHDOG = 0;

        START_CHARGE_THRESH_BAT0 = 65;
        STOP_CHARGE_THRESH_BAT0 = 85;
      };
    };

    services.thermald.enable = true;
    programs.auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "auto";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "lock";
    };

    services.system76-scheduler = {
      enable = true;
      settings.cfsProfiles.enable = true;
      useStockConfig = true;
    };

    hardware.sensor.iio.enable = true;
  };
}

{
  inputs,
  pkgs,
  ...
}:
let
  reapkgs = with inputs.reapkgs-known.legacyPackages.${pkgs.stdenv.hostPlatform.system}; [
    birdbird-reascript-testing."BirdBird_Global Sampler.lua"
    birdbird-reascript-testing."BirdBird_Parameter History.lua"
    birdbird-reascript-testing."BirdBird_FX Inspector.lua"
    rejj."ReEQ.jsfx"
    saike-tools."Amaranth.jsfx"
    saike-tools."saike_abyss.jsfx"
    saike-tools."Saike_Morph.jsfx"
    saike-tools."saike_smooth.jsfx"
    saike-tools."saike_duskverb.jsfx"
    saike-tools."saike_nostalgizer.jsfx"
    saike-tools."saikedrums.jsfx"
    saike-tools."saike_partials.jsfx"
    saike-tools."saike_bric_a_brac.jsfx"
    saike-tools."Swellotron.jsfx"
    saike-tools."Reflectosaurus.jsfx"
    saike-tools."Saike_FMFilter2.jsfx"
    saike-tools."saike_lava.jsfx"
    saike-tools."SatanVerb.jsfx"
    saike-tools."Filther.jsfx"
    saike-tools."StereoSpectrumSplit.jsfx"
    saike-tools."StereoManipulator.jsfx"
    saike-tools."SaikeMultiSpectralAnalyzer_MK2.jsfx"
    saike-tools."Saike_Yutani.jsfx"
    saike-tools."Saike Stereo Bub III.jsfx"
    saike-tools."Transience.jsfx"
    saike-tools."Tight_Compressor.jsfx"
    saike-tools."ToneStacks.jsfx"
    saike-tools."BandSplitter.jsfx"
  ];
  extras = with inputs.reapkgs-extras.legacyPackages.${pkgs.stdenv.hostPlatform.system}; [
    demian-d."AD Collection.jsfx"
  ];
in
{
  xdg.configFile.REAPER = {
    recursive = true;
    source = pkgs.symlinkJoin {
      name = "reapkgs";
      paths = reapkgs ++ extras;
    };
  };
  xdg.configFile."REAPER/MIDINoteNames" = {
    recursive = true;
    source = ./note_names;
  };
  xdg.configFile."REAPER/libSwell-user.colortheme".source = ./reapertips/libSwell-user.colortheme;
  xdg.configFile."REAPER/Mac-Saturated.SWSColor".source = ./reapertips-colors/Mac-Saturated.SWSColor;
  xdg.configFile."REAPER/Data/toolbar_icons" = {
    recursive = true;
    source = ./toolbar_icons;
  };
  xdg.configFile."REAPER/UserPlugins/reaper_sws-x86_64.so".source =
    "${pkgs.reaper-sws-extension}/UserPlugins/reaper_sws-x86_64.so";
  xdg.configFile."REAPER/UserPlugins/reaper_reapack-x86_64.so".source =
    "${pkgs.reaper-reapack-extension}/UserPlugins/reaper_reapack-x86_64.so";

  xdg.configFile."REAPER/Scripts/sws_python.py".source =
    "${pkgs.reaper-sws-extension}/Scripts/sws_python.py";
  xdg.configFile."REAPER/Scripts/sws_python64.py".source =
    "${pkgs.reaper-sws-extension}/Scripts/sws_python64.py";
  xdg.configFile."REAPER/ColorThemes/reapertips.ReaperThemeZip".source =
    ./reapertips/02_Theme/reapertips.ReaperThemeZip;
}

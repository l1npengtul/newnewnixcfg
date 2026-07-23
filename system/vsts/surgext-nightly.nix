{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  freetype,
  libjack2,
  lv2,
  libX11,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
  libGL,
  fontconfig,
  luajit,
}:
stdenv.mkDerivation rec {
  pname = "surge-XT";
  version = "0nightly";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "60e34f80d1d7b26c3fc4dbc251598a522bd20510";
    fetchSubmodules = true;
    hash = "sha256-Ffa9ZlEclRY7PLiPY8I8rzURFUd/G+RAZ276rqrqzhY=";
  };

  nativeBuildInputs = [
    cmake
    luajit
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    libjack2
    lv2
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
    libGL
    fontconfig
    luajit
  ];

  preConfigure = ''
    ls
    mkdir -p libs/luajitlib/bin
     cp ${luajit}/lib/libluajit-5.1.a libs/luajitlib/bin/libluajit.a
     ln -s ${luajit}/include libs/luajitlib
     ls libs/luajitlib/include
  '';

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DSURGE_BUILD_LV2=TRUE"
    "-DSURGE_SKIP_LUA=TRUE"
  ];

  CXXFLAGS = [
    # GCC 13: error: 'uint32_t' has not been declared
    "-include cstdint"
  ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = (
    toString [
      "-lX11"
      "-lXext"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
    ]
  );

  # see https://github.com/NixOS/nixpkgs/pull/149487#issuecomment-991747333
  postPatch = ''
    export XDG_DOCUMENTS_DIR=$(mktemp -d)
  '';

  meta = with lib; {
    description = "LV2 & VST3 synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = licenses.gpl3;
    platforms = ["x86_64-linux"];
    maintainers = with maintainers; [
      magnetophon
      orivej
    ];
  };
}

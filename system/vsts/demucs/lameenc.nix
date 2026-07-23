{
  lib,
  python3Packages,
  fetchFromGitHub,
  lame,
}:
python3Packages.buildPythonPackage rec {
  pname = "lameenc";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "chrisstaite";
    repo = "lameenc";
    tag = "v1.8.1";
    hash = "sha256-/GV18mPcru1raFfFQGSAHgNwpmwN4oVFKcBL4JjZkC8=";
  };

  doCheck = false;
  pyproject = true;
  build-system = with python3Packages; [
    setuptools
    wheel
    setuptools-scm
  ];

  nativeBuildInputs = [
    lame
  ];

  dependencies = with python3Packages; [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
  ];

  preBuild = ''
    rm setup.py
    echo "${lame}"
    cat > setup.py << EOF
    import sys
    import setuptools
    import distutils.core
    import os.path

    print(sys.argv)
    libdir = '${lame.lib}/lib'
    incdir = '${lame}/include/lame'

    # Create the extension
    lameenc = distutils.core.Extension(
        'lameenc',
        include_dirs=[incdir] if incdir else [],
        libraries=['libmp3lame'] if sys.platform == 'win32' else [],
        extra_objects=
            [] if sys.platform == 'win32' or not libdir else [os.path.join(libdir, 'libmp3lame.so')],
        library_dirs=[libdir] if sys.platform == 'win32' and libdir else [],
        sources=['lameenc.c']
    )

    configuration = dict(
        name='lameenc',
        description='LAME encoding bindings',
        long_description=' ',
        author='Chris Staite',
        author_email='chris@yourdreamnet.co.uk',
        url='https://github.com/chrisstaite/lameenc',
        license='LGPLv3',
        ext_modules=[lameenc],
        classifiers=[
            'Topic :: Multimedia :: Sound/Audio :: Conversion',
            'Programming Language :: Python :: 3 :: Only',
            'License :: OSI Approved :: GNU Lesser General Public License v3 (LGPLv3)',
            'Operating System :: MacOS :: MacOS X',
            'Operating System :: Microsoft :: Windows',
            'Operating System :: POSIX :: Linux'
        ]
    )

    # Create the package
    setuptools.setup(**configuration)
    EOF
  '';
}

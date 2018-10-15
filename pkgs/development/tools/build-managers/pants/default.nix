{ stdenv, pythonPackages }:

with stdenv.lib;
with pythonPackages;
#https://files.pythonhosted.org/packages/4c/a0/30c5a4238dc3161816ade1de6addf09c003be2d37a14e8ed895da137e56d/pantsbuild.pants-1.9.0-cp27-none-manylinux1_x86_64.whl
let
  version = "1.9.0";
in buildPythonApplication rec {
  inherit version;
  pname = "pantsbuild.pants";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version; 
    python = "cp27";
    format = "wheel";
    platform = "manylinux1_x86_64";
    sha256 = "aac1b5f29386400cb4b081ff165f5dd9f1c0eddf19741fa3b7ad5fe09013dc2d";
  };

  prePatch = ''
    sed -E -i "s/'([[:alnum:].-]+)[=><][[:digit:]=><.,]*'/'\\1'/g" setup.py
    substituteInPlace setup.py --replace "requests[security]<2.19,>=2.5.0" "requests[security]<2.20,>=2.5.0"
  '';

  # Unnecessary, and causes some really weird behavior around .class files, which
  # this package bundles. See https://github.com/NixOS/nixpkgs/issues/22520.
  dontStrip = true;

  propagatedBuildInputs = [
    twitter-common-collections setproctitle ansicolors packaging pathspec
    scandir twitter-common-dirutil psutil requests pystache pex docutils
    markdown pygments twitter-common-confluence fasteners pywatchman
    futures cffi subprocess32 contextlib2 faulthandler pyopenssl wheel
  ];

  meta = {
    description = "A build system for software projects in a variety of languages";
    homepage    = "https://www.pantsbuild.org/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.unix;
  };
}

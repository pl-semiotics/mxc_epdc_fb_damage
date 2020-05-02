{ stdenv, lib, buildPackages, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "mxc_epdc_fb_damage";
  version = "0.0.1";

  src = lib.cleanSource ./.;

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    # For the module's own makefile
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"

    # To be passed through to the kernel's makefile. See manual-config.nix
    "CC=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "HOSTCC=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
    "ARCH=${stdenv.hostPlatform.platform.kernelArch}"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  NIX_CFLAGS_COMPILE_FLOAT_ABI = "-mfloat-abi=soft";

  outputs = [ "out" "dev" ];

  installPhase = ''
    install -D mxc_epdc_fb_damage.h $dev/include/mxc_epdc_fb_damage.h
    install -D mxc_epdc_fb_damage.ko $out/lib/modules/${kernel.modDirVersion}/drivers/fb/mxc_epdc_fb_damage.ko
  '';
}

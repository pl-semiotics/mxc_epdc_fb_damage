# Introduction

This module provides userspace damage tracking for (at least some)
i.MX6 e-paper framebuffers. It has been tested on the [reMarkable
tablet](https://remarkable.com) which uses an i.MX6 SoloLite.

Since e-paper displays have very high updates latencies, which depend
on the size of the region updated, well-written applications intended
to run on such displays will, whenever ready to draw to the display,
inform the framebuffer driver of precisely what areas of the display
need to be updated. Consequently, the kernel has detailed damage
tracking information available.

For some applications, damage-tracking information is useful, and the
lack of efficient damage-tracking can be an issue when using the Linux
framebuffer. Since, for e-paper displays, the kernel actually has the
necessary information available, this module exports that information
to userspace for the use of programs. The reference consumer of the
information from this module is
[rM-vnc-server](https://github.com/peter-sa/rM-vnc-server), an
efficient VNC server for the reMarkable tablet.

# Interface

When the module is loaded, it will inject damage recording
infrastructure to a framebuffer device `/dev/fbn` specified by the
`fbnode` module parameter (which defaults to `0`). It will then create
a `/dev/fbdamage` device, on which `read`s will block until damage is
created. Each call to `read` will return a single [`struct
mxcfb_damage_update`](./mxc_epdc_fb_damage.h). The `overflow_notify`
member will be set if any updates have been discarded, and the `data`
member will be set to the original `mxcfb_update_data` passed to the
kernel in an `MXCFB_SEND_UPDATE` ioctl.

# Building

The supported way to build this is via the
[Nix](https://nixos.org/nix) package manager, through the
[nix-remarkable](https://github.com/peter-sa/nix-remarkable)
expressions. To build just this project via `nix build` from this
repo, download it into the `pkgs/` directory of `nix-remarkable`.

For any other system, this should build like any other Linux kernel
module being cross-built for the reMarkable.

Prebuilt binaries are available in the [Releases
tab](https://github.com/peter-sa/mxc_epdc_fb_damage/releases).

# Usage

Copy `mxc_epdc_fb_damage.ko` to the reMarkable and run `insmod` on it
to load. If your platform has an mxc framebuffer numbered other than
zero, pass `fbnode=n` to insmod.

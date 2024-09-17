{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ pacman arch-install-scripts ];

  systemd.services."setup-pacman" = {
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.pacman}/bin/pacman-key --init
      KEYRING_IMPORT_DIR=${./.} ${pkgs.pacman}/bin/pacman-key --populate
    '';
  };

  environment.etc."pacman.conf".text = ''
    [options]
    SigLevel = Required DatabaseOptional
    Architecture = auto

    [core]
    Include = /etc/pacman.d/mirrorlist

    [extra]
    Include = /etc/pacman.d/mirrorlist
  '';

  environment.etc."pacman.d/mirrorlist".text = ''
    #
    # Arch Linux repository mirrorlist
    # Generated on 2024-09-17
    #

    # Germany
    Server = https://mirror.23m.com/archlinux/$repo/os/$arch
    Server = https://ftp.agdsn.de/pub/mirrors/archlinux/$repo/os/$arch
    Server = https://appuals.com/archlinux/$repo/os/$arch
    Server = https://mirror.bethselamin.de/$repo/os/$arch
    Server = https://de.mirrors.cicku.me/archlinux/$repo/os/$arch
    Server = https://mirror.clientvps.com/archlinux/$repo/os/$arch
    Server = https://mirror.cmt.de/archlinux/$repo/os/$arch
    Server = https://os.codefionn.eu/archlinux/$repo/os/$arch
    Server = https://mirror.dogado.de/archlinux/$repo/os/$arch
    Server = https://mirror.eto.dev/arch/$repo/os/$arch
    Server = https://ftp.fau.de/archlinux/$repo/os/$arch
    Server = https://pkg.fef.moe/archlinux/$repo/os/$arch
    Server = https://dist-mirror.fem.tu-ilmenau.de/archlinux/$repo/os/$arch
    Server = https://mirror.gnomus.de/$repo/os/$arch
    Server = https://files.hadiko.de/pub/dists/arch/$repo/os/$arch
    Server = https://archlinux.homeinfo.de/$repo/os/$arch
    Server = https://mirror.hugo-betrugo.de/archlinux/$repo/os/$arch
    Server = https://mirror.informatik.tu-freiberg.de/arch/$repo/os/$arch
    Server = https://mirror.iusearchbtw.nl/$repo/os/$arch
    Server = https://arch.jensgutermuth.de/$repo/os/$arch
    Server = https://de.arch.mirror.kescher.at/$repo/os/$arch
    Server = https://mirror.kumi.systems/archlinux/$repo/os/$arch
    Server = https://arch.kurdy.org/$repo/os/$arch
    Server = https://mirror.fra10.de.leaseweb.net/archlinux/$repo/os/$arch
    Server = https://mirror.metalgamer.eu/archlinux/$repo/os/$arch
    Server = https://mirror.mikrogravitation.org/archlinux/$repo/os/$arch
    Server = https://mirror.lcarilla.de/archlinux/$repo/os/$arch
    Server = https://mirror.moson.org/arch/$repo/os/$arch
    Server = https://mirrors.n-ix.net/archlinux/$repo/os/$arch
    Server = https://mirror.netcologne.de/archlinux/$repo/os/$arch
    Server = https://de.arch.niranjan.co/$repo/os/$arch
    Server = https://mirrors.niyawe.de/archlinux/$repo/os/$arch
    Server = https://mirror.orbit-os.com/archlinux/$repo/os/$arch
    Server = https://packages.oth-regensburg.de/archlinux/$repo/os/$arch
    Server = https://mirror.pagenotfound.de/archlinux/$repo/os/$arch
    Server = https://arch.phinau.de/$repo/os/$arch
    Server = https://mirror.pseudoform.org/$repo/os/$arch
    Server = https://archlinux.richard-neumann.de/$repo/os/$arch
    Server = https://ftp.halifax.rwth-aachen.de/archlinux/$repo/os/$arch
    Server = https://mirror.satis-faction.de/archlinux/$repo/os/$arch
    Server = https://mirror.selfnet.de/archlinux/$repo/os/$arch
    Server = https://ftp.spline.inf.fu-berlin.de/mirrors/archlinux/$repo/os/$arch
    Server = https://mirror.sunred.org/archlinux/$repo/os/$arch
    Server = https://archlinux.thaller.ws/$repo/os/$arch
    Server = https://mirror.ubrco.de/archlinux/$repo/os/$arch
    Server = https://mirror.undisclose.de/archlinux/$repo/os/$arch
    Server = https://arch.unixpeople.org/$repo/os/$arch
    Server = https://ftp.wrz.de/pub/archlinux/$repo/os/$arch
    Server = https://mirror.wtnet.de/archlinux/$repo/os/$arch
    Server = https://mirrors.xtom.de/archlinux/$repo/os/$arch
  '';
}

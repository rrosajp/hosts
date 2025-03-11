{
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  name = "stevenblack-hosts-unbound";
  src = ./.;

  installPhase =
    let
      toUnboundConf = ''awk 'NF == 2 && $1 == "0.0.0.0" && $2 != "0.0.0.0" { printf "local-zone: \"%s\" always_nxdomain\n", $2 }'\'';
    in
    ''
      mkdir $out
      cat $src/hosts | ${toUnboundConf} > $out/hosts
      for file in alternates/*/hosts; do
        cat $file | ${toUnboundConf} > $out/$(basename $(dirname $file))
      done
    '';
}

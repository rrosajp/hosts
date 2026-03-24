{
  runCommandLocal,
}:
let
  toUnboundConf = ''awk 'NF == 2 && $1 == "0.0.0.0" && $2 != "0.0.0.0" { printf "local-zone: \"%s\" always_nxdomain\n", $2 }'\'';
in
runCommandLocal "stevenblack-hosts-unbound" { src = ./.; } ''
  mkdir $out
  ${toUnboundConf} < $src/hosts > $out/hosts
  for file in alternates/*/hosts; do
    ${toUnboundConf} < $file > $out/$(basename $(dirname $file))
  done
''

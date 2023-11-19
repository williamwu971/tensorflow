#!/usr/bin/env bash

joined=""

for arg in "$@"; do
  joined+="$arg "
done

joined="${joined%,}"

echo $joined
#exit

scp $joined xiaoxiang@labos.cs.usyd.edu.au:/mnt/sdb/xiaoxiang/.cache/bazel/_bazel_xiaoxiang/2b8bd3a91e41c898147a446c04118590/external/eigen_archive/unsupported/Eigen/CXX11/src/Tensor/

#!/usr/bin/env bash
# rebuild tensorflow

baz="/usr/local/bin/bazel"

if [ "$1" == "clean" ]; then

  while true; do
    read -p "Clean? (y/n) " yn
    case $yn in
    [Yy]*) break ;;    # If the user answers yes, exit the loop.
    [Nn]*) exit ;;     # If the user answers no, exit the script.
    *) echo "(y/n)" ;; # For any other input, ask again.
    esac
  done

  #rm -rf /tmp/tmp.*
  sudo rm -rf /tmp/* /root/.debug
  mkdir /tmp/tensorflow_pkg
  $baz clean --expunge
  $baz clean
fi

rm -f /tmp/tensorflow_pkg/*
pip uninstall -y tensorflow || exit

$baz build --config=dbg //tensorflow/tools/pip_package:build_pip_package || exit

./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg || exit

pip install /tmp/tensorflow_pkg/* || exit

pkill -f bazel # terminate bazel server

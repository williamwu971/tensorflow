# rebuild tensorflow

policy="numactl -N 1 -m 1"

rm -f /tmp/tensorflow_pkg/*

/usr/local/bin/bazel build --config=dbg //tensorflow/tools/pip_package:build_pip_package || exit

./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg || exit

pip uninstall -y tensorflow || exit

#pip install /tmp/tensorflow_pkg/tensorflow-2.13.1-cp38-cp38-linux_x86_64.whl || exit
pip install /tmp/tensorflow_pkg/* || exit


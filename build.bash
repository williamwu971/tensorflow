# rebuild tensorflow

policy="numactl -N 1 -m 1"

rm -f /tmp/tensorflow_pkg/*

/usr/local/bin/bazel build --config=dbg \
    --per_file_copt=+tensorflow/tsl/framework/contraction/eigen_contraction_kernel.*@-g3 \
    --per_file_copt=+tensorflow/tsl/framework/convolution/eigen_spatial_convolutions-inl.*@-g3 \
    --per_file_copt=+tensorflow/tsl/framework/convolution/eigen_spatial_convolutions.*@-g3 \
    --per_file_copt=+tensorflow/tsl/framework/fixedpoint/PacketMathAVX.*@-g3 \
    --per_file_copt=+tensorflow/tsl/framework/fixedpoint/PacketMathAVX512.*@-g3 \
    --per_file_copt=+tensorflow/tsl/framework/fixedpoint/PacketMathAVX2.*@-g3 \
    --per_file_copt=+tensorflow/core/kernels/sparse_matmul_op.*@-g3 \
    --per_file_copt=+tensorflow/core/kernels/sparse_matmul_op_test.*@-g3 \
    --per_file_copt=+tensorflow/core/kernels/depthwise_conv_op.*@-g3 \
    --per_file_copt=+tensorflow/core/kernels/deep_conv2d.*@-g3 \
    --per_file_copt=+tensorflow/core/kernels/eigen_cuboid_convolution.*@-g3 \
    --per_file_copt=+tensorflow/core/kernels/depthwise_conv_op.*@-g3 \
    --per_file_copt=+tensorflow/core/kernels/sparse_matmul_op.*@-g3 \
    --per_file_copt=+tensorflow/core/kernels/depthwise_conv_grad_op.*@-g3 \
    //tensorflow/tools/pip_package:build_pip_package || exit

./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg || exit

pip uninstall -y tensorflow || exit

#pip install /tmp/tensorflow_pkg/tensorflow-2.13.1-cp38-cp38-linux_x86_64.whl || exit
pip install /tmp/tensorflow_pkg/* || exit

# rebuild tensorflow

OLD_IFS="$IFS"
IFS=$'\n'

#policy="numactl -N 1 -m 1"
baz="/usr/local/bin/bazel"

if [ "$1" == "clean" ]; then
    #    $baz clean --expunge
    $baz clean
fi

rm -f /tmp/tensorflow_pkg/*

# 1160 files in total
read -d '' -ra kernel_files <<<"$(ls -1 tensorflow/core/kernels | sed -n '1,600p')"
#read -d '' -ra kernel_files <<<"$(ls -1 tensorflow/core/kernels | sed -n '601,1160p')"
modified_array=()
prefix="--per_file_copt=+tensorflow/core/kernels/"
suffix="@-g"

#read -d '' -ra kernel_files <<<"$(grep -ril pstore tensorflow/core/kernels/)"
#modified_array=()
#prefix="--per_file_copt=+"
#suffix="@-DNDEBUG,-march=native,-Og,-g3"

for elem in "${kernel_files[@]}"; do
    modified_elem="${prefix}${elem}${suffix}"
    modified_array+=("$modified_elem")
done

echo "${modified_array[@]}"

IFS="$OLD_IFS"
#exit

#$baz build --config=dbg "${modified_array[@]}" //tensorflow/tools/pip_package:build_pip_package || exit
#$baz build --config=dbg "${modified_array[@]}" //tensorflow/tools/pip_package:build_pip_package || exit
$baz build --config=v1 "${modified_array[@]}" //tensorflow/tools/pip_package:build_pip_package || exit

#$baz build \
#    --cxxopt='-g' --cxxopt='-Og' --copt='-Og' --config=dbg \
#    //tensorflow/tools/pip_package:build_pip_package || exit

#$baz build \
#    --config=v1 --strip=never --copt='-DNDEBUG' --copt='-march=native' --copt='-Og' --copt='-g3' \
#    //tensorflow/tools/pip_package:build_pip_package || exit

#$baz build --config=dbg \
#    --per_file_copt=+tensorflow/compiler/xla/pjrt/transpose_kernels.*@-g3 \
#    --per_file_copt=+tensorflow/lite/delegates/gpu/gl_delegate.*@-g3 \
#    --per_file_copt=+tensorflow/lite/delegates/gpu/delegate.*@-g3 \
#    --per_file_copt=+tensorflow/lite/delegates/gpu/common/model_builder.*@-g3 \
#    --per_file_copt=+tensorflow/lite/delegates/gpu/common/model_builder.*@-g3 \
#    --per_file_copt=+tensorflow/lite/delegates/gpu/common/model_builder_test.*@-g3 \
#    --per_file_copt=+tensorflow/lite/delegates/gpu/metal/benchmarking/main.*@-g3 \
#    --per_file_copt=+tensorflow/lite/delegates/gpu/metal_delegate.*@-g3 \
#    --per_file_copt=+tensorflow/lite/delegates/gpu/cl/gpu_api_delegate.*@-g3 \
#    --per_file_copt=+tensorflow/lite/experimental/examples/unity/TensorFlowLitePlugin/ProjectSettings/ProjectSettings.*@-g3 \
#    --per_file_copt=+tensorflow/lite/java/demo/gradle/wrapper/gradle-wrapper.*@-g3 \
#    --per_file_copt=+tensorflow/lite/java/ovic/demo/gradle/wrapper/gradle-wrapper.*@-g3 \
#    --per_file_copt=+tensorflow/core/grappler/optimizers/memory_optimizer.*@-g3 \
#    --per_file_copt=+tensorflow/tsl/framework/contraction/eigen_contraction_kernel.*@-g3 \
#    --per_file_copt=+tensorflow/tsl/framework/convolution/eigen_spatial_convolutions-inl.*@-g3 \
#    --per_file_copt=+tensorflow/tsl/framework/convolution/eigen_spatial_convolutions.*@-g3 \
#    --per_file_copt=+tensorflow/tsl/framework/fixedpoint/PacketMathAVX.*@-g3 \
#    --per_file_copt=+tensorflow/tsl/framework/fixedpoint/PacketMathAVX512.*@-g3 \
#    --per_file_copt=+tensorflow/tsl/framework/fixedpoint/PacketMathAVX2.*@-g3 \
#    --per_file_copt=+tensorflow/core/kernels/sparse_matmul_op.*@-g3 \
#    --per_file_copt=+tensorflow/core/kernels/sparse_matmul_op_test.*@-g3 \
#    --per_file_copt=+tensorflow/core/kernels/depthwise_conv_op.*@-g3 \
#    --per_file_copt=+tensorflow/core/kernels/deep_conv2d.*@-g3 \
#    --per_file_copt=+tensorflow/core/kernels/eigen_cuboid_convolution.*@-g3 \
#    --per_file_copt=+tensorflow/core/kernels/depthwise_conv_op.*@-g3 \
#    --per_file_copt=+tensorflow/core/kernels/sparse_matmul_op.*@-g3 \
#    --per_file_copt=+tensorflow/core/kernels/depthwise_conv_grad_op.*@-g3 \
#    //tensorflow/tools/pip_package:build_pip_package || exit

./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg || exit

pip uninstall -y tensorflow || exit

#pip install /tmp/tensorflow_pkg/tensorflow-2.13.1-cp38-cp38-linux_x86_64.whl || exit
pip install /tmp/tensorflow_pkg/* || exit

# rebuild tensorflow

OLD_IFS="$IFS"
IFS=$'\n'

#policy="numactl -N 1 -m 1"
baz="/usr/local/bin/bazel"

if [ "$1" == "clean" ]; then
    #rm -f /tmp/tensorflow_pkg/*
    #rm -rf /tmp/tmp.*
    rm -rf /tmp/*
    mkdir /tmp/tensorflow_pkg
    $baz clean --expunge
    $baz clean
    pip uninstall -y tensorflow || exit
fi

#find tensorflow/core/kernels/ -maxdepth 1 -type f -exec basename {} \; | sed 's/\.[^.]*$//' | sort -u

kernel_files=()

# 1160 files in total
#read -d '' -ra kernel_files <<<"$(ls -1 tensorflow/core/kernels | sed -n '1,600p')"
read -d '' -ra kernel_files <<<"$(ls -1 tensorflow/core/kernels | sed -n '601,1160p')"
modified_array=()
prefix="--per_file_copt=+tensorflow/core/kernels/"
suffix=".*@-g"

#read -d '' -ra kernel_files <<<"$(grep -ril pstore tensorflow/core/kernels/)"
#modified_array=()
#prefix="--per_file_copt=+"
#suffix="@-DNDEBUG,-march=native,-Og,-g3"

IFS="$OLD_IFS"

for elem in "${kernel_files[@]}"; do
    modified_elem="${prefix}${elem}${suffix}"
    modified_array+=("$modified_elem")
done

for elem in "${modified_array[@]}"; do
    echo "$elem"
done
while true; do
    read -p "Continue? (y/n) " yn
    case $yn in
    [Yy]*) break ;;    # If the user answers yes, exit the loop.
    [Nn]*) exit ;;     # If the user answers no, exit the script.
    *) echo "(y/n)" ;; # For any other input, ask again.
    esac
done

#exit

$baz build --config=dbg "${modified_array[@]}" //tensorflow/tools/pip_package:build_pip_package || exit
#$baz build --config=v1 "${modified_array[@]}" //tensorflow/tools/pip_package:build_pip_package || exit

#$baz build \
#    --cxxopt='-g' --cxxopt='-Og' --copt='-Og' --config=dbg \
#    //tensorflow/tools/pip_package:build_pip_package || exit

#$baz build \
#    --config=v1 --strip=never --copt='-DNDEBUG' --copt='-march=native' --copt='-Og' --copt='-g3' \
#    //tensorflow/tools/pip_package:build_pip_package || exit

./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg || exit

#pip install /tmp/tensorflow_pkg/tensorflow-2.13.1-cp38-cp38-linux_x86_64.whl || exit
pip install --ignore-installed /tmp/tensorflow_pkg/* || exit

pkill -f bazel # terminate bazel server

#!/bin/bash -e

. ../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf _build$ndk_suffix
	exit 0
else
	exit 255
fi

make -j$cores
make DESTDIR="$prefix_dir" install

# make pc only generates a partial pkg-config file because ????
mkdir -p $prefix_dir/lib/pkgconfig
make pc >$prefix_dir/lib/pkgconfig/mujs.pc
cat >>$prefix_dir/lib/pkgconfig/mujs.pc <<'EOF'
Name: mujs
Description: MuJS embeddable Javascript interpreter
Version: ${version}
Libs: -L${libdir} -lmujs
Cflags: -I${includedir}
Libs.private: -lm
EOF

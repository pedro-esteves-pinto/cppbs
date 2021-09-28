#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC_ROOT=`realpath $DIR/../`
cd $SRC_ROOT

# our regular includes
(cd src && find -name "*.h" | perl -pe 's|\./.*?/(.*)|"\1"|')

# our proto includes
(cd build/clang_debug/gen_proto && find -name "*.h" |\
	 perl -pe 's|\./.*?/(.*)|"\1"|')

# stdlib inclues 
(cd /usr/include/c++/ && find -maxdepth 2 | sed 's/\.\/.*\///' | awk '{print "<"$0">"}')

# things we included in the past
(cd src && grep -R -h --include "*.*" "#include <" | perl -pe 's|#include <(.*)>|<\1>|' | sort | uniq)

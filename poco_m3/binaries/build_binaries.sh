set -ex
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
(cd ${SCRIPT_DIR}/kexec && ./build.sh)
(cd ${SCRIPT_DIR}/strace && ./build.sh)

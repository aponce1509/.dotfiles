echo '$* without quotes:'
./bar.sh $*

echo '$@ without quotes:'
./bar.sh $@

echo '$* with quotes:'
./bar.sh "$*"

echo '$@ with quotes:'
./bar.sh "$@"

NAME="factorial"
ARGS=""
echo "Test script running..."
gcc -s $NAME.s -o /tmp/$NAME -no-pie
/tmp/$NAME $ARGS
rm /tmp/$NAME

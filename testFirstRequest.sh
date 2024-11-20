LOG_FILE="${1}.log"

echo "TESTING ${1} on ${2} cpu(s)."

./doFirstRequestTests.sh ${1} ${2} > logs/$LOG_FILE
./parse.sh logs/$LOG_FILE

#!/bin/bash

DATE=`date "+%s"`

# -- Phase 2 -- tests successfully compiled single source files for runtime
# failure or timeout or wrong output. Correct sorted output files are put in
# /testsuite/output/CAF-should-pass -- #

TIMEOUT=60 # seconds
NUM_PROCS_SEQ="4"

select="no"
if [ "$1" == "select" ]; then
    select="yes"
fi

# mkdir -p ./run/$DATE

mkdir -p ./run/execute-logs
for d in `ls -d ./run/latest-execute.* 2> /dev/null`; do
    newdir=${d#"./run/latest-execute."}
    mv $d ./run/execute-logs/$newdir
done

mkdir -p ./run/bin ./run/latest-execute.$DATE > /dev/null 2>&1

# assumes ./run/bin contains files to execute
cd ./run
OUTDIR=latest-execute.$DATE
PWD=`pwd`

FAILED_COUNT=0
TOTAL_ATTEMPTS=0
PASSED_COUNT=0
TOTAL_TESTS=0

RESULTS=$OUTDIR/RESULTS

if [ "$select" == "yes" ]; then
    TOTAL_TESTS=`ls -1 bin/select/*.x 2> /dev/null | wc -l`
else
    TOTAL_TESTS=`ls -1 bin/{should-pass,kernels}/*.x 2> /dev/null | wc -l`
fi

echo ""
echo "==========================================================="
echo "              UHCAF REGRESSION TESTS (EXECUTION)"
echo "                        $TOTAL_TESTS TESTS"
echo "==========================================================="
echo ""


if [ "$select" == "yes" ]; then

# copy outputs for all kernels and should-pass tests into select 

cp ../output/CAF-should-pass/*.out ../output/CAF-select/
cp ../output/CAF-kernels/*.out ../output/CAF-select/

for file in `ls -1 bin/select/*.x 2> /dev/null`; do
  TOTAL_ATTEMPTS=$(($TOTAL_ATTEMPTS+1))
  FILE_TO_STRING=`echo "$file" | perl -e '$x=<>; $x =~ s/\.+\/+//g;@y=split("/",$x);printf("%s",pop @y)'`
  for NUM_PROCS in $NUM_PROCS_SEQ; do
    printf "%5s %40s (%s images) ... " "($TOTAL_ATTEMPTS)" $FILE_TO_STRING $NUM_PROCS
    OUTPUT=`LD_LIBRARY_PATH=$MPI_LIB perl ../scripts/timedexec.pl $TIMEOUT \
        cafrun -n $NUM_PROCS ./$file > $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out \
        2> $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.err && echo 1 || echo -1`
    STATUS=UNKNOWN
    if [ "$OUTPUT" == "1" ]; then
      # first try unsorted
      OUTPUT=`cat ../output/CAF-select/$FILE_TO_STRING.t=$NUM_PROCS.out| diff - $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out >/dev/null && echo 1 || echo 0`
      if [ "$OUTPUT" == '1' ]; then
          STATUS="PASSED"
          PASSED_COUNT=$(($PASSED_COUNT+1))
      else
          # that didn't work, so try sorted
          sort < $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out > $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out.sort
          OUTPUT=`sort ../output/CAF-select/$FILE_TO_STRING.t=$NUM_PROCS.out| diff - $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out.sort >/dev/null && echo 1 || echo 0`
          if [ "$OUTPUT" == '1' ]; then
              STATUS="PASSED (when sorted)"
              PASSED_COUNT=$(($PASSED_COUNT+1))
          else
              STATUS="FAILED (wrong output)"
              FAILED_COUNT=$(($FAILED_COUNT+1))
          fi
      fi
    else
      STATUS="FAILED"
      FAILED_COUNT=$(($FAILED_COUNT+1))
    fi
    echo "[$STATUS]"
    printf "%3s %40s %s\n" $TOTAL_ATTEMPTS $FILE_TO_STRING "$STATUS" >> $RESULTS
    # kill zombie if exists
    killall -r "$file" > /dev/null 2>&1
  done
done

rm -f ../output/CAF-select/*.out

else

for file in `ls -1 bin/should-pass/*.x | sort`; do
  TOTAL_ATTEMPTS=$(($TOTAL_ATTEMPTS+1))
  FILE_TO_STRING=`echo "$file" | perl -e '$x=<>; $x =~ s/\.+\/+//g;@y=split("/",$x);printf("%s",pop @y)'`
  for NUM_PROCS in $NUM_PROCS_SEQ; do
    printf "%5s %40s (%s images) ... " "($TOTAL_ATTEMPTS)" $FILE_TO_STRING $NUM_PROCS
    OUTPUT=`LD_LIBRARY_PATH=$MPI_LIB perl ../scripts/timedexec.pl $TIMEOUT \
        cafrun -n $NUM_PROCS ./$file > $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out \
        2> $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.err && echo 1 || echo -1`
    STATUS=UNKNOWN
    if [ "$OUTPUT" == "1" ]; then
      # first try unsorted
      OUTPUT=`cat ../output/CAF-should-pass/$FILE_TO_STRING.t=$NUM_PROCS.out| diff - $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out >/dev/null && echo 1 || echo 0`
      if [ "$OUTPUT" == '1' ]; then
          STATUS="PASSED"
          PASSED_COUNT=$(($PASSED_COUNT+1))
      else
          # that didn't work, so try sorted
          sort < $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out > $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out.sort
          OUTPUT=`sort ../output/CAF-should-pass/$FILE_TO_STRING.t=$NUM_PROCS.out| diff - $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out.sort >/dev/null && echo 1 || echo 0`
          if [ "$OUTPUT" == '1' ]; then
              STATUS="PASSED (when sorted)"
              PASSED_COUNT=$(($PASSED_COUNT+1))
          else
              STATUS="FAILED (wrong output)"
              FAILED_COUNT=$(($FAILED_COUNT+1))
          fi
      fi
    else
      STATUS="FAILED"
      FAILED_COUNT=$(($FAILED_COUNT+1))
    fi
    echo "[$STATUS]"
    printf "%3s %40s %s\n" $TOTAL_ATTEMPTS $FILE_TO_STRING "$STATUS" >> $RESULTS
    # kill zombie if exists
    killall -r "$file" > /dev/null 2>&1
  done
done

for file in `ls -1 bin/kernels/*.x | sort`; do
  TOTAL_ATTEMPTS=$(($TOTAL_ATTEMPTS+1))
  FILE_TO_STRING=`echo "$file" | perl -e '$x=<>; $x =~ s/\.+\/+//g;@y=split("/",$x);printf("%s",pop @y)'`
  for NUM_PROCS in $NUM_PROCS_SEQ; do
    printf "%5s %40s (%s images) ... " "($TOTAL_ATTEMPTS)" $FILE_TO_STRING $NUM_PROCS
    OUTPUT=`LD_LIBRARY_PATH=$MPI_LIB perl ../scripts/timedexec.pl $TIMEOUT \
        cafrun -n $NUM_PROCS ./$file > $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out \
        2> $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.err && echo 1 || echo -1`
    STATUS=UNKNOWN
    if [ "$OUTPUT" == "1" ]; then
      # first try unsorted
      OUTPUT=`cat ../output/CAF-kernels/$FILE_TO_STRING.t=$NUM_PROCS.out| diff - $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out >/dev/null && echo 1 || echo 0`
      if [ "$OUTPUT" == '1' ]; then
          STATUS="PASSED"
          PASSED_COUNT=$(($PASSED_COUNT+1))
      else
          # that didn't work, so try sorted
          sort < $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out > $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out.sort
          OUTPUT=`sort ../output/CAF-kernels/$FILE_TO_STRING.t=$NUM_PROCS.out| diff - $OUTDIR/$FILE_TO_STRING.t=$NUM_PROCS.out.sort >/dev/null && echo 1 || echo 0`
          if [ "$OUTPUT" == '1' ]; then
              STATUS="PASSED (when sorted)"
              PASSED_COUNT=$(($PASSED_COUNT+1))
          else
              STATUS="FAILED (wrong output)"
              FAILED_COUNT=$(($FAILED_COUNT+1))
          fi
      fi
    else
      STATUS="FAILED"
      FAILED_COUNT=$(($FAILED_COUNT+1))
    fi
    echo "[$STATUS]"
    #echo -e "$TOTAL_ATTEMPTS \t $FILE_TO_STRING \t\t\t $STATUS" >> $RESULTS
    printf "%3s %40s %s\n" $TOTAL_ATTEMPTS $FILE_TO_STRING "$STATUS" >> $RESULTS
    # kill zombie if exists
    killall -r "$file" > /dev/null 2>&1
  done
done

fi

echo "Summary of Execution Tests"
echo "Summary of Execution Tests" >> $RESULTS
printf "%d tests passed, %d tests failed\n" \
        $PASSED_COUNT $FAILED_COUNT

printf "%d tests passed, %d tests failed\n" \
        $PASSED_COUNT $FAILED_COUNT >> $RESULTS


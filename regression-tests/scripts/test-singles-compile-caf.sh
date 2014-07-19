#!/bin/bash

DATE=`date "+%s"`

# -- Phase 1 -- Compiling all single source *.caf -- #

if [ "$FC" == "" ]; then
  echo "FC (Fortran compiler) is not set"
  exit 1
fi

select="no"
if [ "$1" == "select" ]; then
    select="yes"
fi

EXE=-o

mkdir -p ./run/compile-logs
for d in `ls -d ./run/latest-compile.* 2> /dev/null`; do
    newdir=${d#"./run/latest-compile."}
    mv $d ./run/compile-logs/$newdir
done

mkdir -p ./run/bin ./run/latest-compile.$DATE > /dev/null 2>&1
mkdir -p ./run/bin/should-pass ./run/bin/kernels ./run/bin/select
cd ./run/latest-compile.$DATE

FAILED_COUNT=0
TOTAL_ATTEMPTS=0
PASSED_COUNT=0
TOTAL_TESTS=0

RESULTS=./RESULTS

PWD=`pwd`

if [ "$select" == "yes" ]; then
    TOTAL_TESTS=`find ../../cases/singles/select -name *.caf | wc -l`
else
    TOTAL_TESTS=`find ../../cases/singles/{should-pass,kernels} -name *.caf | wc -l`
fi

echo ""
echo "==========================================================="
echo "              UHCAF REGRESSION TESTS (COMPILATION)"
echo "                        $TOTAL_TESTS TESTS"
echo "==========================================================="
echo ""

if [ "$select" == "yes" ]; then

for file in `find ../../cases/singles/select/ -name *.caf | sort`; do
  TOTAL_ATTEMPTS=$(($TOTAL_ATTEMPTS+1))
  FILE_TO_STRING=`echo "$file" | perl -e '$x=<>; $x =~ s/\.+\/+//g;@y=split("/",$x);printf("%s",pop @y)'`
  _EXE="$EXE ../bin/select/$FILE_TO_STRING.x"
  printf "%5s %40s ... " "($TOTAL_ATTEMPTS)" $FILE_TO_STRING
  COMPILE_OUT=`$FC $FFLAGS $file $_EXE > /dev/null 2> ./$FILE_TO_STRING.out && echo 1 || echo -1`
  COMPILE_STATUS=undef
  if [ "$COMPILE_OUT" == 1 ]; then
    STATUS="PASSED"
    PASSED_COUNT=$(($PASSED_COUNT+1))
  else
    STATUS="FAILED"
    FAILED_COUNT=$(($FAILED_COUNT+1))
  fi
  echo "[$STATUS]"
  printf "%3s %40s %s\n" $TOTAL_ATTEMPTS $FILE_TO_STRING $STATUS >> $RESULTS
done

else

for file in `find ../../cases/singles/should-pass/ -name *.caf | sort`; do
  TOTAL_ATTEMPTS=$(($TOTAL_ATTEMPTS+1))
  FILE_TO_STRING=`echo "$file" | perl -e '$x=<>; $x =~ s/\.+\/+//g;@y=split("/",$x);printf("%s",pop @y)'`
  _EXE="$EXE ../bin/should-pass/$FILE_TO_STRING.x"
  printf "%5s %40s ... " "($TOTAL_ATTEMPTS)" $FILE_TO_STRING
  COMPILE_OUT=`$FC $FFLAGS $file $_EXE > /dev/null 2> ./$FILE_TO_STRING.out && echo 1 || echo -1`
  COMPILE_STATUS=undef
  if [ "$COMPILE_OUT" == 1 ]; then
    STATUS="PASSED"
    PASSED_COUNT=$(($PASSED_COUNT+1))
  else
    STATUS="FAILED"
    FAILED_COUNT=$(($FAILED_COUNT+1))
  fi
  echo "[$STATUS]"
  printf "%3s %40s %s\n" $TOTAL_ATTEMPTS $FILE_TO_STRING $STATUS >> $RESULTS
done

for file in `find ../../cases/singles/kernels/ -name *.caf | sort`; do
  TOTAL_ATTEMPTS=$(($TOTAL_ATTEMPTS+1))
  FILE_TO_STRING=`echo "$file" | perl -e '$x=<>; $x =~ s/\.+\/+//g;@y=split("/",$x);printf("%s",pop @y)'`
  _EXE="$EXE ../bin/kernels/$FILE_TO_STRING.x"
  printf "%5s %40s ... " "($TOTAL_ATTEMPTS)" $FILE_TO_STRING
  COMPILE_OUT=`$FC $FFLAGS $file $_EXE > /dev/null 2> ./$FILE_TO_STRING.out && echo 1 || echo -1`
  COMPILE_STATUS=undef
  if [ "$COMPILE_OUT" == 1 ]; then
    STATUS="PASSED"
    PASSED_COUNT=$(($PASSED_COUNT+1))
  else
    STATUS="FAILED"
    FAILED_COUNT=$(($FAILED_COUNT+1))
  fi
  echo "[$STATUS]"
  printf "%3s %40s %s\n" $TOTAL_ATTEMPTS $FILE_TO_STRING $STATUS >> $RESULTS
done

fi

echo "Summary of Compilation Tests"
printf "%d files passed, %d files failed\n" \
        $PASSED_COUNT $FAILED_COUNT

echo "Summary of Compilation Tests" >> $RESULTS
printf "%d files passed, %d files failed\n" \
        $PASSED_COUNT $FAILED_COUNT >> $RESULTS


#!/bin/bash
# Copyright (C) 2014 Freescale Semiconductor, Inc. All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
#    @file   tpct.sh
#
#    @brief  shell script template for "toolchain performance comparison".
#
#Revision History:
#                            Modification     Tracking
#Author                          Date          Number    Description of Changes
#WangHao                         2014/01/21        NA        performance
#-------------------------   ------------    ----------  ------------------------------------------
#
#test method
#1. run this script by tpct.sh $num
#

MEMCPY_REF=940
MEMCPY_MIN=940
WHETSTONE_REF=680.683
WHETSTONE_MAX=680.683
WHETS_NEON_REF=346.287
WHETS_NEON_MAX=346.287

MEMCPY_REF_4_6_2=954
MEMCPY_MIDDLE=954
WHETSTONE_REF_4_6_2=680.598
WHETSTONE_MIDDLE=680.598
WHETS_NEON_REF_4_6_2=346.198
WHETS_NEON_MIDDLE=346.198

MEMCPY_REF_4_7_2=1024
MEMCPY_MAX=1024
WHETSTONE_REF_4_7_2=680.555
WHETSTONE_MIN=680.555
WHETS_NEON_REF_4_7_2=345.987
WHETS_NEON_MIN=345.987
##################################################
echo "Toolchain performance comparison test cases"
echo "MEMCPY_MAX       ===========$MEMCPY_MAX"
echo "MEMCPY_MIDDLE    ===========$MEMCPY_MIDDLE"
echo "MEMCPY_MIN       ===========$MEMCPY_MIN"
echo "WHETSTONE_MAX    ===========$WHETSTONE_MAX"
echo "WHETSTONE_MIDDLE ===========$WHETSTONE_MIDDLE"
echo "WHETSTONE_MIN    ===========$WHETSTONE_MIN"
echo "WHETS_NEON_MAX   ===========$WHETS_NEON_MAX"
echo "WHETS_NEON_MIDDLE===========$WHETS_NEON_MIDDLE"
echo "WHETS_NEON_MIN   ===========$WHETS_NEON_MIN"
setup()
{
    #TODO Total test case
    export TST_TOTAL=3
    export TCID="setup"
    export TST_COUNT=0
    RC=1
    trap "cleanup" 0
}
###################################################
cleanup()
{
    RC=0
    #TODO add cleanup code here
if [ $(ls |grep  memcpy.log | wc -l) -eq 1 ];then
	cat memcpy.log
    rm ./memcpy.log
fi
if [ $(ls |grep  whets.res | wc -l) -eq 1 ];then
	cat whets.res
    rm ./whets.res
fi
if [ $(ls |grep  autu_input_test | wc -l) -eq 1 ];then
    rm ./autu_input_test
fi
	return $RC
}
##################################################
usage()
{
    echo "$0 [case ID]"
    echo "1: performance comparison for memcpybm"
	echo "2: performance comparison for whetstone"
    echo "3: performance comparison for whets_neon"
}
##################################################
test_case_01()
{
    TCID="TEST_MEMCPYBM"
    RC=1
    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "
	memcpybm > memcpy.log
	sleep 1
	MEMCPY_CURRENT=$(cat memcpy.log | grep "1024" | cut -c 19-21)
	sleep 1
	echo "MEMCPY_CURRENT====================$MEMCPY_CURRENT"
	sleep 1
	MEMCPY_TMP=$(( $MEMCPY_CURRENT - $MEMCPY_MIN ))
	echo "MEMCPY_TMP========================$MEMCPY_TMP"
	if [ $MEMCPY_TMP -ge 0 ];then
	return 0
	fi
	MEMCPY_TMP=${MEMCPY_TMP#-}
	MEMCPY_THRESHOLD=10
	if [ $MEMCPY_TMP -gt $MEMCPY_THRESHOLD ];then
	return $RC
	fi
    return 0
}
##################################################
test_case_02()
{
    TCID="TEST_WHETSTONE"
    RC=2
    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "
	echo -e "\n" > auto_input_test
	for ((i=0;i<=12;i++)); do echo -e "\n" >> autu_input_test; done
	whetstone < auto_input_test
	sleep 1
	WHETSTONE_CURRENT=$(cat whets.res | grep "Results" |cut -c 51-57 |sed -n '$p')
	sleep 1
	echo "WHETSTONE_CURRENT====================$WHETSTONE_CURRENT"
	sleep 1
    WHETSTONE_TMP=$(echo "scale=3;$WHETSTONE_CURRENT - $WHETSTONE_MIN"|bc|cut -c 0-6)
	echo "WHETSTONE_TMP========================$WHETSTONE_TMP"
	if [ `echo "$WHETSTONE_TMP > 0"|bc` -eq 1 ];then
	return 0
	fi
    WHETSTONE_TMP=${WHETSTONE_TMP#-}
	WHETSTONE_THRESHOLD=5
    if [ `echo "$WHETSTONE_TMP > $WHETSTONE_THRESHOLD"|bc` -eq 1 ];then
	return $RC
	fi
    return 0
}
##################################################
test_case_03()
{
    TCID="TEST_WHETS_NEON"
    RC=3
    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "
	echo -e "\n" > autu_input_test
	for ((i=0;i<=12;i++)); do echo -e "\n" >> autu_input_test; done
	whets_neon < auto_input_test
	sleep 1
	WHETS_NEON_CURRENT=$(cat whets.res | grep "Results" |cut -c 51-57 |sed -n '$p')
	sleep 1
	echo "WHETS_NEON_CURRENT=========================$WHETS_NEON_CURRENT"
	sleep 1
	WHETS_NEON_TMP=$(echo "scale=3;$WHETS_NEON_CURRENT - $WHETS_NEON_MIN"|bc|cut -c 0-6)
	echo "WHETS_NEON_TMP=============================$WHETS_NEON_TMP"
	if [ `echo "$WHETS_NEON_TMP > 0"|bc` -eq 1 ];then
	return 0
	fi
    WHETS_NEON_TMP=${WHETSTONE_TMP#-}
	WHETS_NEON_THRESHOLD=5
	if [ `echo "$WHETS_NEON_TMP > $WHETS_NEON_THRESHOLD"|bc` -eq 1 ];then
	return $RC
	fi
    return 0
}
# main function

RC=0

#check parameter
if [ $# -ne 1 ]
then
    usage
    exit 1
fi

setup || exit $RC

case "$1" in
1)
  test_case_01 || exit $RC
  ;;
2)
  test_case_02 || exit $RC 
  ;;
3)
  test_case_03 || exit $RC
  ;;
*)
  usage
  ;;
esac

tst_resm TINFO "Test PASS"

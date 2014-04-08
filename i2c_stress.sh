#!/bin/bash -x   
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
#WangHao                         2014/03/27     NA       stress test for i2c read and write
#-------------------------   ------------    ----------  ------------------------------------------
#
#test method
#1. run this script by i2c_stress.sh $num
#

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
	return $RC
}
##################################################
usage()
{
    echo "$0 [case ID]"
    echo "1: i2c stress test for codec"
	echo "2: i2c stress test for light sensor"
    echo "3: i2c stress test for "
}
##################################################
test_case_01()
{
    TCID="I2C BUSES STRESS READ AND WRITE"
    RC=1
    #print test info
    tst_resm TINFO "tets $TST_COUNT: $TCID "
    current_vaule=$5
for ((i=0;i<$6;i++))
do
    i2cset -f -y $2 $3 $4 $current_vaule
    sleep 1
    current_vaule=`i2cget -f -y $2 $3 $4` 
    sleep 1
if [ $5 != "$current_vaule" ];then
        return $RC
        echo error
fi
done 
    return 0
    echo right
}
##################################################
test_case_02()
{
    RC=2 
    echo just a tst
    return 0 
}
##################################################
test_case_03()
{
    echo just a tst
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
  test_case_01 $1 $2 $3 $4 $5 || exit $RC
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


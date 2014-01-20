echo "Toolchain performance comparison test cases"
MEMCPY_REF_4_8_1=940
MEMCPY_MIN=940
WHETSTONE_REF_4_8_1=680.683
WHETSTONE_MIN=680.683
WHETS_NEON_REF_4_8_1=346.287
WHETS_NEON_MIN=346.287


MEMCPY_REF_4_6_2=1020
MEMCPY_MAX=1020
WHETSTONE_REF_4_6_2=717.893 
WHETSTONE_MAX=717.893
WHETS_NEON_REF_4_6_2=346.287
WHETS_NEON_MAX=346.287


MEMCPY_REF_4_7_2=1010
MEMCPY_MIDDLE=1010
WHETSTONE_REF_4_7_2=716.893
WHETSTONE+MIDDLE=716.893  
WHETS_NEON_REF_4_7_2=345.287
WHETS_NEON_MIDDLE=345.287




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
    #################################
	###########需要在cleanup里面把log文件给cat出来##############	
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
	###################### by wh #######################
	memcpybm > memcpy.log
	sleep 1
	MEMCPY_CURRENT=$(cat memcpy.log | grep "1024" | cut -c 19-21)
	sleep 1
	echo $MEMCPY_CURRENT
	rm memcpy.log
	sleep 1
	MEMCPY_TMP=$(( $MEMCPY_CURRENT - $MEMCPY_MIN ))
	
	if [ MEMCPY_TMP -ge 0];then
	return 0
	fi 
	MEMCPY_TMP=${MEMCPY_TMP#-}	############求绝对值##############
	
	MEMCPY_THRESHOLD=10                                ##################15 is not good can change by auto#################
	if [ $MEMCPY_TMP -gt $MEMCPY_THRESHOLD ];then
	return $RC
	fi
	###################### by wh #######################
    return 0
}

##################################################
test_case_02()
{
    TCID="TEST_WHETSTONE"
    RC=2
    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "
	###################### by wh #######################	
	whetstone < auto_input
	sleep 1
	WHETSTONE_CURRENT=$(cat whets.res | grep "Results" |cut -c 51-57 |sed -n '$p')
	sleep 1
	echo "WHETSTONE_CURRENT====================$WHETSTONE_CURRENT"
	######rm memcpy.log######
	sleep 1
    WHETSTONE_TMP=$(echo "scale=3;$WHETSTONE_CURRENT - $WHETSTONE_MIN"|bc|cut -c 0-6)
	if [ $WHETSTONE_TMP -ge 0 ];then
	return 0
	fi
    WHETSTONE_TMP=${WHETSTONE_TMP#-}
	WHETSTONE_THRESHOLD=10                                ##################15 is not good can change by auto#################
    echo "WHETSTONE_TMP====================$WHETSTONE_TMP"	
    #if [$(echo "$WHETSTONE_TMP > $WHETSTONE_THRESHOLD"|bc) -eq 1 ];then
    if [ `echo "$WHETSTONE_TMP > $WHETSTONE_THRESHOLD"|bc` -eq 1 ];then
	return $RC
	fi
    ###################### by wh #######################
    return 0
}
##################################################
test_case_03()
{
    TCID="TEST_WHETS_NEON"
    RC=3
    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "
	###################### by wh #######################
	
	
	whets_neon < auto_input
	sleep 1
	WHETS_NEON_CURRENT=$(cat whets.res | grep "Results" |cut -c 51-57 |sed -n '$p')
	sleep 1
	echo "WHETS_NEON_CURRENT====================$WHETS_NEON_CURRENT"
	sleep 1
	WHETS_NEON_TMP=$(echo "scale=3;$WHETS_NEON_CURRENT - $WHETS_NEON_MIN"|bc|cut -c 0-6)
	if [ $WHETS_NEON_TMP -ge 0 ];then
	return 0
	fi
    WHETS_NEON_TMP=${WHETSTONE_TMP#-}
	WHETS_NEON_THRESHOLD=10
	echo "WHETS_NEON_TMP====================$WHETS_NEON_TMP"	
	if [ `echo "$WHETS_NEON_TMP > $WHETS_NEON_THRESHOLD"|bc` -eq 1 ];then
	return $RC
	fi
	###################### by wh #######################
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

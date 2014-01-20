echo "Toolchain performance comparison test cases"


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
	
}
##################################################
usage()
{
    echo "$0 [case ID]"
    echo "1: performance comparison for memcpybm"
	echo "2: performance comparison for whetstone"
    echo "3: performance comparison for whets_neon"	
    echo "4: concurrent memtester and CMA"	
}
##################################################
reference_table()
{
    echo "memcpy performance 1024KBytes  951MB/sec"
    echo "1: performance comparison for memcpybm"
	echo "2: performance comparison for whetstone"
    echo "3: performance comparison for whets_neon"	
    echo "4: concurrent memtester and CMA"	
}

##################################################
test_case_01()
{
    TCID="TEST_MEMCPYBM"
    RC=1
    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "
	###################### by wh #######################
	
    #nor_mtd_testapp -T RDRW -D $mtdnode -L 0x${mtdsize} -V || return $RC
	
	memcpybm 1
	
	
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
    flash_eraseall $mtdnode 
    ret=$(hexdump $mtdnode | grep ffff | wc -l)
    if [ $ret -eq 1 ]; then
        RC=0
    fi
    return $RC
}
##################################################
test_case_03()
{
    TCID="TEST_WHETS_NEON"
    RC=3
    #print test info
    tst_resm TINFO "test $TST_COUNT: $TCID "
    echo "nor performance test"
    nor_mtd_testapp -T PERFORM -D $mtdnode -V || return $RC
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
  test_case_08 || exit $RC
  ;;
*)
  usage
  ;;
esac

tst_resm TINFO "Test PASS"
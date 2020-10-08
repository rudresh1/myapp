# clean previous output files
rm -f test/report/output.xml
rm -f test/report/rerun.xml
rm -f test/report/first_run_log.html
rm -f test/report/second_run_log.html
rm -f test/report/selenium-screenshot-*.png
 
echo
echo "#######################################"
echo "# Running Test Case for a first time      #"
echo "#######################################"
echo

robot $@
# -v loginIP:10.45.1.133 -v browser:chrome -v remoteMachineIp:10.45.1.15 test/testCase/BulkUploadTestCase.robot
 
# we stop the script here if all the tests were OK
if [ $? -eq 0 ]; then
	echo "we don't run the tests again as everything was OK on first try"
	exit 0	
fi
# otherwise we go for another round with the failing tests
 
# we keep a copy of the first log file
cp log.html  test/report/first_run_log.html
 
# we launch the tests that failed
echo
echo "#######################################"
echo "# Running again the tests that failed #"
echo "#######################################"
echo

robot --nostatusrc	--rerunfailed test/report/output.xml --output test/report/rerun.xml $@
# -v loginIP:10.45.1.133 -v browser:chrome -v remoteMachineIp:10.45.1.15 test/testCase/BulkUploadTestCase.robot
# pybot --outputdir output --nostatusrc --rerunfailed output/output.xml --output rerun.xml $@
# Robot Framework generates file rerun.xml
 
# we keep a copy of the second log file
cp log.html  test/report/second_run_log.html
 
# Merging output files
echo
echo "########################"
echo "# Merging output files #"
echo "########################"
echo
rebot --nostatusrc --outputdir test/report --output output.xml --merge test/report/output.xml  test/report/rerun.xml
# # Robot Framework generates a new output.xml
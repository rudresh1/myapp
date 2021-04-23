

================= Installation and config steps for Robot FrameWork ==========	

pip install robotframework
	or
	pip install --no-cache-dir robotframework
	pip uninstall robotframework
	check  --> robot --version
	pip install --upgrade robotframework

	to install specific version
	pip install robotframework==2.9.2

check robot framework installed properly
	pip freeze
	pip list
	pip show robotframework
	pip check robotframework



Env setup

pip install --upgrade robortframework-seleniumlibrary

https://github.com/robotframework/SeleniumLibrary/

downlode crome driver and placed in :  
C:\Users\Jalaja\AppData\Local\Programs\Python\Python38-32\Scripts

env path set

=======

==================How to Run Test Cases =================

1. unzip the primeu

	Copy the "primeus" project folder to your PC  >> in my case it is...
	C:\Users\Jalaja\git\primeus


2. Copy the file "PythonKeywords" in  "\primeus\test\keyword\    TO >> Python Lib folder, in my case it is....
   	C:\Users\Jalaja\AppData\Local\Programs\Python\Python38-32\Lib\site-packages

3. Open the Command prompt
	CD to location where test suite there.... in my case ........
	cd C:\Users\Jalaja\git\primeus\test\testCase
4. cmds to execute test cases
 	#execute all tests in all robot files in current folder and subfolders....
    robot .
	    
	# execute all tests in single robot file in current folder (executes Test Suite AbdominalTestCase.robot)
    robot AbdominalTestCase.robot

	# execute all tests in single robot file in subfolder
    robot path/to/example.robot
	
	# Execute test cases by test name
		To run test cases with specific test name use --test or -t option:
    	# execute test cases with name "Example" in any file.
    robot --test Example .

	# execute test cases with name "Example" in specific file.
    robot --test Example example.robot

	# execute test cases containing name "Example" in any file.
    robot --test *Example* .

	# execute test cases "Example One" and "Example Two" in any file.
    robot --test "Example [One|Two]" .



	
	
----------Execute failed tests--------

	# execute test cases failed in previous run (saved in output.xml). To rerun failed test cases use --rerunfailed or -R option:		
    robot --rerunfailed output.xml .    


	# To rerun test suites with failed test cases use --rerunfailedsuites or -S option:
	execute test cases with failed test cases in previous run (saved in output.xml)
    robot --rerunfailedsuites output.xml .    



*** Settings ***
Library    PythonKeywords
Library    SeleniumLibrary
Resource    ../pages/PageObject.robot

Suite Setup       Open My Browser    ${url}     ${browser}     ${remoteMachineIp}
Suite Teardown    Close Browsers
                                                                                      
*** Variables ***
${url}    qa.smartmedsolution.com/login
${browser}    chrome
${remoteMachineIp}


*** Test Cases ***

Abdominal Test Case
    Log   =========== Abdominal Test Case===========    console=yes  
    ${all data members}=    Get Test Data With Filter    AbdominalTestcaseData2
    ${common}=    Set Variable    @{all data members}[0]
    
    Login To Application    ${common['username']}    ${common['password']}
    Select The Ultrasound Room    ${common['ultrasoundRoom']}
    Select Room    ${common['rooms']}
    Goto Workshop
    Verify Header and Page List
    Selecting The Page    ${common['pageName']}
    # FOR    ${member}    IN    @{all data members}    
        # # Fill The General Information Form    ${member['GeneralDetails']}
        # # Fill Clinical Hx In Abdominal    ${member}    
        # # Fill Findings in Abdominal    ${member} 
        # # Fill Conclusion in Adbominal    ${member} 
        # # Click On Graphic Tab
        # # Click On Nothing To Indicate
        # # Click pause
        
        # # #Click Preview
        # # sleep    10
        # #Scroll Element Into View    id=review-checkbox
        # #Wait Until Element Is Enabled    id=review-checkbox 
        # #Click Element    id=review-checkbox       
        
        
    # END
    
   
    

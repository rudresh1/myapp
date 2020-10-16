*** Settings ***
Library    PythonKeywords
Library    SeleniumLibrary
Resource    ../pages/PageObject.robot

Suite Setup       Open My Browser    ${url}     ${browser}     ${remoteMachineIp}
Suite Teardown    Close Browsers
Test Template    Worksheets Url Test Case                                                                                      
*** Variables ***
${url}    dev.smartmedsolution.com/login
${browser}    chrome
${remoteMachineIp}


*** Test Cases ***
Worksheets Url        worksheets
   
     


*** Keywords ***

 Worksheets Url Test Case
    [Arguments]    ${testFileName}
    sleep    2
    ${all data members}=    Get Test Data With Filter    ${testFileName}
    ${member}=    Set Variable    ${all data members}[0]
    
    Login To Application    ${member['username']}    ${member['password']}
    Goto Workshop 
    FOR    ${pageName}    IN    @{member['pageNames']}
        Selecting The Page    ${pageName}
        sleep    5
        Goto Workshop 
        
    END
    LogOut From Application
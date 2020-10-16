*** Settings ***
Library    PythonKeywords
Library    SeleniumLibrary
Library    String
Resource    ../pages/PageObject.robot
Resource    ../pages/Abdominal.robot

Suite Setup       Open My Browser    ${url}     ${browser}     ${remoteMachineIp}
Suite Teardown    Close Browsers
Test Template    Shoulder Test Case
*** Variables ***
${url}    dev.smartmedsolution.com/login
# ${url}    qa.smartmedsolution.com/login
${browser}    chrome
${remoteMachineIp}

*** Test Cases ***
Right Shoulder    RightShoulder
    
Left Shoulder    LeftShoulder

Right Shoulder Option2      RightShoulderOption2  

        
    
*** Keywords ***

Shoulder Test Case
    [Arguments]    ${testFileName}
    Log   =========== Abdominal Test Case===========     DEBUG    console=yes 
    ${all data members}=    Get Test Data With Filter    ${testFileName}
    ${member}=    Set Variable    ${all data members}[0]
    
    Login To Application    ${member['username']}    ${member['password']}
    # sleep        30
    # Select The Ultrasound Room    ${member['ultrasoundRoom']}
    # sleep        30
    # Select Room    ${member['rooms']}
    # sleep     30
    ${Preview Complete} =	Get Substring	${TEST_NAME}    -16
    Log    ${Preview Complete}    DEBUG    console=yes
    Goto Workshop
    sleep    2
    # Verify Header and Page List
    sleep    2
    Selecting The Page    ${member['pageName']}
    sleep     2
        
    Fill The General Information    ${member['GeneralDetails']}
   
    Fill Clinical Hx In Shoulder    ${member['clinicalHx']}  
    
    # Fill Findings in Abdominal    ${member['findings']} 
    Fill Side selection in Shoulder   ${member['side Selection']} 
    
    Fill Comment in Adbominal    ${member['conclusions']} 
    
    Click On Graphic Tab
    
    Click On Nothing To Indicate
    sleep    5
    
           
    run keyword if   "${Preview Complete}" == "Preview Complete"    Run Keywords   Click Preview and Complete    Click Confirm and Complete
    run keyword if  "${Preview Complete}" != "Preview Complete"    Click Pause
    
    # need to achieve below
    #Click Preview
    sleep   50 
    Wait Until Element Is Visible     class:profile-info 
    #Scroll Element Into View    id=review-checkbox
    #Wait Until Element Is Enabled    id=review-checkbox
    #Click Element    id=review-checkbox
        
    LogOut From Application
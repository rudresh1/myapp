*** Settings ***
Library    PythonKeywords
Library    SeleniumLibrary
Library    String
Resource    ../pages/PageObject.robot
Resource    ../pages/Abdominal.robot

Suite Setup       Open My Browser    ${url}     ${browser}     ${remoteMachineIp}
Suite Teardown    Close Browsers
Test Template    Abdominal Test Case
*** Variables ***
${url}    dev.smartmedsolution.com/login
# ${url}    qa.smartmedsolution.com/login
${browser}    chrome
${remoteMachineIp}

*** Test Cases ***
All Field Nad    AllNad

All Field Nad And Size    AllNadWithSize
    
All Field Nad and NM      AllNadWithNm
    
All Field Nad NM and ROI    AllNadWithNmRoi
    
All Field Nad Size and ROI    AllNadWithSizeRoi
    
All Field Comments with 1st Options Mandatory    AllCommentsWith1OptionMandatory  
    
All Field Comments with 2st Options Mandatory    AllCommentsWith2OptionMandatory
    
All Field Comments with 3rd Options Mandatory    AllCommentsWith3OptionMandatory 
    
All Field Comments with last Options Mandatory    AllCommentsWithLastOptionMandatory
    
All CheckBoxes with 1st Option and TextAreea    AllCheckboxesWith1OptionandTextArea
    
All CheckBoxes with last Option and TextArea    AllCheckboxesWithLastOptionandTextArea
    

    
All Field Nad Preview Complete   AllNad
    
All Field Nad And Size Preview Complete         AllNadWithSize
 
All Field Nad and NM Preview Complete      AllNadWithNm
    
All Field Nad NM and ROI Preview Complete    AllNadWithNmRoi
    
All Field Nad Size and ROI Preview Complete   AllNadWithSizeRoi
    
All Field Comments with 1st Options Mandatory Preview Complete    AllCommentsWith1OptionMandatory  
    
All Field Comments with 2st Options Mandatory Preview Complete    AllCommentsWith2OptionMandatory
    
All Field Comments with 3rd Options Mandatory Preview Complete    AllCommentsWith3OptionMandatory 
    

    
All Field Nad For Renal   RenalAllNad
    
All Field Nad And Size For Neck    NeckAllNadWithSize 
        
    
*** Keywords ***

Abdominal Test Case
    [Arguments]    ${testFileName}
    Log   =========== Abdominal Test Case===========    console=yes  
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
    # Verify Header and Page List
    sleep    2
    Selecting The Page    ${member['pageName']}
    sleep     2
        
    Fill The General Information    ${member['GeneralDetails']}
   
    Fill Clinical Hx In Abdominal    ${member['clinicalHx']}  
    
    Fill Findings in Abdominal    ${member['findings']} 
    
    Fill Comment in Adbominal    ${member['conclusions']} 
    
    Click On Graphic Tab
    
    Click On Nothing To Indicate
    sleep    5
    
           
    run keyword if   "${Preview Complete}" == "Preview Complete"    Run Keywords   Click Preview and Complete    Click Confirm and Complete
    run keyword if  "${Preview Complete}" != "Preview Complete"    Click Pause
    
    # need to achieve below
    #Click Preview
    sleep   100 
    Wait Until Element Is Visible     class:profile-info 
    #Scroll Element Into View    id=review-checkbox
    #Wait Until Element Is Enabled    id=review-checkbox
    #Click Element    id=review-checkbox
        
    LogOut From Application
    
   
Renal Test Case
    [Arguments]    ${testFileName}
    Log   =========== Renal Test Case===========    console=yes  
    ${all data members}=    Get Test Data With Filter    ${testFileName}
    ${member}=    Set Variable    ${all data members}[1]
    
    Login To Application    ${member['username']}    ${member['password']}
    # sleep        30
    # Select The Ultrasound Room    ${member['ultrasoundRoom']}
    # sleep        30
    # Select Room    ${member['rooms']}
    # sleep     30
    Goto Workshop
    # Verify Header and Page List
    sleep     10
    Selecting The Page    ${member['pageName']}
    sleep     10
        
    Fill The General Information    ${member['GeneralDetails']}
   
    Fill Clinical Hx In Abdominal    ${member['clinicalHx']}  
    
    Fill Findings in Abdominal    ${member['findings']} 
    
    Fill Conclusion in Adbominal    ${member['conclusions']} 
    
    Click On Graphic Tab
    
    Click On Nothing To Indicate
    sleep    20
    Click pause
    
    # need to achieve below
    #Click Preview
    sleep   100 
    #Scroll Element Into View    id=review-checkbox
    #Wait Until Element Is Enabled    id=review-checkbox
    #Click Element    id=review-checkbox
        
    LogOut From Application
    
    

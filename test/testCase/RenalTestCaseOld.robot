*** Settings ***
Library    PythonKeywords
Library    SeleniumLibrary
Resource    ../pages/PageObject.robot
Resource    ../pages/Renal.robot
Resource    ../pages/Neck.robot
Suite Setup       Open My Browser    ${url}     ${browser}     ${remoteMachineIp}
Suite Teardown    Close Browsers
Test Template    Neck Test Case
*** Variables ***
${url}    dev.smartmedsolution.com/login
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
    
All Field Nad For Renal   RenalAllNad
    


    
All Field Nad And Size For Renal    RenalAllNadWithSize 
    
All Field NA For Renal    RenalALLNA
    
All Field Nad and ROI For Renal    RenalAllNadWithRoi
    
All CheckBoxes with last Option and TextArea For Renal    RenalAllCheckboxesWithLastOptionandTextArea
 
All Field Comments with 1st Options For Renal    Renal1Option
    
All Field Comments with 2st Options For Renal    Renal2Option
    
All Field Comments with 3rd Options For Renal    Renal3Option        
    
*** Keywords ***

Neck Test Case
    [Arguments]    ${testFileName}
    Log   =========== Neck Test Case===========    console=yes  
    ${all data members}=    Get Test Data With Filter    ${testFileName}
    ${member}=    Set Variable    ${all data members}[0]
    
    Login To Application    ${member['username']}    ${member['password']}
    # sleep        30
    # Select The Ultrasound Room    ${member['ultrasoundRoom']}
    # sleep        30
    # Select Room    ${member['rooms']}
    # sleep     30
    Goto Workshop
    # Verify Header and Page List
    sleep     2
    Selecting The Page    ${member['pageName']}
    sleep     3
        
    Fill The General Information     ${member['GeneralDetails']}
   
    Fill Clinical Hx     ${member['clinicalHx']}  
    
    Fill Findings     ${member['findings']} 
    
    Fill Conclusion    ${member['conclusions']} 
    
    Click On Graphic Tab 
    
    Click On Nothing To Indicate 
    sleep    10
    Click pause
    
    # need to achieve below
    #Click Preview
    sleep   100 
    #Scroll Element Into View    id=review-checkbox
    #Wait Until Element Is Enabled    id=review-checkbox
    #Click Element    id=review-checkbox
        
    LogOut From Application
    
   


    

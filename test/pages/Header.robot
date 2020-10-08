*** Settings ***
Library    SeleniumLibrary 
Resource    PageObject.robot  

*** Variable ***
${patientNameLoc}    (//table[@id='bcknd_attendee_datatable']//tr[.//span[contains(translate(text(),"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz"),
${logOutLoc}    (//div[@class='headerbar-right']//li[contains(.,'Logout')])[2]
*** Keywords ***

LogOut From Application
    Log    Loging Out of Application    DEBUG    console=yes
    Wait Until Element Is Enabled     class:profile-info    120
    Click Element    class:profile-info
    Wait Until Element Is Enabled    ${logOutLoc}    
    Click Element   ${logOutLoc}    
    Wait Until Element Is Enabled    id:username    error=Not Able to Logout
    
Goto Home
    Log    Goto Home Page
    Click Element    link:Home    
    
Goto Workshop
    Log    Goto Workshop    DEBUG    console=yes
    Wait Until Element Is Enabled     link:Worksheets    120
    Click Element    link:Worksheets    
    
Click Resume
    [Documentation]    Resume the patient record 
    Click Elements    link:Resume
    
Click Pause
    [Documentation]    Click Save/Pause Button
    Click Element With Log Display    //li[(normalize-space()='Pause')]/button    Pause

Click Preview and Complete
    [Documentation]    Click Preview/complete Button
    Click Element With Log Display    //li[(normalize-space()='Preview & Complete')]/button    Preview & Complete    
    sleep     3
Click Preview
    [Documentation]    Click Preview Button
    Click Element With Log Display    //li[(normalize-space()='Preview')]/button    Preview
    
Click DICOM Viewer
    [Documentation]    Click DICOM Viewer Button
    Click Element With Log Display    //li[(normalize-space()='DICOM Viewer')]/button    DICOM Viewer
    
Click Reset
    [Documentation]    Click Reset Button
    Click Element With Log Display    //li[(normalize-space()='Reset')]/button    Reset   

Click Import DICOM
    [Documentation]    Click Reset Button
    Click Element With Log Display    //li[(normalize-space()='Import DICOM')]/button    Import DICOM
    
Click Exit
    [Documentation]    Click Reset Button
    Click Element With Log Display    //li[(normalize-space()='Exit')]/button    Exit 

Click Resume For Patient
    [Arguments]    ${firstname}    ${lastname}    
    ${patentName}    Set Variable    ${firstname} ${lastname}
        Wait Until Keyword Succeeds    2 min    5 sec    Click Element With Log Display    ${patientNameLoc}"${patentName}")]]//a)[1]    ${patentName}

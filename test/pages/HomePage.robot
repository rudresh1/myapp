*** Settings ***
Documentation    Custom Keywords for Logpoint
Library    String
Library    SeleniumLibrary    
Library    OperatingSystem 
Resource    PageObject.robot

*** Variable ***
${testsRootFolder}    ${EXECDIR}/test/driver/
${selectRoom}    //button[contains(text(), 'Select Room')]

*** Keywords ***

Select The Ultrasound Room
    [Documentation]    Selecting Ultrasound Room
    [Arguments]    ${roomName}
    Log    Selecting Ultrasound Room as '${roomName}'    DEBUG    console=yes
    Wait Until Element Is Enabled    id:room-select-from-popup    60
    Select From List By Label    id:room-select-from-popup    ${roomName}       
    Click Button     //button[text()='Select']
    Verify Room Tab Is Displayed    ${roomName}    
    
Verify Room Tab Is Displayed
    [Documentation]    Verify tab with room name is displayed
    [Arguments]    ${roomNameOnTab}    
    ${roomNameOnTab}    Convert To Uppercase    ${roomNameOnTab}
    Log    Verify '${roomNameOnTab}' Tab is displayed.    DEBUG    console=yes        
    Wait Until Element Is Enabled    //ul[@data-toggle='tabs']//li/a[text()='${roomNameOnTab}']    60    

Select Room
    [Documentation]    Select Room/s
    [Arguments]    ${rooms}
    Log    Selecting Rooms: @{rooms}    DEBUG    console=yes
    Wait Until Element Is Enabled    ${selectRoom}    60    
    Click Button     ${selectRoom} 
    FOR    ${room}    IN    @{rooms}
        Click Element      //ul[@class='dropdown-menu']//span[contains(text(),'${room}')] 
    END   

Select Patient From Table List 
    [Documentation]    Edit form by patient Name and their RIS status
    [Arguments]    ${patientName}    ${risStatus}  
    Click Element    (//table[@id='bcknd_attendee_datatable']//tr[.//span[@class='badge']]//a/span[text()='${patientName}'])[last()]
    

  
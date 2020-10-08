*** Settings ***
Documentation    Custom Keywords for Logpoint
Library    String    
Library    SeleniumLibrary  
Library    Collections    
Library    OperatingSystem 
Resource    PageObject.robot


*** Variable ***


*** Keywords ***


Selecting The Page
    # [Documentation]     General Ultrasound,Abdominal US page
    [Documentation]     General Ultrasound,Renal page
    [Arguments]    ${pageName}
    Log    Navigating to page '${pageName}'    DEBUG    console=yes
    Wait Until Element Is Enabled    //*[@id="ultrasound-tab"]//a[./div[contains(text(),'${pageName}')]]    60  
    sleep     5  
    Click Element      //*[@id="ultrasound-tab"]//a[./div[contains(text(),'${pageName}')]]


Verify Ultrasound List
    [Documentation]    Verify lists of given Ultrasound section
    [Arguments]    ${sectionName}    ${list}
    ${listOfNames}    Get Text    //div[@id='ultrasound-tab']//div[./h4[text()='${sectionName}']]
    @{cnt}=    Get Element Count    //div[@id='ultrasound-tab']//div[./h4[text()='${sectionName}']]
    # @{stringList}    BuiltIn.Convert To List    ${list}
    Lists Should Be Equal    ${listOfNames}    ${list}    
    Log   ${listOfNames}    DEBUG    console=yes
    
Verify Header and Page List
    [Documentation]    Verify Page list header and their list of page are available correctly.
    Wait Until Element Is Enabled    //div[@class='card-body']    300
    ${all data members}=    Get Test Data With Filter    VerifySelectPageList
    FOR    ${member}    IN    @{all data members}
        Verify Page List Under Each Header Section    ${member}
    END

Verify Page List Under Each Header Section
    [Documentation]    Verify lists Page under each page header section
    [Arguments]    ${member}
    Log    Verifying Page Title '${member['Title']}' contain page names: '${member['Value']}'    DEBUG    console=yes 
    Sleep    5    
   
    ${cnt}=    Get Element Count    //div[@id='ultrasound-tab']//div[./h4[text()='${member['Title']}']]//a
    ${sectionNameCount}    Get Length    ${member['Value']}
    Should Be Equal As Integers    ${cnt}    ${sectionNameCount}    Ultrasound section list count is Does not matched.
    FOR    ${pageName}    IN    @{member['Value']}
       Wait Until Element Is Enabled    //div[@id='ultrasound-tab']//div[./h4[text()='${member['Title']}']]//li[contains(*,'${pageName}')]
    END



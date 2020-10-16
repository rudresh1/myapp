*** Settings ***
Documentation    Custom Keywords for Logpoint
Library    Collections
Library    String
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime
Resource    ../pages/PageObject.robot

*** Variable ***

*** Keywords ***

Click Elements
    [Documentation]    Click List of Elements Found By locator in a page
    [Arguments]    ${locator}
    @{elementList}    Get WebElements    ${locator}
    FOR    ${element}    IN    @{elementList}
        Click Element    ${element}
    END

Click Using JavaScript
    [Documentation]    Click DOM Element By Id using javascript. Element id is search using Xpath
    [Arguments]    ${locator}
    ${elementId}    Get Element Attribute    ${locator}    id
    Execute Javascript    document.getElementById('${elementId}').click()

Refresh If Element Not Visiable
    [Arguments]    ${location}
    Run Keyword And Ignore Error    Wait Until Keyword Succeeds    3x    2    Wait Until Element Is Enabled    ${location}    30
    ${elementCount}    Get Element Count    ${location}
    Run Keyword If    ${elementCount} <1   Run Keywords
    ...    Reload Page
    ...    AND    Wait Until Keyword Succeeds    4x    2    Wait Until Element Is Enabled    ${location}    30

Click And Wait For Element
    [Documentation]    Click Element and Wait for Another Element is to Appear
    [Arguments]    ${clickElementLocator}    ${waitElementLocator}
    Wait Until Element Is Enabled    ${clickElementLocator}    30
    Click Element    ${clickElementLocator}
    Run Keyword And Ignore Error    Wait Until Element Is Visible     ${waitElementLocator}    30
    Refresh If Element Not Visiable     ${waitElementLocator}
    Wait Until Element Is Visible     ${waitElementLocator}    30

Click Element With Retry
    [Documentation]    Clicks element and if element is still present, clicks again using Javascript
    [Arguments]    ${locator}
    Wait Until Element Is Enabled    ${locator}    15
    Click Element    ${locator}
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Not Visible    ${locator}    30      
    Run Keyword Unless    ${status}    Click Using Javascript    ${locator}

Click Untill Element Appear
    [Documentation]    Click Element Multiple time Untill Another Element is not Appear
    [Arguments]    ${clickElementLocator}    ${waitElementLocator}    ${attemptNumber}
    Wait Until Keyword Succeeds    ${attemptNumber}x    10    Click And Wait Element    ${clickElementLocator}    ${waitElementLocator}
    
Click And Wait Element
    [Documentation]    Click Element and Wait for Another Element is to Appear
    [Arguments]    ${clickElementLocator}    ${waitElementLocator}
    Wait Until Element Is Enabled    ${clickElementLocator}    30
    Click Element    ${clickElementLocator}
    Run Keyword And Ignore Error    Wait Until Element Is Visible     ${waitElementLocator}    30
    Refresh If Element Not Visiable     ${waitElementLocator}
    Wait Until Element Is Visible     ${waitElementLocator}    30

Click Element With Log Display
    [Documentation]    For Clicking element and displaying log    
    [Arguments]    ${location}    ${elementName}
    Log    Clicking on '${elementName}'    DEBUG    console=yes
    Click Element    ${location}

Input Text With Log Display
    [Documentation]    For Input element value and displaying log 
    [Arguments]     ${locator}    ${elementText}    ${fieldName} 
    Log    Entering '${fieldName}' field value as:${elementText}     DEBUG    console=yes
    Clear Element Text    ${locator}
    Input Text    ${locator}   ${elementText}


Select Value For Field
    [Documentation]    Click Yes radio option for given field
    [Arguments]    ${fieldName}    ${value}
    ${location}    Set Variable    (//tr[@note-structure="${fieldName}"]//label[span[text()='${value}']])[1]
    Scroll Element Into View    ${location}
    Click Element With Log Display    ${location}    Selecting '${value}' for field '${fieldName}'    
    

Enter Date In Sub-Field
    [Documentation]    Enter date in sub field
    [Arguments]    ${fieldName}    ${dateString}
    Log    Enter Date as '${dateString}' for field named ${fieldName}
    Input Text    //tr[@note-structure='${fieldName}']//input[@placeholder="-- Date --"]    ${dateString}
    Click Element    //tr/td[text()='${fieldName}']
    
Enter Text On Field
    [Documentation]    Input text for field.
    [Arguments]    ${field}    ${value}
    Input Text    (//tr[@note-structure="${field}"]//textarea)[last()]    ${value}  

 
Select Dropdown By Text
    [Documentation]    Select multiple dropdown option from Dropdown box \n
    ...    ${fieldName}    Field Name where dropdown option is avaiable\n
    ...    ${dropdownName}    Dropdown placeholder name text. It's text that can seen in graycolor inside dropdown box.\n
    ...    ${optionTextList}    List of option seperated by common to be selected.\n
    ...    Example:    Select Dropdown By Text    Comparison    ---Modality---    X-ray,Unsure,Unknown     
    [Arguments]     ${fieldName}    ${dropdownName}    ${optionTextList}
    @{optionTextArray}    Split String    ${optionTextList}    ,    
    FOR    ${optionText}    IN    @{optionTextArray}
        Log    Selecting ${optionText} option in ${dropdownName} dropdown for ${fieldName} field    DEBUG    console=yes    
        Click Element    //tr[@note-structure='${fieldName}']//div[@class='form-group multiSel' and .//select[@data-placeholder='${dropdownName}']]//input 
        Click Element    //div[contains(@class,'select2-drop-multi')]//li[contains(*,'${optionText}')]
        Wait Until Element Is Visible    //tr[@note-structure='${fieldName}']//div[@class='form-group multiSel' and .//select[@data-placeholder='${dropdownName}']]//div[text()='${optionText}']    60
    END   
    Click Element    //tr/td[text()='${fieldName}']     

Toggle Field
    [Documentation]    Toggle checkbox
    [Arguments]    ${field}    ${checkBoxName}    ${checkOption}
    ${chkBoxLocator}    Set Variable    (//tr[@note-structure='${field}']//label[./input[@value='${checkBoxName}'] and contains(@class,'checkbox-styled')])[1]
    ${checkedCount}    Get Element Count    (//tr[@note-structure='${field}']//label[./input[@value='${checkBoxName}'] and (contains(@class,'sec-red-class') or contains(@class,'active-radio'))])[1]
    ${checkOption}    Convert To Lower Case    ${checkOption}
   
    Scroll Element Into View    ${chkBoxLocator}

    Run Keyword If    "${checkOption}"=="true" and ${checkedCount}<1    Run keywords
    ...    Log    Checking ${checkBoxName} option for ${field} field    DEBUG    console=yes
    ...    AND    Click Element    ${chkBoxLocator}
    ...    ELSE IF    "${checkOption}"=="false" and ${checkedCount}>0    Run keywords
    ...    Log    Un-Checking ${checkBoxName} option for ${field} field    DEBUG    console=yes
    ...    AND    Click Element    ${chkBoxLocator}
     
Toggle List Of Fields             
    [Documentation]    Toggle multiple checkbox list \n
    ...    ${checkBoxName}    List of check box name seperated by comma
    [Arguments]    ${field}    ${checkBoxNameList}    ${checkOption}
    @{listOfCheckbox}    Split String    ${checkBoxNameList}    ,
    FOR    ${checkBoxName}    IN    @{listOfCheckbox}    
        Toggle Field    ${field}    ${checkBoxName}    ${checkOption}
    END
    

Enter Size In Sub-Field
    [Documentation]    Enter size for given sub field
    [Arguments]    ${fieldName}    ${size}
    Log    Enter size as '${size}' for field named ${fieldName}
    Input Text    //tr[@note-structure="${fieldName}"]//div/span[contains(text(),'Size')]/following-sibling::input    ${size}
   
    



    
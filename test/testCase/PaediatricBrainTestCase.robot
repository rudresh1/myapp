*** Settings ***
Library    PythonKeywords
Library    SeleniumLibrary
Library    String
Resource    ../pages/PageObject.robot
Resource    ../pages/Abdominal.robot

# Suite Setup       Open My Browser    ${url}     ${browser}     ${remoteMachineIp}
# Suite Teardown    Close Browsers
Test Template    PaediatricBrain Test Case
*** Variables ***
${url}    dev.smartmedsolution.com/login
# ${url}    qa.smartmedsolution.com/login
${browser}    chrome
${remoteMachineIp}

*** Test Cases ***
All Field NA    BrainAllNa

All Field Nad    BrainAllNad
    
# All Field Nad With No Enlarged LN    AllNadWithNoEnlargedLN 
    
# All Field Nad With Size And No Enlarged LN   AllNadWithSizeAndNoEnlargedLN  

# All Field Nad And Size    AllNadWithSize
    
# All Field Nad and NM      AllNadWithNm
    
# All Field Nad NM and ROI    AllNadWithNmRoi
    
# All Field Nad Size and ROI    AllNadWithSizeRoi

    
# All Field Comments with 1st Options Mandatory    AllCommentsWith1OptionMandatory  
    
# All Field Comments with 2st Options Mandatory    AllCommentsWith2OptionMandatory
    
# All Field Comments with 3rd Options Mandatory    AllCommentsWith3OptionMandatory 
    
# All Field Comments with last Options Mandatory    AllCommentsWithLastOptionMandatory
    
# All CheckBoxes with 1st Option and TextAreea    AllCheckboxesWith1OptionandTextArea
    
# All CheckBoxes with last Option and TextArea    AllCheckboxesWithLastOptionandTextArea
    

All Field NA Preview Complete   BrainAllNa
        
All Field Nad Preview Complete   BrainAllNad
    

# All Field Nad And Size Preview Complete         AllNadWithSize
 
# All Field Nad and NM Preview Complete      AllNadWithNm
    
# All Field Nad NM and ROI Preview Complete    AllNadWithNmRoi
    
# All Field Nad Size and ROI Preview Complete   AllNadWithSizeRoi
    
# All Field Comments with 1st Options Mandatory Preview Complete    AllCommentsWith1OptionMandatory  
    
# All Field Comments with 2st Options Mandatory Preview Complete    AllCommentsWith2OptionMandatory
    
# All Field Comments with 3rd Options Mandatory Preview Complete    AllCommentsWith3OptionMandatory 

# All CheckBoxes with 1st Option and TextAreea Preview Complete   AllCheckboxesWith1OptionandTextArea    

    
# All Field Nad For Renal   RenalAllNad
    
# All Field Nad And Size For Neck    NeckAllNadWithSize 
        
    
*** Keywords ***

PaediatricBrain Test Case
    [Arguments]    ${testFileName}    ${credentials}=${None}
    Log   =========== PaediatricBrain Test Case===========     DEBUG    console=yes
    # ${common}    Get File    test\\testData\\credentials.json
    # ${common1}=     Convert To Upper Case    ${common}   
    # Log    ${common1}    console=yes
    Open My Browser    ${url}     ${browser}     ${remoteMachineIp} 
    ${all data members}=    Get Test Data With Filter    ${testFileName}
    ${member}=    Set Variable    ${all data members}[0]
    # ${credentials}=    Get Test Data With Filter    ${credentials}
    ${credentials}=    Run Keyword If    '${credentials}' != '${None}'    Get Test Data With Filter    ${credentials}
       
    Run Keyword If    ${credentials}    Login To Application    ${credentials['username']}    ${credentials['password']}
    ...    ELSE
    ...    Login To Application    ${member['username']}    ${member['password']}
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
    # sleep    2
    Selecting The Page    ${member['pageName']}
    Wait Until Element Is Not Visible     class:loader    
        
    Fill The General Information    ${member['GeneralDetails']}    ${testFileName}

   
    Fill Clinical Hx In Abdominal    ${member['clinicalHx']}
    
       
    
    Fill Findings in Abdominal    ${member['findings']} 
    
    Fill Comment in Adbominal    ${member['conclusions']} 
    
    Click On Graphic Tab
    
    Click On Nothing To Indicate
    sleep    5
    
    Worksheet Submit    ${Preview Complete}       

    sleep   20 
    Wait Until Element Is Visible     class:profile-info
    Wait Until Element Is Not Visible     class:modal-body    60 
    Wait Until Element Is Not Visible     class:loader    60
    Wait Until Element Is Not Visible     class:modal-body     60
    Wait Until Element Is Not Visible     class:loader     60
    

        
    LogOut From Application
    Close Browsers 
Fill Findings
    [Arguments]    ${findingName}    ${state}    ${scenario}
    # sleep    1
    Run keyword if    "${findingName}" =="Lymph nodes" and ("${scenario}"=="AllNadAndNoEnlargedLN" or "${scenario}"=="AllNadWithSizeAndNoEnlargedLN") and ("${state}"=="green" or "${state}"=="grey")     Run Keywords
    ...    Scroll Element Into View    xpath=(//tr[@note-structure="${findingName}"]/descendant::label[./input[@type='radio' and @state='green']])[2]
    ...    AND
    ...    sleep    1
    ...    AND
    ...    Click Element    xpath=(//tr[@note-structure="${findingName}"]/descendant::label[./input[@type='radio' and @state="green"]])[2]
    ...    ELSE IF    "${findingName}" =="Other findings" and "${state}"=="grey"     Run Keywords
    ...    Scroll Element Into View    xpath=(//tr[@note-structure="${findingName}"]/descendant::label[./input[@type='radio' and @state='green']])[1]
    ...    AND
    ...    Click Element    xpath=(//tr[@note-structure="${findingName}"]/descendant::label[./input[@type='radio' and @state="green"]])[1]
    ...    ELSE    Run Keywords   
    ...    Scroll Element Into View    xpath=(//tr[@note-structure="${findingName}"]/descendant::label[./input[@type='radio' and @state='${state}']])[1]
    ...    AND
    ...    Click Element    xpath=(//tr[@note-structure="${findingName}"]/descendant::label[./input[@type='radio' and @state="${state}"]])[1]
    # ...    AND
    # ...    Scroll Element Into View    //tr[@note-structure='${findingName}']/descendant::input[@type='radio' and @state='${state}']
    ${locator}    Set Variable    //tr[@note-structure="${findingName}"]//div/span[contains(text(),'Size')]/following-sibling::input
    ${present}=    Run Keyword And Return Status    Element Should Be Visible   ${locator}
    
      
    Run keyword if    ${present} and ("${scenario}" =="AllNadWithSize" or "${scenario}" =="AllNadWithSizeAndNoEnlargedLN")    Enter Size Value     ${findingName}   
    # sleep    1
    
 
Enter Size Value
    [Arguments]    ${findingName}  
    # sleep    1
    ${locator}    Set Variable    //tr[@note-structure="${findingName}"]//div/span[contains(text(),'Size')]/following-sibling::input
    # ${rand_num}=    Generate random string    2    0123456789
    ${size}      Generate random string    2    0123456789
    Input Text    //tr[@note-structure="${findingName}"]//div/span[contains(text(),'Size')]/following-sibling::input    ${size}


NAD
    ${locator}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='green']])
    Click NAD    ${locator}

Click NAD
    [Arguments]    ${locators}
    ${count}    Get Element Count    ${locators}
    ${count}=     Evaluate    ${count} + 1
    ${elements}=    Get WebElements    ${locators}

    # ${count}     Set Variable    1
     FOR    ${INDEX}    IN RANGE    1   ${count}
          
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     ${locators}\[${INDEX}\]
        Run keyword if    ${present}    Run keywords
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Scroll Element Into View    ${locators}\[${INDEX}\] 
        ...    AND
        # ...    sleep    1
        # ...    AND
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Click Element    ${locators}\[${INDEX}\]  
   
        

     END 
    Log    ${elements}
    # FOR   ${locators}    IN    "${elements}"
        # sleep    1
        # Log    ${locators} 
        # Handle Locator    ${locators}
        # # Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='green']])[${count}]
        # # Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='green']])[${count}] 
        # # ${count}=     evaluate    ${count} + 1
    # END  
 
NM
    # sleep    1
    ${chkBoxLocator}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr//div/label[./input[@value='NM'] and contains(@class,'checkbox-styled')])
    # ${count}    Get Element Count    ${chkBoxLocator}
    # Log     ${count}
    # ${locator}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr//div//label[./input[@type='checkbox' and @value='NM'] and  contains(@class,'checkbox-styled')])
    # ${locator}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr//div//label[./input[@type='checkbox' and @id='sizemmpanelNotMeasured'] and  contains(@class,'checkbox-styled')])
    ${locator}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div//label[./input[@type='checkbox' and @id='sizemmpanelNotMeasured']])
    # ${count}    Get Element Count    @{locator}
    # Log     ${count}   

    Click NM     ${locator}  
    
Click NM
     [Arguments]    ${locators}
     ${count}    Get Element Count    ${locators}
     ${count}=     evaluate    ${count} + 1
     ${elements}=    Get WebElements    ${locators}
     FOR    ${INDEX}    IN RANGE    1   ${count}
        ${present}=    Run Keyword And Return Status    Element Should Be Visible    ${locators}\[${INDEX}\]
        Run keyword if    ${present}    Run keywords
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Scroll Element Into View    ${locators}\[${INDEX}\]    AND
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Click Element    ${locators}[${INDEX}]
     END
     
NA
    ${locators}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='grey']])
    ${count}    Get Element Count    ${locators}
    ${count}=     evaluate    ${count} + 1
    ${elements}=    Get WebElements    ${locators}

     FOR    ${INDEX}    IN RANGE    1   ${count}
          
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     ${locators}\[${INDEX}\]
        Run keyword if    ${present}    Run keywords
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Scroll Element Into View    ${locators}\[${INDEX}\] 
        ...    AND
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Click Element    ${locators}\[${INDEX}\]  
   
     END 
     
Comment Options
    [Arguments]    ${option}
    ${locators}    Set Variable    xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='red']])
    ${count}    Get Element Count    ${locators}
    ${count}=     evaluate    ${count} + 1
    # ${rowcheck}    Set Variable    1   
    ${elements}=    Get WebElements    ${locators}
    # Log    comment entry${rowcheck}     console=yes
       

     FOR    ${INDEX}    IN RANGE    1   ${count}
        # Sleep    1  
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='red']])[${INDEX}]
        Run keyword if    ${present}    Run keywords
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Scroll Element Into View    xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='red']])[${INDEX}] 
        ...    AND
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Click Element    xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='red']])[${INDEX}]  
        ...    AND     Capture Element Screenshot            xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='red']])[${INDEX}] 
        # ...    Click CheckBoxes 
        # ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${INDEX}]
        Log    within comment loop${INDEX}    console=yes
        # ${rowcheck}=    Run Keyword If    ${rowcheck} == ${None} and ${INDEX}>=${12}    Set Variable    0    ELSE IF    ${INDEX}>=${12}      Increment    ${rowcheck}
        # Run keyword if    ${INDEX}>=${12}    Run keywords      Log    inif${rowcheck}     console=yes    AND
        # ...      Click CheckBoxes    ${rowcheck}    ${option}
        # ...    Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][3])[2] 
        # ...    AND
        # ...    Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][3])[2]
        # ...    AND     
        # ...    Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[8]    
        # ...    AND
        # ...    Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[8]
        # ...    AND    Sleep    2
        # ...    AND
        # ...   Sleep    5
       ${rowcheck}=    Run keyword if     ${INDEX} >= ${3}         evaluate    ${INDEX} - 1    
        Run keyword if    ${rowcheck}    Click CheckBoxes    ${rowcheck}    ${option}
     END
     Capture Page Screenshot    
 
Increment
    [Arguments]    ${rowcheck}
    Log    within increment-${rowcheck}    console=yes
    # ${rowcheck}=     Run keyword if    ${rowcheck} is ${None}    Set Variable    1
    ${rowcheck}    evaluate    ${rowcheck} + 1    
    [Return]    ${rowcheck}
        
     
Click CheckBoxes
    [Arguments]    ${rowcheck}    ${option}
    ${locators}    Set Variable    xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr[${rowcheck}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])
    ${count}    Get Element Count    ${locators}
    ${count}=     evaluate    ${count} + 1
    ${elements}=    Get WebElements    ${locators}
    Log    Checkbox entry-${rowcheck}    console=yes
     FOR    ${INDEX}    IN RANGE    1   ${count}
        # Sleep    1 
        Log    with in Checkbox loop-${INDEX}    console=yes
        # Continue For Loop If    ${rowcheck} == 7 and ${INDEX}==5 or (${rowcheck} == 9 and (${INDEX}==6 or ${INDEX}>=6))
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr[${rowcheck}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${INDEX}]
        Run keyword if    ${present}   # Run keywords
        ...    Know CheckBox Value And Click   ${INDEX}    ${rowcheck}    #AND  
        # ...    Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${INDEX}] 
        # ...    AND
        # ...    Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${INDEX}]  
        # ...    AND
        # ...    Click Option Under CheckBoxes    ${INDEX}    ${rowcheck}
     END
    ${locators}    Set Variable    xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr[${rowcheck}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])
    ${counter}    Get Element Count    ${locators}
    ${counter}=     evaluate    ${counter} + 1     
     FOR    ${INDEX}    IN RANGE    1   ${counter}
        # Sleep    1 
        Log    with in sub option loop-${INDEX}    console=yes
        # Continue For Loop If    ${rowcheck} == 7 and ${INDEX}==5 
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr[${rowcheck}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])[${INDEX}]
        Run keyword if    ${present} 
        ...    Click Option Under CheckBoxes    ${INDEX}    ${rowcheck}    ${option}
     END

Know CheckBox Value And Click
    [Arguments]    ${SubRow}    ${MAINROW}
    ${Is_Checkbox_Selected}=    Run Keyword And Return Status    Checkbox Should Be Selected    xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}] 
    ${Actual_Chkbx_Value}=    Run Keyword If    '${Is_Checkbox_Selected}'== 'True'    Set Variable    Yes
    ...    ELSE IF    '${Is_Checkbox_Selected}'== 'False'    Set Variable    No
    Log    ${Actual_Chkbx_Value}
    Run Keyword If    'Yes'!='${Actual_Chkbx_Value}'    Run keywords 
    ...    Wait Until Keyword Succeeds    1 min    3 sec     Scroll Element Into View    xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}] 
    ...    AND
    ...    Wait Until Keyword Succeeds    1 min    3 sec     Click Element    xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}]    
    ...    AND
    ...    Log    xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}]    console=yes
     
Click Option Under CheckBoxes
    [Arguments]    ${SubOption}    ${MAINROW}    ${option}
    # ${locators}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][1])
    # ${count}    Get Element Count    ${locators}
    # ${count}=     evaluate    ${count} + 1
    # ${elements}=    Get WebElements    ${locators}
    # below iteration clicks all 1st suboption.. eg: click Normal, click Smooth,click No... etc   
     # FOR    ${INDEX}    IN RANGE    1   ${count}
    Sleep    1  
    ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])[${SubOption}]
    Run keyword if    ${present}    Run keywords
    ...    Wait Until Keyword Succeeds    1 min    3 sec     Scroll Element Into View    xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])[${SubOption}] 
    ...    AND
    ...    Wait Until Keyword Succeeds    1 min    3 sec     Click Element    xpath=(//tbody[5]//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])[${SubOption}] 
     # END
      
ROI
     ${locators}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div//label[./input[@type='checkbox' and @id='roiPanelRoi']])  
     ${count}    Get Element Count    ${locators}
     ${count}=     evaluate    ${count} + 1
     ${elements}=    Get WebElements    ${locators}
     FOR    ${INDEX}    IN RANGE    1   ${count}
        ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div//label[./input[@type='checkbox' and @id='roiPanelRoi']])[${INDEX}]
        Run keyword if    ${present}    Run keywords
        ...    Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div//label[./input[@type='checkbox' and @id='roiPanelRoi']])[${INDEX}]    AND
        ...    Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div//label[./input[@type='checkbox' and @id='roiPanelRoi']])[${INDEX}]
     END

Enter Size
     ${locators}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div/descendant::input[@type='text' and @id='size'])  
     ${count}    Get Element Count    ${locators}
     ${count}=     evaluate    ${count} + 1
     ${elements}=    Get WebElements    ${locators}
     ${size}      Generate random string    2    0123456789
     FOR    ${INDEX}    IN RANGE    1   ${count}
        ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div/descendant::input[@type='text' and @id='size'])[${INDEX}]
        Run keyword if    ${present}    Run keywords
        ...    Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div/descendant::input[@type='text' and @id='size'])[${INDEX}]    AND
        ...    Input Text    (//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div/descendant::input[@type='text' and @id='size'])[${INDEX}]    ${size}
     END    
     
Handle Locator
    [Arguments]    ${locators}
    ${count}     Set Variable    1
    FOR   ${locator}    IN    ${locators}
         Scroll Element Into View    (${locator})[${count}]
         Click Element    (${locator})[${count}]
         ${count}=     evaluate    ${count} + 1
    END       
 
Find Element abdomin        
    sleep    1
    @{elements}=    Get WebElements    //tr//label[./input[@type='radio' and @state='green']]
    FOR    ${btns}    IN RANGE    1     3
        
        LOG     ${btns}    console=yes
        Log   ${elements}[${btns}]     console=yes
        Scroll Element Into View    xpath=(//tr//label[./input[@type='radio' and @state='green']])[${btns}]
        Click Element    xpath=(//tr//label[./input[@type='radio' and @state='green']])[${btns}]
           
    END
    ${elements1}=    Get WebElements    //input[@state='green']
    # FOR    ${element}    IN    @{elements1}
        # Log    ${element.text}
        # Click Element    ${element}
    # END
    : FOR    ${INDEX}    IN RANGE    1    ${elements1}
    \    Log    ${INDEX}
    \    ${lintext}=    Get Text    //input[@state='green'][${INDEX}]
    \    Log    ${lintext}
    \    Click Element   //input[@state='green'][${INDEX}]
    \    
    # xpath    =    //input[@state='green']

    # \    ${linklength}    Get Length    ${lintext}
    # \    Run Keyword If    ${linklength}>1    Append To List    ${LinkItems}
    

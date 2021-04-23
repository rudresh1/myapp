*** Settings ***
Library    PythonKeywords
Library    SeleniumLibrary
Library    String
Resource    ../pages/PageObject.robot
Resource    ../pages/Abdominal.robot

# Suite Setup       Open My Browser    ${url}     ${browser}     ${remoteMachineIp}
# Suite Teardown    Close Browsers
Test Template    Arm Test Case
*** Variables ***
${url}    dev.smartmedsolution.com/login
# ${url}    qa.smartmedsolution.com/login
${browser}    edge
${remoteMachineIp}

*** Test Cases ***
    
Arm Right Side Nad    ArmRightSideNad
    
Arm Left Side Nad    ArmLeftSideNad
    
Arm Right Side Nad Roi    ArmRightSideNadRoi
    
Arm Left Side Nad Roi    ArmLeftSideNadRoi
    
Arm Right Left Side Nad Roi    ArmRightLeftSideNadRoi
    
Arm Right Left Side Nad    ArmRightLeftSideNad
    
Arm Right Side Na    ArmRightSideNa
    
Arm Left Side Na    ArmLeftSideNa
    
Arm Right Left Side Na    ArmRightLeftSideNa
    

# ++++++++++
Arm Right Side Nad Preview Complete    ArmRightSideNad
    
Arm Left Side Nad Preview Complete    ArmLeftSideNad
    
Arm Right Side Nad Roi Preview Complete    ArmRightSideNadRoi
    
Arm Left Side Nad Roi Preview Complete    ArmLeftSideNadRoi
    
Arm Right Left Side Nad Roi Preview Complete    ArmRightLeftSideNadRoi
    
Arm Right Left Side Nad Preview Complete    ArmRightLeftSideNad
    
Arm Right Side Na Preview Complete    ArmRightSideNa
    
Arm Left Side Na Preview Complete    ArmLeftSideNa
    
Arm Right Left Side Na Preview Complete    ArmRightLeftSideNa
    
    
Arm Right Left Side Comment Option1    ArmRightLeftSideCommentOption1
    

        
    
*** Keywords ***

Arm Test Case
    [Arguments]    ${testFileName}    ${credentials}=${None}
    Log   =========== Pelvis Test Case===========     DEBUG    console=yes 
    ${common}    Get File    test\\testData\\credentials.json
    
    Log    ${common}    console=yes
    Open My Browser    ${url}     ${browser}     ${remoteMachineIp} 
    
    ${all data members}=    Get Test Data With Filter    ${testFileName}
    ${member}=    Set Variable    ${all data members}[0]
    # ${credentials}=    Get Test Data With Filter    ${credentials}
    # Log    ${member['findings']['LEFT GROIN']['Hernia']['option']}    console=yes
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
    FOR    ${key}    IN    @{member['keyList']}
        Log    ${key}    console=yes
        
        ${match}  ${value}  Run Keyword And Ignore Error      Should Contain    ${key}    Side
        Log    ${match}    console=yes
        Log    ${value}    console=yes
        ${compare}  ${value}  Run Keyword And Ignore Error      Should Contain    ${key}    Comment
        ${Patterns}=    Run keyword if    '${match}' == 'PASS' or '${compare}' == 'PASS'      Split String    ${key}    _  
        ...    ELSE    Set Variable    Side Selection    2
   
        # Run keyword if  '${match}' == 'FAIL' or '${compare}' == 'PASS'
        # ...    ${key}    
        Run keyword if  '${match}' == 'PASS' or '${compare}' == 'PASS'
        ...     ${Patterns}[0]    ${Patterns}[1] 
        ...    ELSE    ${key}
    END
    
    Fill Clinical Hx In Abdominal    ${member['clinicalHx']}
    Fill Findings in Abdominal    ${member['findings']}    'SideSelection'
    
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
    
    #Scroll Element Into View    id=review-checkbox
    #Wait Until Element Is Enabled    id=review-checkbox
    #Click Element    id=review-checkbox
        
    LogOut From Application
    Close Browsers
 
    
Side Selection
    [Arguments]    ${option}
    ${locators}    Set Variable    xpath=(//tbody[2]//tr[@class='tr-toggle1']/following-sibling::tr[6]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])
    ${count}    Get Element Count    ${locators}
    ${count}=     evaluate    ${count} + 1
    ${elements}=    Get WebElements    ${locators}

    
          
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     ${locators}\[${option}\]
        Run keyword if    ${present}    Run keywords
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Scroll Element Into View    ${locators}\[${option}\] 
        ...    AND
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Click Element    ${locators}\[${option}\]  
   
    
   
 


NAD
    ${locator}    Set Variable    xpath=(//tr/following-sibling::tr/descendant::label[./input[@type='radio' and @state='green']])
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
    ${locators}    Set Variable    xpath=(//tr/following-sibling::tr/descendant::label[./input[@type='radio' and @state='grey']])
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
    ${locators}    Set Variable    xpath=(//tr/descendant::td/label[input[@type='radio' and @state='red']])
    ${count}    Get Element Count    ${locators}
    ${count}=     evaluate    ${count} + 1
    ${rowcheck}    Set Variable    1   
    ${elements}=    Get WebElements    ${locators}
    Log    comment entry${rowcheck}     console=yes
       

     FOR    ${INDEX}    IN RANGE    1   ${count}
        # Sleep    1  
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tr/descendant::td/label[input[@type='radio' and @state='red']])[${INDEX}]
        Run keyword if    ${present}    Run keywords
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Scroll Element Into View       xpath=(//tr/descendant::td/label[input[@type='radio' and @state='red']])[${INDEX}] 
        ...    AND
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Click Element    xpath=(//tr/descendant::td/label[input[@type='radio' and @state='red']])[${INDEX}]  
        ...    AND     Capture Element Screenshot            xpath=(//tr/descendant::td/label[input[@type='radio' and @state='red']])[${INDEX}] 
        # ...    Click CheckBoxes 
        # ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${INDEX}]
        Log    within comment loop${rowcheck}    console=yes
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
        ${rowcheck}=    Run keyword if     ${INDEX} <= ${3}     Set Variable    0   ELSE     evaluate    ${INDEX} - 3
         Click CheckBoxes    ${rowcheck}    ${option}
         
        # Click CheckBoxes    ${INDEX}    ${option} 
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
    ${locators}    Set Variable    xpath=(//tr[${rowcheck}]/descendant::td/div/div[@class='details-check_hover']/label[input[@type='checkbox']])
    ${count}    Get Element Count    ${locators}
    ${count}=     evaluate    ${count} + 1
    ${elements}=    Get WebElements    ${locators}
    Log    Checkbox entry-${rowcheck}    console=yes
     FOR    ${INDEX}    IN RANGE    1   ${count}
        # Sleep    1 
        Log    with in Checkbox loop-${INDEX}    console=yes
        # Continue For Loop If    ${rowcheck} == 7 and ${INDEX}==5 or (${rowcheck} == 9 and (${INDEX}==6 or ${INDEX}>=6))
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tr[${rowcheck}]/descendant::td/div/div[@class='details-check_hover']/label[input[@type='checkbox']])[${INDEX}]
        Run keyword if    ${present}   # Run keywords
        ...    Know CheckBox Value And Click   ${INDEX}    ${rowcheck}    #AND  
        # ...    Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${INDEX}] 
        # ...    AND
        # ...    Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${INDEX}]  
        # ...    AND
        # ...    Click Option Under CheckBoxes    ${INDEX}    ${rowcheck}
     END
    ${locators}    Set Variable    xpath=(//tbody//tr[@class='tr-toggle1']/following-sibling::tr[${rowcheck}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])
    ${counter}    Get Element Count    ${locators}
    ${counter}=     evaluate    ${counter} + 1     
     FOR    ${INDEX}    IN RANGE    1   ${counter}
        # Sleep    1 
        Log    with in sub option loop-${INDEX}    console=yes
        # Continue For Loop If    ${rowcheck} == 7 and ${INDEX}==5 
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tbody//tr[@class='tr-toggle1']/following-sibling::tr[${rowcheck}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])[${INDEX}]
        Run keyword if    ${present} 
        ...    Click Option Under CheckBoxes    ${INDEX}    ${rowcheck}    ${option}
     END

Know CheckBox Value And Click
    [Arguments]    ${SubRow}    ${MainRow}
    # ${Is_Checkbox_Selected}=    Run Keyword And Return Status    Checkbox Should Be Selected    xpath=(//tbody//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}] 
    # ${Actual_Chkbx_Value}=    Run Keyword If    '${Is_Checkbox_Selected}'== 'True'    Set Variable    Yes
    # ...    ELSE IF    '${Is_Checkbox_Selected}'== 'False'    Set Variable    No
    # Log    ${Actual_Chkbx_Value}
    # Run Keyword If    'Yes'!='${Actual_Chkbx_Value}'    Run keywords 
    # ...    Wait Until Keyword Succeeds    1 min    3 sec     Scroll Element Into View    xpath=(//tbody//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}] 
    # ...    AND
    # ...    Wait Until Keyword Succeeds    1 min    3 sec     Click Element    xpath=(//tbody//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}]    
    # ...    AND
    # ...    Log    xpath=(//tbody//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}]    console=yes
    Wait Until Keyword Succeeds    1 min    3 sec     Scroll Element Into View    xpath=(//tr[${MainRow}]/descendant::td/div/div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}] 
    
    Wait Until Keyword Succeeds    1 min    3 sec     Click Element    xpath=(//tr[${MainRow}]/descendant::td/div/div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}]    
    
    Log    xpath=(//tr[${MainRow}]/descendant::td/div/div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}]    console=yes
         


 
Click Option Under CheckBoxes
    [Arguments]    ${SubOption}    ${MAINROW}    ${option}
    # ${locators}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][1])
    # ${count}    Get Element Count    ${locators}
    # ${count}=     evaluate    ${count} + 1
    # ${elements}=    Get WebElements    ${locators}
    # below iteration clicks all 1st suboption.. eg: click Normal, click Smooth,click No... etc   
     # FOR    ${INDEX}    IN RANGE    1   ${count}
    Sleep    1  
    ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tbody//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])[${SubOption}]
    Run keyword if    ${present}    Run keywords
    ...    Wait Until Keyword Succeeds    1 min    3 sec     Scroll Element Into View    xpath=(//tbody//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])[${SubOption}] 
    ...    AND
    ...    Wait Until Keyword Succeeds    1 min    3 sec     Click Element    xpath=(//tbody//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])[${SubOption}] 
     # END
      
ROI
     ${locators}    Set Variable    xpath=(//tr/following-sibling::tr/descendant::div//label[./input[@type='checkbox' and @id='roiPanelRoi']])  
     ${count}    Get Element Count    ${locators}
     ${count}=     evaluate    ${count} + 1
     ${elements}=    Get WebElements    ${locators}
     FOR    ${INDEX}    IN RANGE    1   ${count}
        ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=(//tr/following-sibling::tr/descendant::div//label[./input[@type='checkbox' and @id='roiPanelRoi']])[${INDEX}]
        Run keyword if    ${present}    Run keywords
        ...    Scroll Element Into View    xpath=(//tr/following-sibling::tr/descendant::div//label[./input[@type='checkbox' and @id='roiPanelRoi']])[${INDEX}]    AND
        ...    Click Element    xpath=(//tr/following-sibling::tr/descendant::div//label[./input[@type='checkbox' and @id='roiPanelRoi']])[${INDEX}]
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
     


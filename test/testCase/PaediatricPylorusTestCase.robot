*** Settings ***
Library    SeleniumLibrary
Library    String
# Library    PythonKeywords
# Resource    ../keyword/PythonKeywords.py


Resource    ../pages/PageObject.robot
Resource    ../pages/Abdominal.robot

# Suite Setup       Open My Browser    ${url}     ${browser}     ${remoteMachineIp}
# Suite Teardown    Close Browsers            
Test Template    Pylorus Test Case
*** Variables ***
${url}    dev.smartmedsolution.com/login
# ${url}    qa.smartmedsolution.com/login
${browser}    chrome
${remoteMachineIp}

*** Test Cases ***
All Field NA    PylorusAllNa

All Field Nad    PylorusAllNad

All Field Nad And Size    PylorusAllNadWithSize
      
All Field Nad and NM      PylorusAllNadWithNm
    
All Field Nad And Size Preview Complete    PylorusAllNadWithSize
      
All Field Nad and NM Preview Complete      PylorusAllNadWithNm
        


    

*** Keywords ***

Pylorus Test Case
    [Arguments]    ${testFileName}
    Open My Browser    ${url}     ${browser}     ${remoteMachineIp}
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
    # sleep    2
    Selecting The Page    ${member['pageName']}
    Wait Until Element Is Not Visible     class:loader    
        
    Fill The General Information    ${member['GeneralDetails']}
     FOR    ${key}    IN    @{member['keyList']}
        Log    ${key}    console=yes
        ${match}  ${value}  Run Keyword And Ignore Error      Should Contain  ${key}     Comment
        Log    ${match}    console=yes
        Log    ${value}    console=yes
        ${Patterns}=    Run keyword if    '${match}' == 'PASS'       Split String    ${key}    _  
        ...    ELSE    Set Variable    Comment Options    2
   
        Run keyword if  '${match}' == 'FAIL'
        ...    ${key}    
        Run keyword if  '${match}' == 'PASS'
        ...     ${Patterns}[0]    ${Patterns}[1] 
    END
  
   
    # Fill Clinical Hx In Abdominal    ${member['clinicalHx']}
    
    # Click NA
    # Enter Size
    # NM
    # ROI
    # Comment Options
    # NAD
    # FOR   ${findingName}    IN    @{member['findings1']}
        # sleep    1
        # Fill Findings    ${findingName}
    # END
    # FOR   ${findingName}    IN    @{member['findings1']}
        # sleep    1
        # Fill Findings    ${findingName}    ${member['state']}    ${member['scenario']}
    # END                
    # Find Element abdomin       
    
    # Fill Findings in Abdominal    ${member['findings']} 
    
    # Fill Comment in Adbominal    ${member['conclusions']} 
    
    Click On Graphic Tab
    
    Click On Nothing To Indicate
    sleep    5
    
           
    # run keyword if   "${Preview Complete}" == "Preview Complete"    Run Keywords   Click Preview and Complete    Click Confirm and Complete
    ${present}=    Run Keyword And Return Status    Element Should Be Visible   xpath=(//div[contains(@class,'alert-light-warning')])[4]
    run keyword if    ${present}    Run Keywords
    ...    Scroll Element Into View    xpath=(//div[contains(@class,'modal-footer')]/button[@data-dismiss='modal'])[11]    AND
    ...    Click Element    xpath=(//div[contains(@class,'modal-footer')]/button[@data-dismiss='modal'])[11]    AND
    ...    Run Keyword And Continue On Failure    Wait Until Keyword Succeeds    1min    3sec    Fill Mandatory Fields       AND
    ...    Click Preview and Complete    AND   
    ...    Click Confirm and Complete
    ...    ELSE
    ...    Click Confirm and Complete  
    run keyword if  "${Preview Complete}" != "Preview Complete"    Click Pause
    
    # need to achieve below
    #Click Preview
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
          
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='green']])[${INDEX}]
        Run keyword if    ${present}    Run keywords
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='green']])[${INDEX}] 
        ...    AND
        # ...    sleep    1
        # ...    AND
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='green']])[${INDEX}]  
   
        

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
        ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div//label[./input[@type='checkbox' and @id='sizemmpanelNotMeasured']])[${INDEX}]
        Run keyword if    ${present}    Run keywords
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div//label[./input[@type='checkbox' and @id='sizemmpanelNotMeasured']])[${INDEX}]    AND
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div//label[./input[@type='checkbox' and @id='sizemmpanelNotMeasured']])[${INDEX}]
     END
     
NA
    ${locators}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='grey']])
    ${count}    Get Element Count    ${locators}
    ${count}=     evaluate    ${count} + 1
    ${elements}=    Get WebElements    ${locators}

     FOR    ${INDEX}    IN RANGE    1   ${count}
          
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='grey']])[${INDEX}]
        Run keyword if    ${present}    Run keywords
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='grey']])[${INDEX}] 
        ...    AND
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='grey']])[${INDEX}]  
   
     END 
     
Comment Options
    [Arguments]    ${option}
    ${locators}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='red']])
    ${count}    Get Element Count    ${locators}
    ${count}=     evaluate    ${count} + 1
    ${rowcheck}    Set Variable    0   
    ${elements}=    Get WebElements    ${locators}
    Log    comment entry${rowcheck}     console=yes
       

     FOR    ${INDEX}    IN RANGE    1   ${count}
        # Sleep    1  
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='red']])[${INDEX}]
        Run keyword if    ${present}    Run keywords
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='red']])[${INDEX}] 
        ...    AND
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='red']])[${INDEX}]  
        ...    AND     Capture Element Screenshot            xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::label[./input[@type='radio' and @state='red']])[${INDEX}] 
        # ...    Click CheckBoxes 
        # ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${INDEX}]
        Log    within comment loop${rowcheck}    console=yes
        ${rowcheck}=    Run Keyword If    ${rowcheck} == ${None} and ${INDEX}>=${5}    Set Variable    0    ELSE IF    ${INDEX}>=${5}      Increment    ${rowcheck}
        Run keyword if    ${INDEX}>=${5}    Run keywords      Log    inif${rowcheck}     console=yes    AND
        ...      Click CheckBoxes    ${rowcheck}    ${option}
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
    ${locators}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${rowcheck}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])
    ${count}    Get Element Count    ${locators}
    ${count}=     evaluate    ${count} + 1
    ${elements}=    Get WebElements    ${locators}
    Log    Checkbox entry-${rowcheck}    console=yes
     FOR    ${INDEX}    IN RANGE    1   ${count}
        # Sleep    1 
        Log    with in Checkbox loop-${INDEX}    console=yes
        Continue For Loop If    ${rowcheck} == 7 and ${INDEX}==5 or (${rowcheck} == 9 and (${INDEX}==6 or ${INDEX}>=6))
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${rowcheck}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${INDEX}]
        Run keyword if    ${present}   # Run keywords
        ...    Know CheckBox Value And Click   ${INDEX}    ${rowcheck}    #AND  
        # ...    Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${INDEX}] 
        # ...    AND
        # ...    Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${INDEX}]  
        # ...    AND
        # ...    Click Option Under CheckBoxes    ${INDEX}    ${rowcheck}
     END
    ${locators}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${rowcheck}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])
    ${counter}    Get Element Count    ${locators}
    ${counter}=     evaluate    ${counter} + 1     
     FOR    ${INDEX}    IN RANGE    1   ${counter}
        # Sleep    1 
        Log    with in sub option loop-${INDEX}    console=yes
        # Continue For Loop If    ${rowcheck} == 7 and ${INDEX}==5 
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${rowcheck}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])[${INDEX}]
        Run keyword if    ${present} 
        ...    Click Option Under CheckBoxes    ${INDEX}    ${rowcheck}    ${option}
     END

Know CheckBox Value And Click
    [Arguments]    ${SubRow}    ${MAINROW}
    ${Is_Checkbox_Selected}=    Run Keyword And Return Status    Checkbox Should Be Selected    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}] 
    ${Actual_Chkbx_Value}=    Run Keyword If    '${Is_Checkbox_Selected}'== 'True'    Set Variable    Yes
    ...    ELSE IF    '${Is_Checkbox_Selected}'== 'False'    Set Variable    No
    Log    ${Actual_Chkbx_Value}
    Run Keyword If    'Yes'!='${Actual_Chkbx_Value}'    Run keywords 
    ...    Wait Until Keyword Succeeds    1 min    3 sec     Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}] 
    ...    AND
    ...    Wait Until Keyword Succeeds    1 min    3 sec     Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div[@class='details-check_hover']/label[input[@type='checkbox']])[${SubRow}]    
     
Click Option Under CheckBoxes
    [Arguments]    ${SubOption}    ${MAINROW}    ${option}
    # ${locators}    Set Variable    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][1])
    # ${count}    Get Element Count    ${locators}
    # ${count}=     evaluate    ${count} + 1
    # ${elements}=    Get WebElements    ${locators}
    # below iteration clicks all 1st suboption.. eg: click Normal, click Smooth,click No... etc   
     # FOR    ${INDEX}    IN RANGE    1   ${count}
    Sleep    1  
    ${present}=    Run Keyword And Return Status    Element Should Be Visible     xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])[${SubOption}]
    Run keyword if    ${present}    Run keywords
    ...    Wait Until Keyword Succeeds    1 min    3 sec     Scroll Element Into View    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])[${SubOption}] 
    ...    AND
    ...    Wait Until Keyword Succeeds    1 min    3 sec     Click Element    xpath=(//tr[@class='tr-toggle1']/following-sibling::tr[${MAINROW}]/descendant::div/label/following-sibling::div/descendant::label[input[@type='radio']][${option}])[${SubOption}] 
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
    
# Renal Test Case
    # [Arguments]    ${testFileName}
    # Log   =========== Renal Test Case===========    console=yes  
    # ${all data members}=    Get Test Data With Filter    ${testFileName}
    # ${member}=    Set Variable    ${all data members}[1]
    
    # Login To Application    ${member['username']}    ${member['password']}
    # # sleep        30
    # # Select The Ultrasound Room    ${member['ultrasoundRoom']}
    # # sleep        30
    # # Select Room    ${member['rooms']}
    # # sleep     30
    # Goto Workshop
    # # Verify Header and Page List
    # sleep     10
    # Selecting The Page    ${member['pageName']}
    # sleep     10
        
    # Fill The General Information    ${member['GeneralDetails']}
   
    # Fill Clinical Hx In Abdominal    ${member['clinicalHx']}  
    
    # Fill Findings in Abdominal    ${member['findings']} 
    
    # Fill Conclusion in Adbominal    ${member['conclusions']} 
    
    # Click On Graphic Tab
    
    # Click On Nothing To Indicate
    # sleep    20
    # Click pause
    
    # # need to achieve below
    # #Click Preview
    # sleep   100 
    # #Scroll Element Into View    id=review-checkbox
    # #Wait Until Element Is Enabled    id=review-checkbox
    # #Click Element    id=review-checkbox
        
    # LogOut From Application
    
    

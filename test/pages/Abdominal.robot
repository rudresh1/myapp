*** Settings ***
Documentation    Custom Keywords for Logpoint
Library    String
Library    SeleniumLibrary    
Library    OperatingSystem 
Resource    PageObject.robot
Resource    Shoulder.robot

*** Variable ***
${testsRootFolder}    ${EXECDIR}/test/driver/
@{criticalHxFieldList}    Clinical Hx (Referral)    Hx from patient    Surgical Hx    Comparison    Specific ROI    Scan quality    Side selection
@{findingList}    Liver    Portal vein    Gallbladder    CBD    Pancreas    Spleen   Right kidney    Left kidney    Aorta    Free fluid    Lymph nodes    RIF    LIF    Other findings
@{commentList}    Comment   Further APT    Follow up    COMMENT (_side_)
@{templateKeys}    J effusion    B    J    T 
@{subTempTypes}      bursa    jEffusion    joint    tendon    commonFindings
# ${jEffusion}    'J effusion'
# ${bursa}    ' B'
# ${joint}    ' J'
# ${tendon}   ' T'  
    
*** Keywords ***

Fill US Abdominal Form
    [Arguments]    ${member}
    Run keyword if  'GeneralDetails' in @{member}    Fill The General Information Form    ${member['GeneralDetails']}
    Run keyword if  'clinicalHx' in @{member}    Fill Clinical Hx In Abdominal    ${member}[clinicalHx]
    Run keyword if  'findings' in @{member}    Fill Findings in Abdominal    ${member}[findings]
    Run keyword if  'comments' in @{member}    Fill Comment in Adbominal    ${member}[comments]

Fill The List Of Fields
    [Arguments]    ${member}    ${fieldList}
    FOR    ${key}    IN    @{member}
        Log    ${key}    console=yes
    END
    # FOR    ${key}    IN    @{fieldList.keys()}
        # ${value}=    Get From Dictionary    ${fieldList}    ${key}
        # Run keyword if  '${key}' in @{member}    ${key}     ${member}[${key}]
    # END
    FOR    ${key}    IN    @{member}
        # ${value}=    Get From Dictionary    ${fieldList}    ${key}
        # Run keyword if  '${key}' in @{member}    ${key}     ${member}[${key}]
        # Run keyword if  '${key}' in @{member}    RunKeys     ${member}[${key}]    ${key}
        Run keyword if  'templateType'=='${key}'
        ...    Fill Template Data    ${member}[templateType]    ${key}        
        Run keyword if  '${key}' in @{member} and '${key}' in @{criticalHxFieldList}    ${key}     ${member}[${key}]    
        ...    ELSE IF  '${key}' in @{member} and '${key}' in @{commentList}    ${key}     ${member}[${key}]  
        ...    ELSE IF  '${key}' in @{member}    RunKeys     ${member}[${key}]    ${key}
    END

    
New Fill The List Of Fields
    [Arguments]    ${member}    ${fieldList}
    FOR    ${key}    IN    @{member}
        Log    ${key}    console=yes
    END
    sleep     2
    # FOR    ${key}    IN    @{fieldList}
        # Log    ${key}    console=yes
        # ${keyList}    Get Dictionary Keys    ${member} 
        # ${found}    Evaluate    '${key}' in @{keyList}    
        # Log    ${found}    console=yes   
        # # Run keyword if  '${key}' in @{keyList}    ${key}     ${member}[${key}]
        # # Run keyword if  '${key}' in @{keyList}    ${key}     ${member}[${key}]
        # Run keyword if  '${key}' in @{keyList} and '${key}' in @{criticalHxFieldList}    ${key}     ${member}[${key}]    
        # ...    ELSE IF  '${key}' in @{keyList} and '${key}' in @{commentList}    ${key}     ${member}[${key}]  
        # ...    ELSE IF  '${key}' in @{keyList}    RunKeys     ${member}[${key}]    ${key}
    # END
    FOR    ${key}    IN    @{member}
        Log    ${key}    console=yes
        ${keyList}    Get Dictionary Keys    ${member} 
        # ${found}    Evaluate    '${key}' in @{keyList}    
        # Log    ${found}    console=yes   
        # Run keyword if  '${key}' in @{keyList}    ${key}     ${member}[${key}]
        # Run keyword if  '${key}' in @{keyList}    ${key}     ${member}[${key}]
        Run keyword if  'templateType'=='${key}'
        ...    Fill Template Data    ${member}[templateType]    ${key}
        Run keyword if    '${key}' == 'bursa'    Fill Bursa Data    ${member}    ${key}
        ...    ELSE IF    '${key}' in @{member} and '${key}' in @{criticalHxFieldList}    ${key}     ${member}[${key}]    
        ...    ELSE IF  '${key}' in @{member} and '${key}' in @{commentList}    ${key}     ${member}[${key}]  
        ...    ELSE IF  '${key}' in @{member}    RunKeys     ${member}[${key}]    ${key}
    END
    

Fill The General Information Form
    [Documentation]    Filling the form for the abdominal US
    [Arguments]     ${genMember}    ${testFileName}= 'Test case name not passed'
    Log    Filling General Information From    DEBUG    console=yes
    Log    testinggggggggg    
    # Log    ${genMember['allField']['generalInfo']['DOB']}       
    ${first_Name}    Generate Random String    8
    ${last_Name}    Generate Random String    12
    ${patientId}=    Get Patient Id
    ${accessid}    Generate random string    8    0123456789
    ${site}    Generate Random String    3   
    ${room}    Generate Random String    3
    ${clinical-hx}    Generate Random String    6 
    Input Text    //input[@type='text'][@placeholder='First Name']   ${testFileName}
    Input Text    //input[@type='text'][@placeholder='Last Name']   ${last_Name}
    Input Text    id=date-of-birth    ${genMember['DOB']}
    Input Text    id =patientID      ${patientId}
    Input Text    id=accessionNo    ${accessid}
    Input Text    id=site-name   ${genMember['site-name']} 
    Input Text    id=modality-name    ${genMember['Room']}
    # Input Text    (//textarea[@id='direct-report-txtbox1'])    ${clinical-hx} 
    
    Click Element    //label[./input[@name='gender_state']]/span[text()='${genMember['gender']}']       
    
Fill The General Information
    [Arguments]     ${genMember}    ${testFileName}=${None}
    Fill Template Data    ${genMember}[templateType]    generalInfo    ${testFileName}


Fill Clinical Hx In Abdominal
    [Documentation]     Filling the form for clinical hx
    [Arguments]    ${clinMember}
    Log   clinMember= ${clinMember}        console=yes
    &{oldFieldList}    Create Dictionary    Clinical Hx (Referral)=referral    Hx from Patient=hxFromPatient    Surgical Hx=surgicalHx    Comparison=comparison
    ...    Specific ROI=specificRoi    Scan Quality=ScanQuality     Side selection=sideSelection   
    Run keyword if  'templateType' in @{clinMember}    Run Keywords    
    ...    Fill Template Data    ${clinMember}[templateType]    clinicalHx
    ...    AND
    ...    Log   clinicalHx= ${clinMember}[templateType]        console=yes
    ...    ELSE    Fill The List Of Fields    ${clinMember}    ${oldFieldList}

Fill Findings in Abdominal 
    [Documentation]     Filling the findings for findings
    [Arguments]    ${findMember}    ${sideSelection}=${None}
    Log   =========== Findings ===========    console=yes
    # Log    side-1-${findMember}[sideSelection]    console=yes
      &{oldFieldList}    Create Dictionary    Liver=liver    Portal vein=portalVein    Gallbladder=gallbladder    CBD=cbd    Pancreas=pancreas
      ...   Spleen=spleen   Right Kidney=rightkidney    Left Kidney=leftkidney    Aorta=aorta    Free Fluid=freefluid    Lymph nodes=lymphnodes    Rif=rif       
      ...    Lif=lif    Other Findings=otherfindings
    Log    ${findMember}    console=yes  
    Run keyword if  'templateType' in @{findMember} and 'sideSelection' in @{findMember}
    ...    Fill Template Data    ${findMember}[templateType]    findings    None    ${findMember}[sideSelection]
    ...    ELSE IF    'templateType' in @{findMember}
    ...    Fill Template Data    ${findMember}[templateType]    findings
    ...    ELSE IF    ${sideSelection}!=${None}    Fill The List Of Fields with SideSelection    ${findMember}       
    ...    ELSE
    ...    Fill The List Of Fields    ${findMember}    ${oldFieldList}
  

Fill Comment in Adbominal
    [Documentation]     Filling the comment for clinical hx
    [Arguments]         ${conMember}
    Log   =========== Findings ===========    console=yes
    &{oldFieldList}    Create Dictionary    Comment=comment   Further APT=furtherapt    Follow up=followup    'COMMENT (_side_)=comment(_side_)
    
    Run keyword if  'templateType' in @{conMember}
    ...    Fill Template Data    ${conMember}[templateType]    comment
    ...    ELSE    Fill The List Of Fields    ${conMember}    ${oldFieldList}


Clinical Hx (Referral)
    [Documentation]    selecting the options of clinical hx
    [Arguments]        ${textArea}=${EMPTY}
    Enter Text On Field    Clinical Hx (Referral)    ${textArea}
    
Hx from Patient
    [Documentation]      selecting the options of hx
    [Arguments]    ${data}
    Select Value For Field    Hx from patient        ${data}[option]
    Run Keyword If    '${data}[option]'=='Yes'
    ...    Enter Text On Field    Hx from patient    ${data}[textArea]
    
Surgical Hx
    [Documentation]    selecting the options of Surgical hx
    [Arguments]        ${data}
    Select Value For Field    Surgical Hx        ${data}[option]
    Run Keyword If    '${data}[option]'=='Yes'    Run Keywords
    ...    Run Keyword If    '${data}[dropdownOptions]'!='${EMPTY}'    Select Dropdown By Text    Surgical Hx    --choose--    ${data}[dropdownOptions]
    ...    AND    Run Keyword If    '${data}[textArea]'!='${EMPTY}'    Enter Text On Field    Surgical Hx    ${data}[textArea]
     
Comparison
    [Documentation]    selecting the options of Comparison
    [Arguments]    ${data}    ${date}=${EMPTY}
    Select Value For Field    Comparison    ${data}[option]
    Run Keyword If    '${data}[option]'=='Yes'    Run Keywords
    ...    Run Keyword If    '${data}[modalityOptions]'!='${EMPTY}'    Select Dropdown By Text    Comparison    ---Modality---    ${data}[modalityOptions]
    ...    AND    Run Keyword If    '${data}[providerOptions]'!='${EMPTY}'    Select Dropdown By Text    Comparison    ---Provider---    ${data}[providerOptions]
    ...    AND    Run Keyword If    '${data}[subField]'!='${EMPTY}'    Select Value For Field    Comparison    ${data}[subField]
    ...    AND    Run Keyword If    '${data}[subField]'=='Date' and '${date}'=='${EMPTY}'     Enter Date In Sub-Field    Comparison    ${data}[date]
    ...    AND    Run Keyword If    '${data}[subField]'=='Date' and '${date}'!='${EMPTY}'     Enter Date In Sub-Field    Comparison    ${date}
    ...    AND    Run Keyword If    '${data}[textArea]'!='${EMPTY}'    Enter Text On Field    Comparison    ${data}[textArea]

Specific ROI
    [Documentation]    selecting the options of Specific ROI
    [Arguments]    ${data}    ${dropdownOptions}=${EMPTY}    ${textArea}=${EMPTY}
    Select Value For Field    Specific ROI        ${data}[option]
    Run Keyword If    '${data}[option]'=='Yes'    Run Keywords
    ...    Run Keyword If    '${data}[dropdownOptions]'!='${EMPTY}'    Select Dropdown By Text    Specific ROI    --choose--    ${data}[dropdownOptions]
    ...    AND    Run Keyword If    '${data}[textArea]'!='${EMPTY}'    Enter Text On Field    Specific ROI    ${data}[textArea]
    
Scan Quality
    [Documentation]    selecting the options of Scan Quality
    [Arguments]    ${data}    ${check}=true
    Select Value For Field    Scan quality    ${data}[option]
    Run Keyword If    '${data}[option]'=='Suboptimal'
    ...    Toggle Field And Their Corresponding Comment Section    Scan quality    ${data}[checkboxOptions]    ${check}

          
Toggle Field And Their Corresponding Comment Section
    [Arguments]    ${field}    ${detailList}    ${check}
    Log    ${field}    DEBUG    console=yes
    FOR    ${detail}    IN    @{detailList}
        Toggle Field    ${field}    ${detail}[checkboxName]    ${check}
        Run Keyword If    '${detail}[comments]'!='${EMPTY}'
        ...    Input Text    //tr[@note-structure='${field}']//label[./input[@value='${detail}[checkboxName]'] and contains(@class,'checkbox-styled')]//following-sibling::textarea    ${detail}[comments]
    END

RunKeys
    [Documentation]    selecting the options of Liver
    [Arguments]    ${data}=${EMPTY}    ${key}=${NONE}    ${sideSelectionKey}=${None}
    sleep    1
    ${match}  ${value}    Run Keyword And Ignore Error      Should Contain Any      ${key}    bursa    
    ${RETURNVALUE}      Set Variable If      '${match}' == 'PASS'      ${True}      ${False}
    Log    ${RETURNVALUE}    console=yes
    ${Liver}    Set Variable    ${key}
    Scroll Element Into View    //table//td[text()='${key}']
    # sleep    1
    Run keyword if    'option' in @{data}    Select Value For Field    ${key}    ${data}[option]
    # sleep    1
    Run keyword if  'textArea' in @{data}    Input Text    //tr[@note-structure='${key}']//textarea    ${data}[textArea]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    ${key}    ${data}[checkboxOptions]
    # sleep    1
    Run keyword if  'size' in @{data}    Enter Size In Sub-Field    ${key}    ${data}[size]
    # sleep    1
    Run keyword if  'nm' in @{data}    Toggle Field    ${key}    NM    ${data}[nm]
    Run Keyword If    'roi' in @{data}    Toggle Field    ${key}    ROI    ${data}[roi]
    # Run Keyword If    '${data}[option]'!='N E' and '${size}'!='${EMPTY}'    Enter Size In Sub-Field    Liver    ${size}
    # Run Keyword If    '${data}[option]'!='N E' and '${isNM}'!='${EMPTY}'    Toggle Field    Liver    NM    ${isNM}
    #Run Keyword If    '${data}[option]'!='Comments'    Run Keyword
    #...    Run Keyword If    '${data}[option]'!='    Select Value Under Comment Section    Liver    ${data}[subOption]
    



Liver
    [Documentation]    selecting the options of Liver
    [Arguments]    ${data}=${EMPTY}
    sleep    1
    Scroll Element Into View    //table//td[text()='Liver']
    sleep    1
    Select Value For Field    Liver    ${data}[option]
    sleep    1
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Liver    ${data}[checkboxOptions]
    sleep    1
    Run keyword if  'size' in @{data}    Enter Size In Sub-Field    Liver    ${data}[size]
    sleep    1
    Run keyword if  'nm' in @{data}    Toggle Field    Liver    NM    ${data}[nm]
    # Run Keyword If    '${data}[option]'!='N E' and '${size}'!='${EMPTY}'    Enter Size In Sub-Field    Liver    ${size}
    # Run Keyword If    '${data}[option]'!='N E' and '${isNM}'!='${EMPTY}'    Toggle Field    Liver    NM    ${isNM}
    #Run Keyword If    '${data}[option]'!='Comments'    Run Keyword
    #...    Run Keyword If    '${data}[option]'!='    Select Value Under Comment Section    Liver    ${data}[subOption]
 
Select Value Under Comment Section
    [Documentation]    Select option located inside comments field.\n
    ...    Example: Selecting of 'Smooth' by first clcking selcting 'comments' then 'Smooth' of 'Liver' section.
    [Arguments]    ${field}    ${data}
    Select Value For Field    ${field}    Comments
    FOR    ${subSection}    IN    ${data}
        Run Keyword If    '${subSection}[type]'!='required_Fixed'    Toggle Field    ${field}    ${subSection}[option]    true
        Run keyword If    '${subSection}[radioOption]'!='${EMPTY}'    Select Value For Field    ${field}    ${subSection}[radioOption]
        Run keyword If    '${subSection}[textArea]'!='${EMPTY}'    Select Value For Field    ${field}    ${subSection}[textArea]
    END

Portal vein
    [Documentation]    selecting the options of portal vein
    [Arguments]    ${data}
    Scroll Element Into View    //table//td[text()='Portal vein']
    Select Value For Field    Portal vein    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Portal vein    ${data}[checkboxOptions]
    
    
Fill Comment Section
    [Arguments]    ${field}    ${data}    ${sideSelectionKey}=${None}
    FOR    ${fieldSection}    IN    @{data}
        ${locator}=    Run Keyword If    '${sideSelectionKey}' != '${None}'
        ...    Set Variable    //tr[td//span/b[text()='${sideSelectionKey}']]/following-sibling::tr[@note-structure='${field}']//div[./label[./input[@value='${fieldSection}[checkboxName]'] and (contains(@class,'sec-red-class') or contains(@class,'active-radio'))]]
        ...    ELSE
        ...    Set Variable        //tr[@note-structure='${field}']//div[./label[./input[@value='${fieldSection}[checkboxName]'] and (contains(@class,'sec-red-class') or contains(@class,'active-radio'))]]
        # sleep    1
        Toggle Field    ${field}    ${fieldSection}[checkboxName]    True    ${sideSelectionKey}
        Log    ${fieldSection} commenthere     DEBUG    console=yes
        # sleep    1
        Log     subcheck     DEBUG    console=yes
        Run keyword if  'subCheckboxName' in @{fieldSection}    Fill Sub Section    ${fieldSection}[option]    ${fieldSection}[subCheckboxName]
        # Run keyword if  'subCheckboxName' in @{fieldSection}    Run Keyword    Run Keyword If    '${fieldSection}[subCheckboxName]'=='NM'    Run Keywords    Scroll Element Into View    ${locator}//label[./input[@value='NM'] and contains(@class,'checkbox-styled')])[1]    AND    Click Element    ${locator}//label[./input[@value='NM'] and contains(@class,'checkbox-styled')])[1]
        # sleep    3
        Log     option     DEBUG    console=yes
        Log    ${locator}    console=yes
        Run keyword if  'option' in @{fieldSection}    Click Element    ${locator}//label[span[text()='${fieldSection}[option]']]
        # sleep    1
        Run keyword if  'option1' in @{fieldSection}    Click Element    ${locator}//label[span[text()='${fieldSection}[option1]']]
        # sleep    1
        Log     othersComment     DEBUG    console=yes
        Run keyword if  'othersComment' in @{fieldSection}    Input Text   ${locator}//textarea    ${fieldSection}[othersComment]
        # sleep    5
        Run keyword if  'cm/sec' in @{fieldSection}     Input Text   ${locator}//input[following-sibling::span[text()='cm/sec']]    ${fieldSection}[cm/sec]
        # sleep    1
        Log     textArea     DEBUG    console=yes
        Run keyword if  'textArea' in @{fieldSection}    Input Text    ${locator}//textarea    ${fieldSection}[textArea]
        # sleep    1
        Log     chooseOptions     DEBUG    console=yes
        Run Keyword If  'chooseOptions' in @{fieldSection}    Select Dropdown By Text    ${field}    --choose--    ${fieldSection}[chooseOptions]
        # sleep    1
        Log     inputBox     DEBUG    console=yes
        Run keyword if  'inputBox' in @{fieldSection}    Input Text    ${locator}//div[preceding::span[text()='${fieldSection}[inputBox][inputBoxName]']]/input[@name='rowText']    ${fieldSection}[inputBox][value]
        
        #Run keyword if    'type' in @{fieldSection}
        # ...    Run Keyword If    '${fieldSection}[type]'=='required_Fixed'     Run Keywords
        # ...    Log    Verify Requirerd field '${fieldSection}[checkboxName]' is Colored red and Mandatory.    DEBUG    console=yes
        #...    AND    Element Should Be Visible    //tr[@note-structure='${field}']//label[contains(@class,'sec-red-class')]/input[@value='${fieldSection}[checkboxName]' and contains(@class,'mandatory')]

    END


Fill Sub Section
    [Arguments]    ${field}    ${data}
    FOR    ${fieldSection}    IN    @{data}
        sleep    1
      
      
    END    
    # sleep     1    

Gallbladder
    [Documentation]    selecting the options of gall bladder
    [Arguments]    ${data}
    sleep    1
    Scroll Element Into View    //table//td[text()='Gallbladder']
    sleep    1
    Click Element    //table//td[text()='Gallbladder']
    sleep    1
    Select Value For Field    Gallbladder    ${data}[option]
    sleep    1
    Run keyword if  'checkboxOptions' in @{data}   Fill Comment Section    Gallbladder    ${data}[checkboxOptions]
    
CBD
    [Documentation]    selecting the options of CBD
    [Arguments]        ${data}
    Select Value For Field    CBD    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}   Fill Comment Section    CBD    ${data}[checkboxOptions]

    Run keyword if  'size' in @{data}    Enter Size In Sub-Field    CBD    ${data}[size]
    Run keyword if  'nm' in @{data}    Toggle Field    CBD    NM    ${data}[nm]

Pancreas
    [Documentation]    selecting the options of Pancreas
    [Arguments]    ${data}
    Select Value For Field    Pancreas    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}   Fill Comment Section    Pancreas    ${data}[checkboxOptions]

Spleen
    [Documentation]    selecting the options of spleen
    [Arguments]    ${data}
    Click Element    //table//td[text()='Spleen']
    Select Value For Field    Spleen    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}   Fill Comment Section    Spleen    ${data}[checkboxOptions]

    Run keyword if  'size' in @{data}    Enter Size In Sub-Field    Spleen    ${data}[size]
    Run keyword if  'nm' in @{data}    Toggle Field    Spleen    NM    ${data}[nm]

Right kidney
    [Documentation]    selecting the options of right kidney
    [Arguments]    ${data}
    Scroll Element Into View    //table//td[text()='Right kidney']
    Click Element    //table//td[text()='Right kidney']
    Select Value For Field    Right kidney    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}   Fill Comment Section    Right kidney    ${data}[checkboxOptions]

    Run keyword if  'size' in @{data}    Enter Size In Sub-Field    Right kidney    ${data}[size]
    Run keyword if  'nm' in @{data}    Toggle Field    Right kidney    NM    ${data}[nm]

Left kidney
    [Documentation]    selecting the options of left kidney
    [Arguments]        ${data}
    Scroll Element Into View    //table//td[text()='Left kidney']
    Select Value For Field    Left kidney    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}   Fill Comment Section    Left kidney    ${data}[checkboxOptions]

    Run keyword if  'size' in @{data}    Enter Size In Sub-Field    Left kidney    ${data}[size]
    Run keyword if  'nm' in @{data}    Toggle Field    Left kidney    NM    ${data}[nm]

Aorta
    [Documentation]    selecting the options of aorta
    [Arguments]    ${data}
    Select Value For Field    Aorta    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Aorta    ${data}[checkboxOptions]
    
    Run keyword if  'size' in @{data}    Enter Size In Sub-Field    Aorta    ${data}[size]
    Run keyword if  'nm' in @{data}    Toggle Field    Aorta    NM    ${data}[nm]
Rif
    [Documentation]    selecting the options of rif
    [Arguments]    ${data}
    Select Value For Field    RIF    ${data}[option]
    Run Keyword If    'roi' in @{data}    Toggle Field    RIF    ROI    ${data}[roi]
    # Run keyword if  'ROI' in @{data}    Check Roi    RIF    ${data}[checkboxOptions]   
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    RIF    ${data}[checkboxOptions]
    #Run keyword if  'checkboxOptions' in @{data}    Check Roi    RIF    ${data}[checkboxOptions]

Lif
    [Documentation]    selecting the options of lif
    [Arguments]    ${data}
    Select Value For Field    LIF    ${data}[option]
    Run Keyword If    'roi' in @{data}    Toggle Field    LIF    ROI    ${data}[roi]
    # Run keyword if  'checkboxOptions' in @{data}    Check Roi    LIF    ${data}[checkboxOptions]    
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    LIF    ${data}[checkboxOptions]
    #Run keyword if  'checkboxOptions' in @{data}    Check Roi    LIF    ${data}[checkboxOptions]

Free Fluid
    [Documentation]    selecting the options of free fluid
    [Arguments]    ${data}
    Select Value For Field    Free fluid    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Free fluid    ${data}[checkboxOptions]
   # Run Keyword If    '${subOptionList}'!='${EMPTY}' and '${subOptionList}'=='Suboptimal'
    #...    Toggle List Of Fields    Free fluid    ${subOptionList}    ${check}
    # Run Keyword If    '${subOptionList}'!='${EMPTY}' and '${subOptionList}'=='Suboptimal'
    # ...    Toggle List Of Fields    Free fluid    ${subOptionList}    ${check}


Lymph nodes
    [Documentation]    selecting the options of lymphnode
    [Arguments]    ${data}
    Select Value For Field    Lymph nodes    ${data}[option]
    Run Keyword If    'roi' in @{data}    Toggle Field    Lymph nodes    ROI    ${data}[roi]

Other Findings
    [Documentation]    selecting the options of Other findings
    [Arguments]    ${data}
    # Wait Until Element Is Visible    id=complete-screenshot    20
    sleep     20
    Select Value For Field    Other findings       ${data}[option]
    Run Keyword If    '${data}[option]'=='Comments'    Enter Text On Field    Other findings    ${data}[textArea]
    
Comment
    [Documentation]  selecting the options of comment
    [Arguments]    ${data}    
    Select Value For Field    COMMENT        ${data}[option]
    Run Keyword If    '${data}[option]'=='Comments'    Enter Text On Field    COMMENT    ${data}[textArea]

Further APT
    [Documentation]    selecting the options of Further APT
    [Arguments]        ${data}   
    Select Value For Field    Further APT    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Further APT    ${data}[checkboxOptions]
   

Follow up
    [Documentation]    selecting the options of Follow up
    [Arguments]      ${data}    
    Select Value For Field    Follow up    ${data}[option] 
    Run Keyword If    '${data}[option]'=='Yes'    Enter Text On Field    Follow up    ${data}[textArea]


Click On Graphic Tab
    [Documentation]    selecting the graphic tab
    Wait Until Element Is Enabled    id:graphics-panel
    Click Element    id:graphics-panel

Click On Nothing To Indicate
    [Documentation]    selecting the nothing to indicate tab
    Click Element    id:nothingToIndicate

Click Confirm and Complete
    sleep    5
    Wait Until Element Is Visible    class:toast-close-button    30
    Scroll Element Into View    class:toast-close-button
    Click Element    class:toast-close-button    
    Wait Until Page Does Not Contain Element    //div[@class='toast-message']    120
    Wait Until Element Is Visible    id=complete-screenshot    20
    Scroll Element Into View    id=complete-screenshot
   
    Click Using JavaScript    //input[@id='review-checkbox']    
    Click Element With Log Display    (//button[@id='complete-screenshot'])[last()]    Complete
    Wait Until Element Is Enabled    //div[@class='table-responsive']    120
    
Fill Template Data
    [Documentation]    Read template Json file and fill the form
    [Arguments]    ${templateType}    ${formType}    ${testFileName}=${None}    ${sideSelectionKey}=${None}
    ${pattern}    Split String    ${templateType}    _
    ${scenario}    Set Variable   ${pattern}[1]
    Log   templateType= ${templateType}    console=yes
    Log   scenario= ${pattern}[1]    console=yes
    Log    ${pattern[0]}     console=yes
     # ${templateData}=    Get Test Data With Filter    template/${pattern[0]}
     # ${data}    Set Variable   ${templateData}[${scenario}]
    # ${templateData}=    Get Test Data With Filter    template/${pattern[0]}    scenario    ${scenario}    
    ${templateData}=    Get Test Data With Filter    template/${pattern[0]}    scenario    ${scenario}
    sleep    5
    Log   templateData= ${templateData}    console=yes
    ${data}    Set Variable   ${templateData}[0]
    Log   templateData 0 = ${templateData}[0]    console=yes
    ${data}    Set Variable     ${data}[${scenario}]
    Log   data scenario = ${data}    console=yes
    Run Keyword If    '${formType}'=='generalInfo'    Fill The General Information Form    ${data}[generalInfo]    ${testFileName}   
    Run Keyword If    '${formType}'=='clinicalHx'    New Fill The List Of Fields    ${data}[clinicalHx]    ${criticalHxFieldList}    
    Run Keyword If    '${formType}'=='findings' and '${sideSelectionKey}' != '${None}'
    ...    Fill The List Of Fields with SideSelection    ${data}[findings]    
    ...    ELSE IF    '${formType}'=='findings'
    ...    New Fill The List Of Fields    ${data}[findings]    ${findingList}
    Run Keyword If    '${formType}'=='comment'    New Fill The List Of Fields    ${data}[comment]    ${commentList}
    Run Keyword If    '${formType}'=='bursa'    List Of Fields with SideSelection for Findings    ${data}[bursa]    ${sideSelectionKey}
    Run Keyword If    '${formType}'=='jEffusion'    List Of Fields with SideSelection for Findings    ${data}[jEffusion]    ${sideSelectionKey}
    Run Keyword If    '${formType}'=='joint'    List Of Fields with SideSelection for Findings    ${data}[joint]    ${sideSelectionKey}
    Run Keyword If    '${formType}'=='tendon'    List Of Fields with SideSelection for Findings    ${data}[tendon]    ${sideSelectionKey}
    Run Keyword If    '${formType}'=='commonFindings'    List Of Fields with SideSelection for Findings    ${data}[commonFindings]    ${sideSelectionKey}
        
          
Worksheet Submit
    [Arguments]    ${Preview Complete}
    run keyword if   "${Preview Complete}" == "Preview Complete"    Run Keywords   Click Preview and Complete    

    run keyword if  "${Preview Complete}" != "Preview Complete"    Click Pause
    ${present}=    Run Keyword And Return Status    Element Should Be Visible   xpath=(//div[contains(@class,'alert-light-warning')])[4]
    run keyword if    ${present} and "${Preview Complete}" == "Preview Complete"    Run Keywords
    ...    Scroll Element Into View    xpath=(//div[contains(@class,'modal-footer')]/button[@data-dismiss='modal'])[11]    AND
    ...    Click Element    xpath=(//div[contains(@class,'modal-footer')]/button[@data-dismiss='modal'])[11]    AND
    ...    Run Keyword And Continue On Failure    Wait Until Keyword Succeeds    1min    3sec    Fill Mandatory Fields       AND
    ...    Click Preview and Complete    AND   
    ...    Click Confirm and Complete
    ...    ELSE IF    "${Preview Complete}" == "Preview Complete"
    ...    Click Confirm and Complete
    
    ${present}=    Run Keyword And Return Status    Element Should Be Visible   xpath=(//div[contains(@class,'alert-light-warning')])[4]
    run keyword if    ${present} and "${Preview Complete}" != "Preview Complete"    Run Keywords
    ...    Scroll Element Into View    xpath=(//div[contains(@class,'modal-footer')]/button[@data-dismiss='modal'])[11]    AND
    ...    Click Element    xpath=(//div[contains(@class,'modal-footer')]/button[@data-dismiss='modal'])[11]    AND
    ...    Run Keyword And Continue On Failure    Wait Until Keyword Succeeds    1min    3sec    Fill Mandatory Fields       AND
    ...    Click Pause    
    # ...    ELSE IF    "${Preview Complete}" != "Preview Complete"
    # ...    Click Confirm and Complete
    

Fill The List Of Fields with SideSelection
    [Documentation]     Filling the findings for findings
    [Arguments]    ${members}
    Log   =========== Findings ===========    console=yes
    FOR    ${key}    IN    @{members}
       List Of Fields with SideSelection for Findings    ${members['${key}']}   ${key} 
    END    

List Of Fields with SideSelection for Findings
    [Arguments]    ${member}    ${sideSelectionKey}
    FOR    ${key}    IN    @{member}
        # ${value}=    Get From Dictionary    ${fieldList}    ${key}
        # Run keyword if  '${key}' in @{member}    ${key}     ${member}[${key}]
        # Run keyword if  '${key}' in @{member}    RunKeys     ${member}[${key}]    ${key}
        Run keyword if  '${key}' in @{subTempTypes}
        ...    Fill Template Data    ${member}[${key}][templateType]    ${key}    ${None}    ${sideSelectionKey}
        ...    ELSE IF  '${key}' in @{member} and '${key}' in @{criticalHxFieldList}    ${key}     ${member}[${key}]    
        ...    ELSE IF  '${key}' in @{member} and '${key}' in @{commentList}    ${key}     ${member}[${key}]  
        ...    ELSE IF  '${key}' in @{member}    SideSelection and FindingKeys     ${member}[${key}]    ${key}    ${sideSelectionKey}
    END

SideSelection and FindingKeys
    [Documentation]    selecting the options of Liver
    [Arguments]    ${data}=${EMPTY}    ${key}=${NONE}    ${sideSelectionKey}=${None}
    sleep    1
    # @{templateKeys}
    
    ${Liver}    Set Variable    ${key}
    ${value}    Set Variable    None
    @{tempalteKey}=    Split String    ${key}    ${SPACE}
    FOR    ${tmpKey}    IN    @{tempalteKey}
         ${value}=    Run Keyword If    '${tmpKey}' in @{templateKeys}    Set Variable    ${tmpKey}
         
    END        
    
    ${match}    ${value1}      Run Keyword And Ignore Error      Should Contain Any      ${key}    J effusion     ${SPACE}B     ${SPACE}J     ${SPACE}T        
    ${RETURNVALUE}      Set Variable If      '${match}' == 'PASS'      ${True}      ${False}
    Log    RETURNVALUE:${RETURNVALUE}    console=yes
    Log    match:${match}    console=yes
    Log    value1:${value1}    console=yes
    # Scroll Element Into View    //table//td[text()='${key}']
    Run Keyword If    '${key}' == 'Other findings' or '${key}' == 'COMMENT'    Scroll Element Into View    xpath=(//table//tbody[tr//td//span//b[text()="${sideSelectionKey}"]]//following-sibling::tbody//tr[@note-structure='${key}']//td[text()='${key}'])[1]
    ...    ELSE IF    ${RETURNVALUE}    Scroll Element Into View    //tr[td//span/b[text()='${sideSelectionKey}']]/following-sibling::tr[@note-structure='${key}']//td[span[text()='${value}']]
    ...    ELSE
    ...   Scroll Element Into View    //tr[td//span/b[text()='${sideSelectionKey}']]/following-sibling::tr[@note-structure='${key}']//td[text()='${key}']
    # sleep    1
    Select Value For Field with SideSelection    ${key}    ${data}[option]    ${sideSelectionKey}
    # sleep    1
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    ${key}    ${data}[checkboxOptions]    ${sideSelectionKey}
    # sleep    1
    Run keyword if  'size' in @{data}    Enter Size In Sub-Field    ${key}    ${data}[size]
    # sleep    1
    Run keyword if  'nm' in @{data}    Toggle Field    ${key}    NM    ${data}[nm]
    Run Keyword If    'roi' in @{data}    Toggle Field    ${key}    ROI    ${data}[roi]
    
Select Value For Field with SideSelection
    [Documentation]    Click Yes radio option for given field
    [Arguments]    ${fieldName}    ${value}    ${sideSelectionKey}=${None}
    # ${location}    Set Variable    (//tr[@note-structure="${fieldName}"]//label[span[text()='${value}']])[1]
    ${location}=    Run Keyword If    '${fieldName}' == 'Other findings' or '${fieldName}' == 'COMMENT'    Set Variable    xpath=(//table//tbody[tr//td//span//b[text()="${sideSelectionKey}"]]//following-sibling::tbody//tr[@note-structure="${fieldName}"]//label[span[text()="${value}"]])[1]
    ...    ELSE    Set Variable    //tr[td//span/b[text()="${sideSelectionKey}"]]/following-sibling::tr[@note-structure="${fieldName}"]//label[span[text()="${value}"]]
        
    Scroll Element Into View    ${location}
    Click Element With Log Display    ${location}    Selecting '${value}' for field '${fieldName}' in '${sideSelectionKey}'

Fill Bursa Data    
    [Arguments]    ${data}=${EMPTY}    ${key}=${NONE}    ${sideSelectionKey}=${None}
    sleep    1
    Scroll Element Into View    //table//td[text()='${key}']
    Select Value For Field    ${key}    ${data}[option]
 

Side Selection
    [Arguments]    ${option}
    ${locators}    Set Variable    xpath=(//tr//td//div//label//span[text()='${option}'])[1]
    ${count}    Get Element Count    ${locators}
    ${count}=     evaluate    ${count} + 1
    ${elements}=    Get WebElements    ${locators}

    
          
        ${present}=    Run Keyword And Return Status    Element Should Be Visible     ${locators}
        Run keyword if    ${present}    Run keywords
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Scroll Element Into View    ${locators} 
        ...    AND
        ...    Wait Until Keyword Succeeds    1 min    3 sec    Click Element    ${locators}
   
    
   
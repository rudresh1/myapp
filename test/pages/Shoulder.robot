*** Settings ***
Documentation    Custom Keywords for Logpoint
Library    String
Library    Collections
Library    SeleniumLibrary    
Library    OperatingSystem 
Library    DateTime
Resource    PageObject.robot
Resource    Abdominal.robot

*** Variable ***
${testsRootFolder}    ${EXECDIR}/test/driver/
@{criticalHxFieldList}    Clinical Hx (Referral)    Hx from patient    Surgical Hx    Comparison    Specific ROI    Scan quality    
@{sideSelectionList}    Side selection    LHB T    Subscapularis T    Supraspinatus T    Infraspinatus T       Subacromial B      AC J    Shoulder J effusion    Abduction    Internal rotation    External rotation    Frozen shoulder    Other findings
@{commentList}    COMMENT (_side_)   Further APT  Comment
    
*** Keywords ***

Fill US Shoulder Form
    [Arguments]    ${member}
    Run keyword if  'GeneralDetails' in @{member}    Fill The General Information Form    ${member['GeneralDetails']}
    Run keyword if  'clinicalHx' in @{member}    Fill Clinical Hx In Shoulder    ${member}[clinicalHx]
    Run keyword if  'side Selection' in @{member}    Fill Side selection in Shoulder    ${member}[side Selection]
    Run keyword if  'comments' in @{member}    Fill Comment in Adbominal    ${member}[comments]

side Selection
    [Documentation]    selecting the options of Side selection
    [Arguments]    ${data}    ${check}=true
    sleep    2
    Log    ${data}[option]
    Select Value For Field    Side selection    ${data}[option]
    # Run Keyword If    '${data}[option]'=='Suboptimal'
    # ...    Toggle Field And Their Corresponding Comment Section    Scan quality    ${data}[checkboxOptions]    ${check}


Fill Clinical Hx In Shoulder
    [Documentation]     Filling the form for clinical hx
    [Arguments]    ${clinMember}
    Log   clinMember= ${clinMember}        console=yes
    &{oldFieldList}    Create Dictionary    Clinical Hx (Referral)=referral    Hx from Patient=hxFromPatient    Surgical Hx=surgicalHx    Comparison=comparison
    ...    Specific ROI=specificRoi    Scan Quality=ScanQuality        
    Run keyword if  'templateType' in @{clinMember} 
    ...    Fill Template Data    ${clinMember}[templateType]    clinicalHx
    ...    ELSE    Fill The List Of Fields    ${clinMember}    ${oldFieldList}


Fill Side selection in Shoulder 
    [Documentation]     Filling the findings for findings
    [Arguments]    ${sideSeelectionMember}
    Log   =========== side selections options ===========    console=yes
      &{oldFieldList}    Create Dictionary    Side selection=sideSelection    LHB T=lhbt    Subscapularis T=subscapularisT    Supraspinatus T=supraspinatusT    Infraspinatus T=infraspinatusT    Subacromial B=subacromialB
      ...   Infraspinatus T=infraspinatusT   Subacromial bursa=subacromialBursa    AC J=acj    Shoulder J effusion=shoulderJeffusion    Abduction=abduction    Internal rotation=internalrotation    External rotation=externalrotation       
      ...    Frozen shoulder=frozenShoulder    Other Findings=otherfindings
      
    Run keyword if  'templateType' in @{sideSeelectionMember}
    ...    Fill Shoulder Template Data    ${sideSeelectionMember}[templateType]    shoulder
    ...    ELSE    Fill The List Of Fields    ${sideSeelectionMember}    ${oldFieldList}

Fill Shoulder Template Data
    [Arguments]    ${templateType}    ${formType}
    ${pattern}    Split String    ${templateType}    _
    ${scenario}    Set Variable   ${pattern}[1]
     # ${templateData}=    Get Test Data With Filter    template/${pattern[0]}
     # ${data}    Set Variable   ${templateData}[${scenario}]
    ${templateData}=    Get Test Data With Filter    template/${pattern[0]}    scenario    ${scenario}    
    sleep    5
    Log   ${scenario}    console=yes
    ${data}    Set Variable   ${templateData}[0]
    Log  template data 0 ${data}    console=yes
    ${data}    Set Variable     ${data}[${scenario}]
    Log   data scenario = ${data}    console=yes
    Run Keyword If    '${formType}'=='generalInfo'    Fill The General Information Form    ${data}[generalInfo]    
    Run Keyword If    '${formType}'=='clinicalHx'    New Fill The List Of Fields    ${data}[clinicalHx]    ${criticalHxFieldList}
    Run Keyword If    '${formType}'=='shoulder'     New Fill The List Of Fields In Shoulder    ${data}[shoulder]    ${sideSelectionList}
        # Log To Console    "tstlog"    
            # ${dataTemp}    Set Variable   ${data}[shoulder]
            # Log   "datatemp ==" ${dataTemp}    console=yes  
            # ${patterns}    Split String    ${dataTemp}[templateType]    _ 
            # ${scenario}    Set Variable   ${patterns}[1]
            # ${subTemplateData}=    Get Test Data With Filter    template/${patterns[0]}    scenario    ${scenario}
            # Fill Shoulder Sub Template Data    ${subTemplateData}   ${scenario}      ${patterns}[2]
            # ELSE IF    Run keywords      New Fill The List Of Fields1    ${data}[shoulder]    ${sideSelectionList}
        
    Run Keyword If    '${formType}'=='comment'    New Fill The List Of Fields    ${data}[comment]    ${commentList}
    sleep     2
 
Fill Shoulder Sub Template Data
    [Arguments]    ${subTemplateData}   ${scenario}      ${pattern}
    sleep    2
    Log    ${subTemplateData}    console=yes
    Log    ${scenario}    console=yes
    Log    ${pattern}    console=yes
    
 
New Fill The List Of Fields In Shoulder
    [Arguments]    ${member}    ${fieldList}
    
    FOR    ${key}    IN    @{fieldList}
        
        Log    ${key}    console=yes
        ${keyList}    Get Dictionary Keys    ${member} 
        ${found}    Evaluate    '${key}' in @{keyList}    
        Log    ${found}    console=yes  
        Log    ${member}[${key}]    console=yes
        ${patterns}=  set variable if  'templateType' in ${member}[${key}]
        ...    ${member}[${key}][templateType]     
        ${pattern}=     Run keyword if  'templateType' in ${member}[${key}]         
        ...    Split String    ${patterns}    _        
        ${templateData}=     Run keyword if  'templateType' in ${member}[${key}]      
        ...    Get Test Data With Filter    template/${pattern[0]}    scenario    ${pattern}[1]
        ${data}=  set variable if    ${templateData}     ${templateData}[0]
        ${data}=  set variable if    ${data}     ${data}[${pattern}[1]]
        # ${member}[${key}]=  set variable if    ${data}     ${data}     
        # Log    ${templateData}[0]
        Run keyword if  'option' in ${member}[${key}]    ${key}     ${member}[${key}]    
        Run keyword if  '${key}' in @{keyList}
        ...    Run Keyword If  ${data}
                ...    ${key}     ${data}
                ...    ELSE
                ...    ${key}     ${member}[${key}]
         # Run keyword if  '${key}' in @{keyList} and  ${member}[${key}][option]    ${key}     ${member}[${key}]
         sleep     10
    END      
LHB T
    [Documentation]      selecting the options of LHB T
    [Arguments]    ${data}
    sleep     4
    Log     ${data}[option]
    Scroll Element Into View    //tr[@note-structure='LHB T']
    Select Value For Field    LHB T    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    LHB T    ${data}[checkboxOptions]
 
Subscapularis T
    [Documentation]      selecting the options of Subscapularis T
    [Arguments]    ${data}
    sleep     2
    Scroll Element Into View    //tr[@note-structure='Subscapularis T']
    Select Value For Field    Subscapularis T    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Subscapularis T    ${data}[checkboxOptions] 

Supraspinatus T
    [Documentation]      selecting the options of Supraspinatus T
    [Arguments]    ${data}
    sleep     2
    Scroll Element Into View    //tr[@note-structure='Supraspinatus T']
    Select Value For Field    Supraspinatus T    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Supraspinatus T    ${data}[checkboxOptions]
    
Infraspinatus T
    [Documentation]      selecting the options of Infraspinatus T
    [Arguments]    ${data}
    sleep     2
    Scroll Element Into View    //tr[@note-structure='Infraspinatus T']
    Select Value For Field    Infraspinatus T    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Infraspinatus T    ${data}[checkboxOptions]
    
Subacromial B
    [Documentation]      selecting the options of Subacromial B
    [Arguments]    ${data}
    sleep     2
    Scroll Element Into View    //tr[@note-structure='Subacromial B']
    Select Value For Field    Subacromial B    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Subacromial B    ${data}[checkboxOptions]
    
Subacromial bursa
    [Documentation]      selecting the options of Subacromial bursa
    [Arguments]    ${data}
    sleep     2
    Scroll Element Into View    //tr[@note-structure='Subacromial bursa']
    Select Value For Field    Subacromial bursa    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Subacromial bursa    ${data}[checkboxOptions]
    
AC J
    [Documentation]      selecting the options of AC J
    [Arguments]    ${data}
    sleep     2
    Scroll Element Into View    //tr[@note-structure='AC J']
    Select Value For Field    AC J    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    AC J    ${data}[checkboxOptions]
    
Shoulder J effusion
    [Documentation]      selecting the options of Shoulder J effusion
    [Arguments]    ${data}
    sleep     2
    Scroll Element Into View    //tr[@note-structure='Shoulder J effusion']
    Select Value For Field    Shoulder J effusion    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Shoulder J effusion    ${data}[checkboxOptions]
    
Abduction
    [Documentation]      selecting the options of Abduction
    [Arguments]    ${data}
    sleep     2
    Scroll Element Into View    //tr[@note-structure='Abduction']
    Select Value For Field    Abduction    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Abduction    ${data}[checkboxOptions]
    
Internal rotation
    [Documentation]      selecting the options of Internal rotation
    [Arguments]    ${data}
    sleep     2
    Scroll Element Into View    //tr[@note-structure='Internal rotation']
    Select Value For Field    Internal rotation    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Internal rotation    ${data}[checkboxOptions]
    
External rotation
    [Documentation]      selecting the options of External rotation
    [Arguments]    ${data}
    sleep     2
    Scroll Element Into View    //tr[@note-structure='External rotation']
    Select Value For Field    External rotation    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    External rotation    ${data}[checkboxOptions]
    
Frozen shoulder
    [Documentation]      selecting the options of Frozen shoulder
    [Arguments]    ${data}
    sleep     2
    Scroll Element Into View    //tr[@note-structure='Frozen shoulder']
    Select Value For Field    Frozen shoulder    ${data}[option]
    Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Frozen shoulder    ${data}[checkboxOptions]
    
# Other findings
    # [Documentation]      selecting the options of Other findings
    # [Arguments]    ${data}
    # sleep     2
    # Scroll Element Into View    //tr[@note-structure='Other findings']
    # Select Value For Field    Other findings    ${data}[option]
    # Run keyword if  'checkboxOptions' in @{data}    Fill Comment Section    Other findings    ${data}[checkboxOptions]
  
*** Settings ***
Documentation    Custom Keywords for Logpoint
Library    String
Library    SeleniumLibrary    
Library    OperatingSystem 
Resource    PageObject.robot
Resource    Abdominal.robot

*** Variable ***
${testsRootFolder}    ${EXECDIR}/test/driver/
@{criticalHxFieldList}    Clinical Hx (Referral)    Hx from patient    Surgical Hx    Comparison    Specific ROI    Scan quality    Menstrual Hx    Contraception    Technique
@{findingList}    Rt. Parotid Gland       Lt. Parotid Gland    Rt. Submandibular G     Lt. Submandibular G           Thyroid     Lymph nodes    Other findings  
@{conclusionList}    Comment   Further APT   
    
*** Keywords ***

Fill US Pelvis Form
    [Arguments]    ${member}
    Run keyword if  'GeneralDetails' in @{member}    Fill The General Information Form    ${member['GeneralDetails']}
    Run keyword if  'clinicalHx' in @{member}    Fill Clinical Hx    ${member}[clinicalHx]
    Run keyword if  'findings' in @{member}    Fill Findings    ${member}[findings]
    Run keyword if  'conclusions' in @{member}    Fill Conclusion    ${member}[conclusions]

Fill Clinical Hx
    [Documentation]     Filling the form for clinical hx
    [Arguments]    ${clinMember}
    &{oldFieldListInPelvis}    Create Dictionary    Clinical Hx (Referral)=referral    Hx from Patient=hxFromPatient    Surgical Hx =surgicalHx    Comparison=comparison
    ...    Specific ROI=specificRoi    Scan Quality=ScanQuality    Menstrual Hx=menstrualHx    Contraception=contraception    Technique=technique    
    Run keyword if  'templateType' in @{clinMember}
    ...    Fill Template Data    ${clinMember}[templateType]    clinicalHx
    ...    ELSE    Fill The List Of Fields    ${clinMember}    ${oldFieldListInPelvis}

Fill Findings 
    [Documentation]     Filling the findings for clinical hx
    [Arguments]    ${findMember}
    Log   =========== Findings ===========    console=yes
    &{oldFieldListInPelvis}    Create Dictionary    Uterus size=UterusSize     Uterus position=UterusPosition   Other findings=Otherfindings    Uterus shape=UterusShape        Endometrium=Endometrium        Myometrium=Myometrium        Cervix=Cervix
    ...    Right ovary=RightOovary    Right adnexa=RightAdnexa    RIF=RIF    Left ovary=LeftOvary    Left adnexa=LeftAdnexa    LIF=LIF    Free fluid=FreeFluid
      
    Run keyword if  'templateType' in @{findMember}
    ...    Fill Template Data In Pelvis    ${findMember}[templateType]    findings
    ...    ELSE    Fill The List Of Fields    ${findMember}    ${oldFieldListInPelvis}
  

Fill Conclusion
    [Documentation]     Filling the conclusion for clinical hx
    [Arguments]         ${conMember}
    Log   =========== Findings ===========    console=yes
    &{oldFieldListInPelvis}    Create Dictionary    Comment=comment   Further APT=furtherapt    Follow up=followup
    
    Run keyword if  'templateType' in @{conMember}
    ...    Fill Template Data In Pelvis   ${conMember}[templateType]    conclusion
    ...    ELSE    Fill The List Of Fields    ${conMember}    ${oldFieldListInPelvis}
    ...    
  

Fill Template Data In Pelvis
    [Documentation]    Read template Json file and fill the form
    [Arguments]    ${templateType}    ${formType}
    ${pattern}    Split String    ${templateType}    _
    ${scenario}    Set Variable   ${pattern}[1]
     # ${templateData}=    Get Test Data With Filter    template/${pattern[0]}
     # ${data}    Set Variable   ${templateData}[${scenario}]
    ${templateData}=    Get Test Data With Filter    template/${pattern[0]}    scenario    ${scenario}    
    sleep    10
    ${data}    Set Variable   ${templateData}[0]
    ${data}    Set Variable     ${data}[${scenario}]
    Run Keyword If    '${formType}'=='generalInfo'    Fill The General Information Form   ${data}[generalInfo]    
    Run Keyword If    '${formType}'=='clinicalHx'    New Fill The List Of Fields    ${data}[clinicalHx]    ${criticalHxFieldList}    
    Run Keyword If    '${formType}'=='findings'    New Fill The List Of Fields   ${data}[findings]    ${findingList}
    Run Keyword If    '${formType}'=='conclusion'    New Fill The List Of Fields   ${data}[comment]    ${conclusionList}
    

*** Settings ***
Library    PythonKeywords
Library    SeleniumLibrary
Library    PythonKeywords
Resource    ../pages/PageObject.robot

Suite Setup       Open My Browser    ${url}     ${browser}     ${remoteMachineIp}
Suite Teardown    Close Browsers
                                                                                      
*** Variables ***
${url}    qa.smartmedsolution.com/login
${browser}    chrome
${remoteMachineIp}
${hx_text}    No
${surgical_text}    Yes
${comparision_text}    Yes
${specific_text}    No
${scan_text}     suboptimal
${liver_text}    comments
${portal_text}    nad
${gallbladder_text}    comments
${cbd_text}        comments
${pancreas_text}    comments
${spleen_text}    comments
${rkidney_text}   comments
${lkidney_text}    comments
${aorta_text}        comments
${rif_text}        comments
${lif_text}        comments

*** Test Cases ***

Simple Test Case
    Log   =========== Simple Test Case ===========    console=yes  
    ${all data members}=    Get Test Data With Filter    Sample
    ${member}=    Set Variable    @{all data members}[0]

    Login To Application    ${member['username']}    ${member['password']}
    Select The Ultrasound Room    ${member['ultrasoundRoom']}

    Select Room    ${member['rooms']}
    Goto Workshop
    # Verify Header and Page List
    Selecting The Page    ${member['pageName']}
    # Fill Findings in Abdominal    ${member}
    # Fill Clinical Hx In Abdominal    ${member}
    
        # ${data}    Set Variable    ${member}[clinicalHx][ScanQualit]
        # ${field}    Set Variable    ${data}[subOption]
        # FOR    ${detail}    IN    @{field}
            # Log    ${detail}[checkboxName]    DEBUG    console=yes   
        # END
    
    
    
    # Specific ROI    No
    # Specific ROI    Yes    Rt Upper quadrant,RIF    text goes here
    
    # Comparision    No
    # Comparision    Yes    inputString=asdfs
    # Comparision    Yes    MRI scan,Ultrasound    Unsure,Western Radiology    inputString=asdfs
    # Comparision    Yes    MRI scan,Ultrasound    Unsure,Western Radiology    Date    27/07/2020    asdfs
    # Comparision    Yes    MRI scan,Ultrasound    Unsure,Western Radiology    Unknown Date    inputString=            

    # Hx from Patient    No
    # Hx from Patient    Yes    texthere
    
    # Surgical Hx    No
    # Surgical Hx    Yes    Cholecystectomy,Rt. Total Nephrectomy 
    # Surgical Hx    Yes   
    # Surgical Hx    No
    # Surgical Hx    Yes    Rt. Partial Nephrectomy    string goes here    
    
    # Liver    NAD
    # Liver    isNM=true
    # Liver    isNM=false
    # Liver    size=100
    # Liver    Comments    isNM=true 
     
    
    # Free Fluid    No
    # # Free Fluid    Comments   freetext    true
    # Free Fluid    NE         
    
    
    # Other Findings    None    
    # Other Findings    Comments    texthere
    
    # Conclusion    No    
    # Conclusion    Comments    texthere
    
    # Follow up    No
    # Follow up    Yes    texthere
    
  

    
    Toggle List Of Fields    Liver    Cyst,Pneumobilia,Peripotal cuffing / starry sky appearance    true
    # Select Value Under Comment Section    Liver    Cyst    No    
    
    Toggle Field    Liver    NM    false
    Select Value For Field    Comparison    Yes
    Select Dropdown By Text    Comparison    ---Modality---    X-ray,Unsure,Unknown
    Select Dropdown By Text    Comparison    ---Provider---    Insight,PRC,SKG
    Enter Text On Field    Comparison    testing text area

    # Fill The Form    ${member['firstname']}    ${member['lastname']}      ${member['patientid']}      ${member['accessid']}      ${member['site-name']}
    # Fill Clinical Hx In Abdominal    ${member['values']}     ${hx_text}    ${surgical_text}    ${comparision_text}    ${specific_text}    ${scan_text}
    # Fill Findings In Abdominal    ${liver_text}    ${portal_text}    ${gallbladder_text}    ${cbd_text}    ${pancreas_text}    ${spleen_text}    ${rkidney_text}    ${lkidney_text}    ${aorta_text}    ${rif_text}    ${lif_text}







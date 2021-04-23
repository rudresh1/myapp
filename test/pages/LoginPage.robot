*** Settings ***
Documentation    Custom Keywords for Logpoint
Library    String
Library    SeleniumLibrary    
Library    OperatingSystem 
Resource    PageObject.robot

*** Variable ***

${testsRootFolder}    ${EXECDIR}/test/driver/


*** Keywords ***

Open My Browser
    [Arguments]    ${loginIp}    ${browser}    ${remoteIp}
     Run Keyword If    "${REMOTE IP}"!="${EMPTY}"
     ...    Browse Remotely    http://${loginIp}    ${browser}    ${remoteIp}
     ...    ELSE
     ...    Browse Locally    http://${loginIp}    ${browser}

Browse Locally
    [Arguments]    ${loginUrl}    ${browser}
    Append To Environment Variable  PATH    ${testsRootFolder}
    Run Keyword If    '${browser}'== 'chrome'    Open Chrome    ${loginUrl}    ${browser}
    Run Keyword If    '${browser}'== 'firefox'    Open Firefox    ${loginUrl}    ${browser}
    Run Keyword If    '${browser}'== 'edge'    Open Edge    ${loginUrl}    ${browser}      	
    # ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # Call Method    ${chrome_options}    add_argument    --ignore-certificate-errors
    # ${options}=     Call Method     ${chrome_options}    to_capabilities    
    # Open Browser    ${loginUrl}    browser=${browser}    desired_capabilities=${options}
    
    # Open Browser    ${LOGIN URL}   headlesschrome
    # Set Window Position    0    0
    # Set Window Size    960    1000

Open Edge
    [Arguments]    ${loginUrl}    ${browser}
    ${firefox_options} =     Evaluate    sys.modules['selenium.webdriver'].EdgeOptions()    sys, selenium.webdriver
    Call Method    ${firefox_options}    add_argument    --ignore-certificate-errors
    ${options}=     Call Method     ${firefox_options}    to_capabilities    
    Open Browser    ${loginUrl}    browser=${browser}    desired_capabilities=${options}
Open Firefox
    [Arguments]    ${loginUrl}    ${browser}
    ${firefox_options} =     Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    sys, selenium.webdriver
    Call Method    ${firefox_options}    add_argument    --ignore-certificate-errors
    ${options}=     Call Method     ${firefox_options}    to_capabilities    
    Open Browser    ${loginUrl}    browser=${browser}    desired_capabilities=${options}
Open Chrome
    [Arguments]    ${loginUrl}    ${browser}
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --ignore-certificate-errors
    ${options}=     Call Method     ${chrome_options}    to_capabilities    
    Open Browser    ${loginUrl}    browser=${browser}    desired_capabilities=${options}
    
Browse Remotely
    [Arguments]    ${loginUrl}    ${browser}    ${remoteIp}
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    # Call Method    ${chrome_options}    add_argument    --lang\=de     # NOTE: important to escape equal sign '\='
    # Call Method    ${chrome_options}   add_argument    headless
    # Call Method    ${chrome_options}   add_argument    disable-gpu
    ${options}=     Call Method     ${chrome_options}    to_capabilities
    Open Browser    ${loginUrl}    browser=${browser}    remote_url=http://${remoteIp}:4444/wd/hub     desired_capabilities=${options}
    # Create Webdriver    Remote   command_executor=http://${REMOTE IP}:4444/wd/hub    desired_capabilities=${options}
    Set Window Position    0    0
    Set Window Size    960    1000

Close Browsers
    Close All Browsers

Open Login Page
    [Arguments]    ${loginIp}
    Go To    https://${loginIp}

Login To Application
    [Documentation]    Login to application.
    [Arguments]    ${username}    ${password}
    Log    Login as ${username}    DEBUG    console=yes
    Maximize Browser Window
    Wait Until Element Is Visible     id:username
    Input Text        id:username       ${username}
    Input Password    id:password    ${password}        
    Click Button    //button[text()='Login']
    Wait Until Element Is Enabled    class:modal-dialog    60    Not Able to Login.    
    Log    Successfuly login    DEBUG    console=yes
    
    


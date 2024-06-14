#!/usr/bin/env python3

from io import TextIOWrapper
import requests,json
from requests.auth import HTTPBasicAuth
import sys, getopt
from datetime import datetime
from typing import Any

JIRA_HOST           = "https://jira-pro.its.hpecorp.net:8443"
JIRA_API_ENDPOINT   = "/rest/api/2/search?jql="
JIRA_FIELD_FIELDS   = 'fields'
JIRA_FIELD_ISSUES   = 'issues'
JIRA_FIELD_ID       = 'id'
JIRA_FIELD_SUMMARY  = 'summary'
JIRA_FIELD_DUE_DATE = 'duedate'
JIRA_FIELD_DESCRIPTION = 'description'
JIRA_FIELD_COMPONENTS  = 'components'
JIRA_FIELD_RISK_AND_ISSUES  = 'customfield_18325'
JIRA_FIELD_EVALUATED_PROBLEM_DESCRIPTION = 'customfield_18344'
JIRA_FIELD_WORKAROUND_STEPS = 'customfield_18343'
JIRA_FIELD_AFFECTS_VERSIONS = 'versions'
JIRA_FIELD_STRING   = { JIRA_FIELD_SUMMARY          : 'Summary',
                        JIRA_FIELD_DUE_DATE         : 'Due date',
                        JIRA_FIELD_DESCRIPTION      : 'Description',
                        JIRA_FIELD_COMPONENTS       : 'Components',
                        JIRA_FIELD_RISK_AND_ISSUES  : 'Risk and Issues',
                        JIRA_FIELD_EVALUATED_PROBLEM_DESCRIPTION : 'Evaluated Problem Description',
                        JIRA_FIELD_WORKAROUND_STEPS : 'Workaround Steps',
                        JIRA_FIELD_AFFECTS_VERSIONS : 'Affects Version/s'}

NS_NEW_FEATURES     = 'newfeatures'
NS_RESOLVED_ISSUES  = 'resolvedissues'
NS_KNOWN_ISSUES     = 'knownissues'
NS_BREAKING_CHANGES = 'interface_and_operational'
NS_SECURITY_ISSUES  = 'securityissues'
NS_SUMMARY          = 'summary'

ESCAPE        = '\\'
CRNL          = '\r\n'
UNDERSCORE    = '_'
NL            = '\n'
PIPE          = '|'
H2            = '##'
EMPTY_CONTENT = '<br>N/A<br>'
WHITE_SPACE   = ' '
MARKDOWN_SAFE_NL ='<br>'
MARKDOWN_PDF_SAFE_NL = MARKDOWN_SAFE_NL + WHITE_SPACE + WHITE_SPACE

MISSING_JIRA_CONTENT     = "MISSING-JIRA-CONTENT-IN-FIELD:"
UNSUPPORTED_JIRA_CONTENT = "UNSUPPORTED-JIRA-CONTENT-IN-FIELD:"

QUERY_FILTERS = { NS_NEW_FEATURES     : 'filter = slingshot-2.1.2-release-notes-feature-complete',
                  NS_RESOLVED_ISSUES  : 'filter = slingshot-2.1.2-release-notes-resolved-issues',
                  NS_KNOWN_ISSUES     : 'filter = slingshot-2.1.2-release-notes-known-issues',
                  NS_BREAKING_CHANGES : 'filter = slingshot-2.1.2-release-notes-breaking-change',
                  NS_SECURITY_ISSUES  : 'filter = slingshot-2.1.2-release-notes-security',
                  NS_SUMMARY          : 'filter = slingshot-2.1.2-release-notes-summary' }

QUERY_FIELDS  = { NS_NEW_FEATURES     : [ JIRA_FIELD_ID, JIRA_FIELD_SUMMARY, JIRA_FIELD_RISK_AND_ISSUES, JIRA_FIELD_EVALUATED_PROBLEM_DESCRIPTION ],
                  NS_RESOLVED_ISSUES  : [ JIRA_FIELD_ID, JIRA_FIELD_SUMMARY, JIRA_FIELD_RISK_AND_ISSUES, JIRA_FIELD_COMPONENTS, JIRA_FIELD_AFFECTS_VERSIONS ],
                  NS_KNOWN_ISSUES     : [ JIRA_FIELD_ID, JIRA_FIELD_SUMMARY, JIRA_FIELD_WORKAROUND_STEPS ],
                  NS_BREAKING_CHANGES : [ JIRA_FIELD_ID, JIRA_FIELD_SUMMARY, JIRA_FIELD_RISK_AND_ISSUES, JIRA_FIELD_EVALUATED_PROBLEM_DESCRIPTION ],
                  NS_SECURITY_ISSUES  : [ JIRA_FIELD_ID, JIRA_FIELD_SUMMARY, JIRA_FIELD_RISK_AND_ISSUES ],
                  NS_SUMMARY          : [ JIRA_FIELD_DUE_DATE, JIRA_FIELD_DESCRIPTION ] }

HEADINGS      = { NS_NEW_FEATURES     : 'New Features',
                  NS_RESOLVED_ISSUES  : 'Resolved Issues',
                  NS_KNOWN_ISSUES     : 'Known Issues',
                  NS_BREAKING_CHANGES : 'Interface and Operational Changes',
                  NS_SECURITY_ISSUES  : 'Security Issues Resolved',
                  NS_SUMMARY          : 'Summary' }

TBL_LABELS    = { NS_NEW_FEATURES     : ['ID', 'Description', 'Impact', 'Benefit'],
                  NS_RESOLVED_ISSUES  : ['ID', 'Description', 'Impact', 'Component', 'Affected Version/s'],
                  NS_KNOWN_ISSUES     : ['ID', 'Description', 'Workaround'],
                  NS_BREAKING_CHANGES : ['ID', 'Description', 'Impact', 'Benefit'],
                  NS_SECURITY_ISSUES  : ['ID', 'CVE', 'Description'],
                  NS_SUMMARY          : [] }

TBL_DIVIDERS  = { NS_NEW_FEATURES     : [':--:', ':---------', ':---------', ':---------'],
                  NS_RESOLVED_ISSUES  : [':--:', ':---------', ':---------', ':----', ':----'],
                  NS_KNOWN_ISSUES     : [':--:', ':---------', ':---------'],
                  NS_BREAKING_CHANGES : [':--:', ':---------', ':---------', ':---------'],
                  NS_SECURITY_ISSUES  : [':--:', ':----', ':---------'],
                  NS_SUMMARY          : [] }

MARKDOWN_SAFE = { CRNL       : MARKDOWN_PDF_SAFE_NL,
                  UNDERSCORE : f'{ESCAPE}{UNDERSCORE}' }

SUMMARY_TEMPLATE = '''
Date of Release: {}

{} {}

{}'''

RELEASE_NOTE_CONTENTS = [ NS_NEW_FEATURES,
                          NS_RESOLVED_ISSUES,
                          NS_KNOWN_ISSUES,
                          NS_BREAKING_CHANGES,
                          NS_SECURITY_ISSUES,
                          NS_SUMMARY ]

def commandline_args() -> tuple:
    user = ''
    password = ''
    cacert = False
    opts = []
    
    try:
        opts, [] = getopt.getopt(sys.argv[1:], "c:u:p:h", ['user=', 'password=', 'cacert', 'help'])
    except:
        print("Error for command line aurguments")
        
    for opt, arg in opts:
        if opt in ['-u', '--user']:
            user = arg
        elif opt in ['-p', '--password']:
            password = arg
        elif opt in ['-c', '--cacert']:
            cacert = arg            
        elif opt in ['-h', '--help']:
            print("format for executing file: slingshot-create-release-note.py -u <user name> -p <password> -c <cacert>")
            exit(1)
            
    return (user, password, cacert)


def generate_heading(fd : TextIOWrapper, key : str) -> int:
    return fd.write(f'{NL}{H2} {HEADINGS[key]}{NL}')    


def generate_markdown_table(fd : TextIOWrapper, col : str) -> int:
    if (col == []):
        return fd.write(f'{PIPE + NL}')
    
    fd.write(f'{PIPE}{col[0]}')
    
    return generate_markdown_table(fd, col[1:])


def generate_markdown_content(fd : TextIOWrapper, content : str) -> int:
    return fd.write(content)


def generate_markdown_summary(fd : TextIOWrapper, contents : list) -> int:
    try:
        date_obj = datetime.strptime(contents[0], "%Y-%m-%d")
        date_str = datetime.strftime(date_obj, "%B %d, %Y")
    except:
        date_str = contents[0]
        
    content = SUMMARY_TEMPLATE.format(date_str, H2, HEADINGS[NS_SUMMARY], contents[1])
    
    return generate_markdown_content(fd, content)


def generate_release_note_snippet(name : str, contents : list) -> None:
    with open(f'{name}.md', 'w') as fd:
        if (contents == []):
            generate_heading(fd, name)            
            generate_markdown_content(fd, EMPTY_CONTENT)
            return 

        if (name == NS_SUMMARY):
            [ generate_markdown_summary(fd, content) for content in contents ]
        else:
            generate_heading(fd, name)
            generate_markdown_table(fd, TBL_LABELS[name])
            generate_markdown_table(fd, TBL_DIVIDERS[name])
            [ generate_markdown_table(fd, content) for content in contents ]
    return


def query_components_handler(value: Any) -> str:
    if (value[1:] == []):
        return value[0].get("name")
    else:
        return value[0].get("name") + MARKDOWN_PDF_SAFE_NL + query_components_handler(value[1:])

    
def query_string_handler_1(value : str, keys : list) -> str:
    if ( keys == []):
        return value

    return query_string_handler_1(value.replace(keys[0], MARKDOWN_SAFE[keys[0]]), keys[1:])


def query_string_handler(value: Any) -> str:
    markdown_keys = MARKDOWN_SAFE.keys()
    
    return query_string_handler_1(value, list(markdown_keys))


def query_preformat_handler(value : Any) -> Any:
    return value
    

def query_default_handler(value: Any) -> str:
    return UNSUPPORTED_JIRA_CONTENT + type(value)


def query_fields_handler(issue : Any, key :str) -> Any:
    handlers = { JIRA_FIELD_DESCRIPTION                   : query_preformat_handler,
                 JIRA_FIELD_SUMMARY                       : query_string_handler,
                 JIRA_FIELD_RISK_AND_ISSUES               : query_string_handler,
                 JIRA_FIELD_EVALUATED_PROBLEM_DESCRIPTION : query_string_handler,
                 JIRA_FIELD_DUE_DATE                      : query_string_handler,
                 JIRA_FIELD_WORKAROUND_STEPS              : query_string_handler,
                 JIRA_FIELD_AFFECTS_VERSIONS              : query_components_handler,                 
                 JIRA_FIELD_COMPONENTS                    : query_components_handler }
    
    res = issue.get(JIRA_FIELD_FIELDS).get(key)

    if (res == None or res == []):
        return MISSING_JIRA_CONTENT + JIRA_FIELD_STRING[key]
    else:
        return handlers.get(key, query_default_handler)(res)

    
def safe_query_result(issue : Any, key : str) -> Any:
    if (key == JIRA_FIELD_ID):
        return issue.get(JIRA_FIELD_ID)

    return query_fields_handler(issue, key)


def query(file_name : str) -> list:
    user, password, cacert = commandline_args()
    query_uri = JIRA_HOST + JIRA_API_ENDPOINT + QUERY_FILTERS[file_name]    
    query_resp = requests.get(query_uri, verify = cacert, auth = HTTPBasicAuth(user, password))
    query_resp_text = json.loads(query_resp.text)
    
    return [[safe_query_result(i, x) for x in QUERY_FIELDS[file_name]]
            for i in query_resp_text.get(JIRA_FIELD_ISSUES)]

def main():
    for name in  RELEASE_NOTE_CONTENTS:
        contents = query(name)
        generate_release_note_snippet(name, contents)

if __name__ == '__main__':
    main()

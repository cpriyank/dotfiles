#!/bin/python
from subprocess import check_output

def get_pass(outlook):
        return check_output("pass Mail/"+outlook, shell=True).rstrip()

def get_pass(gmail):
        return check_output("pass Mail/"+gmail, shell=True).rstrip()
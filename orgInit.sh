#!/bin/bash

sfdx force:org:create -f config/project-scratch-def.json -s -a empAppsX
sfdx force:source:push
sfdx force:user:permset:assign -n DealerManager
sfdx force:data:tree:import -p data/importPlan.json
# sfdx force:apex:execute -f scripts/setup.cls
sfdx force:org:open -p one/one.app#/n/Mobile_Inspections
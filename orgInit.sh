#!/bin/bash

sfdx force:org:create -f config/project-scratch-def.json -s
sfdx force:source:push
sfdx force:user:permset:assign -n myPermSetName
sfdx force:data:tree:import -p data/masterImportPlan.json
sfdx force:apex:execute -f scrips/setup.cls
sfdx force:org:open
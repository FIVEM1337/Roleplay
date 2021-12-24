#!/bin/bash
dir=${PWD}
file_contents=$(cat binary-server/txport.txt)

bash ${dir}'/binary-server/run.sh' +set txAdminPort $file_contents

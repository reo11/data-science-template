#!/bin/bash
files=$(find . -type f -name "*.py")

for file_name in $files;do
   autopep8 --in-place --aggressive --aggressive $file_name
done
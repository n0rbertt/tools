#!/bin/bash
echo "Which command?"
read cmd
man -t $cmd | ps2pdf - $cmd.pdf


#!/bin/bash

exec dd ibs=6102 skip=1 cbs=2554 conv=unblock if=Reval_GeneralInfo.txt of=geninfo_rec.txt

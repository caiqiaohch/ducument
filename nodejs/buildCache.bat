@echo off
cd 导出目录
python buildCache.py -input ..\猛将数值表 -output .\develop
echo 导表完成，按任意键关闭
pause

python buildCache.py -input ../猛将数值表 -output ./develop >log.txt
@echo off
cd ����Ŀ¼
python buildCache.py -input ..\�ͽ���ֵ�� -output .\develop
echo ������ɣ���������ر�
pause

python buildCache.py -input ../�ͽ���ֵ�� -output ./develop >log.txt
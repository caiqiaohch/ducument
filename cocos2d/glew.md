 OpenGLѧϰ----��������-glew
2.2 glew

2.2.1 ���
OpenGL��չWrangler��(GLEW)��һ����ƽ̨�Ŀ�ԴC/C++��չ���ؿ⡣GLEW�ṩ�˸�Ч������ʱ������ȷ��Ŀ��ƽ̨��֧����ЩOpenGL��չ��OpenGL���ĺ���չ�����ڵ���ͷ�ļ��й�����
������

    ֧�ֺ���OpenGL 4.6�ͳ���399����չ
    ��Windows��Linux��Mac OS X��FreeBSD��Irix��Solaris�Ͻ����˲���
    ����OpenGL��չ�淶�Զ����ɴ���
    �Զ����Ⱦ�����ĵ��̰߳�ȫ֧��
    ��չ֧����֤ʵ�ó���

2.2.2 ���ļ��ͱ��빤��׼��
��http://glew.sourceforge.net/index.html����glew��
��https://cmake.org/download/����CMake���빤�ߡ�
2.1.3 ����glew��
�����ص�glew���ļ�glew-2.1.0.zip��ѹ��Ȼ���cmake���ߣ�ѡ��CMakeLists.txt�ļ����ڵ��ļ���(glew-2.1.0\build\cmake)�Լ������ļ���·��������ͼ��


�� Configure ѡ��������ͱ���İ汾����(x64 �� win32)��


��Finish�󣬿�ʼ����Ĭ�����ã�


����������£�


������Ҫ�������Լ����������ñ���ѡ��������£�
��1��Ĭ���ַ���Ϊʹ�ö��ֽ��ַ�����Ĭ������ʱ��ΪMTd����Ҫ�޸�Ϊ�ַ���ʹ��Unicode���޸�����ʱ��ʹ��MDd,��Ҫ��CMakeLists.txt�����ļ������������������ݣ�
add_definitions(-MDd -DUNICODE -D_UNICODE)


��2�����뽫����֮��� lib ��ͷ�ļ������ָ���ļ����£�����Ҫ����CMARK_INSTALL_PREFIX ���·����


���������µ���� Configure���� CMake ������޸ĺ�Ĳ�������������Ŀ:


Ȼ���generate��ʼ���ɽ��������


Ȼ��򿪽��������׼�����룺


��ALL_BUILD�������ɣ�


��INSTALL�������ɣ�


���ɳɹ��������ܿ�����cmake�����õ������ļ�·����


�Լ����ļ���


����glew�������ɡ�

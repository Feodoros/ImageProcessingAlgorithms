struct u_Struct            // ���塞 ��������.
{
  float angle;             // � ������ angle �㤥� �࠭����� 㣮� (0..2*Pi), ���祭�� ���ண�
                           // �㤥� �������� � �ணࠬ��.
};

uniform u_Struct u_struct; // ���塞 uniform-��६����� u_struct.

varying float v_t;         // ���塞 varying-��६����� v_t. �� ��६����� �㤥� ��।������� 
                           // �� �ࠣ����� 襩���, ��� �� �㤥� ���� �� ���௮��஢�����
                           // ���祭��.

attribute float a_phase;   // ���塞 attribute-��६����� a_phase. �� ��६����� �㤥�
                           // ���������� ���-���⥪᭮, � ������� 䠧���� ᬥ饭�� ��� ᨭ��.

void main()                // ������� �㭪�� - �窠 �室� � 襩���. 
{
  float c = sin(a_phase + u_struct.angle);     // ����ᥬ � ��६����� 'c' ���᫥��� ᨭ�� 
                                               // � ������ 䠧�� � 㣫��.

  gl_Position = gl_ModelViewProjectionMatrix * // ����襬 � clip-������ ���⥪�
                gl_Vertex +                    // �࠭��ନ஢���� object-������ � �������
                c;                             // � ����祭���� ������ ���祭�� 'c'.
                                               // ������ ���設� �㤥� ���������� �� ᨭ���
                                               // � ᢮�� 䠧�� � ��騬 㣫��.         

  v_t = abs(sin(u_struct.angle));              // ���᫨� 0..1 ���祭��, ������饥 �� 㣫�.
                                               // ����祭��� �᫮ �� ����襬 � 
                                               // varying-��६����� 'v_t'  ��� ��᫥���饣� 
                                               // �ᯮ�짮����� �� �ࠣ���⮬ 襩���.

  // �믮��塞 ࠡ��� ffp:

  gl_FrontColor = gl_Color;                    // ��襬 梥�.
  gl_TexCoord[0] = gl_MultiTexCoord0;          // ��襬 ⥪������ ���न���� 0-�� �.
}

struct u_Struct              // ���塞 ��������, �������筮 ��� � ���⥪᭮� 襩���.
{
  float angle;
};

uniform u_Struct u_struct;   // ��� ��� uniform-��६����� u_struct ����� ���������� ��� � ⨯
                             // � u_struct � ���⥪᭮�-襩���, �� uniform'� ���� ��ꥤ�����
                             // �� ��������, � ���������� � �ணࠬ�� ���� ��� ����, ��騩
                             // ��� vs/fs uniform.  

uniform sampler2D u_texture; // ���塞 uniform-��६����� ⨯� sampler2D. � u_texture
                             // �㤥� ���������� ����� ⥪���୮�� �, �� ���ண� ��
                             // �㤥� ���� ⥪ᥫ�. 

varying float v_t;           // ���塞 varying-��६����� v_t, �������筮 ��� � ���⥪᭮�
                             // 襩���. �� ��� �� �㤥� ���� 㦥 ���௮��஢����� ����� 
                             // ���⥪ᠬ� ���祭��.

vec3 grayscale(vec3 color, float t) // ���塞 �㭪�� ���௮��樨 ��室���� 梥� (color) �
                                    // ᮮ�. ��� grayscale-梥� �� t.
{
  const vec3 vGrayscale = vec3(0.2125, 0.7154, 0.0721); // �����樥��� ��ॢ��� � grayscale.

  const mat3 mIdentity = mat3(vec3(1, 0, 0),  // �����筠� �����. �������� � column-major
                              vec3(0, 1, 0),  // �ଠ�.
                              vec3(0, 0, 1)); 

  vec3 c;                    // ���塞 vec4-��६����� c, � ���ன �㤥� �࠭�����
                             // ���᫥���� ���祭��.

  c.r = dot(mix(vGrayscale, mIdentity[0], t), color); // ����砥� red-����������.
  c.g = dot(mix(vGrayscale, mIdentity[1], t), color); // ����砥� green-����������.
  c.b = dot(mix(vGrayscale, mIdentity[2], t), color); // ����砥� blue-����������.

  return c; // �����頥� ���祭�� ��६����� 'c'.
}

void main()                  // ������� �㭪�� - �窠 �室� � 襩���. 
{
  vec4 texColor = texture2D(u_texture, vec2(gl_TexCoord[0]));  // ��⠥� ⥪ᥫ�.

  gl_FragColor = vec4(grayscale(vec3(texColor*gl_Color), v_t), // ��襬 � 梥� �ࠣ����, �
                      1);                                      // �⢥��� ��������� (�����)
                                                               // ����ᨬ 1.    
}

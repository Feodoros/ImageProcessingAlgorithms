struct u_Struct              // Объявляем структуру, аналогично как в вертексном шейдере.
{
  float angle;
};

uniform u_Struct u_struct;   // Так как uniform-переменная u_struct имеет одинаковое имя и тип
                             // с u_struct в вертексном-шейдере, эти uniform'ы будут объединены
                             // при линковке, и задаваться в программе будут как один, общий
                             // для vs/fs uniform.  

uniform sampler2D u_texture; // Объявляем uniform-переменную типа sampler2D. В u_texture
                             // будет задаваться номер текстурного юнита, из которого мы
                             // будем читать тексель. 

varying float v_t;           // Объявляем varying-переменную v_t, аналогично как в вертексном
                             // шейдере. Из нее мы будем читать уже интерполированное между 
                             // вертексами значение.

vec3 grayscale(vec3 color, float t) // Объявляем функцию интерполяции исходного цвета (color) и
                                    // соотв. ему grayscale-цвета по t.
{
  const vec3 vGrayscale = vec3(0.2125, 0.7154, 0.0721); // Коэффициенты перевода в grayscale.

  const mat3 mIdentity = mat3(vec3(1, 0, 0),  // Единичная матрица. Задается в column-major
                              vec3(0, 1, 0),  // формате.
                              vec3(0, 0, 1)); 

  vec3 c;                    // Объявляем vec4-переменную c, в которой будет храниться
                             // вычисленное значение.

  c.r = dot(mix(vGrayscale, mIdentity[0], t), color); // Получаем red-компоненту.
  c.g = dot(mix(vGrayscale, mIdentity[1], t), color); // Получаем green-компоненту.
  c.b = dot(mix(vGrayscale, mIdentity[2], t), color); // Получаем blue-компоненту.

  return c; // Возвращаем значение переменной 'c'.
}

void main()                  // Главная функция - точка входа в шейдер. 
{
  vec4 texColor = texture2D(u_texture, vec2(gl_TexCoord[0]));  // Читаем тексель.

  gl_FragColor = vec4(grayscale(vec3(texColor*gl_Color), v_t), // Пишем в цвет фрагмента, в
                      1);                                      // четвертый компонент (альфу)
                                                               // заносим 1.    
}

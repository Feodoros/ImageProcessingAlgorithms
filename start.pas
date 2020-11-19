// объявляем нужные переменные: 
var
    po: GLhandleARB;   // программный объект (program object)
    vs: GLhandleARB;   // вершинный шейдер
    fs: GLhandleARB;   // фрагментный шейдер
    u_angle: GLuint;   // адрес uniform-переменной 'u_angle'
    a_phase: GLuint;   // адрес attribute-переменной 'a_phase'
    u_texture: GLuint; // адрес uniform-переменной 'u_texture'
	
// Для проверки ошибок и вывода лога создадим процедуру CheckGLSLError
procedure CheckGLSLError(Handle: GLhandleARB; Param: GLenum);
var
  l, glsl_ok: GLint;
  s: PChar;
begin
  CheckGLError; // Проверяем ошибку OpenGL (см. демку к статье).
  glGetObjectParameterivARB(Handle, Param, @glsl_ok); // Получаем успешность операции 
                                                      // 'Param' для хэндла 'Handle'.
  s := StrAlloc(1000);
  glGetInfoLogARB(Handle, StrBufSize(s), @l, PGLcharARB(s)); // Получаем лог последней операции
                                                             // над хэндлом 'Handle'.
  Writeln(s); // Вывод лога на экран.
  Assert(glsl_ok = GL_TRUE, 'glSLang error');
end;

// Программный объект - это контейнер для различных по функциональности шйдеров, он нужен для линковки их друг с другом. Создаем его: 
  po := glCreateProgramObjectARB;

  // Теперь создадим сами шейдеры.

  vs := glCreateShaderObjectARB(GL_VERTEX_SHADER_ARB);
  CheckGLError; 
  fs := glCreateShaderObjectARB(GL_FRAGMENT_SHADER_ARB);
  CheckGLError;
  
// Укажем для шейдеров текст программ: 
  procedure LoadSources;
  var
    src: PChar; // PGLcharARB = PChar;
    len: GLuint;
  begin
    // Загружаем текст вершинного шейдера.
    src := PChar(LoadSourceFromFile('Shaders\GLSL-demo.vert'));
    len := StrLen(src);
    glShaderSourceARB(vs, 1, @src, @len);
    CheckGLError;

    // Загружаем текст фрагментного шейдера.
    src := PChar(LoadSourceFromFile('Shaders\GLSL-demo.frag'));
    len := StrLen(src);
    glShaderSourceARB(fs, 1, @src, @len);
    CheckGLError;
  end;

// Объявление glShaderSource выглядит так: 
procedure glShaderSourceARB(shaderObj: GLhandleARB; count: GLsizei; 

                            const string_: PPGLcharARB; const length: PGLint);

  // Компилируем шейдеры:
  
  glCompileShaderARB(vs);
  CheckGLSLError(vs, GL_OBJECT_COMPILE_STATUS_ARB);
  glCompileShaderARB(fs);
  CheckGLSLError(fs, GL_OBJECT_COMPILE_STATUS_ARB);

  // Затем присоединяем шейдеры к программному объекту:

  glAttachObjectARB(po, vs);
  glAttachObjectARB(po, fs);

  // Линкуем шейдеры в программном объекте (при линковке varying в vs 
  // соединяются с varying в fs, объединяются общие uniform'ы).

  glLinkProgramARB(po);
  CheckGLSLError(po, GL_OBJECT_LINK_STATUS_ARB);

  // Проверяем слинкованные шейдеры на предмет различных falls - в идеале эта функция в логе 
  // должна возвращать различные советы по улучшении оптимизации текста шейдер, но опять таки,
  // это зависит от вендора и реализации.

  glValidateProgramARB(po);
  CheckGLSLError(po, GL_OBJECT_VALIDATE_STATUS_ARB); 
  
// Получаем адрес нужных uniform-, varying-, и attribute-переменных: 
  u_angle := glGetUniformLocationARB(po, PGLcharARB(PChar('u_struct.angle')));
  CheckGLError;

  u_texture := glGetUniformLocationARB(po, PGLcharARB(PChar('u_texture')));
  CheckGLError;

  a_phase := glGetAttribLocationARB(po, PGLcharARB(PChar('a_phase')));
  CheckGLError;

  // Биндим программный объект:       
  glUseProgramObjectARB(po);
  
 glUniform1fARB(u_angle, angle); // Пишем в 'u_angle' значение переменной angle.
  CheckGLError;
  angle :=angle + angleStep;      // angle принимает значения от 0 до 2*Pi,
                                  // с каждым кадром увеличиваясь на angleStep.

  if angle > 2*Pi then angle := 2*Pi - angle;
  
  glUniform1iARB(u_texture, 0); // Пишем в 'u_texture' номер используемого tiu, 
                                // в данном случае 0. Разумеется, до этого нужно установить 
                                // текстурный образ и параметры фильтрации, разрешать
                                // GL_TEXTURE_2D не обязательно. 
  CheckGLError;

  glBegin(GL_TRIANGLES);                
    glColor3f(1.0, 0.0, 0.0);                
    glTexCoord2f(0.0, 0.0);
    glVertexAttrib1fARB(a_phase, 0.0); // Пишем в 'a_phase' требуемую фазу для вершина,
                                       // в данном случае 0. 
    glVertex3f(-10.0, -10.0, -30.0);

    glColor3f(0.0, 1.0, 0.0);
    glTexCoord2f(1.0, 0.0);
    glVertexAttrib1fARB(a_phase, 1.0); // Пишем в 'a_phase' требуемую фазу для вершина,
                                       // в данном случае 1.0. 
    glVertex3f(10.0, -10.0, -30.0);

    glColor3f(0.0, 0.0, 1.0);
    glTexCoord2f(0.5, 1.0);
    glVertexAttrib1fARB(a_phase, 2.0); // Пишем в 'a_phase' требуемую фазу для вершина,
                                       // в данном случае 2.0. 
    glVertex3f(0.0, 10.0, -30.0);
  glEnd;
  
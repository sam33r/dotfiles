// Custom window shader for Compton.
// This is called from a shell script that replaces {Iteration} with a positive number.
// Originally based on https://github.com/chjj/compton/issues/530

uniform sampler2D tex;
void main() {
  vec4 c = texture2D(tex, gl_TexCoord[0].xy);
  float y = dot(c.rgb, vec3(0.299, 0.587, 0.114));

  int mode = {Mode}%10;

  switch (mode) {
  default:
  case 0: // Default: No transform
    gl_FragColor = vec4(c.r, c.g, c.b, 1.0);
    break;
  case 1: // Color at 2700K
    gl_FragColor = vec4(c.r, c.g*0.66, c.b*0.34, 1.0);
    break;
  case 2: // Color at 2100K
    gl_FragColor = vec4(c.r, c.g*0.57, c.b*0.13, 1.0);
    break;
  case 3: // Color at 1700K
    gl_FragColor = vec4(c.r, c.g*0.47, 0.0, 1.0);
    break;
  case 4: // Color at 1200K
    gl_FragColor = vec4(c.r, c.g*0.33, 0.0, 1.0);
    break;
  case 5: // 2500K
    gl_FragColor = vec4(y, y*0.63, y*0.28, 1.0);
    break;
  case 6: // 2100K Mono
    gl_FragColor = vec4(y, y*0.57, y*0.13, 1.0);
    break;
  case 7: // 1700K Mono
    gl_FragColor = vec4(y, y*0.47, 0.0, 1.0);
    break;
  case 8: // 1200K Mono
    gl_FragColor = vec4(y, y*0.33, 0.0, 1.0);
    break;
  case 9: // Dark Mode (1700K Mono + Invert)
    y = 1.0 - y;
    gl_FragColor = vec4(y, y*0.47, 0.0, 1.0);
    break;
  }
}

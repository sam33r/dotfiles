// Custom window shader for Compton.
// This is called from a shell script that replaces {Iteration} with a positive
// number. Originally based on https://github.com/chjj/compton/issues/530

uniform sampler2D tex;
void main() {
  vec4 c = texture2D(tex, gl_TexCoord[0].xy);
  float y = dot(c.rgb, vec3(0.299, 0.587, 0.114));

  int mode = {Mode};

  gl_FragColor = vec4(y, y * 0.79, y * 0.58, 1.0);

  /* See https://andi-siess.de/rgb-to-color-temperature/
   * for color conversion calculations. */
  /* `switch` doesn't work with all versions of GSLS,
   * hence the long if-else block. */
  if (mode == 0) {  // Default: No transform
    gl_FragColor = vec4(c.r, c.g, c.b, 1.0);
  } else if (mode == 1) {  // Color at 3700K
    gl_FragColor = vec4(c.r, c.g * 0.79, c.b * 0.58, 1.0);
  } else if (mode == 2) {  // Color at 2700K
    gl_FragColor = vec4(c.r, c.g * 0.66, c.b * 0.34, 1.0);
  } else if (mode == 3) {  // Color at 2100K
    gl_FragColor = vec4(c.r, c.g * 0.57, c.b * 0.13, 1.0);
  } else if (mode == 4) {  // Color at 1200K
    gl_FragColor = vec4(c.r, c.g * 0.33, 0.0, 1.0);
  } else if (mode == 5) {  // 3700K Mono
    gl_FragColor = vec4(y, y * 0.79, y * 0.58, 1.0);
  } else if (mode == 6) {  // 2100K Mono
    gl_FragColor = vec4(y, y * 0.57, y * 0.13, 1.0);
  } else if (mode == 7) {  // 1700K Mono
    gl_FragColor = vec4(y, y * 0.47, 0.0, 1.0);
  } else if (mode == 8) {  // 1200K Mono
    gl_FragColor = vec4(y, y * 0.33, 0.0, 1.0);
  } else if (mode == 9) {  // Dark Mode (1700K Mono + Invert)
    y = 1.0 - y;
    gl_FragColor = vec4(y, y * 0.47, 0.0, 1.0);
  }
}

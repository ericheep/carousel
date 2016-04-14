#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;

uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

//////////////////////////////////////////

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0.0);
const float sqrtoftwo = 1.41421356237;

uniform float amount;
uniform float exposure;
uniform float diffusion;

void main(void)
{
	vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
  	vec2 tc1 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
  	vec2 tc2 = vertTexCoord.st + vec2(+texOffset.s, -texOffset.t);
  	vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
  	vec2 tc4 = vertTexCoord.st + vec2(         0.0,          0.0);
  	vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
  	vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s, +texOffset.t);
  	vec2 tc7 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
  	vec2 tc8 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);

  	vec4 input0 = texture2D(texture, tc0);
  	vec4 input1 = texture2D(texture, tc1);
  	vec4 input2 = texture2D(texture, tc2);
  	vec4 input3 = texture2D(texture, tc3);
  	vec4 input4 = texture2D(texture, tc4);
  	vec4 input5 = texture2D(texture, tc5);
  	vec4 input6 = texture2D(texture, tc6);
  	vec4 input7 = texture2D(texture, tc7);
  	vec4 input8 = texture2D(texture, tc8);
	
	vec4 blurresult = (input0 + input1 + input2 + input3 + input4 + input5 + input6 + input7 + input8) * 0.125;

	vec4 origluma = vec4(dot(input0, lumcoeff));
	vec4 luma = vec4(dot(blurresult, lumcoeff));

	vec4 contrast = mix(origluma, luma, diffusion);

	vec4 exposureresult = log2(vec4(pow(exposure + sqrtoftwo, 2.0))) * luma;

	vec4 result = mix(origluma, exposureresult, luma * contrast);
	result = mix(input0, result, amount);
	result.a = input0.a;
	
	gl_FragColor = result;
}

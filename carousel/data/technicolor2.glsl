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

const vec4 redfilter 		= vec4(1.0, 0.0, 0.0, 0.0);
const vec4 bluegreenfilter 	= vec4(0.0, 1.0, 1.0, 0.0);

const vec4 cyanfilter		= vec4(0.0, 1.0, 0.5, 0.0);
const vec4 magentafilter	= vec4(1.0, 0.0, 0.25, 0.0);

uniform float amount;

void main(void)
{
	vec4 input0 = texture2D(texture, vertTexCoord.st);

	vec4 redrecord = input0 * redfilter;
	vec4 bluegreenrecord = input0 * bluegreenfilter;
	
	vec4 rednegative = vec4(redrecord.r);
	vec4 bluegreennegative = vec4((bluegreenrecord.g + bluegreenrecord.b)/2.0);

	vec4 redoutput = rednegative + cyanfilter;
	vec4 bluegreenoutput = bluegreennegative + magentafilter;

	vec4 result = redoutput * bluegreenoutput;

	result = mix(input0, result, amount);
	result.a = input0.a;

	gl_FragColor = result;
}
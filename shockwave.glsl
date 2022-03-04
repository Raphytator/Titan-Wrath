#define PI 3.14159265359

// SHOCKWAVE
uniform float diameter;
uniform float time;
uniform float area;
uniform bool aoe;
uniform vec2 shake;

float intensity = 0.1;

float newWave(vec2 uv, vec2 position, float size, float thickness)
{
    float w = (1.0 - smoothstep(size - 0.1, size, length(uv - position)))
            * smoothstep(size - thickness - 0.1, size-thickness, length(uv - position));
    return w * step(0.37, uv.y);         
}

float mask(vec2 uv, vec2 pos, float minAngle, float maxAngle)
{
    if (aoe == true)
    {
        return 1.0;
    }
    float a = atan(uv.y-pos.y, uv.x-pos.x);
    return (1.0 - step(maxAngle, a)) * step(minAngle, a);
}

vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords)
{
    screenCoords += shake;
    vec2 normUV = screenCoords / love_ScreenSize.xy;
    float ratio = love_ScreenSize.x / love_ScreenSize.y;
    vec2 scaledUV = (normUV - vec2(0.5, 0.0) ) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
    vec2 center = vec2(0.5, 0.37);

    float wave = newWave(scaledUV, center, diameter, 0.05 + sin(time)*0.02);
    if (aoe == true)
    {
        wave += newWave(scaledUV, center, max(0.0, diameter - 0.3), 0.05 + sin(time)*0.02)
              + newWave(scaledUV, center, max(0.0, diameter - 0.6), 0.05 + sin(time)*0.02)
              + newWave(scaledUV, center, max(0.0, diameter - 0.9), 0.05 + sin(time)*0.02);
    } 
    vec2 disp = normalize(scaledUV - center) * intensity * wave * mask(scaledUV, center, (area-1.0)*PI/5.0, area*PI/5.0);

    color = Texel(texture, normUV - disp);
    return color;
}
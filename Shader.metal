#include <metal_stdlib>
#include <simd/simd.h>
#include "Shaders.h"

using namespace metal;

struct VertexOut {
    float4 color;
    float4 position [[position]];
};

vertex VertexOut vertexShader(const device Vertex *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]])
{
    Vertex in = vertexArray[vid];
    VertexOut out;
    out.color = in.color;
    out.position = float4(in.position.x, in.position.y, 0, 1);
    return out;
}

fragment float4 fragmentShader(VertexOut interpolated [[stage_in]]) {
    return interpolated.color;
}

import Foundation
import Metal
import MetalKit
import simd

struct Vertex {
    var color: vector_float4
    var pos: vector_float2
}

class Renderer: NSObject, MTKViewDelegate {
        
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let piplineState: MTLRenderPipelineState
    let vertexBuffer: MTLBuffer
    
    init?(mtkView: MTKView) {
        device = mtkView.device!
        commandQueue = device.makeCommandQueue()!
        
        do {
            piplineState = try Renderer.buildRenderPipelineWith(device: device, metalKitView: mtkView)
        }catch {
            return nil
        }
        
        let vertices = [Vertex(color: [1, 0, 0, 1], pos: [-1, -1]),
                        Vertex(color: [0, 1, 0, 1], pos: [0, 1]),
                        Vertex(color: [0, 0, 1, 1], pos: [1, -1])]
        
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])!
    }
    
    class func buildRenderPipelineWith(device: MTLDevice, metalKitView: MTKView) throws -> MTLRenderPipelineState {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        guard let library = device.makeDefaultLibrary() else {fatalError("couldn't create library")}
        
        pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func draw(in view: MTKView) {
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColorMake(0,0,0,1) // BACKGROUND COLOR
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        renderEncoder?.setRenderPipelineState(piplineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(view.currentDrawable!)
        commandBuffer?.commit()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

    }
}

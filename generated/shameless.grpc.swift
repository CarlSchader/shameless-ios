// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the gRPC Swift generator plugin for the protocol buffer compiler.
// Source: shameless.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/grpc/grpc-swift

import GRPCCore
import GRPCProtobuf

internal enum Shameless_ShamelessService {
    internal static let descriptor = GRPCCore.ServiceDescriptor.shameless_ShamelessService
    internal enum Method {
        internal enum GetLogs {
            internal typealias Input = Shameless_GetLogsRequest
            internal typealias Output = Shameless_Logs
            internal static let descriptor = GRPCCore.MethodDescriptor(
                service: Shameless_ShamelessService.descriptor.fullyQualifiedService,
                method: "GetLogs"
            )
        }
        internal enum PostLogs {
            internal typealias Input = Shameless_Logs
            internal typealias Output = Shameless_Void
            internal static let descriptor = GRPCCore.MethodDescriptor(
                service: Shameless_ShamelessService.descriptor.fullyQualifiedService,
                method: "PostLogs"
            )
        }
        internal static let descriptors: [GRPCCore.MethodDescriptor] = [
            GetLogs.descriptor,
            PostLogs.descriptor
        ]
    }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    internal typealias StreamingServiceProtocol = Shameless_ShamelessServiceStreamingServiceProtocol
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    internal typealias ServiceProtocol = Shameless_ShamelessServiceServiceProtocol
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    internal typealias ClientProtocol = Shameless_ShamelessServiceClientProtocol
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    internal typealias Client = Shameless_ShamelessServiceClient
}

extension GRPCCore.ServiceDescriptor {
    internal static let shameless_ShamelessService = Self(
        package: "shameless",
        service: "ShamelessService"
    )
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
internal protocol Shameless_ShamelessServiceStreamingServiceProtocol: GRPCCore.RegistrableRPCService {
    func getLogs(request: GRPCCore.ServerRequest.Stream<Shameless_GetLogsRequest>) async throws -> GRPCCore.ServerResponse.Stream<Shameless_Logs>
    
    func postLogs(request: GRPCCore.ServerRequest.Stream<Shameless_Logs>) async throws -> GRPCCore.ServerResponse.Stream<Shameless_Void>
}

/// Conformance to `GRPCCore.RegistrableRPCService`.
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Shameless_ShamelessService.StreamingServiceProtocol {
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    internal func registerMethods(with router: inout GRPCCore.RPCRouter) {
        router.registerHandler(
            forMethod: Shameless_ShamelessService.Method.GetLogs.descriptor,
            deserializer: GRPCProtobuf.ProtobufDeserializer<Shameless_GetLogsRequest>(),
            serializer: GRPCProtobuf.ProtobufSerializer<Shameless_Logs>(),
            handler: { request in
                try await self.getLogs(request: request)
            }
        )
        router.registerHandler(
            forMethod: Shameless_ShamelessService.Method.PostLogs.descriptor,
            deserializer: GRPCProtobuf.ProtobufDeserializer<Shameless_Logs>(),
            serializer: GRPCProtobuf.ProtobufSerializer<Shameless_Void>(),
            handler: { request in
                try await self.postLogs(request: request)
            }
        )
    }
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
internal protocol Shameless_ShamelessServiceServiceProtocol: Shameless_ShamelessService.StreamingServiceProtocol {
    func getLogs(request: GRPCCore.ServerRequest.Single<Shameless_GetLogsRequest>) async throws -> GRPCCore.ServerResponse.Single<Shameless_Logs>
    
    func postLogs(request: GRPCCore.ServerRequest.Single<Shameless_Logs>) async throws -> GRPCCore.ServerResponse.Single<Shameless_Void>
}

/// Partial conformance to `Shameless_ShamelessServiceStreamingServiceProtocol`.
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Shameless_ShamelessService.ServiceProtocol {
    internal func getLogs(request: GRPCCore.ServerRequest.Stream<Shameless_GetLogsRequest>) async throws -> GRPCCore.ServerResponse.Stream<Shameless_Logs> {
        let response = try await self.getLogs(request: GRPCCore.ServerRequest.Single(stream: request))
        return GRPCCore.ServerResponse.Stream(single: response)
    }
    
    internal func postLogs(request: GRPCCore.ServerRequest.Stream<Shameless_Logs>) async throws -> GRPCCore.ServerResponse.Stream<Shameless_Void> {
        let response = try await self.postLogs(request: GRPCCore.ServerRequest.Single(stream: request))
        return GRPCCore.ServerResponse.Stream(single: response)
    }
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
internal protocol Shameless_ShamelessServiceClientProtocol: Sendable {
    func getLogs<R>(
        request: GRPCCore.ClientRequest.Single<Shameless_GetLogsRequest>,
        serializer: some GRPCCore.MessageSerializer<Shameless_GetLogsRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Shameless_Logs>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse.Single<Shameless_Logs>) async throws -> R
    ) async throws -> R where R: Sendable
    
    func postLogs<R>(
        request: GRPCCore.ClientRequest.Single<Shameless_Logs>,
        serializer: some GRPCCore.MessageSerializer<Shameless_Logs>,
        deserializer: some GRPCCore.MessageDeserializer<Shameless_Void>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse.Single<Shameless_Void>) async throws -> R
    ) async throws -> R where R: Sendable
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Shameless_ShamelessService.ClientProtocol {
    internal func getLogs<R>(
        request: GRPCCore.ClientRequest.Single<Shameless_GetLogsRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse.Single<Shameless_Logs>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.getLogs(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Shameless_GetLogsRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Shameless_Logs>(),
            options: options,
            body
        )
    }
    
    internal func postLogs<R>(
        request: GRPCCore.ClientRequest.Single<Shameless_Logs>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse.Single<Shameless_Void>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.postLogs(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Shameless_Logs>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Shameless_Void>(),
            options: options,
            body
        )
    }
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Shameless_ShamelessService.ClientProtocol {
    internal func getLogs<Result>(
        _ message: Shameless_GetLogsRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse.Single<Shameless_Logs>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest.Single<Shameless_GetLogsRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.getLogs(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    internal func postLogs<Result>(
        _ message: Shameless_Logs,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse.Single<Shameless_Void>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest.Single<Shameless_Logs>(
            message: message,
            metadata: metadata
        )
        return try await self.postLogs(
            request: request,
            options: options,
            handleResponse
        )
    }
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
internal struct Shameless_ShamelessServiceClient: Shameless_ShamelessService.ClientProtocol {
    private let client: GRPCCore.GRPCClient
    
    internal init(wrapping client: GRPCCore.GRPCClient) {
        self.client = client
    }
    
    internal func getLogs<R>(
        request: GRPCCore.ClientRequest.Single<Shameless_GetLogsRequest>,
        serializer: some GRPCCore.MessageSerializer<Shameless_GetLogsRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Shameless_Logs>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse.Single<Shameless_Logs>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Shameless_ShamelessService.Method.GetLogs.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    internal func postLogs<R>(
        request: GRPCCore.ClientRequest.Single<Shameless_Logs>,
        serializer: some GRPCCore.MessageSerializer<Shameless_Logs>,
        deserializer: some GRPCCore.MessageDeserializer<Shameless_Void>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse.Single<Shameless_Void>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Shameless_ShamelessService.Method.PostLogs.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
}

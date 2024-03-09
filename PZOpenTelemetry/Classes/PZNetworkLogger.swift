//
//  PZNetworkLogger.swift
//  PZOpenTelemetry
//
//  Created by AT on 09/03/24.
//

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk
import URLSessionInstrumentation
import OpenTelemetryProtocolExporterHttp

public final class PZNetworkLogger {
    
    public static let shared = PZNetworkLogger()
    private let dataUploadEndpoint = "99b0365a6555406fa947b782c37949e7.apm.us-central1.gcp.cloud.es.io"
    private let sessionInstrumentation: URLSessionInstrumentation
   
    private init() {
            let endPoint = URL(string: "https://\(dataUploadEndpoint)/v1/traces")!
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Authorization": "Bearer Df7h0ZCYa9FNUiZpi6"]
            let session = URLSession(configuration: configuration)
            
            //Creat Span Exporter
            let spanExporter = OtlpHttpTraceExporter(endpoint: endPoint, useSession: session)
            
            //Setting Attributes
            let attrs: [String: AttributeValue] = [
              "service.name": AttributeValue.string("iOS-App"),
              "service.version": AttributeValue.string("1.0"),
              "deployment.environment": AttributeValue.string("prodUAT"),
              "telemetry.sdk.name": AttributeValue.string("opentelemetry"),
              "telemetry.sdk.language": AttributeValue.string("swift"),
              "telemetry.sdk.version": AttributeValue.string("1.9.1")
            ]
            
            let resource = Resource(attributes: attrs)
        
        //Instrumentation of HTTP Requests - start
        let sessionConfiguration = URLSessionInstrumentationConfiguration(shouldInstrument: { request in
          // Only instrument legitimate API calls and not the calls to the APM collector
          if request.url?.host() == endPoint.host() {
            return false
          }
          return true
        }, nameSpan: { request in
          // sets the name of the span to the relative path of the URL
          return request.url?.path().split(separator: "/").last?.lowercased()
        }, injectCustomHeaders: { request, span in
          // This section is for injecting headers, we are injecting X-B3 headers to enable context propagation
          if request.url?.host() == endPoint.host() {
            return
          }
          request.setValue(span!.context.traceId.hexString, forHTTPHeaderField: "X-B3-TraceId")
          request.setValue(span!.context.spanId.hexString, forHTTPHeaderField: "X-B3-SpanId")
        }) { _, span in
          // this section is for adding attributes, we are adding the HttpStatusCode attribute
          span.setAttribute(key: "HttpStatusCode", value: 200)
        } receivedError: { _, _, status, span in
          span.setAttribute(key: "HttpStatusCode", value: status)
        }
        self.sessionInstrumentation = URLSessionInstrumentation(configuration: sessionConfiguration)
        
        // End
        
            
            //Register the Trace Explorer
            OpenTelemetry.registerTracerProvider(tracerProvider: TracerProviderBuilder()
              .add(spanProcessor: SimpleSpanProcessor(spanExporter: spanExporter))
              .with(resource: resource)
              .build()
            )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.log()
        }
    }
    
    public func log() {
        // Create a URLSession instance as you normally would
        let session = URLSession(configuration: .default)
        // Now use this session for your network calls
        let url = URL(string: "https://example.com")!
        let task = session.dataTask(with: url) { (data, response, error) in
            // Handle response here
        }
        task.resume()
    }
}


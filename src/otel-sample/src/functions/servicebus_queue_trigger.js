// Import Azure Functions app instance for Service Bus trigger setup
const { app } = require("@azure/functions");

// Import OpenTelemetry API for tracing
const otelAPI = require("@opentelemetry/api");

/**
 * Service Bus Queue trigger function that demonstrates OpenTelemetry tracing.
 * This function is triggered when a message is added to the Service Bus queue.
 *
 * @param {unknown} message - The Service Bus message that triggered the function
 * @param {import("@azure/functions").InvocationContext} context - Azure Functions invocation context for logging and tracing
 */
async function serviceBusQueueTrigger(message, context) {
  context.log(
    "JavaScript ServiceBus Queue trigger start processing a message:",
    message
  );

  // Log Azure Functions context traceparent for correlation
  context.log(`Context traceparent- "${context.traceContext.traceParent}"`);

  // Log active span trace ID from OpenTelemetry for debugging
  context.log(`ActiveSpan traceId- "${otelAPI.trace.getActiveSpan()}"`);

  // Log active span ID from OpenTelemetry for debugging
  context.log(`ActiveSpan spanId- "${otelAPI.trace.getActiveSpan()}"`);

  // Simulate processing time
  await new Promise((resolve) => setTimeout(resolve, 5000));

  context.log("JavaScript ServiceBus Queue trigger end processing a message");
}

// Register Service Bus Queue trigger function with Azure Functions runtime
app.serviceBusQueue("servicebus_queue_trigger", {
  queueName: "%ServiceBusQueueName%",
  connection: "ServiceBusConnection",
  handler: serviceBusQueueTrigger,
});

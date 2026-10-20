import ballerinax/ai.openai;

final openai:ModelProvider openaiModelprovider = check new (customopenaiAgentManagerKey, "gpt-5.6-terra", customopenaiAgentManagerUrl, reasoningEffort = "none");

// MCP toolkit that connects to the contract store MCP server, used to fetch and search contracts.
final ContractStoreMcpToolkit contractStoreMcp = check new (contractStoreMcpUrl, auth = {tokenUrl: agentIdTokenUrl, clientId: agentIdClientId, clientSecret: agentIdClientSecret, scopes: agentIdScopes, optionalParams: {"resource": contractStoreMcpUrl}});

// MCP toolkit that connects to the Resend MCP server, used to send the contract review feedback by email.
final ResendMcpServerMcpToolkit resendMcpServerMcp = check new (resendMcpServerMcpUrl, auth = {tokenUrl: agentIdTokenUrl, clientId: agentIdClientId, clientSecret: agentIdClientSecret, scopes: agentIdScopes, optionalParams: {"resource": resendMcpServerMcpUrl}});

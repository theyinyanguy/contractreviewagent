import ballerina/ai;
import ballerina/mcp;

final ai:Agent contractReviewAgent = check new (
    systemPrompt = {
        role: string `Contract Review Assistant`,
        instructions: string `You are a contract review assistant. You help users review contracts that are kept in a contract store and communicate review feedback over email.
Use the contract store tools to fetch or search for the contract the user is referring to before reviewing it.
Carefully review the contract content for risks, unclear or missing clauses, unfavorable terms, compliance concerns and inconsistencies.
Produce clear, structured feedback that explains each issue you find and why it matters, and suggest concrete improvements.
When the user asks you to share or send the feedback, use the send email tool to deliver it to the requested recipient with a clear subject and a well formatted summary.
Always confirm the contract identifier and recipient details before taking any action that fetches data or sends an email.
If a tool call fails or the contract cannot be found, explain this clearly to the user instead of guessing.`
    }, model = openaiModelprovider, tools = [resendMcpServerMcp, contractStoreMcp]
);

isolated class ResendMcpServerMcpToolkit {
    *ai:McpBaseToolKit;
    private final mcp:StreamableHttpClient mcpClient;
    private final readonly & ai:ToolConfig[] tools;

    public isolated function init(string serverUrl, mcp:Implementation info = {name: "MCP", version: "1.0.0"},
            *mcp:StreamableHttpClientTransportConfig config) returns ai:Error? {
        do {
            self.mcpClient = check new mcp:StreamableHttpClient(serverUrl, config);
            self.tools = check ai:getPermittedMcpToolConfigs(self.mcpClient, info, self.callTool).cloneReadOnly();
        } on fail error e {
            return error ai:Error("Failed to initialize MCP toolkit", e);
        }
    }

    public isolated function getTools() returns ai:ToolConfig[] => self.tools;

    @ai:AgentTool
    public isolated function callTool(mcp:CallToolParams params) returns mcp:CallToolResult|error {
        return self.mcpClient->callTool(params);
    }
}

isolated class ContractStoreMcpToolkit {
    *ai:McpBaseToolKit;
    private final mcp:StreamableHttpClient mcpClient;
    private final readonly & ai:ToolConfig[] tools;

    public isolated function init(string serverUrl, mcp:Implementation info = {name: "MCP", version: "1.0.0"},
            *mcp:StreamableHttpClientTransportConfig config) returns ai:Error? {
        do {
            self.mcpClient = check new mcp:StreamableHttpClient(serverUrl, config);
            self.tools = check ai:getPermittedMcpToolConfigs(self.mcpClient, info, self.callTool).cloneReadOnly();
        } on fail error e {
            return error ai:Error("Failed to initialize MCP toolkit", e);
        }
    }

    public isolated function getTools() returns ai:ToolConfig[] => self.tools;

    @ai:AgentTool
    public isolated function callTool(mcp:CallToolParams params) returns mcp:CallToolResult|error {
        return self.mcpClient->callTool(params);
    }
}

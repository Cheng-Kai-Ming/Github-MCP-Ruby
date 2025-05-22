# MCP Ruby SDK

A Ruby implementation of the Model Context Protocol (MCP) server that enables AI models to interact with tools and external systems.

## Overview

This SDK provides a lightweight Ruby implementation of the Model Context Protocol, allowing you to create MCP servers that can register tools and handle requests from AI models. The protocol follows the JSON-RPC 2.0 specification for communication.

## Features

- Implement MCP servers with custom tools
- Register and manage tool handlers
- Process JSON-RPC requests and responses
- Built-in logging capabilities
- Example GitHub CLI integration

## Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd mcp-ruby
```

2. Install required gems:
```bash
bundle install
```

## Dependencies

For GitHub tools functionality:
- GitHub CLI (`gh`) installed and configured

## Usage

### Basic Usage

1. Register tools:

```ruby
# Create a tool handler class
class MyToolHandler
  def call(param1:, param2:)
    # Implement tool functionality
    { result: "Processed #{param1} and #{param2}" }
  end
end

# Define input schema (JSON Schema format)
input_schema = {
  type: "object",
  properties: {
    param1: { type: "string" },
    param2: { type: "string" }
  },
  required: ["param1", "param2"]
}

# Register the tool
server.add_tool(
  "my_tool",
  "My custom tool description",
  input_schema,
  MyToolHandler
)
```

3. Start the server:

```ruby
server.start
```

### GitHub CLI Integration

This SDK includes a GitHub CLI integration example that demonstrates how to wrap the GitHub CLI commands as MCP tools:

```ruby
require_relative 'mcp_server'
require_relative 'handlers/github_handler'

# Initialize server
server = MCPServer.new(log_file: "dev.log")

# Register GitHub tools
# See mcp_github_server.rb for full example
```

## Protocol Support

This SDK implements the Model Context Protocol version `2024-11-05`.

Supported methods:
- `initialize`: Initialize the server connection
- `tools/list`: List all registered tools
- `tools/call`: Call a specific tool with arguments
- `resources/list`: List available resources
- `prompts/list`: List available prompts

## Creating Custom Tool Handlers

To create a custom tool handler:

1. Define a new class with a `call` method that accepts keyword arguments matching your input schema:

```ruby
class WeatherToolHandler
  def call(location:, units: "celsius")
    # Implement weather lookup logic
    { 
      temperature: 22,
      condition: "Sunny",
      location: location,
      units: units
    }
  end
end
```

2. Register the tool with appropriate schema:

```ruby
weather_schema = {
  type: "object",
  properties: {
    location: { type: "string" },
    units: { 
      type: "string",
      enum: ["celsius", "fahrenheit"],
      default: "celsius"
    }
  },
  required: ["location"]
}

server.add_tool(
  "get_weather",
  "Get current weather for a location",
  weather_schema,
  WeatherToolHandler
)
```

## License

[MIT License](LICENSE)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

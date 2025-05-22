#!/usr/bin/env ruby

# 導入必要的模組
require_relative 'mcp_server'
require_relative 'handlers/github_handler'

server = MCPServer.new(log_file: File.join(__dir__, 'dev.log'))

server.add_tool(
  'github_list_prs',
  'list pull requests',
  {
    type: 'object',
    properties: {
      owner: { type: 'string' },
      repo: { type: 'string' }
    },
    required: ['owner', 'repo']
  },
  GitHubHandler.new.method(:list_prs)
)



# 啟動 MCP 伺服器
# 開始監聽並處理客戶端請求
server.start

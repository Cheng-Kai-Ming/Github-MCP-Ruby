#!/usr/bin/env ruby
require 'json'
require 'open3'

class GitHubHandler
  # Check GitHub CLI login status
  def auth_status(params)
    run_gh_command('auth status')
  end

  # List user repositories
  def list_repos(params)
    run_gh_command('repo list')
  end

  # View repository information
  def repo_view(params)
    owner = params['owner']
    repo = params['repo']
    run_gh_command("repo view #{owner}/#{repo}")
  end

  # Clone repository
  def clone_repo(params)
    repo = params['repo']
    directory = params['directory']
    
    cmd = "repo clone #{repo}"
    cmd += " #{directory}" if directory && !directory.empty?
    
    run_gh_command(cmd)
  end

  # List Issues
  def list_issues(params)
    owner = params['owner']
    repo = params['repo']
    run_gh_command("issue list -R #{owner}/#{repo}")
  end

  # Create Issue
  def create_issue(params)
    title = params['title']
    body = params['body']
    repo = params['repo']
    
    cmd = "issue create"
    cmd += " -R #{repo}" if repo && !repo.empty?
    cmd += " -t \"#{title}\""
    cmd += " -b \"#{body}\"" if body && !body.empty?
    
    run_gh_command(cmd)
  end

  # List Pull Requests
  def list_prs(params)
    owner = params['owner']
    repo = params['repo']
    run_gh_command("pr list -R #{owner}/#{repo}")
  end

  # Create Pull Request
  def create_pr(params)
    title = params['title']
    body = params['body']
    head = params['head']
    base = params['base']
    repo = params['repo']
    
    cmd = "pr create"
    cmd += " -R #{repo}" if repo && !repo.empty?
    cmd += " -t \"#{title}\""
    cmd += " -b \"#{body}\"" if body && !body.empty?
    cmd += " -H #{head}"
    cmd += " -B #{base}"
    
    run_gh_command(cmd)
  end

  # Run any GitHub CLI command
  def run_command(params)
    command = params['command']
    run_gh_command(command)
  end

  private

  # Execute GitHub CLI command and return result
  def run_gh_command(command)
    begin
      # Prepend 'gh' to the command
      full_command = "gh #{command}"
      
      # Use Open3 to execute the command, capturing standard output and standard error
      stdout, stderr, status = Open3.capture3(full_command)
      
      if status.success?
        {
          'success' => true,
          'output' => stdout.strip,
          'command' => full_command
        }
      else
        {
          'success' => false,
          'error' => stderr.strip,
          'command' => full_command
        }
      end
    rescue => e
      {
        'success' => false,
        'error' => e.message,
        'command' => "gh #{command}"
      }
    end
  end
end

defmodule GithubProfiler.Search do
  use HTTPoison.Base

  def run(query) do
    IO.puts graphql_body(query)
    post!("/graphql", graphql_body(query))
  end
  
  def process_url(url), do: "https://api.github.com" <> url

  def process_request_headers(headers) do
    [{"Authorization",
      ["bearer ", Application.get_env(:github_profiler, :auth_token)]}
     |headers]
  end

  def graphql_body(query) do
    # WORKS
    # ~S"""
    # {"query":"{\n  search(query: \"eellson\", type: USER, first: 10) {\n    edges {\n      node {\n        ... on User {\n          login\n          name\n          avatarUrl\n        }\n      }\n    }\n  }\n  rateLimit {\n    limit\n    cost\n    remaining\n    resetAt\n  }\n}\n","variables":"{}","operationName":null}
    # """
    "{\"query\":\"{\\n  search(query: \\\"#{query}\\\", type: USER, first: 10) {\\n    edges {\\n      node {\\n        ... on User {\\n          login\\n          name\\n          avatarUrl\\n        }\\n      }\\n    }\\n  }\\n  rateLimit {\\n    limit\\n    cost\\n    remaining\\n    resetAt\\n  }\\n}\\n\",\"variables\":\"{}\",\"operationName\":null}\n\n"
  end
end

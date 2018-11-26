# list-my-gists

`list-my-gists` is a command for you to generate a list of your gists with links. The list will be saved into a new gist under your github account.

By default, it will create a *public* gist of all your public gists, and a *secret* gist of all your secret gists.

## Prerequisite

- Install [gist command](https://github.com/defunkt/gist)
- Log in with `gist --login` (or refer to its [document](https://github.com/defunkt/gist#login))

## Installation

You can install list-my-gists via either `curl` or `wget`

Via curl
```
sudo curl -fsSL -o /usr/local/bin/list-my-gists https://raw.githubusercontent.com/cslee/list-my-gists/master/list-my-gists.sh
sudo chmod +x /usr/local/bin/list-my-gists
```

Via wget
```
sudo wget --no-verbose https://raw.githubusercontent.com/cslee/list-my-gists/master/list-my-gists.sh -O /usr/local/bin/list-my-gists
sudo chmod +x /usr/local/bin/list-my-gists
```

## Usage

```
Usage: list-my-gists [options...]

Options:
 -p,  --public-only         Create (or update) a public list of my public gists (default enabled)
 -s,  --secret-only         Create (or update) a secret list of my secret gists (default enabled)
 -ps, --public-and-secret   Create (or update) a secret list of my public & secret gists
      --no-signature        Do not include signature in the gist created
```

## License

[MIT](https://github.com/cslee/list-my-gists/blob/master/LICENSE)

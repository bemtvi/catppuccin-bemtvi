Thanks for contributing! Before opening the PR:

- Format and lint: `stylua .` and `selene .` (selene built with the Lua 5.4 grammar:
  `cargo install selene --features selene-lib/lua54`). The pre-commit hooks run both.
- Run the specs: `bemtvi --test-plugin .`, and add a case for new behaviour.
- If you changed `doc/catppuccin-bemtvi.md`, regenerate the help with
  `bash scripts/gen-vimdoc.sh` and commit `doc/catppuccin-bemtvi.txt` too.
- Target `btv.*` only; no `vim.*` calls.
- Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) messages.

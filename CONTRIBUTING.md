# Contributing

Contributions and suggestions are welcome.

## Getting started

This module needs no Azure subscription and no credentials to develop against. Checks run through the pinned [gkvm-tools](https://github.com/glueckkanja/gkvm-tools) container image, so Docker (or `CONTAINER_RUNTIME=podman`) is the only local requirement. The devcontainer uses the same image.

## Before opening a pull request

```bash
./gkvm pre-commit   # formatting, block ordering, docs — writes files
./gkvm pr-check     # everything CI runs, read-only
```

Commit whatever `pre-commit` changes; CI fails if the committed files drift from the generated ones.

Example READMEs embed their own HCL source via `{{ include }}`, so they are generated too -- with `examples/.terraform-docs.yml`, never with the root config, which would strip the embedded block.

## Conventions

- Conventional Commits for commit subjects; use `!` for breaking changes.
- `snake_case` for all Terraform identifiers.
- Every variable and output carries a `description`.

## Changes that affect state

This module is consumed across many Terraform states, so treat resource addresses as a public interface.

`for_each` key expressions are state addresses. Changing one forces a destroy and recreate of every affected resource in every consuming state, and `moved` blocks cannot repair keys computed from a variable — leaving consumers to run `terraform state mv` by hand. Do not change a key expression unless you are deliberately shipping a migration, and say so explicitly in the pull request.

When a change does affect state, describe the impact in the pull request: what Terraform will plan on the first run after upgrading, and what a consumer has to do about it.

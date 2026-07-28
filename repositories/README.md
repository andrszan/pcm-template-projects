# Local Template Repositories

This directory contains independent Git repositories used by the PCM template workspace.

The root `template-projects` repository does not track the contents of these repositories. Cloning the root repository therefore does not automatically clone them.

Use `../scripts/bootstrap.sh` after real remote URLs are configured in `../repositories.yaml`, or create the repositories locally.

Do not run `git clean -fdx` from the root workspace: ignored nested repository directories could be removed.

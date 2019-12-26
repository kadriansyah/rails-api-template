#!/bin/bash

# make sure we can write to stdout and stderr as "app"
chown --dereference app "/proc/$$/fd/1" "/proc/$$/fd/2" || :
exec gosu app "$@"